WARN('[sorianeditutilities.lua ------------------------ '..debug.getinfo(1).currentline..'] ----------------------------- Platoon File Offset.')

local NavUtils = import('/lua/sim/NavUtils.lua')

local SUtils = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')
-- local UUtils = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua')
local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')

local HERODEBUG = false
local NUKEDEBUG = false
local HERODEBUGSorianEdit = false

local MarkerSwitchDist = 20
local MarkerSwitchDistEXP = 40

local PlatoonExists = moho.aibrain_methods.PlatoonExists
local GetPlatoonUnits = moho.platoon_methods.GetPlatoonUnits
local IsUnitState = moho.unit_methods.IsUnitState
local AssignUnitsToPlatoon = moho.aibrain_methods.AssignUnitsToPlatoon
local GetPlatoonPosition = moho.platoon_methods.GetPlatoonPosition
local GetBrain = moho.platoon_methods.GetBrain
local PlatoonCategoryCount = moho.platoon_methods.PlatoonCategoryCount

local BaseRestrictedArea, BaseMilitaryArea, BaseEnemyArea = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua').GetDangerZoneRadii()
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua').GetDangerZoneRadii()

local SorianEditCOPY = table.copy
local SorianEditSORT = table.sort
local SorianEditTIME = GetGameTimeSeconds
local SorianEditFLOOR = math.floor
local SorianEditENTITY = EntityCategoryContains
local SorianEditINSERT = table.insert
local SorianEditCAT = table.cat
local GetPlatoonUnits = moho.platoon_methods.GetPlatoonUnits
local GetPlatoonPosition = moho.platoon_methods.GetPlatoonPosition
local PlatoonExists = moho.aibrain_methods.PlatoonExists
local ALLBPS = __blueprints
local GetNumUnitsAroundPoint = moho.aibrain_methods.GetNumUnitsAroundPoint
local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
local GetThreatAtPosition = moho.aibrain_methods.GetThreatAtPosition
local GetEconomyStored = moho.aibrain_methods.GetEconomyStored
local RNGGETN = table.getn
local RNGINSERT = table.insert
local WaitTicks = coroutine.yield

local VDist2Sq = VDist2Sq
local VDist3 = VDist3

local ForkThread = ForkThread
local ForkTo = ForkThread

local KillThread = KillThread
local MaxPlatoonWeaponRange = nil

SorianEditPlatoonClass = Platoon
Platoon = Class(SorianEditPlatoonClass) {
    
    -------------------------------------------------------
    --   Function: EngineerBuildAI
    --   Args:
    --       self - the single-engineer platoon to run the AI on
    --   Description:
    --       a single-unit platoon made up of an engineer, this AI will determine
    --       what needs to be built (based on platoon data set by the calling
    --       abstraction, and then issue the build commands to the engineer
    --   Returns:
    --       nil (tail calls into a behavior function)
    -------------------------------------------------------
	
    EngineerBuildAIEdit = function(self)
        -- LOG('*------------------------------- AI-sorian: EngineerBuildAIEdit()')
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local armyIndex = aiBrain:GetArmyIndex()
        local x,z = aiBrain:GetArmyStartPos()
        local cons = self.PlatoonData.Construction
        local buildingTmpl, buildingTmplFile, baseTmpl, baseTmplFile
        local eng
        for k, v in platoonUnits do
            if not v.Dead and EntityCategoryContains(categories.ENGINEER - categories.STATIONASSISTPOD, v) then --DUNCAN - was construction
                IssueClearCommands({v})
                if not eng then
                    eng = v
                else
                    IssueGuard({v}, eng)
                end
            end
        end

        if not eng or eng.Dead then
            coroutine.yield(1)
            self:PlatoonDisband()
            return
        end

        --DUNCAN - added
        if eng:IsUnitState('Building') or eng:IsUnitState('Upgrading') or eng:IsUnitState("Enhancing") then
           return
        end

        local FactionToIndex  = { UEF = 1, AEON = 2, CYBRAN = 3, SERAPHIM = 4, NOMADS = 5}
        local factionIndex = cons.FactionIndex or FactionToIndex[eng.factionCategory]

        buildingTmplFile = import(cons.BuildingTemplateFile or '/lua/BuildingTemplates.lua')
        baseTmplFile = import(cons.BaseTemplateFile or '/lua/BaseTemplates.lua')
        buildingTmpl = buildingTmplFile[(cons.BuildingTemplate or 'BuildingTemplates')][factionIndex]
        baseTmpl = baseTmplFile[(cons.BaseTemplate or 'BaseTemplates')][factionIndex]

        --LOG('*AI DEBUG: EngineerBuild AI ' .. eng.Sync.id)

        if self.PlatoonData.NeedGuard then
            eng.NeedGuard = true
        end

        -------- CHOOSE APPROPRIATE BUILD FUNCTION AND SETUP BUILD VARIABLES --------
        local reference = false
        local refName = false
        local buildFunction
        local closeToBuilder
        local relative
        local baseTmplList = {}

        -- if we have nothing to build, disband!
        if not cons.BuildStructures then
            coroutine.yield(1)
            self:PlatoonDisband()
            return
        end
        if cons.NearUnitCategory then
            local NearUnitCategories = cons.NearUnitCategory
            -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
            if type(NearUnitCategories) == 'string' then
                NearUnitCategories = ParseEntityCategory(NearUnitCategories)
            end
            self:SetPrioritizedTargetList('support', {NearUnitCategories})
            local unitNearBy = self:FindPrioritizedUnit('support', 'Ally', false, self:GetPlatoonPosition(), cons.NearUnitRadius or 50)
            --LOG("ENGINEER BUILD: " .. cons.BuildStructures[1] .." attempt near: ", cons.NearUnitCategory)
            if unitNearBy then
                reference = table.copy(unitNearBy:GetPosition())
                -- get commander home position
                --LOG("ENGINEER BUILD: " .. cons.BuildStructures[1] .." Near unit: ", cons.NearUnitCategory)
                if cons.NearUnitCategory == 'COMMAND' and unitNearBy.CDRHome then
                    reference = unitNearBy.CDRHome
                end
            else
                reference = table.copy(eng:GetPosition())
            end
            relative = false
            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))
        elseif cons.Wall then
            local pos = aiBrain:PBMGetLocationCoords(cons.LocationType) or cons.Position or self:GetPlatoonPosition()
            local radius = cons.LocationRadius or aiBrain:PBMGetLocationRadius(cons.LocationType) or 100
            relative = false
            reference = AIUtils.GetLocationNeedingWalls(aiBrain, 200, 4, 'STRUCTURE - WALLS', cons.ThreatMin, cons.ThreatMax, cons.ThreatRings)
            table.insert(baseTmplList, 'Blank')
            buildFunction = AIBuildStructures.WallBuilder
        elseif cons.NearBasePatrolPoints then
            relative = false
            reference = AIUtils.GetBasePatrolPoints(aiBrain, cons.Location or 'MAIN', cons.Radius or 100)
            baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]
            for k,v in reference do
                table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, v))
            end
            -- Must use BuildBaseOrdered to start at the marker; otherwise it builds closest to the eng
            buildFunction = AIBuildStructures.AIBuildBaseTemplateOrdered
        elseif cons.PdCreep then
            relative = false
			-- Get a position where to start the creep; Get enemy position
            local x,z = aiBrain:GetArmyStartPos()
            local ex, ez = aiBrain:GetCurrentEnemy():GetArmyStartPos()
			-- DrawCircle({x,0,z}, 5, '19FF19')
			-- DrawCircle({ex,0,ez}, 5, 'FF0119')
			-- Generate a path to the enemy Base and filter all markers based on distance, ideally oldmarker to newmarker distance should be higher than half a T2 PDs range
            local reference, reason = AIAttackUtils.GeneratePathSimpleSorianEdit(aiBrain, 'Land', {x,0,z}, {ex,0,ez})
			-- Test Results: Pathnode: 1 at coords: { 133.5, 19.368370056152, 484.5, type="VECTOR3" }
			if reference then
			local referenceCount = table.getn(reference)
			local referencefiltered = {}
			local offset = 0
			-- for i=1, referenceCount do
			-- LOG('-------------- PathGen Pathnode: '..i..' at coords: '..repr(reference[i]))
			-- end
			for i = 1, referenceCount - 2 do 
				-- format: { x, y, z }
				local m0 = reference[i+offset]
				local m1 = reference[i+1+offset]
				local m2 = reference[i+2+offset]
				-- LOG('-------------- CurrOffset: '..repr(offset))
				-- LOG('-------------- Marker 1: '..repr(m0))
				-- LOG('-------------- Marker 2: '..repr(m1))
				-- LOG('-------------- Marker 3: '..repr(m2))
				if m2 == nil then
					break
				end
				-- Square of Distance between two 2d points (x1,y1,x2,y2)
				local distSq = VDist2Sq(m0[1], m0[3], m1[1], m1[3])
				local distSq2 = VDist2Sq(m0[1], m0[3], m2[1], m2[3])
				-- make sure the distance between each marker is higher than 30, so that we keep a min distance between each PDgroup
				if distSq < 30*30 then
					-- if the distance to the next marker is too big for the previous PD to cover, we skip deleting this marker
					if distSq2 > 50*50 then
						local UnitCountMarker = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.DEFENSE, Vector(m1[1],0,m1[3]), 20, 'Ally')
						if table.getn(UnitCountMarker) < 3 then
							table.insert(referencefiltered, {m1[1],0,m1[3]})
						end
					else
						local UnitCountMarker = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.DEFENSE, Vector(m2[1],0,m2[3]), 20, 'Ally')
						offset = offset+1
						if table.getn(UnitCountMarker) < 3 then
							table.insert(referencefiltered, {m2[1],0,m2[3]})
						end
					end
				else
					local UnitCountMarker = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.DEFENSE, Vector(m1[1],0,m1[3]), 20, 'Ally')
					if table.getn(UnitCountMarker) < 3 then
						table.insert(referencefiltered, {m1[1],0,m1[3]})
					end
				end
			end
			local referencefilteredCount = table.getn(referencefiltered)
			-- for i=1, referencefilteredCount do
			-- LOG('-------------- Filtered Pathnode: '..i..' at coords: '..repr(referencefiltered[i]))
			-- end
			baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]
			-- we need to insert the start and end position since its remove in PlatoonGenerateSafePathTo()
			table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, {x,0,z}))
			for k,v in referencefiltered do
				table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, v))
			end
			table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, {ex,0,ez}))
			-- Must use BuildBaseOrdered to start at the marker; otherwise it builds closest to the eng
			buildFunction = AIBuildStructures.AIBuildBaseTemplateOrdered
			else
				-- WARN('-------------- PathGen Error '..repr(reason))
				self:PlatoonDisband()
			end
        elseif cons.FireBase and cons.FireBaseRange then
            --DUNCAN - pulled out and uses alt finder
            reference, refName = AIUtils.AIFindFirebaseLocation(aiBrain, cons.LocationType, cons.FireBaseRange, cons.NearMarkerType, cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType,cons.MarkerUnitCount, cons.MarkerUnitCategory, cons.MarkerRadius)
            if not reference or not refName then
                self:PlatoonDisband()
                return
            end

        elseif cons.NearMarkerType and cons.ExpansionBase then
            local pos = aiBrain:PBMGetLocationCoords(cons.LocationType) or cons.Position or self:GetPlatoonPosition()
            local radius = cons.LocationRadius or aiBrain:PBMGetLocationRadius(cons.LocationType) or 100

            if cons.NearMarkerType == 'Expansion Area' then
                reference, refName = AIUtils.AIFindExpansionAreaNeedsEngineer(aiBrain, cons.LocationType,
                        (cons.LocationRadius or 100), cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType)
                -- didn't find a location to build at
                if not reference or not refName then
                    self:PlatoonDisband()
                    return
                end
            elseif cons.NearMarkerType == 'Naval Area' then
                reference, refName = AIUtils.AIFindNavalAreaNeedsEngineer(aiBrain, cons.LocationType,
                        (cons.LocationRadius or 100), cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType)
                -- didn't find a location to build at
                if not reference or not refName then
                    self:PlatoonDisband()
                    return
                end
            else
                --DUNCAN - use my alternative expansion finder on large maps below a certain time
                local mapSizeX, mapSizeZ = GetMapSize()
                if GetGameTimeSeconds() <= 780 and mapSizeX > 512 and mapSizeZ > 512 then
                    reference, refName = AIUtils.AIFindFurthestStartLocationNeedsEngineer(aiBrain, cons.LocationType,
                        (cons.LocationRadius or 100), cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType)
                    if not reference or not refName then
                        reference, refName = AIUtils.AIFindStartLocationNeedsEngineer(aiBrain, cons.LocationType,
                            (cons.LocationRadius or 100), cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType)
                    end
                else
                    reference, refName = AIUtils.AIFindStartLocationNeedsEngineer(aiBrain, cons.LocationType,
                        (cons.LocationRadius or 100), cons.ThreatMin, cons.ThreatMax, cons.ThreatRings, cons.ThreatType)
                end
                -- didn't find a location to build at
                if not reference or not refName then
                    self:PlatoonDisband()
                    return
                end
            end

            -- If moving far from base, tell the assisting platoons to not go with
            if cons.FireBase or cons.ExpansionBase then
                local guards = eng:GetGuards()
                for k,v in guards do
                    if not v.Dead and v.PlatoonHandle then
                        v.PlatoonHandle:PlatoonDisband()
                    end
                end
            end

            if not cons.BaseTemplate and (cons.NearMarkerType == 'Naval Area' or cons.NearMarkerType == 'Defensive Point' or cons.NearMarkerType == 'Expansion Area') then
                baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]
            end
            if cons.ExpansionBase and refName then
                AIBuildStructures.AINewExpansionBase(aiBrain, refName, reference, eng, cons)
            end
            relative = false
            if reference and aiBrain:GetThreatAtPosition(reference , 1, true, 'AntiSurface') > 0 then
                --aiBrain:ExpansionHelp(eng, reference)
            end
            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))
            -- Must use BuildBaseOrdered to start at the marker; otherwise it builds closest to the eng
            --buildFunction = AIBuildStructures.AIBuildBaseTemplateOrdered
            buildFunction = AIBuildStructures.AIBuildBaseTemplate
        elseif cons.NearMarkerType and cons.NearMarkerType == 'Defensive Point' then
            baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]

            relative = false
            local pos = self:GetPlatoonPosition()
            reference, refName = AIUtils.AIFindDefensivePointNeedsStructure(aiBrain, cons.LocationType, (cons.LocationRadius or 100),
                            cons.MarkerUnitCategory, cons.MarkerRadius, cons.MarkerUnitCount, (cons.ThreatMin or 0), (cons.ThreatMax or 1),
                            (cons.ThreatRings or 1), (cons.ThreatType or 'AntiSurface'))

            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))

            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
        elseif cons.NearMarkerType and cons.NearMarkerType == 'Naval Defensive Point' then
            baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]

            relative = false
            local pos = self:GetPlatoonPosition()
            reference, refName = AIUtils.AIFindNavalDefensivePointNeedsStructure(aiBrain, cons.LocationType, (cons.LocationRadius or 100),
                            cons.MarkerUnitCategory, cons.MarkerRadius, cons.MarkerUnitCount, (cons.ThreatMin or 0), (cons.ThreatMax or 1),
                            (cons.ThreatRings or 1), (cons.ThreatType or 'AntiSurface'))

            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))

            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
        elseif cons.NearMarkerType and (cons.NearMarkerType == 'Rally Point' or cons.NearMarkerType == 'Protected Experimental Construction') then
            --DUNCAN - add so experimentals build on maps with no markers.
            if not cons.ThreatMin or not cons.ThreatMax or not cons.ThreatRings then
                cons.ThreatMin = -1000000
                cons.ThreatMax = 1000000
                cons.ThreatRings = 0
            end
            relative = false
            local pos = self:GetPlatoonPosition()
            reference, refName = AIUtils.AIGetClosestThreatMarkerLoc(aiBrain, cons.NearMarkerType, pos[1], pos[3],
                                                            cons.ThreatMin, cons.ThreatMax, cons.ThreatRings)
            if not reference then
                reference = pos
            end
            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))
            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
        elseif cons.NearMarkerType then
            --WARN('*Data weird for builder named - ' .. self.BuilderName)
            if not cons.ThreatMin or not cons.ThreatMax or not cons.ThreatRings then
                cons.ThreatMin = -1000000
                cons.ThreatMax = 1000000
                cons.ThreatRings = 0
            end
            if not cons.BaseTemplate and (cons.NearMarkerType == 'Defensive Point' or cons.NearMarkerType == 'Expansion Area') then
                baseTmpl = baseTmplFile['ExpansionBaseTemplates'][factionIndex]
            end
            relative = false
            local pos = self:GetPlatoonPosition()
            reference, refName = AIUtils.AIGetClosestThreatMarkerLoc(aiBrain, cons.NearMarkerType, pos[1], pos[3],
                                                            cons.ThreatMin, cons.ThreatMax, cons.ThreatRings)
            if cons.ExpansionBase and refName then
                AIBuildStructures.AINewExpansionBase(aiBrain, refName, reference, (cons.ExpansionRadius or 100), cons.ExpansionTypes, nil, cons)
            end
            if reference and aiBrain:GetThreatAtPosition(reference, 1, true) > 0 then
                --aiBrain:ExpansionHelp(eng, reference)
            end
            table.insert(baseTmplList, AIBuildStructures.AIBuildBaseTemplateFromLocation(baseTmpl, reference))
            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
        elseif cons.AvoidCategory then
            relative = false
            local pos = aiBrain.BuilderManagers[eng.BuilderManagerData.LocationType].EngineerManager.Location
            local cat = cons.AdjacencyCategory
            -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
            if type(cat) == 'string' then
                cat = ParseEntityCategory(cat)
            end
            local avoidCat = cons.AvoidCategory
            -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
            if type(avoidCat) == 'string' then
                avoidCat = ParseEntityCategory(avoidCat)
            end
            local radius = (cons.AdjacencyDistance or 50)
            if not pos or not pos then
                coroutine.yield(1)
                self:PlatoonDisband()
                return
            end
            reference  = AIUtils.FindUnclutteredArea(aiBrain, cat, pos, radius, cons.maxUnits, cons.maxRadius, avoidCat)
            buildFunction = AIBuildStructures.AIBuildAdjacency
            table.insert(baseTmplList, baseTmpl)
        elseif cons.AdjacencyCategory then
            relative = false
            local pos = aiBrain.BuilderManagers[eng.BuilderManagerData.LocationType].EngineerManager.Location
            local cat = cons.AdjacencyCategory
            -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
            if type(cat) == 'string' then
                cat = ParseEntityCategory(cat)
            end
            local radius = (cons.AdjacencyDistance or 50)
            if not pos or not pos then
                coroutine.yield(1)
                self:PlatoonDisband()
                return
            end
            reference  = AIUtils.GetOwnUnitsAroundPoint(aiBrain, cat, pos, radius, cons.ThreatMin, cons.ThreatMax, cons.ThreatRings)
            buildFunction = AIBuildStructures.AIBuildAdjacency
            table.insert(baseTmplList, baseTmpl)
        else
            table.insert(baseTmplList, baseTmpl)
            relative = true
            reference = true
            buildFunction = AIBuildStructures.AIExecuteBuildStructureEdit
        end
        if cons.BuildClose then
            closeToBuilder = eng
        end
        if cons.BuildStructures[1] == 'T1Resource' or cons.BuildStructures[1] == 'T2Resource' or cons.BuildStructures[1] == 'T3Resource' then
            relative = true
            closeToBuilder = eng
            local guards = eng:GetGuards()
            for k,v in guards do
                if not v.Dead and v.PlatoonHandle and aiBrain:PlatoonExists(v.PlatoonHandle) then
                    v.PlatoonHandle:PlatoonDisband()
                end
            end
			-- LOG("*-----------AI DEBUG: Engineer building Mex" .. eng.Sync.id)
            buildFunction = AIBuildStructures.AIExecuteBuildStructure
        end

        --LOG("*AI DEBUG: Setting up Callbacks for " .. eng.Sync.id)
        self.SetupEngineerCallbacks(eng)

        -------- BUILD BUILDINGS HERE --------
        for baseNum, baseListData in baseTmplList do
            for k, v in cons.BuildStructures do
                if aiBrain:PlatoonExists(self) then
                    if not eng.Dead then
                        local faction = SUtils.GetEngineerFaction(eng)
                        if aiBrain.CustomUnits[v] and aiBrain.CustomUnits[v][faction] then
                            local replacement = SUtils.GetTemplateReplacement(aiBrain, v, faction, buildingTmpl)
                            if replacement then
                                buildFunction(aiBrain, eng, v, closeToBuilder, relative, replacement, baseListData, reference, cons.NearMarkerType,cons)
                            else
                                buildFunction(aiBrain, eng, v, closeToBuilder, relative, buildingTmpl, baseListData, reference, cons.NearMarkerType,cons)
                            end
                        else
                            buildFunction(aiBrain, eng, v, closeToBuilder, relative, buildingTmpl, baseListData, reference, cons.NearMarkerType,cons)
                        end
                    else
                        if aiBrain:PlatoonExists(self) then
                            coroutine.yield(1)
                            self:PlatoonDisband()
                            return
                        end
                    end
                end
            end
        end

        -- wait in case we're still on a base
        local count = 0
        while not eng.Dead and eng:IsUnitState('Attached') and count < 2 do
            coroutine.yield(60)
            count = count + 1
        end

        if not eng.Dead and not eng:IsUnitState('Building') then
            return self.ProcessBuildCommand(eng, false)
        end
    end,

    -- Fixed a bug where the ACU stops working when build to close
    ProcessBuildCommand = function(eng, removeLastBuild)
        if not eng or eng.Dead or not eng.PlatoonHandle then
            return
        end
        local aiBrain = eng.PlatoonHandle:GetBrain()
        if not aiBrain.sorianedit then
            return SorianEditPlatoonClass.ProcessBuildCommand(eng, removeLastBuild)
        end

        if not aiBrain or eng.Dead or not eng.EngineerBuildQueue or table.empty(eng.EngineerBuildQueue) then
            if aiBrain:PlatoonExists(eng.PlatoonHandle) then
                if not eng.AssistSet and not eng.AssistPlatoon and not eng.UnitBeingAssist and not eng.UnitBeingBuiltBehavior then
                    eng.PlatoonHandle:PlatoonDisband()
                end
            end
            if eng then eng.ProcessBuild = nil end
            return
        end

        -- it wasn't a failed build, so we just finished something
        if removeLastBuild then
            table.remove(eng.EngineerBuildQueue, 1)
        end

		-- eng.Stuck = false
        eng.ProcessBuildDone = false
        IssueClearCommands({eng})
        local commandDone = false
        local PlatoonPos
		local basePosition = aiBrain.BuilderManagers['MAIN'].Position
        while not eng.Dead and not commandDone and not table.empty(eng.EngineerBuildQueue)  do
            local whatToBuild = eng.EngineerBuildQueue[1][1]
            local buildLocation = {eng.EngineerBuildQueue[1][2][1], 0, eng.EngineerBuildQueue[1][2][2]}
            if GetTerrainHeight(buildLocation[1], buildLocation[3]) > GetSurfaceHeight(buildLocation[1], buildLocation[3]) then
                --land
                buildLocation[2] = GetTerrainHeight(buildLocation[1], buildLocation[3])
            else
                --water
                buildLocation[2] = GetSurfaceHeight(buildLocation[1], buildLocation[3])
            end
            local buildRelative = eng.EngineerBuildQueue[1][3]
			-- if eng.Stuck then
				-- IssueClearCommands({eng})
				-- eng.EngineerBuildQueue = {}
				-- IssueMove({eng}, basePosition)
				-- break
			-- end
            if not eng.NotBuildingThread then
                eng.NotBuildingThread = eng:ForkThread(eng.PlatoonHandle.WatchForNotBuilding)
            end
            -- see if we can move there first
            if AIUtils.EngineerMoveWithSafePathSE(aiBrain, eng, buildLocation) then
                if not eng or eng.Dead or not eng.PlatoonHandle or not aiBrain:PlatoonExists(eng.PlatoonHandle) then
                    return
                end
                -- issue buildcommand to block other engineers from caping mex/hydros or to reserve the buildplace
                PlatoonPos = eng:GetPosition()
                -- if SUtils.GetIsACU(eng:GetUnitId()) and VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, buildLocation[1] or 0, buildLocation[3] or 0) >= 30 then -- fix, eng with more than 1 entry in the Buildstructures{} table will break
                if VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, buildLocation[1] or 0, buildLocation[3] or 0) >= 30 then -- fix, eng with more than 1 entry in the Buildstructures{} table will break
                    aiBrain:BuildStructure(eng, whatToBuild, {buildLocation[1], buildLocation[3], 0}, buildRelative)
                    coroutine.yield(3)
                    -- wait until we are close to the buildplace so we have intel
                    while not eng.Dead do
                        PlatoonPos = eng:GetPosition()
                        if VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, buildLocation[1] or 0, buildLocation[3] or 0) < 12 then
                            break
                        end
                        -- check if we are already building in close range
                        -- (ACU can build at higher range than engineers)
                        if eng:IsUnitState("Building") then
                            break
                        end
                        coroutine.yield(1)
                    end
                end
                if not eng or eng.Dead or not eng.PlatoonHandle or not aiBrain:PlatoonExists(eng.PlatoonHandle) then
                    if eng then eng.ProcessBuild = nil end
                    return
                end
                -- if we are already building then we don't need to reclaim, repair or issue the BuildStructure again
				-- coroutine.yield(4) --------------- dunno why I put this here 
                if not eng:IsUnitState("Building") then
                    -- cancel all commands, also the buildcommand for blocking mex to check for reclaim or capture
                    eng.PlatoonHandle:Stop()
                    -- check to see if we need to reclaim or capture...
                    AIUtils.EngineerTryReclaimCaptureArea(aiBrain, eng, buildLocation)
                    -- check to see if we can repair
                    AIUtils.EngineerTryRepair(aiBrain, eng, whatToBuild, buildLocation)
                    -- otherwise, go ahead and build the next structure there
                    aiBrain:BuildStructure(eng, whatToBuild, {buildLocation[1], buildLocation[3], 0}, buildRelative)
                end
                if not eng.NotBuildingThread then
                    eng.NotBuildingThread = eng:ForkThread(eng.PlatoonHandle.WatchForNotBuilding)
                end
                -- if not eng.EngineerStuckThread then
                    -- eng.EngineerStuckThread = eng:ForkThread(eng.PlatoonHandle.EngineerStuck)
                -- end
                commandDone = true
            else
                -- we can't move there, so remove it from our build queue
                table.remove(eng.EngineerBuildQueue, 1)
            end
        end

        -- final check for if we should disband
        if not eng or eng.Dead or table.empty(eng.EngineerBuildQueue) then
            if eng.PlatoonHandle and aiBrain:PlatoonExists(eng.PlatoonHandle) and not eng.PlatoonHandle.UsingTransport then
                eng.PlatoonHandle:PlatoonDisband()
            end
        end
        if eng then eng.ProcessBuild = nil end
    end,

    EngineerStuck = function(eng)
		local lastpos
		local StuckCount
		local platPos
		LOG(' -------------------------------- Engineer stuck function called')
        while not eng.Dead and not eng:IsUnitState('Building') do
			platPos = eng:GetPosition() or false
			-- if haven't moved much -- 
			if lastpos and VDist2Sq( lastpos[1],lastpos[3], platPos[1],platPos[3] ) < 0.15 then
				StuckCount = StuckCount + 1
			else
				lastpos = SorianEditCOPY(platPos)
				StuckCount = 0
			end
			StuckCount = StuckCount + 1
			LOG(' -------------------------------- Engineerstuck function Engineer is not building at stuckcount: '..repr(StuckCount))
			
			if StuckCount > 10 then
				LOG(' -------------------------------- Engineer is stuck, disbanding at stuckcount: '..repr(StuckCount))
				eng:Kill()
				break
			end
            coroutine.yield(100)
        end
	end,
	
	-- For AI Patch V8 (Patched) fixed issue with AI cdr not building at game start
    WatchForNotBuilding = function(eng)
        coroutine.yield(10)
        local aiBrain = eng:GetAIBrain()
		
        while not eng.Dead and (eng.GoingHome or eng.UnitBeingBuiltBehavior or eng.ProcessBuild != nil or not eng:IsIdleState()) do
            coroutine.yield(30)
        end

		-- if not eng.Dead and eng.PlatoonHandle and eng:IsIdleState() and (GetGameTimeSeconds() > 120) then
			-- eng.PlatoonHandle:PlatoonDisband()
		-- end

        eng.NotBuildingThread = nil
        if not eng.Dead and eng:IsIdleState() and table.getn(eng.EngineerBuildQueue) != 0 and eng.PlatoonHandle then
            eng.PlatoonHandle.SetupEngineerCallbacks(eng)
            if not eng.ProcessBuild then
                eng.ProcessBuild = eng:ForkThread(eng.PlatoonHandle.ProcessBuildCommand, true)
            end
        end
    end,

-- SorianEdit Stuff: ------------------------------------------------------------------------------------

    -- Hook for Mass RepeatBuild
    PlatoonDisband = function(self)
        local aiBrain = self:GetBrain()
        if not self.SorianEdit then
            return SorianEditPlatoonClass.PlatoonDisband(self)
        end
		if self.TrackThread or self.TrackThread ~= false then
			self:KillThread(TrackThread)
			self.TrackThread = false
		end
       -- LOG('* AI-SorianEdit: PlatoonDisband = '..repr(self.PlatoonData.Construction.BuildStructures))
       -- LOG('* AI-SorianEdit: PlatoonDisband = '..repr(self.PlatoonData.Construction))
        if self.PlatoonData.Construction.RepeatBuild then
		local range = self.PlatoonData.MaxDistance or 1000
           -- LOG('* AI-SorianEdit: Repeat build = '..repr(self.PlatoonData.Construction.BuildStructures[1]))
            -- only repeat build if less then 10% of all structures are extractors
            -- local UCBC = import('/lua/editor/UnitCountBuildConditions.lua')
            -- if UCBC.HaveUnitRatioVersusCap(aiBrain, 0.10, '<', categories.STRUCTURE * categories.MASSEXTRACTION) then
                -- only repeat if we have a free mass spot
                local MABC = import('/lua/editor/MarkerBuildConditions.lua')
                if MABC.CanBuildOnMassLessThanDistance(aiBrain, 'MAIN', range, -500, 1, 0, 'AntiSurface', 1) then  -- LocationType, distance, threatMin, threatMax, threatRadius, threatType, maxNum
                    self:SetAIPlan('EngineerBuildAI')
                    return
                end
            -- end
            -- delete the repeat flag so the engineer will not repeat on its next task
            self.PlatoonData.Construction.RepeatBuild = nil
            self:MoveToLocation(aiBrain.BuilderManagers['MAIN'].Position, false)
            return
        end
        SorianEditPlatoonClass.PlatoonDisband(self)
    end,

    BaseManagersDistressAI = function(self)
        -- Only use this with AI-SorianEdit
         local aiBrain = self:GetBrain()
         if not aiBrain.sorianedit then
             return SorianEditPlatoonClass.BaseManagersDistressAI(self)
         end
         coroutine.yield(10)
         -- We are leaving this forked thread here because we don't need it.
         -- This shit is annoying!
         KillThread(CurrentThread())
    end,

    RenamePlatoon = function(self, text)
        for k, v in self:GetPlatoonUnits() do
            if v and not v.Dead then
                v:SetCustomName(text..' '..math.floor(GetGameTimeSeconds()))
            end
        end
    end,

    InterceptorBomberGunshipSorianEdit = function(self)
        AIAttackUtils.GetMostRestrictiveLayer(self) 
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local PlatoonStrength = table.getn(platoonUnits)
		-- self.TrackThread = false
		
        if platoonUnits and PlatoonStrength > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    if v:TestToggleCaps('RULEUTC_StealthToggle') then
                        
                        v:SetScriptBit('RULEUTC_StealthToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_CloakToggle') then
                        
                        v:SetScriptBit('RULEUTC_CloakToggle', false)
                    end
                    v:RemoveCommandCap('RULEUCC_Reclaim')
                    v:RemoveCommandCap('RULEUCC_Repair')
                end
            end
        end

        local MoveToCategories = {}
        -- if self.PlatoonData.MoveToCategories then
            -- for k,v in self.PlatoonData.MoveToCategories do
                -- table.insert(MoveToCategories, v )
            -- end
        -- else
            -- LOG('* AI-SorianEdit: * InterceptorSorianEdit: MoveToCategories missing in platoon '..self.BuilderName)
        -- end
		
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
		
        local PrioritizedCategories = {}
        if self.PlatoonData.PrioritizedCategories then
            for k,v in self.PlatoonData.PrioritizedCategories do
                table.insert(MoveToCategories, v )
            end
		else
            LOG('* AI-SorianEdit: * InterceptorSorianEdit: PrioritizedCategories missing in platoon '..self.BuilderName)
        end
		
        self:SetPrioritizedTargetList('Attack', PrioritizedCategories)
		
        local target
        local bAggroMove = self.PlatoonData.AggressiveMove
        local path
        local reason
        local maxRadius = self.PlatoonData.SearchRadius or 100
        local PlatoonPos = self:GetPlatoonPosition()
        local LastTargetPos = PlatoonPos
        local basePosition
        if self.MovementLayer == 'Water' then
            basePosition = PlatoonPos
        else
            -- land and air units are assigned to mainbase
            basePosition = aiBrain.BuilderManagers['MAIN'].Position
        end
        local GetTargetsFromBase = self.PlatoonData.GetTargetsFromBase
        local GetTargetsFrom = basePosition
        local LastTargetCheck
        local DistanceToBase = 0
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory or 'ALLUNITS'
        local armorPercent = nil
        local fuelPercent = nil
        local AirStaging = nil
        local AirStagingPos = nil
        local repairing = false
        local UnitNeedsRefuelRepair = 0
        while aiBrain:PlatoonExists(self) do
		
			UnitNeedsRefuelRepair =  0
			PlatoonUnits = self:GetPlatoonUnits()
			for k, v in PlatoonUnits do
				if not v.Dead then
					armorPercent = 100 / v:GetMaxHealth() * v:GetHealth()
					fuelPercent = v:GetFuelRatio() * 100
					if (armorPercent <= 70) or (fuelPercent <= 50) then
						UnitNeedsRefuelRepair = UnitNeedsRefuelRepair + 1
					end
				end
			end
			
			-- LOG('* AI-SorianEdit: * InterceptorBomberGunshipSorianEdit: Platoon: '..self.BuilderName..' with'..repr(UnitNeedsRefuelRepair)..' damaged units')
			
			repairing = false
			while PlatoonStrength / 3 < UnitNeedsRefuelRepair do
				if not repairing then
					-- LOG('* AI-SorianEdit: * InterceptorBomberGunshipSorianEdit: getting repairs for damaged units')
					AirStaging = self:FindClosestUnit('Attack', 'Ally', false, (categories.AIRSTAGINGPLATFORM * categories.STRUCTURE))
					if not AirStaging or AirStaging.Dead then
						-- LOG('* AI-SorianEdit: * InterceptorBomberGunshipSorianEdit: could not find airstaging')
						break
					end
					AirStagingPos = AirStaging:GetPosition()
					self:Patrol(AirStagingPos)
					-- LOG('* AI-SorianEdit: * InterceptorBomberGunshipSorianEdit: set patrol at Airstaging')
					repairing = true
				end
				PlatoonUnits = self:GetPlatoonUnits()
				for k, v in PlatoonUnits do
					if not v.Dead then
						armorPercent = 100 / v:GetMaxHealth() * v:GetHealth()
						fuelPercent = v:GetFuelRatio() * 100
						if (armorPercent >= 70) or (fuelPercent >= 50) then
							UnitNeedsRefuelRepair = UnitNeedsRefuelRepair - 1
							-- LOG('* AI-SorianEdit: * InterceptorBomberGunshipSorianEdit: unit repaired with '..repr(UnitNeedsRefuelRepair)..' damaged units left')
						end
					end
				end
				coroutine.yield(10)
			end
			
            PlatoonPos = self:GetPlatoonPosition()
            if not GetTargetsFromBase then
                GetTargetsFrom = PlatoonPos
            else
                DistanceToBase = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, basePosition[1] or 0, basePosition[3] or 0)
                if DistanceToBase > maxRadius then
                    target = nil
                end
            end
			
			-- if self.TrackThread or self.TrackThread ~= false then
				-- self:KillThread(TrackThread)
				-- self.TrackThread = false
			-- end
            -- only get a new target and make a move command if the target is dead
            if not target or target.Dead or target:BeenDestroyed() then
                UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', GetTargetsFrom, maxRadius, MoveToCategories, TargetSearchCategory, false )
				
				-- if ScenarioInfo.Options.SEPathing ~= 'No' and not self.TrackThread then
					-- self.TrackThread = self:ForkThread(SUtils.TrackPlatoon, aiBrain, UnitWithPath, false, -10)
				-- end
                if UnitWithPath then
                    --LOG('* AI-SorianEdit: *InterceptorSorianEdit: found UnitWithPath')
                    self:Stop()
                    target = UnitWithPath
                    if self.PlatoonData.IgnorePathing then
                        self:AttackTarget(UnitWithPath)
                    elseif path then
                        self:MovePathSorianEdit(aiBrain, path, bAggroMove, UnitWithPath)
                    -- if we dont have a path, but UnitWithPath is true, then we have no map markers but PathCanTo() found a direct path
                    else
                        self:MoveDirect(aiBrain, bAggroMove, UnitWithPath)
                    end
                    -- We moved to the target, attack it now if its still exists
                    if aiBrain:PlatoonExists(self) and UnitWithPath and not UnitWithPath.Dead and not UnitWithPath:BeenDestroyed() then
                        self:AttackTarget(UnitWithPath)
                    end
                elseif UnitNoPath then
                    --LOG('* AI-SorianEdit: *InterceptorSorianEdit: found UnitNoPath')
                    self:Stop()
                    target = UnitNoPath
                    self:Stop()
                    if self.MovementLayer == 'Air' then
                        self:AttackTarget(UnitNoPath)
                    else
                        self:SimpleReturnToBaseSorianEdit(basePosition)
                    end
                else
                    --LOG('* AI-SorianEdit: *InterceptorSorianEdit: no target found '..repr(reason))
                    -- we have no target return to main base
                    self:Stop()
                    if self.MovementLayer == 'Air' then
                        if VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, basePosition[1] or 0, basePosition[3] or 0) > 30 then
                            self:MoveToLocation(basePosition, false)
                        else
                            -- we are at home and we don't have a target. Disband!
                            if aiBrain:PlatoonExists(self) then
                                self:PlatoonDisband()
                                return
                            end
                        end
                    else
                        if not self.SuicideMode then
                            self.SuicideMode = true
                            self.PlatoonData.AttackEnemyStrength = 100
                            self.PlatoonData.GetTargetsFromBase = false
                            self.PlatoonData.MoveToCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self.PlatoonData.WeaponTargetCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self:InterceptorSorianEdit()
                        else
                            self:SimpleReturnToBaseSorianEdit(basePosition)
                        end
                    end
                end
				
            -- target exists and is not dead
            end
            if aiBrain:PlatoonExists(self) and target and not target.Dead then
                LastTargetPos = target:GetPosition()
                -- check if we are still inside the attack radius and be sure the area is not a nuke blast area
                if VDist2(basePosition[1] or 0, basePosition[3] or 0, LastTargetPos[1] or 0, LastTargetPos[3] or 0) < maxRadius then
                    self:Stop()
                    if self.PlatoonData.IgnorePathing or VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, LastTargetPos[1] or 0, LastTargetPos[3] or 0) < 60 then
                        self:AttackTarget(target)
                    else
                        self:MoveToLocation(LastTargetPos, false)
                    end
                else
                    target = nil
                end
            end
            coroutine.yield(10)
        end
    end,

    LandAttackSorianEdit = function(self)
        if 1==1 then
            self:HeroFightPlatoonSorianEdit()
            return
        end 
        AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        -- Search all platoon units and activate Stealth and Cloak (mostly Modded units)
        local platoonUnits = self:GetPlatoonUnits()
        local PlatoonStrength = table.getn(platoonUnits)
        local ExperimentalInPlatoon = false
        if platoonUnits and PlatoonStrength > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    if v:TestToggleCaps('RULEUTC_StealthToggle') then
                        v:SetScriptBit('RULEUTC_StealthToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_CloakToggle') then
                        v:SetScriptBit('RULEUTC_CloakToggle', false)
                    end
                    if EntityCategoryContains(categories.EXPERIMENTAL, v) then
                        ExperimentalInPlatoon = true
                    end
                    -- prevent units from reclaiming while attack moving
                    v:RemoveCommandCap('RULEUCC_Reclaim')
                    v:RemoveCommandCap('RULEUCC_Repair')
                end
            end
        end
        local MoveToCategories = {}
        if self.PlatoonData.MoveToCategories then
            for k,v in self.PlatoonData.MoveToCategories do
                table.insert(MoveToCategories, v )
            end
        else
            LOG('* AI-SorianEdit: * LandAttackSorianEdit: MoveToCategories missing in platoon '..self.BuilderName)
        end
        -- Set the target list to all platoon units
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
        self:SetPrioritizedTargetList('Attack', WeaponTargetCategories)
        local aiBrain = self:GetBrain()
        local target
        local bAggroMove = self.PlatoonData.AggressiveMove
        local WantsTransport = self.PlatoonData.RequireTransport
        local maxRadius = self.PlatoonData.SearchRadius
        local PlatoonPos = self:GetPlatoonPosition()
        local LastTargetPos = PlatoonPos
        local DistanceToTarget = 0
        local basePosition = aiBrain.BuilderManagers['MAIN'].Position
        local losttargetnum = 0
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory or 'ALLUNITS'
        while aiBrain:PlatoonExists(self) do
            PlatoonPos = self:GetPlatoonPosition()
            -- only get a new target and make a move command if the target is dead or after 10 seconds
            if not target or target.Dead then
                UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', PlatoonPos, maxRadius, MoveToCategories, TargetSearchCategory, false )
                if UnitWithPath then
                    losttargetnum = 0
                    self:Stop()
                    target = UnitWithPath
                    LastTargetPos = table.copy(target:GetPosition())
                    DistanceToTarget = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, LastTargetPos[1] or 0, LastTargetPos[3] or 0)
                    if DistanceToTarget > 30 then
                        -- if we have a path then use the waypoints
                        if self.PlatoonData.IgnorePathing then
                            self:Stop()
                            self:SetPlatoonFormationOverride('AttackFormation')
                            self:AttackTarget(UnitWithPath)
                        else
                            self:MoveDirect(aiBrain, bAggroMove, target)
                        end
                        -- We moved to the target, attack it now if its still exists
                        if aiBrain:PlatoonExists(self) and UnitWithPath and not UnitWithPath.Dead and not UnitWithPath:BeenDestroyed() then
                            self:Stop()
                            self:SetPlatoonFormationOverride('AttackFormation')
                            self:AttackTarget(UnitWithPath)
                        end
                    end
                elseif UnitNoPath then
                    losttargetnum = 0
                    self:Stop()
                    target = UnitNoPath
                    self:MoveWithTransport(aiBrain, bAggroMove, target, basePosition, ExperimentalInPlatoon)
                    -- We moved to the target, attack it now if its still exists
                    if aiBrain:PlatoonExists(self) and UnitNoPath and not UnitNoPath.Dead and not UnitNoPath:BeenDestroyed() then
                        self:SetPlatoonFormationOverride('AttackFormation')
                        self:AttackTarget(UnitNoPath)
                    end
                else
                    -- we have no target return to main base
                    losttargetnum = losttargetnum + 1
                    if losttargetnum > 2 then
                        if not self.SuicideMode then
                            self.SuicideMode = true
                            self.PlatoonData.AttackEnemyStrength = 100
                            self.PlatoonData.GetTargetsFromBase = false
                            self.PlatoonData.MoveToCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self.PlatoonData.WeaponTargetCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self:Stop()
                            self:SetPlatoonFormationOverride('NoFormation')
                            self:LandAttackSorianEdit()
                        else
                            self:Stop()
                            self:SetPlatoonFormationOverride('NoFormation')
                            self:ForceReturnToNearestBaseSorianEdit()
                        end
                    end
                end
            else
                if aiBrain:PlatoonExists(self) and target and not target.Dead and not target:BeenDestroyed() then
                    LastTargetPos = target:GetPosition()
                    -- check if the target is not in a nuke blast area
                    if AIUtils.IsNukeBlastAreaSE(aiBrain, LastTargetPos) then
                        target = nil
                    else
                        self:SetPlatoonFormationOverride('AttackFormation')
                        self:AttackTarget(target)
                    end
                    coroutine.yield(20)
                end
            end
            coroutine.yield(10)
        end
    end,
    
    ACUAttackSorianEdit = function(self)
        --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: START '..self.BuilderName)
        AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        local aiBrain = self:GetBrain()
        local PlatoonUnits = self:GetPlatoonUnits()
        local cdr = PlatoonUnits[1]
		self.TrackThread = false
		self.maxRadius = false
        self.created = GetGameTimeSeconds()
        -- There should be only the commander inside this platoon. Check it.
        if not cdr then
            WARN('* ACUAttackSorianEdit: Platoon formed but Commander unit not found!')
            coroutine.yield(1)
            for k,v in self:GetPlatoonUnits() or {} do
                if EntityCategoryContains(categories.COMMAND, v) then
                    WARN('* ACUAttackSorianEdit: Commander found in platoon on index: '..k)
                    cdr = v
                else
                    WARN('* ACUAttackSorianEdit: Platoon unit Index '..k..' is not a commander!')
                end
            end
            if not cdr then
                self:PlatoonDisband()
                return
            end
        end
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        cdr.HealthOLD = 100
        cdr.CDRHome = aiBrain.BuilderManagers['MAIN'].Position
        cdr.smartPos = cdr:GetPosition()
        cdr.position = cdr.smartPos
        cdr.LastDamaged = 0
        cdr.LastMoved = GetGameTimeSeconds()
        local MoveToCategories = {}
        if self.PlatoonData.MoveToCategories then
            for k,v in self.PlatoonData.MoveToCategories do
                table.insert(MoveToCategories, v )
            end
        else
            LOG('* AI-SorianEdit: * ACUAttackSorianEdit: MoveToCategories missing in platoon '..self.BuilderName)
        end
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
		
        local UnitBlueprint = cdr:GetBlueprint()
        for _, weapon in UnitBlueprint.Weapon or {} do
            -- filter dummy weapons
            if weapon.Damage == 0
            or weapon.WeaponCategory == 'Missile'
            or weapon.WeaponCategory == 'Anti Navy'
            or weapon.WeaponCategory == 'Anti Air'
            or weapon.WeaponCategory == 'Defense'
            or weapon.WeaponCategory == 'Teleport' then
                continue
            end
            -- check if the weapon is only enabled by an enhancment
            if weapon.EnabledByEnhancement then
                WeaponEnabled = false
                -- check if we have the enhancement
                for k, v in SimUnitEnhancements[cdr.EntityId] or {} do
                    if v == weapon.EnabledByEnhancement then
                        -- enhancement is installed, the weapon is valid
                        WeaponEnabled = true
                        --LOG('* AI-Uveso: * ACUChampionPlatoon: Weapon: '..weapon.EnabledByEnhancement..' - is installed by an enhancement!')
                        -- no need to search for other enhancements
                        break
                    end
                end
                -- if the wepon is not installed, continue with the next weapon
                if not WeaponEnabled then
                    --LOG('* AI-Uveso: * ACUChampionPlatoon: Weapon: '..weapon.EnabledByEnhancement..' - is not installed.')
                    continue
                end
            end
            --WARN('* AI-Uveso: * ACUChampionPlatoon: Weapon: '..weapon.DisplayName..' - WeaponCategory: '..weapon.WeaponCategory..' - MaxRadius:'..weapon.MaxRadius..'')
            if weapon.OverChargeWeapon then
                OverchargeWeapon = weapon
            end
            if not cdr.MaxWeaponRange or cdr.MaxWeaponRange < weapon.MaxRadius then
                cdr.MaxWeaponRange = weapon.MaxRadius
            end
        end
		
        UnitBlueprint = nil
        --WARN('* AI-Uveso: * ACUChampionPlatoon: cdr.MaxWeaponRange: '..cdr.MaxWeaponRange)

        -- set playablearea so we know where the map border is.
        local playablearea
        if ScenarioInfo.MapData.PlayableRect then
            playablearea = ScenarioInfo.MapData.PlayableRect
        else
            playablearea = {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
        end
        self:SetPrioritizedTargetList('Attack', WeaponTargetCategories)
        -- prevent ACU from reclaiming while attack moving
        cdr:RemoveCommandCap('RULEUCC_Reclaim')
        cdr:RemoveCommandCap('RULEUCC_Repair')
        local TargetUnit, DistanceToTarget
		self.TargetData = TargetUnit
        local PlatoonPos = self:GetPlatoonPosition()
        -- land and air units are assigned to mainbase
        local GetTargetsFromBase = self.PlatoonData.GetTargetsFromBase
        local GetTargetsFrom = cdr.CDRHome
        local LastTargetCheck
        local DistanceToBase = 0
        local UnitsInACUBaseRange
        local ReturnToBaseAfterGameTime = self.PlatoonData.ReturnToBaseAfterGameTime or false
        local DoNotLeavePlatoonUnderHealth = self.PlatoonData.DoNotLeavePlatoonUnderHealth or 30
        local maxRadius
        local maxTimeRadius
        local SearchRadius = self.PlatoonData.SearchRadius or 250
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory or 'ALLUNITS'
		
        local MoveToTarget
        local MoveToTargetPos
        local FocusTarget
        local FocusTargetPos
        local smartPos = {}
        local unitPos
        local x
        local y
        local alpha
        local NavigatorGoal
        local UnderAttack
        local CDRHealth
        local InstalledEnhancementsCount = 0
		
        while aiBrain:PlatoonExists(self) do
		
            if cdr.Dead then
                self:PlatoonDisband()
				break
			end
            cdr.position = self:GetPlatoonPosition()
            -- leave the loop and disband this Platoon in time
            if ReturnToBaseAfterGameTime and ReturnToBaseAfterGameTime < GetGameTimeSeconds()/60 then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: ReturnToBaseAfterGameTime:'..ReturnToBaseAfterGameTime..' >= '..GetGameTimeSeconds()/60)
                SUtils.CDRParkingHome(self,cdr)
                break
            end
			
            -- the maximum radius that the ACU can be away from base
            maxRadius = (SUtils.ComHealth(cdr)-30)*5
            maxTimeRadius = 1024 - GetGameTimeSeconds()/60*25 -- reduce the radius by 25 map units per minute
			
            if maxRadius > maxTimeRadius then 
                maxRadius = math.max( 60, maxTimeRadius ) -- IF maxTimeRadius < 60 THEN maxTimeRadius = 60
            end
			
            if maxRadius > SearchRadius then
                maxRadius = SearchRadius
            end
			
			self.maxRadius = maxRadius
				
            UnitsInACUBaseRange = aiBrain:GetUnitsAroundPoint( TargetSearchCategory, cdr.CDRHome, maxRadius, 'Enemy')
			
            -- get the position of this platoon (ACU)
            if not GetTargetsFromBase then
                -- we don't get out targets relativ to base position. Use the ACU position
                GetTargetsFrom = cdr.position
            end
			
            ----------------------------------------------
            --- This is the start of the main ACU loop ---
            ----------------------------------------------
			
            if aiBrain:GetEconomyStoredRatio('ENERGY') > 0.40 then
                cdr:SetAutoOvercharge(true)
            else
                cdr:SetAutoOvercharge(false)
            end
           
            -- in case we have no Factory left, recover!
            if not aiBrain:GetListOfUnits(categories.STRUCTURE * categories.FACTORY * categories.LAND - categories.SUPPORTFACTORY, false)[1] then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: exiting attack function. RECOVER')
                self:PlatoonDisband()
                return
            -- check if we are further away from base then the closest enemy
            -- elseif SUtils.CDRRunHomeEnemyNearBase(self,cdr,UnitsInACUBaseRange) then
                -- --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: CDRRunHomeEnemyNearBase')
                -- TargetUnit = false
            -- check if we get actual damage, then move home
            elseif SUtils.CDRRunHomeAtDamage(self,cdr) then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: CDRRunHomeAtDamage')
                TargetUnit = false
            -- check how much % health we have and go closer to our base
            elseif SUtils.CDRRunHomeHealthRange(self,cdr,maxRadius) then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: CDRRunHomeHealthRange')
                TargetUnit = false
            else
               --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: ATTACK')
                -- ToDo: scann for enemy COM and change target if needed
                TargetUnit, _, _, _ = AIUtils.AIFindNearestCategoryTargetInRangeSorianEditCDRSorianEdit(aiBrain, GetTargetsFrom, maxRadius, MoveToCategories, TargetSearchCategory, false)
				local EACUFocus = false
				local EACUBRange = false
				EACUBRange = ( aiBrain:GetUnitsAroundPoint( categories.COMMAND, GetTargetsFrom, (maxRadius/4), 'Enemy') )[1]
                -- if we have a target, move to the target and attack
                if TargetUnit then
					self.TargetData = TargetUnit
					
					---------------
					-- Targeting --
					---------------
					MoveToTarget = false
					MoveToTargetPos = false

					-- start micro only if the ACU is closer to our base than any other enemy unit
					if TargetUnit then
						MoveToTarget = TargetUnit
						MoveToTargetPos = TargetUnit:GetPosition()
					-- we don't have a dfocussed target, is there a enemy ACU in close range ? 
					elseif EACUBRange then
						MoveToTarget = EACUBRange
						MoveToTargetPos = MoveToTarget:GetPosition()
					end
					
					FocusTarget = ( aiBrain:GetUnitsAroundPoint( ( categories.ALLUNITS - categories.WALL - (categories.AIR * categories.MOBILE) ) , GetTargetsFrom, 26, 'Enemy') )[1]
					EACUFocus = ( aiBrain:GetUnitsAroundPoint( categories.COMMAND, GetTargetsFrom, 28, 'Enemy') )[1]
					
					if FocusTarget then
						FocusTargetPos = FocusTarget:GetPosition()
					elseif EACUFocus then
						FocusTarget = EACUFocus
						FocusTargetPos = FocusTarget:GetPosition()
					else
						FocusTargetPos = false
					end
					
					CDRHealth = SUtils.ComHealth(cdr)
					
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: ATTACK TargetUnit')
				
					if ScenarioInfo.Options.SEPathing ~= 'No' and not self.TrackThread then
						self.TrackThread = self:ForkThread(SUtils.TrackCDRPlatoon, aiBrain, MoveToTargetPos, false, -6)
					end
					
					if not aiBrain:PlatoonExists(self) or cdr.Dead then
						self:PlatoonDisband()
						return
					end
					
					NavigatorGoal = cdr:GetNavigator():GetGoalPos()
					
					if MoveToTargetPos then
						-- if the target has moved or we got a new target, delete the Weapon Blocked flag.
						if cdr.LastMoveToTargetPos ~= MoveToTargetPos then
							cdr.WeaponBlocked = false
							cdr.LastMoveToTargetPos = MoveToTargetPos
						end
						-- Set different move destination if weapon fire is blocked
						if cdr.WeaponBlocked then
							-- Weapoon fire is blocked, move to the target as close as possible.
							smartPos = { MoveToTargetPos[1], MoveToTargetPos[2], MoveToTargetPos[3] }
						else
							-- go closeer to the target depending on ACU health
							local RangeMod = CDRHealth/10
							if RangeMod < 1 then RangeMod = 0 end
							if RangeMod > 10 then RangeMod = 10 end
							-- Weapoon fire is not blocked, move to the target at Max Weapon Range.
							alpha = math.atan2 (MoveToTargetPos[3] - cdr.position[3] ,MoveToTargetPos[1] - cdr.position[1])
							x = MoveToTargetPos[1] - math.cos(alpha) * (cdr.MaxWeaponRange * 0.9 - RangeMod)
							y = MoveToTargetPos[3] - math.sin(alpha) * (cdr.MaxWeaponRange * 0.9 - RangeMod)
							smartPos = { x, GetTerrainHeight( x, y), y }
						end
					end
					
					-- in case we are not moving for 4 seconds, force moving (maybe blocked line of sight)
					if not cdr:IsUnitState("Moving") then
						if cdr.LastMoved + 4 < GetGameTimeSeconds() then
							smartPos = SUtils.RandomizePositionTML(smartPos)
							cdr.LastMoved = GetGameTimeSeconds()
						end
					else
						cdr.LastMoved = GetGameTimeSeconds()
					end

					-- check if we have already a move position
					if not smartPos[1] then
						smartPos = cdr.position
					end
					-- Validate move position, make sure it's not out of map
					if smartPos[1] < playablearea[1] then
						smartPos[1] = playablearea[1]
					elseif smartPos[1] > playablearea[3] then
						smartPos[1] = playablearea[3]
					end
					if smartPos[3] < playablearea[2] then
						smartPos[3] = playablearea[2]
					elseif smartPos[3] > playablearea[4] then
						smartPos[3] = playablearea[4]
					end
					-- check if the move position is new, then issue a move command
					-- ToDo in case we are under fire we should move in zig-zag to evade
					if VDist2( smartPos[1], smartPos[3], NavigatorGoal[1], NavigatorGoal[3] ) > 0.7 then
						IssueClearCommands({cdr})
						IssueMove({cdr}, smartPos )
					elseif VDist2( cdr.position[1], cdr.position[3], NavigatorGoal[1], NavigatorGoal[3] ) <= 0.7 then
					end

					-- fire primary weapon
					if FocusTargetPos and SUtils.CheckBlockingTerrain(cdr.position, FocusTargetPos, 'low', 0) then
						cdr.WeaponBlocked = true
					else
						cdr.WeaponBlocked = false
					end
					if not cdr.WeaponBlocked and FocusTarget and not FocusTarget.Dead and not FocusTarget:BeenDestroyed() then
						IssueAttack({cdr}, FocusTarget)
					end
					
                -- if we have no target, move to base. If we are at base, dance. (random moves)
                elseif SUtils.CDRForceRunHome(self,cdr) then
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: CDRForceRunHome true. we are running home')
                -- we are at home, dance if we have nothing to do.
                else
                    -- There is nothing to fight; so we left the attack function and see if we can build something
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit:We are at home and dancing')
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: exiting attack function')
                    self:PlatoonDisband()
                    return
                end
            end
			
            ------------------
            -- Enhancements --
            ------------------

            -- check if we are close to Main base, then decide if we can enhance
            if VDist2(cdr.position[1], cdr.position[3], cdr.CDRHome[1], cdr.CDRHome[3]) < 256 then
                -- only upgrade if we are good at health
                local check = true
                if self.created + 10 > GetGameTimeSeconds() then
                    check = false
                else
                end
                if CDRHealth < 60 then
                    check = false
                end
                if UnderAttack then
                    check = false
                end
                -- Only upgrade with full Energy storage
                if aiBrain:GetEconomyStoredRatio('ENERGY') < 1.00 then
                    check = false
                end
                -- First enhancement needs at least +300 energy
                if aiBrain:GetEconomyTrend('ENERGY')*10 < 300 then
                    check = false
                end
                -- Enhancement 3 and all other should only be done if we have good eco. (Black Ops ACU!)
                if InstalledEnhancementsCount >= 2 and (aiBrain:GetEconomyStoredRatio('MASS') < 0.40) then
                    check = false
                end
                if check then
                    -- in case we have engineers inside the platoon, let them assist the ACU
                    for _, unit in self:GetPlatoonUnits() do
                        if unit.Dead then continue end
                        -- exclude the ACU
                        if unit.CDRHome then
                            continue
                        end
                        if EntityCategoryContains(categories.ENGINEER - categories.POD, unit) then
                            --LOG('Engineer ASSIST ACU')
                            -- NOT working for enhancements
                            IssueGuard({unit}, cdr)
                        end
                        
                    end
                    -- will only start enhancing if ECO is good
                    local InstalledEnhancement = self:BuildACUEnhancementsSorianEdit(cdr, InstalledEnhancementsCount < 1)
                    --local InstalledEnhancement = self:BuildACUEnhancements(cdr, false)
                    -- do we have succesfull installed the enhancement ?
                    if InstalledEnhancement then
                        SPEW('* AI-Uveso: * ACUChampionPlatoon: enhancement '..InstalledEnhancement..' installed')
                        -- count enhancements
                        InstalledEnhancementsCount = 0
                        for i, name in SimUnitEnhancements[cdr.EntityId] or {} do
                            InstalledEnhancementsCount = InstalledEnhancementsCount + 1
                            SPEW('* AI-Uveso: * ACUChampionPlatoon: Found enhancement: '..name..' - InstalledEnhancementsCount = '..InstalledEnhancementsCount..'')
                        end
                        -- check if we have installed a weapon
                        local tempEnhanceBp = cdr:GetBlueprint().Enhancements[InstalledEnhancement]
                        -- Is it a weapon with a new max range ?
                        if tempEnhanceBp.NewMaxRadius then
                            -- set the new max range
                            if not cdr.MaxWeaponRange or cdr.MaxWeaponRange < tempEnhanceBp.NewMaxRadius then
                                cdr.MaxWeaponRange = tempEnhanceBp.NewMaxRadius -- maxrange minus 10%
                                SPEW('* AI-Uveso: * ACUChampionPlatoon: New cdr.MaxWeaponRange: '..cdr.MaxWeaponRange..' ['..InstalledEnhancement..']')
                            end
                        else
                            --DebugArray(tempEnhanceBp)
                        end
                    end
                end
            end
			
            coroutine.yield(3)
            --------------------------------------------
            --- This is the end of the main ACU loop ---
            --------------------------------------------
			
        end
        --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: END '..self.BuilderName)
        self:PlatoonDisband()
    end,
    
    BuildACUEnhancementsSorianEdit = function(platoon,cdr, force)
        local EnhancementsByUnitID = {
            -- UEF
            ['uel0001'] = {'HeavyAntiMatterCannon', 'DamageStabilization', 'Shield', 'ShieldGeneratorField'},
            -- Aeon
            ['ual0001'] = {'HeatSink', 'CrysalisBeam', 'Shield', 'ShieldHeavy'},
            -- Cybran
            ['url0001'] = {'CoolingUpgrade', 'StealthGenerator', 'MicrowaveLaserGenerator', 'CloakingGenerator'},
            -- Seraphim
            ['xsl0001'] = {'RateOfFire', 'DamageStabilization', 'BlastAttack', 'DamageStabilizationAdvanced'},
            -- Nomads
            ['xnl0001'] = {'Capacitor', 'GunUpgrade', 'MovementSpeedIncrease', 'DoubleGuns'},

            -- UEF - Black Ops ACU
            ['eel0001'] = {'GatlingEnergyCannon', 'CombatEngineering', 'ShieldBattery', 'AutomaticBarrelStabalizers', 'AssaultEngineering', 'ImprovedShieldBattery', 'EnhancedPowerSubsystems', 'ApocalypticEngineering', 'AdvancedShieldBattery'},
            -- Aeon
            ['eal0001'] = {'PhasonBeamCannon', 'CombatEngineering', 'ShieldBattery', 'DualChannelBooster', 'AssaultEngineering', 'ImprovedShieldBattery', 'EnergizedMolecularInducer', 'ApocalypticEngineering', 'AdvancedShieldBattery'},
            -- Cybram
            ['erl0001'] = {'EMPArray', 'CombatEngineering', 'ArmorPlating', 'AdjustedCrystalMatrix', 'AssaultEngineering', 'StructuralIntegrityFields', 'EnhancedLaserEmitters', 'ApocalypticEngineering', 'CompositeMaterials'},
            -- Seraphim
            ['esl0001'] = {'PlasmaGatlingCannon', 'CombatEngineering', 'ElectronicsEnhancment', 'PhasedEnergyFields', 'AssaultEngineering', 'PersonalTeleporter', 'SecondaryPowerFeeds', 'ApocalypticEngineering', 'CloakingSubsystems'},
        }
        local CRDBlueprint = cdr:GetBlueprint()
        --LOG('* AI-SorianEdit: BlueprintId '..repr(CRDBlueprint.BlueprintId))
        local ACUUpgradeList = EnhancementsByUnitID[CRDBlueprint.BlueprintId]
        --LOG('* AI-SorianEdit: ACUUpgradeList '..repr(ACUUpgradeList))
        local NextEnhancement = false
        local HaveEcoForEnhancement = false
        for _,enhancement in ACUUpgradeList or {} do
            local wantedEnhancementBP = CRDBlueprint.Enhancements[enhancement]
            -- LOG('* AI-SorianEdit: wantedEnhancementBP '..repr(wantedEnhancementBP))
            if not wantedEnhancementBP then
                SPEW('* AI-SorianEdit: ACUAttackSorianEdit: no enhancement found for  = '..repr(enhancement))
            elseif cdr:HasEnhancement(enhancement) then
                NextEnhancement = false
                -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit: Enhancement is already installed: '..enhancement)
            elseif platoon:EcoGoodForUpgradeSorianEdit(cdr, wantedEnhancementBP) then
                -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit: Eco is good for '..enhancement)
                if not NextEnhancement then
                    NextEnhancement = enhancement
                    HaveEcoForEnhancement = true
                    -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: *** Set as Enhancememnt: '..NextEnhancement)
                end
            elseif force then
                --LOG('* AI-SorianEdit: * ACUAttackAIUveso: BuildACUEnhancements: Eco is bad for '..enhancement..' - Ignoring eco requirement!')
                if not NextEnhancement then
                    NextEnhancement = enhancement
                    HaveEcoForEnhancement = true
                end
            else
                -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit: Eco is bad for '..enhancement)
                if not NextEnhancement then
                    NextEnhancement = enhancement
                    HaveEcoForEnhancement = false
                    -- if we don't have the eco for this ugrade, stop the search
                    LOG('* AI-SorianEdit: * ACUAttackSorianEdit: canceled search. no eco available')
                    break
                end
            end
        end
        if NextEnhancement and HaveEcoForEnhancement then
            -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit Building '..NextEnhancement)
            if platoon:BuildEnhancementSorianEdit(cdr, NextEnhancement) then
                -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit returned true'..NextEnhancement)
                return NextEnhancement
            else
                -- LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildACUEnhancementsSorianEdit returned false'..NextEnhancement)
                return false
            end
        end
        return false
    end,
    
    EcoGoodForUpgradeSorianEdit = function(platoon,cdr,enhancement)
        local aiBrain = platoon:GetBrain()
        local BuildRate = cdr:GetBuildRate()
        if not enhancement.BuildTime then
            WARN('* AI-SorianEdit: EcoGoodForUpgradeSorianEdit: Enhancement has no buildtime: '..repr(enhancement))
        end
        -- LOG('* AI-SorianEdit: cdr:GetBuildRate() '..BuildRate..'')
        local drainMass = (BuildRate / enhancement.BuildTime) * enhancement.BuildCostMass
        local drainEnergy = (BuildRate / enhancement.BuildTime) * enhancement.BuildCostEnergy
        -- LOG('* AI-SorianEdit: drain: m'..drainMass..'  e'..drainEnergy..'')
        -- LOG('* AI-SorianEdit: Pump: m'..math.floor(aiBrain:GetEconomyTrend('MASS')*10)..'  e'..math.floor(aiBrain:GetEconomyTrend('ENERGY')*10)..'')
        if aiBrain.HasParagon then
            return true
        elseif aiBrain:GetEconomyTrend('MASS')*10 >= drainMass and aiBrain:GetEconomyTrend('ENERGY')*10 >= drainEnergy then
            return true
        end
        return false
    end,
    
    BuildEnhancementSorianEdit = function(platoon,cdr,enhancement)
        --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildEnhancementSorianEdit '..enhancement)
        local aiBrain = platoon:GetBrain()

        IssueStop({cdr})
        IssueClearCommands({cdr})
        
        if not cdr:HasEnhancement(enhancement) then
            
            local tempEnhanceBp = cdr:GetBlueprint().Enhancements[enhancement]
            local unitEnhancements = import('/lua/enhancementcommon.lua').GetEnhancements(cdr.EntityId)
            -- Do we have already a enhancment in this slot ?
            if unitEnhancements[tempEnhanceBp.Slot] and unitEnhancements[tempEnhanceBp.Slot] ~= tempEnhanceBp.Prerequisite then
                -- remove the enhancement
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: Found enhancement ['..unitEnhancements[tempEnhanceBp.Slot]..'] in Slot ['..tempEnhanceBp.Slot..']. - Removing...')
                local order = { TaskName = "EnhanceTask", Enhancement = unitEnhancements[tempEnhanceBp.Slot]..'Remove' }
                IssueScript({cdr}, order)
                coroutine.yield(10)
            end
            --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildEnhancementSorianEdit: '..platoon:GetBrain().Nickname..' IssueScript: '..enhancement)
            local order = { TaskName = "EnhanceTask", Enhancement = enhancement }
            IssueScript({cdr}, order)
        end
        while aiBrain:PlatoonExists(platoon) and not cdr.Dead and not cdr:HasEnhancement(enhancement) do
            if SUtils.ComHealth(cdr) < 50 and SUtils.UnderAttack(cdr) and cdr.WorkProgress < 0.90 then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildEnhancementSorianEdit: '..platoon:GetBrain().Nickname..' Emergency!!! low health, canceling Enhancement '..enhancement)
                IssueStop({cdr})
                IssueClearCommands({cdr})
                return false
            end
            if cdr.WorkProgress < 0.30 and SUtils.UnderAttack(cdr) then
                SPEW('* AI-Uveso: BuildEnhancement: '..platoon:GetBrain().Nickname..' Emergency!!! WorkProgress < 30% and under attack, canceling Enhancement '..enhancement)
                IssueStop({cdr})
                IssueClearCommands({cdr})
                return false
            end
            coroutine.yield(3)
        end
        --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildEnhancementSorianEdit: '..platoon:GetBrain().Nickname..' Upgrade finished '..enhancement)
        return true
    end,

    MoveWithTransportSorianEdit = function(self, aiBrain, bAggroMove, target, basePosition, ExperimentalInPlatoon, MaxPlatoonWeaponRange, EnemyThreatCategory)
        local MaxPlatoonWeaponRange = MaxPlatoonWeaponRange or 30
        local EnemyThreatCategory = EnemyThreatCategory or (categories.ALLUNITS - categories.WALL)
        local TargetPosition = table.copy(target:GetPosition())
        local usedTransports = false
        if not aiBrain:PlatoonExists(self) then
            WARN('* AI-SorianEdit: MoveWithTransportSorianEdit: platoon does not exist')
            return
        end
        local PlatoonPosition = self:GetPlatoonPosition()
        if not PlatoonPosition then
            WARN('* AI-SorianEdit: MoveWithTransportSorianEdit: PlatoonPosition is NIL')
            return
        end
        -- see if we are in danger, fight units that are close to the platoon
        if bAggroMove then
            numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(EnemyThreatCategory, PlatoonPosition, MaxPlatoonWeaponRange + 20 , 'Enemy')
            if numEnemyUnits > 0 then
                return
            end
        end
        self:SetPlatoonFormationOverride('NoFormation')
        --LOG('* AI-SorianEdit: * MoveWithTransportSorianEditSorianEdit: CanPathTo() failed for '..repr(TargetPosition)..' forcing SendPlatoonWithTransportsNoCheckSE.')
        if not ExperimentalInPlatoon and aiBrain:PlatoonExists(self) then
            usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, TargetPosition, true, false)
        end
        if not usedTransports then
            --LOG('* AI-SorianEdit: * MoveWithTransportSorianEditSorianEdit: SendPlatoonWithTransportsNoCheckSE failed.')
            local PlatoonPos = self:GetPlatoonPosition() or TargetPosition
            local DistanceToTarget = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, TargetPosition[1] or 0, TargetPosition[3] or 0)
            local DistanceToBase = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, basePosition[1] or 0, basePosition[3] or 0)
            -- if DistanceToBase < DistanceToTarget or DistanceToTarget > 50 then
                -- --LOG('* AI-SorianEdit: * MoveWithTransportSorianEditSorianEdit: base is nearer then distance to target or distance to target over 50. Return To base')
                -- self:SimpleReturnToBaseSorianEdit(basePosition)
            -- else
                --LOG('* AI-SorianEdit: * MoveWithTransportSorianEditSorianEdit: Direct move to Target')
                if bAggroMove then
                    self:AggressiveMoveToLocation(TargetPosition)
                else
                    self:MoveToLocation(TargetPosition, false)
                end
            -- end
        else
            --LOG('* AI-SorianEdit: * MoveWithTransportSorianEditSorianEdit: We got a transport!!')
        end
    end,

    MoveDirect = function(self, aiBrain, bAggroMove, target)
        local MaxPlatoonWeaponRange = MaxPlatoonWeaponRange or 30
        -- local EnemyThreatCategory = EnemyThreatCategory or (categories.ALLUNITS - categories.WALL)
        local EnemyThreatCategory = (categories.ALLUNITS - categories.WALL)
        local platoonUnits = self:GetPlatoonUnits()
        self:SetPlatoonFormationOverride('NoFormation')
        local TargetPosition = table.copy(target:GetPosition())
        local PlatoonPosition
        local Lastdist
        local dist
        local Stuck = 0
        local ATTACKFORMATION = false
        local numEnemyUnits
        if bAggroMove then
            self:AggressiveMoveToLocation(TargetPosition)
        else
            self:MoveToLocation(TargetPosition, false)
        end
        while aiBrain:PlatoonExists(self) do
            PlatoonPosition = self:GetPlatoonPosition() or TargetPosition
            dist = VDist2( TargetPosition[1], TargetPosition[3], PlatoonPosition[1], PlatoonPosition[3] )
            if not bAggroMove then
                local platoonUnitscheck = self:GetPlatoonUnits()
                if table.getn(platoonUnits) > table.getn(platoonUnitscheck) then
                    --LOG('* AI-SorianEdit: * MoveDirect: unit in platoon destroyed!!!')
                    ATTACKFORMATION = true
                    self:SetPlatoonFormationOverride('AttackFormation')
                    return
                end
            end
            --LOG('* AI-SorianEdit: * MoveDirect: dist to next Waypoint: '..dist)
            --LOG('* AI-SorianEdit: * MoveDirect: dist to target: '..dist)
            if not ATTACKFORMATION and dist < 80 then
                ATTACKFORMATION = true
                --LOG('* AI-SorianEdit: * MoveDirect: dist < 50 '..dist)
                self:SetPlatoonFormationOverride('AttackFormation')
            end
            if dist < 20 then
                return
            end
            -- Do we move ?
            if Lastdist ~= dist then
                Stuck = 0
                Lastdist = dist
            -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
            else
                Stuck = Stuck + 1
                if Stuck > 20 then
                    --LOG('* AI-SorianEdit: * MoveDirect: Stucked while moving to target. Stuck='..Stuck)
                    self:Stop()
                    return
                end
            end
            -- If we lose our target, stop moving to it.
            if not target or target.Dead then
                --LOG('* AI-SorianEdit: * MoveDirect: Lost target while moving to target. ')
                return
            end
            -- see if we are in danger, fight units that are close to the platoon
            if bAggroMove then
                numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(EnemyThreatCategory, PlatoonPosition, MaxPlatoonWeaponRange + 30 , 'Enemy')
                if numEnemyUnits > 0 then
                    return
                end
            end
            coroutine.yield(10)
        end
    end,

    MovePathSorianEdit = function(self, aiBrain, path, bAggroMove, target, MaxPlatoonWeaponRange, EnemyThreatCategory)
        local distEnd
        local MaxPlatoonWeaponRange = MaxPlatoonWeaponRange or 30
        -- local EnemyThreatCategory = EnemyThreatCategory or (categories.ALLUNITS - categories.WALL)
        local EnemyThreatCategory = (categories.ALLUNITS - categories.WALL)
        local platoonUnits = self:GetPlatoonUnits()
        self:SetPlatoonFormationOverride('NoFormation')
        local PathNodesCount = table.getn(path)
        if self.MovementLayer == 'Air' then
            -- Air units should not follow the path for the last 3 hops.
            if PathNodesCount - 3 > 0 then
                PathNodesCount = PathNodesCount - 3
            -- if we have a short path, just use the destination as waypoint
            else
                path[1] = path[PathNodesCount]
                PathNodesCount = 1
            end
        end
        if not path[1] then
            if target and not target.Dead and not target:BeenDestroyed() then 
                path =  {table.copy(target:GetPosition())}
            else
                return
            end
        end
        local ATTACKFORMATION = false
        for i=1, PathNodesCount do
            local PlatoonPosition
            local Lastdist
            local dist
            local Stuck = 0
            --LOG('* AI-SorianEdit: * MovePath: moving to destination. i: '..i..' coords '..repr(path[i]))
            if bAggroMove then
                self:AggressiveMoveToLocation(path[i])
            else
                self:MoveToLocation(path[i], false)
            end
            if HERODEBUGSorianEdit then
                self:RenamePlatoon('MovePath: moving to path['..i..'] '..repr(path[i]))
            end
            while aiBrain:PlatoonExists(self) do
                PlatoonPosition = self:GetPlatoonPosition() or path[i]
                dist = VDist2( path[i][1], path[i][3], PlatoonPosition[1], PlatoonPosition[3] )
                if not bAggroMove then
                    local platoonUnitscheck = self:GetPlatoonUnits()
                    if table.getn(platoonUnits) > table.getn(platoonUnitscheck) then
                        --LOG('* AI-SorianEdit: * MovePath: unit in platoon destroyed!!!')
                        self:SetPlatoonFormationOverride('AttackFormation')
                    end
                end
                --LOG('* AI-SorianEdit: * MovePath: dist to next Waypoint: '..dist)
                distEnd = VDist2( path[PathNodesCount][1], path[PathNodesCount][3], PlatoonPosition[1], PlatoonPosition[3] )
                --LOG('* AI-SorianEdit: * MovePath: dist to Path End: '..distEnd)
                if not ATTACKFORMATION and distEnd < 80 then
                    ATTACKFORMATION = true
                    --LOG('* AI-SorianEdit: * MovePath: distEnd < 50 '..distEnd)
                    self:SetPlatoonFormationOverride('AttackFormation')
                end
                -- are we closer then 20 units from the next marker ? Then break and move to the next marker
                if dist < 20 then
                    -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                    self:Stop()
                    break
                end
                -- Do we move ?
                if Lastdist ~= dist then
                    Stuck = 0
                    Lastdist = dist
                -- No, we are not moving, wait 20 ticks then break and use the next weaypoint
                else
                    Stuck = Stuck + 1
                    if Stuck > 20 then
                        --LOG('* AI-SorianEdit: * MovePath: Stucked while moving to Waypoint. Stuck='..Stuck..' - '..repr(path[i]))
                        self:Stop()
                        break -- break the while aiBrain:PlatoonExists(self) do loop and move to the next waypoint
                    end
                end
                -- If we lose our target, stop moving to it.
                if not target or target.Dead then
                    if HERODEBUGSorianEdit then
                        self:RenamePlatoon('MovePath: Lost target while moving to Waypoint ')
                    end
                    --LOG('* AI-SorianEdit: * MovePath: Lost target while moving to Waypoint. '..repr(path[i]))
                    return
                end
                -- see if we are in danger, fight units that are close to the platoon
                if bAggroMove then
                    numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(EnemyThreatCategory, PlatoonPosition, MaxPlatoonWeaponRange + 30 , 'Enemy')
                    if numEnemyUnits > 0 then
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('MovePath: cancel move, enemies nearby')
                        end
                        return
                    end
                end
                coroutine.yield(10)
            end
        end
        if HERODEBUGSorianEdit then
            self:RenamePlatoon('MovePath: destination reached; dist:'..distEnd)
        end
    end,

    MoveToLocationInclTransportSorianEdit = function(self, target, TargetPosition, bAggroMove, WantsTransport, basePosition, ExperimentalInPlatoon, MaxPlatoonWeaponRange, EnemyThreatCategory, SupportThreat)
        local MaxPlatoonWeaponRange = MaxPlatoonWeaponRange or 30
        local EnemyThreatCategory = EnemyThreatCategory or (categories.ALLUNITS - categories.WALL)
        local SupportThreat = SupportThreat or 512
        local MarkerSwitchDistance = MarkerSwitchDist
        if ExperimentalInPlatoon then
            MarkerSwitchDistance = MarkerSwitchDistEXP
        end
        local platoonUnits = self:GetPlatoonUnits()
        self:SetPlatoonFormationOverride('NoFormation')
        if not TargetPosition then
            TargetPosition = table.copy(target:GetPosition())
        end
        local aiBrain = self:GetBrain()
        local PlatoonPosition = self:GetPlatoonPosition()
        -- this will be true if we got our units transported to the destination
        local usedTransports = false
        local TransportNotNeeded, bestGoalPos
        -- check, if we can reach the destination without a transport
        local unit = AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer or 'Land' , PlatoonPosition, TargetPosition, SupportThreat, 1024)
        if reason == 'TooMuchThreat' then
			path, reason = AIAttackUtils.GeneratePathSimpleSorianEdit(aiBrain, self.MovementLayer or 'Land' , PlatoonPosition, TargetPosition)
        end
        if not aiBrain:PlatoonExists(self) then
            return
        end
        -- don't use a transporter if we have a path and the target is closer than 100 map units
        if path and VDist2Sq( PlatoonPosition[1], PlatoonPosition[3], TargetPosition[1], TargetPosition[3] ) < 1024 then
            -- LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: no trasnporter used for target distance '..VDist2( PlatoonPosition[1], PlatoonPosition[3], TargetPosition[1], TargetPosition[3] ) )
        -- use a transporter if we don't have a path, or if we want a transport
        elseif not ExperimentalInPlatoon and ((not path and reason ~= 'NoGraph') or WantsTransport) then
            -- LOG('* AI-SorianEdit: * MoveToLocationInclTransport: SendPlatoonWithTransportsNoCheckSE')
            if HERODEBUGSorianEdit then
                self:RenamePlatoon('SendPlatoonWithTransportsNoCheckSE')
                coroutine.yield(1)
            end
            usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, TargetPosition, true, false)
			-- LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: usedTransports == '..repr(usedTransports)..' Reason == '..repr(reason) )
        end
        -- if we don't got a transport, try to reach the destination by path or directly
        if not usedTransports then
            if HERODEBUGSorianEdit then
                self:RenamePlatoon('usedTransports = false')
                coroutine.yield(1)
            end
            -- clear commands, so we don't get stuck if we have an unreachable destination
            IssueClearCommands(self:GetPlatoonUnits())
            if path then
                -- LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: No transport used, and we dont need it.')
                if table.getn(path) > 1 then
                    -- LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: table.getn(path): '..table.getn(path))
                end
                local PathNodesCount = table.getn(path)
                local ATTACKFORMATION = false
                if HERODEBUGSorianEdit then
                    self:RenamePlatoon('PathNodesCount: '..repr(PathNodesCount))
                    coroutine.yield(1)
                end
                for i=1, PathNodesCount do
                    if HERODEBUGSorianEdit then
                        self:RenamePlatoon('move to : path['..i..']')
                        coroutine.yield(1)
                    end
                    --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: moving to destination. i: '..i..' coords '..repr(path[i]))
                    if bAggroMove then
                        self:AggressiveMoveToLocation(path[i])
                    else
                        self:MoveToLocation(path[i], false)
                    end
                    local PlatoonPosition
                    local Lastdist
                    local dist
                    local Stuck = 0
                    while aiBrain:PlatoonExists(self) do
                        PlatoonPosition = self:GetPlatoonPosition() or nil
                        if not PlatoonPosition then break end
                        dist = VDist2( path[i][1], path[i][3], PlatoonPosition[1], PlatoonPosition[3] )
                        if not bAggroMove then
                        local platoonUnitscheck = self:GetPlatoonUnits()
                        if table.getn(platoonUnits) > table.getn(platoonUnitscheck) then
                            --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: unit in platoon destroyed!!!')
                            self:SetPlatoonFormationOverride('AttackFormation')
                            end
                        end
                        --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: dist to next Waypoint: '..dist)
                        distEnd = VDist2( path[PathNodesCount][1], path[PathNodesCount][3], PlatoonPosition[1], PlatoonPosition[3] )
                        --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: dist to Path End: '..distEnd)
                        if not ATTACKFORMATION and distEnd < 80 then
                            ATTACKFORMATION = true
                            --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: distEnd < 50 '..distEnd)
                            self:SetPlatoonFormationOverride('AttackFormation')
                        end
                        -- are we closer then 20 units from the next marker ? Then break and move to the next marker
                        if dist < 20 then
                            -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                            self:Stop()
                            break
                        end
                        -- Do we move ?
                        if Lastdist ~= dist then
                            Stuck = 0
                            Lastdist = dist
                        -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
                        else
                            Stuck = Stuck + 1
                            if Stuck > 20 then
                                --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: Stucked while moving to Waypoint. Stuck='..Stuck..' - '..repr(path[i]))
                                self:Stop()
                                break -- break the while aiBrain:PlatoonExists(self) do loop and move to the next waypoint
                            end
                        end
                        -- If we lose our target, stop moving to it.
                        if not target then
                            --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: Lost target while moving to Waypoint. '..repr(path[i]))
                            self:Stop()
                            return
                        end
                        -- see if we are in danger, fight units that are close to the platoon
                        if bAggroMove then
                            numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(EnemyThreatCategory, PlatoonPosition, MaxPlatoonWeaponRange + 30 , 'Enemy')
                            if numEnemyUnits > 0 then
                                if HERODEBUG then
                                    self:RenamePlatoon('enemy nearby')
                                    coroutine.yield(1)
                                end
                                return
                            end
                        end
                        coroutine.yield(10)
                    end
                end
            else
                --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: No transport used, and we have no Graph to reach the destination. Checking CanPathTo()')
                if reason == 'NoGraph' then
                    local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingExSE(self, TargetPosition)
                    if success then
                        --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: No transport used, found a way with CanPathTo(). moving to destination')
                        if bAggroMove then
                            self:AggressiveMoveToLocation(bestGoalPos)
                        else
                            self:MoveToLocation(bestGoalPos, false)
                        end
                        local PlatoonPosition
                        local Lastdist
                        local dist
                        local Stuck = 0
                        while aiBrain:PlatoonExists(self) do
                            PlatoonPosition = self:GetPlatoonPosition() or nil
                            if not PlatoonPosition then continue end
                            dist = VDist2( bestGoalPos[1], bestGoalPos[3], PlatoonPosition[1], PlatoonPosition[3] )
                            if dist < 20 then
                                break
                            end
                            -- Do we move ?
                            if Lastdist ~= dist then
                                Stuck = 0
                                Lastdist = dist
                            -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
                            else
                                Stuck = Stuck + 1
                                if Stuck > 20 then
                                    --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: Stucked while moving to target. Stuck='..Stuck)
                                    self:Stop()
                                    break -- break the while aiBrain:PlatoonExists(self) do loop and move to the next waypoint
                                end
                            end
                            -- If we lose our target, stop moving to it.
                            if not target then
                                --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: Lost target while moving to target. ')
                                self:Stop()
                                return
                            end
                            coroutine.yield(10)
                        end
                    else
                        --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: CanPathTo() failed for '..repr(TargetPosition)..' forcing SendPlatoonWithTransportsNoCheckSE.')
                        if not ExperimentalInPlatoon then
                            usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, TargetPosition, true, false)
                        end
                        if not usedTransports then
                            --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: CanPathTo() and SendPlatoonWithTransportsNoCheckSE failed. SimpleReturnToBaseSorianEdit!')
                            local PlatoonPos = self:GetPlatoonPosition()
                            local DistanceToTarget = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, TargetPosition[1] or 0, TargetPosition[3] or 0)
                            local DistanceToBase = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, basePosition[1] or 0, basePosition[3] or 0)
                            if DistanceToBase < DistanceToTarget and DistanceToTarget > 50 then
                                --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: base is nearer then distance to target and distance to target over 50. Return To base')
                                self:SimpleReturnToBaseSorianEdit(basePosition)
                            else
                                --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: Direct move to Target')
                                if bAggroMove then
                                    self:AggressiveMoveToLocation(TargetPosition)
                                else
                                    self:MoveToLocation(TargetPosition, false)
                                end
                            end
                        else
                            --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: CanPathTo() failed BUT we got an transport!!')
                        end

                    end
                else
                    --LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: We have no path but there is a Graph with markers. So why we don\'t get a path ??? (Island or threat too high?) - reason: '..repr(reason))
                end
            end
        else
            LOG('* AI-SorianEdit: * MoveToLocationInclTransportSorianEdit: TRANSPORTED.')
        end
    end,

    TransferSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        if not aiBrain.BuilderManagers[self.PlatoonData.MoveToLocationType] then
            --LOG('* AI-SorianEdit: * TransferSorianEdit: Location ('..self.PlatoonData.MoveToLocationType..') has no BuilderManager!')
            self:PlatoonDisband()
            return
        end
        local eng = self:GetPlatoonUnits()[1]
        if eng and not eng.Dead and eng.BuilderManagerData.EngineerManager then
            --LOG('* AI-SorianEdit: * TransferSorianEdit: '..repr(self.BuilderName))
            eng.BuilderManagerData.EngineerManager:RemoveUnit(eng)
            --LOG('* AI-SorianEdit: * TransferSorianEdit: AddUnit units to - BuilderManagers: '..self.PlatoonData.MoveToLocationType..' - ' .. aiBrain.BuilderManagers[self.PlatoonData.MoveToLocationType].EngineerManager:GetNumCategoryUnits('Engineers', categories.ALLUNITS) )
            aiBrain.BuilderManagers[self.PlatoonData.MoveToLocationType].EngineerManager:AddUnit(eng, true)
            -- Move the unit to the desired base after transfering BuilderManagers to the new LocationType
            local basePosition = aiBrain.BuilderManagers[self.PlatoonData.MoveToLocationType].Position
            --LOG('* AI-SorianEdit: * TransferSorianEdit: Moving transfer-units to - ' .. self.PlatoonData.MoveToLocationType)
            self:MoveToLocationInclTransportSorianEdit(true, basePosition, false, false, basePosition, false, 128, false, 1024)
        end
        if aiBrain:PlatoonExists(self) then
            self:PlatoonDisband()
        end
    end,

    ReclaimSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local eng
        for k, v in platoonUnits do
            if not v.Dead and EntityCategoryContains(categories.MOBILE * categories.ENGINEER - categories.STATIONASSISTPOD, v) then
                eng = v
                break
            end
        end
        if eng then
            eng.UnitBeingBuilt = eng
            SUtils.ReclaimAIThreadSorian(self,eng,aiBrain)
            eng.UnitBeingBuilt = nil
        end
		coroutine.yield(15)
        self:PlatoonDisband()
    end,

    FinisherSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        if not self.PlatoonData or not self.PlatoonData.LocationType then
            self:PlatoonDisband()
            return
        end
        local eng = self:GetPlatoonUnits()[1]
        local engineerManager = aiBrain.BuilderManagers[self.PlatoonData.LocationType].EngineerManager
        if not engineerManager then
            self:PlatoonDisband()
            return
        end
        local unfinishedUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE + categories.EXPERIMENTAL, engineerManager.Location, engineerManager.Radius, 'Ally')
        for k,v in unfinishedUnits do
            local FractionComplete = v:GetFractionComplete()
            if FractionComplete < 1 and table.getn(v:GetGuards()) < 1 then
                self:Stop()
                if not v.Dead and not v:BeenDestroyed() then -- Finisher AI would try to finish a dead or destoryed building.
                    IssueRepair(self:GetPlatoonUnits(), v)
                end
                break
            end
        end
        local count = 0
        repeat
            coroutine.yield(20)
            if not aiBrain:PlatoonExists(self) then
                return
            end
            count = count + 1
            if eng:IsIdleState() then break end
        until count >= 30
        self:PlatoonDisband()
    end,
	
    SorianPlatoonMerger = function(self)
        -- LOG('*------------------------------ Sorian: * SorianPlatoonMerger: called from Builder: '..(self.BuilderName or 'Unknown'))
        local aiBrain = self:GetBrain()
        local PlatoonPlan = self.PlatoonData.AIPlan
        -- LOG('* Sorian: * SorianPlatoonMerger: AIPlan: '..(PlatoonPlan or 'Unknown'))
        if not PlatoonPlan then
            return
        end
        -- Get all units from the platoon
        local platoonUnits = self:GetPlatoonUnits()
        -- check if we have already a Platoon with this AIPlan
        local AlreadyMergedPlatoon
        local PlatoonList = aiBrain:GetPlatoonsList()
        for _,Platoon in PlatoonList do
            if Platoon:GetPlan() == PlatoonPlan then
                -- LOG('* Sorian: * SorianPlatoonMerger: Found Platoon with plan '..PlatoonPlan)
                AlreadyMergedPlatoon = Platoon
                break
            end
            -- LOG('* Sorian: * SorianPlatoonMerger: Found '..repr(Platoon:GetPlan()))
        end
        -- if we dont have already a platoon for this AIPlan, create one.
        if not AlreadyMergedPlatoon then
            AlreadyMergedPlatoon = aiBrain:MakePlatoon( PlatoonPlan..'Platoon', PlatoonPlan )
            AlreadyMergedPlatoon.PlanName = PlatoonPlan
            AlreadyMergedPlatoon.BuilderName = PlatoonPlan..'Platoon'
            --AlreadyMergedPlatoon:UniquelyNamePlatoon(PlatoonPlan)
        end
        -- Add our unit(s) to the platoon
        aiBrain:AssignUnitsToPlatoon( AlreadyMergedPlatoon, platoonUnits, 'support', 'none' )
        -- Disband this platoon, it's no longer needed.
        self:PlatoonDisbandNoAssign()
    end,

    ExtractorUpgradeAISorian = function(self)
        -- LOG('*------------------------------ Sorian: +++ ExtractorUpgradeAISorian: START')
        local aiBrain = self:GetBrain()
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        local ratio = 0.0
                          -- 0    6     10    15    20    25    30  >600  >1000
                          -- 1    2     3     4     5     6     7     8     9
        local RatioTable = {0.15, 0.20, 0.25, 0.3, 0.35, 0.40, 0.40, 0.50, 1.0}
		
		if string.find(personality, 'cheat') then
        -- if personality == 'sorianeditadaptivecheat' or personality == 'sorianeditnavycheat' or personality == 'sorianeditaircheat' then
            RatioTable = {0.2, 0.3, 0.4, 0.5, 0.5, 0.55, 0.55, 0.55, 1.0}
        end
		
        while aiBrain:PlatoonExists(self) do
            --LOG('* AI-Uveso: +++ ExtractorUpgradeAI: PULSE')
            if aiBrain.PriorityManager.HasParagon then
                -- if we have a paragon, upgrade mex as fast as possible. Mabye we lose the paragon and need mex again.
                ratio = RatioTable[9]
            elseif aiBrain:GetEconomyIncome('MASS') * 10 > 1000 then
                --LOG('* AI-Uveso: Mass over 1000. Eco running with 50%')
                ratio = RatioTable[9]
            elseif aiBrain:GetEconomyIncome('MASS') * 10 > 600 then
                --LOG('* AI-Uveso: Mass over 600. Eco running with 35%')
                ratio = RatioTable[8]
            elseif GetGameTimeSeconds() > 1800 then -- 30 * 60
                ratio = RatioTable[7]
            elseif GetGameTimeSeconds() > 1500 then -- 25 * 60
                ratio = RatioTable[6]
            elseif GetGameTimeSeconds() > 1200 then -- 20 * 60
                ratio = RatioTable[5]
            elseif GetGameTimeSeconds() > 900 then -- 15 * 60
                ratio = RatioTable[4]
            elseif GetGameTimeSeconds() > 600 then -- 10 * 60
                ratio = RatioTable[3]
            elseif GetGameTimeSeconds() > 360 then -- 6 * 60
                ratio = RatioTable[2]
            elseif GetGameTimeSeconds() <= 360 then -- 6 * 60
                ratio = RatioTable[1]
            end
            local platoonUnits = self:GetPlatoonUnits()
            local MassExtractorUnitList = aiBrain:GetListOfUnits(categories.MASSEXTRACTION * (categories.TECH1 + categories.TECH2 + categories.TECH3), false, false)
            -- Check if we can pause/unpause TECH3 Extractors (for more energy)
            if not SUtils.ExtractorPauseSorian( self, aiBrain, MassExtractorUnitList, ratio, 'TECH3') then
                -- Check if we can pause/unpause TECH2 Extractors
                if not SUtils.ExtractorPauseSorian( self, aiBrain, MassExtractorUnitList, ratio, 'TECH2') then
                    -- Check if we can pause/unpause TECH1 Extractors
                    if not SUtils.ExtractorPauseSorian( self, aiBrain, MassExtractorUnitList, ratio, 'TECH1') then
                        -- We have nothing to pause or unpause, lets upgrade more extractors
                        -- if we have 30% TECH1 extractors left (and 90% TECH2), then upgrade TECH2 to TECH3
                        if SUtils.HaveUnitRatio( aiBrain, 0.70, categories.MASSEXTRACTION * categories.TECH1, '<=', categories.MASSEXTRACTION * categories.TECH2 ) then
                            -- Try to upgrade a TECH2 extractor.
                            if not SUtils.ExtractorUpgradeSorian(self, aiBrain, MassExtractorUnitList, ratio, 'TECH2', UnitUpgradeTemplates, StructureUpgradeTemplates) then
                                -- We can't upgrade a TECH2 extractor. Try to upgrade from TECH1 to TECH2
                                SUtils.ExtractorUpgradeSorian(self, aiBrain, MassExtractorUnitList, ratio, 'TECH1', UnitUpgradeTemplates, StructureUpgradeTemplates)
                            end
                        else
                            -- We have less than 90% TECH2 extractors compared to TECH1. Upgrade more TECH1
                            SUtils.ExtractorUpgradeSorian(self, aiBrain, MassExtractorUnitList, ratio, 'TECH1', UnitUpgradeTemplates, StructureUpgradeTemplates)
                        end
                    end
                end
            end
            -- Check the Eco every x Ticks
            coroutine.yield(10)
            -- find dead units inside the platoon and disband if we find one
            for k,v in self:GetPlatoonUnits() do
                if not v or v.Dead or v:BeenDestroyed() then
                    -- We found a dead unit inside this platoon. Disband the platton; It will be reformed
                    -- LOG('* Sorian: +++ ExtractorUpgradeAISorian: Found Dead unit, self:PlatoonDisbandNoAssign()')
                    -- needs PlatoonDisbandNoAssign, or extractors will stop upgrading if the platton is disbanded
                    coroutine.yield(1)
                    self:PlatoonDisbandNoAssign()
                    return
                end
            end
        end
        -- No return here. We will never reach this position. After disbanding this platoon, the forked 'ExtractorUpgradeAISorian' thread will be terminated from outside.
    end,

    SimpleReturnToBaseSorianEdit = function(self, basePosition)
        local aiBrain = self:GetBrain()
        local PlatoonPosition
        local Lastdist
        local dist
        local Stuck = 0
        self:Stop()
        self:MoveToLocation(basePosition, false)
        while aiBrain:PlatoonExists(self) do
            PlatoonPosition = self:GetPlatoonPosition()
            if not PlatoonPosition then
                --LOG('* AI-SorianEdit: * SimpleReturnToBaseSorianEdit: no Platoon Position')
                break
            end
            dist = VDist2( basePosition[1], basePosition[3], PlatoonPosition[1], PlatoonPosition[3] )
            if dist < 20 then
                break
            end
            -- Do we move ?
            if Lastdist ~= dist then
                Stuck = 0
                Lastdist = dist
            -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
            else
                Stuck = Stuck + 1
                if Stuck > 20 then
                    self:Stop()
                    break
                end
            end
            coroutine.yield(10)
        end
        if aiBrain:PlatoonExists(self) then -- Platoons were getting really stuck with this.
            self:PlatoonDisband()
        end
    end,

    ForceReturnToNearestBaseSorianEdit = function(self)
        local platPos = self:GetPlatoonPosition() or false
        if not platPos then
            return
        end
        local aiBrain = self:GetBrain()
        local nearestbase = false
        for k,v in aiBrain.BuilderManagers do
            -- check if we can move to this base
            if not AIUtils.ValidateLayerSorianEdit(v.FactoryManager.Location,self.MovementLayer) then
                --LOG('* AI-SorianEdit: ForceReturnToNearestBaseSorianEdit Can\'t return to This base. Wrong movementlayer: '..repr(v.FactoryManager.LocationType))
                continue
            end
            local dist = VDist2( platPos[1], platPos[3], v.FactoryManager.Location[1], v.FactoryManager.Location[3] )
            if not nearestbase or nearestbase.dist > dist then
                nearestbase = {}
                nearestbase.Pos = v.FactoryManager.Location
                nearestbase.dist = dist
            end
        end
        if not nearestbase then
            return
        end
        self:Stop()
        self:MoveToLocationInclTransportSorianEdit(true, nearestbase.Pos, false, false, nearestbase.Pos, false, 128, false, 1024)
        -- Disband the platoon so the locationmanager can assign a new task to the units.
        coroutine.yield(30)
        if aiBrain:PlatoonExists(self) then -- Platoons were getting really stuck with this.
            self:PlatoonDisband()
        end
    end,

    ForceReturnToNavalBaseSorianEdit = function(self, aiBrain, basePosition)
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer or 'Water' , self:GetPlatoonPosition(), basePosition, 1000, 512)
        -- clear commands, so we don't get stuck if we have an unreachable destination
        IssueClearCommands(self:GetPlatoonUnits())
        if path then
            if table.getn(path) > 1 then
                --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: table.getn(path): '..table.getn(path))
            end
            --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: moving to destination by path.')
            for i=1, table.getn(path) do
                --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: moving to destination. i: '..i..' coords '..repr(path[i]))
                self:MoveToLocation(path[i], false)
                --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: moving to Waypoint')
                local PlatoonPosition
                local Lastdist
                local dist
                local Stuck = 0
                while aiBrain:PlatoonExists(self) do
                    PlatoonPosition = self:GetPlatoonPosition()
                    dist = VDist2( path[i][1], path[i][3], PlatoonPosition[1], PlatoonPosition[3] )
                    -- are we closer then 15 units from the next marker ? Then break and move to the next marker
                    if dist < 20 then
                        -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                        self:Stop()
                        break
                    end
                    -- Do we move ?
                    if Lastdist ~= dist then
                        Stuck = 0
                        Lastdist = dist
                    -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
                    else
                        Stuck = Stuck + 1
                        if Stuck > 15 then
                            --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: Stucked while moving to Waypoint. Stuck='..Stuck..' - '..repr(path[i]))
                            self:Stop()
                            break
                        end
                    end
                    coroutine.yield(10)
                end
            end
        else
            --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: we have no Graph to reach the destination. Checking CanPathTo()')
            if reason == 'NoGraph' then
                local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingExSE(self, basePosition)
                if success then
                    --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: found a way with CanPathTo(). moving to destination')
                    self:MoveToLocation(basePosition, false)
                else
                    --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: CanPathTo() failed for '..repr(basePosition)..'.')
                end
            end
        end
        local oldDist = 100000
        local platPos = self:GetPlatoonPosition() or basePosition
        local Stuck = 0
        while aiBrain:PlatoonExists(self) do
            self:MoveToLocation(basePosition, false)
            --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: Waiting for moving to base')
            platPos = self:GetPlatoonPosition() or basePosition
            dist = VDist2(platPos[1], platPos[3], basePosition[1], basePosition[3])
            if dist < 20 then
                --LOG('* AI-SorianEdit: * ForceReturnToNavalBaseSorianEdit: We are home! disband!')
                -- Wait some second, so all platoon units have time to reach the base.
                WaitSeconds(5)
                self:Stop()
                break
            end
            -- if we haven't moved in 5 seconds... leave the loop
            if oldDist - dist < 0 then
                break
            end
            oldDist = dist
            Stuck = Stuck + 1
            if Stuck > 4 then
                self:Stop()
                break
            end
            WaitSeconds(5)
        end
        -- Disband the platoon so the locationmanager can assign a new task to the units.
        coroutine.yield(30)
        self:PlatoonDisband()
    end,

    SorianEditT3AntiNukeAI = function(self)
        local aiBrain = self:GetBrain()
        while aiBrain:PlatoonExists(self) do
            local platoonUnits = self:GetPlatoonUnits()
            -- find dead units inside the platoon and disband if we find one
            for k,unit in platoonUnits do
                if not unit or unit.Dead or unit:BeenDestroyed() then
                    -- We found a dead unit inside this platoon. Disband the Platoon; It will be reformed
                    -- needs PlatoonDisbandNoAssign, or launcher will stop building nukes if the Platoon is disbanded
                    self:PlatoonDisbandNoAssign()
                    --LOG('* AI-SorianEdit: * U3AntiNukeAI: PlatoonDisband')
                    return
                else
                    unit:SetAutoMode(true)
                end
            end
            coroutine.yield(50)
        end
    end,

    SorianEditT3ArtilleryAI = function(self)
        local aiBrain = self:GetBrain()
        local ClosestTarget = nil
        local LastTarget = nil
        while aiBrain:PlatoonExists(self) do
            -- Primary Target
            ClosestTarget = nil
            -- We always use the PrimaryTarget from the targetmanager first:
            if aiBrain.PrimaryTarget and not aiBrain.PrimaryTarget.Dead then
                ClosestTarget = aiBrain.PrimaryTarget
            else
                -- We have no PrimaryTarget from the tagetmanager.
                -- That means there is no paragon, no experimental and no Tech3 Factories left as target.
                -- No need to search for any of this here.
            end
            -- in case we found a target, attack it until it's dead or we have another Primary Target
            if ClosestTarget == LastTarget then
                --LOG('* AI-SorianEdit: * U34ArtilleryAI: ClosestTarget == LastTarget')
            elseif ClosestTarget and not ClosestTarget.Dead then
                local BlueprintID = ClosestTarget:GetBlueprint().BlueprintId
                LastTarget = ClosestTarget
                -- Wait until the target is dead
                while ClosestTarget and not ClosestTarget.Dead do
                    -- leave the loop if the primary target has changed
                    if aiBrain.PrimaryTarget and aiBrain.PrimaryTarget ~= ClosestTarget then
                        break
                    end
                    platoonUnits = self:GetPlatoonUnits()
                    for _, Arty in platoonUnits do
                        if not Arty or Arty.Dead then
                            return
                        end
                        local Target = Arty:GetTargetEntity()
                        if Target == ClosestTarget then
                            --Arty:SetCustomName('continue '..BlueprintID)
                        else
                            --Arty:SetCustomName('Attacking '..BlueprintID)
                            --IssueStop({v})
                            IssueClearCommands({Arty})
                            coroutine.yield(1)
                            if ClosestTarget and not ClosestTarget.Dead then
                                IssueAttack({Arty}, ClosestTarget)
                            end
                        end
                    end
                    coroutine.yield(50)
                end
            end
            -- Reaching this point means we have no special target and our arty is using it's own weapon target priorities.
            -- So we are still attacking targets at this point.
            coroutine.yield(50)
        end
    end,

    ShieldRepairSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local BuilderManager = aiBrain.BuilderManagers['MAIN']
        local lastSHIELD = 0
        local lastSUB = 0
        local numSUB
        local SUBCOMs
        local platoonUnits

        while aiBrain:PlatoonExists(self) do
            platoonUnits = self:GetPlatoonUnits()
            numSUB = table.getn(platoonUnits) or 0
            local Shields = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.STRUCTURE * categories.SHIELD, BuilderManager.Position, 256)
            local lasthighestHealth
            local highestHealth
            local numSHIELD = 0
            -- get the shield with the highest health
            for k,Shield in Shields do
                if not Shield or Shield.Dead then continue end
                if not highestHealth or Shield.MyShield:GetMaxHealth() > highestHealth then
                    highestHealth = Shield.MyShield:GetMaxHealth()
                end
                numSHIELD = numSHIELD + 1
            end
            for k,Shield in Shields do
                if not Shield or Shield.Dead then continue end
                if (not lasthighestHealth or Shield.MyShield:GetMaxHealth() > lasthighestHealth) and Shield.MyShield:GetMaxHealth() < highestHealth then
                    lasthighestHealth = Shield.MyShield:GetMaxHealth()
                end
            end
            if numSUB ~= lastSUB or numSHIELD ~= lastSHIELD then
                self:Stop()
                -- Wait for stopping assist
                coroutine.yield(1)
                lastSUB = numSUB
                lastSHIELD = numSHIELD
                for i,unit in self:GetPlatoonUnits() do
--                    IssueClearCommands({unit})
                    unit.AssistSet = nil
                    unit.UnitBeingAssist = nil
                end
                while true do
                    local numAssisters
                    local ShieldWithleastAssisters
                    -- get a shield with highest Health and lowest assistees
                    numAssisters = nil
                    -- Fist check all shields with the highest health
                    for k,Shield in Shields do
                        if not Shield or Shield.Dead or Shield.MyShield:GetMaxHealth() ~= highestHealth then continue end
                        if not numAssisters or table.getn(Shield:GetGuards()) < numAssisters  then
                            numAssisters = table.getn(Shield:GetGuards())
                            -- set a maximum of 10 assisters per shield
                            if numAssisters < 10 then
                                ShieldWithleastAssisters = Shield
                            end
                        end
                    end
                    -- If we have assister on all high shilds then spread the remaining SUBCOMs over lower shields
                    if not ShieldWithleastAssisters and lasthighestHealth and lasthighestHealth ~= highestHealth then
                        for k,Shield in Shields do
                            if not Shield or Shield.Dead or Shield.MyShield:GetMaxHealth() ~= lasthighestHealth then continue end
                            if not numAssisters or table.getn(Shield:GetGuards()) < numAssisters  then
                                numAssisters = table.getn(Shield:GetGuards())
                                ShieldWithleastAssisters = Shield
                            end
                        end
                    end
                    
                    if not ShieldWithleastAssisters then
                        --LOG('* AI-Uveso: *ShieldRepairAI: not ShieldWithleastAssisters. break!')
                        break
                    end
                    local shieldPos = ShieldWithleastAssisters:GetPosition() or nil
                    -- search for the closest idle unit
                    local closest
                    local bestUnit
                    for i,unit in self:GetPlatoonUnits() do
                        if not unit or unit.Dead or unit:BeenDestroyed() then
                            self:PlatoonDisbandNoAssign()
                            return
                        end
                        if unit.AssistSet then continue end
                        local unitPos = unit:GetPosition() or nil
                        if unitPos and shieldPos then
                            local dist = VDist2(shieldPos[1], shieldPos[3], unitPos[1], unitPos[3])
                            if not closest or dist < closest then
                                closest = dist
                                bestUnit = unit
                            end
                        end
                    end
                    if not bestUnit then
                        --LOG('* AI-Uveso: *ShieldRepairAI: not bestUnit. break!')
                        break
                    end
                    IssueClearCommands({bestUnit})
                    coroutine.yield(1)
                    IssueGuard({bestUnit}, ShieldWithleastAssisters)
                    bestUnit.AssistSet = true
                    bestUnit.UnitBeingAssist = ShieldWithleastAssisters
                    coroutine.yield(1)
                end

            end
            coroutine.yield(30)
        end
    end,

    FactoryAssistSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local BuilderManager = aiBrain.BuilderManagers['MAIN']
        local lastFAC = 0
        local lastEngie = 0
        local numEngie
        local platoonUnits

        while aiBrain:PlatoonExists(self) do
            platoonUnits = self:GetPlatoonUnits()
            numEngie = table.getn(platoonUnits) or 0
            local Factories = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.STRUCTURE * categories.FACTORY, BuilderManager.Position, 256)
            local lasthighestHealth
            local highestHealth
            local numFactories = 0
            for k,Factory in Factories do
                if not Factory or Factory.Dead then continue end
                numFactories = numFactories + 1
            end
            if (numEngie ~= lastEngie) or (numFactories ~= lastFAC) then
                self:Stop()
                -- Wait for stopping assist
                coroutine.yield(1)
                lastEngie = numEngie
                lastFAC = numFactories
                for i,unit in self:GetPlatoonUnits() do
                    -- IssueClearCommands({unit})
                    unit.AssistSet = nil
                    unit.UnitBeingAssist = nil
                end
                while true do
                    local numAssisters = nil
                    local FactoryWithleastAssisters
                    -- Fist check all Factories
                    for k,Factory in Factories do
                        if not Factory or Factory.Dead then continue end
                        if not numAssisters or table.getn(Factory:GetGuards()) < numAssisters  then
                            numAssisters = table.getn(Factory:GetGuards())
                            -- set a maximum of 10 assisters per Factory
                            if numAssisters < 10 then
                                FactoryWithleastAssisters = Factory
                            end
                        end
                    end
                    
                    if not FactoryWithleastAssisters then
                        break
                    end
                    local FactoryPos = FactoryWithleastAssisters:GetPosition() or nil
                    -- search for the closest idle unit
                    local closest
                    local bestUnit
                    for i,unit in self:GetPlatoonUnits() do
                        if not unit or unit.Dead or unit:BeenDestroyed() then
                            self:PlatoonDisbandNoAssign()
                            return
                        end
                        if unit.AssistSet then continue end
                        local unitPos = unit:GetPosition() or nil
                        if unitPos and FactoryPos then
                            local dist = VDist2(FactoryPos[1], FactoryPos[3], FactoryPos[1], FactoryPos[3])
                            if not closest or dist < closest then
                                closest = dist
                                bestUnit = unit
                            end
                        end
                    end
                    if not bestUnit then
                        break
                    end
                    IssueClearCommands({bestUnit})
                    coroutine.yield(1)
                    IssueGuard({bestUnit}, FactoryWithleastAssisters)
                    bestUnit.AssistSet = true
                    bestUnit.UnitBeingAssist = FactoryWithleastAssisters
                    coroutine.yield(600)
                end
            end
            coroutine.yield(30)
        end
    end,

    NukePlatoonSorianEdit = function(self)
        local NUKEDEBUG = false
        local aiBrain = self:GetBrain()
        local ECOLoopCounter = 0
        local mapSizeX, mapSizeZ = GetMapSize()
        local platoonUnits
        local LauncherFull
        local LauncherReady
        local ExperimentalLauncherReady
        local LauncherCount
        local EnemyAntiMissile
        local EnemyUnits
        local EnemyTargetPositions
        local MissileCount
        local EnemyTarget
        local NukeSiloAmmoCount
        local TargetPosition

        while aiBrain:PlatoonExists(self) do
            ---------------------------------------------------------------------------------------------------
            -- Count Launchers, set them to automode, count stored missiles
            ---------------------------------------------------------------------------------------------------
            platoonUnits = self:GetPlatoonUnits()
            LauncherFull = {}
            LauncherReady = {}
            ExperimentalLauncherReady = {}
            HighMissileCountLauncherReady = {}
            MissileCount = 0
            LauncherCount = 0
            HighestMissileCount = 0
            NukeSiloAmmoCount = 0
            NukeLaunched = false
            coroutine.yield(100)
            platoonUnits = self:GetPlatoonUnits()
            for _, Launcher in platoonUnits do
                -- We found a dead unit inside this platoon. Disband the Platoon; It will be reformed
                -- needs PlatoonDisbandNoAssign, or launcher will stop building nukes if the Platoon is disbanded
                if not Launcher or Launcher.Dead or Launcher:BeenDestroyed() then
                    self:PlatoonDisbandNoAssign()
                    return
                end
                Launcher:SetAutoMode(true)
                IssueClearCommands({Launcher})
                NukeSiloAmmoCount = Launcher:GetNukeSiloAmmoCount() or 0
                if not HighMissileCountLauncherReady.MissileCount or HighMissileCountLauncherReady.MissileCount < NukeSiloAmmoCount then
                    HighMissileCountLauncherReady = Launcher
                    HighMissileCountLauncherReady.MissileCount = NukeSiloAmmoCount
                end
                -- check if the launcher is full:
                local bp = Launcher:GetBlueprint()
                local weapon = bp.Weapon[1]
                local MaxLoad = weapon.MaxProjectileStorage or 5
                if NUKEDEBUG then
                    LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: launcher can load '..MaxLoad..' missiles ')
                end

                if NukeSiloAmmoCount >= MaxLoad then
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: launcher can load '..MaxLoad..' missiles and has '..NukeSiloAmmoCount..' = FULL ')
                    end
                    table.insert(LauncherFull, Launcher)
                end
                if NukeSiloAmmoCount > 0 and EntityCategoryContains(categories.NUKE * categories.EXPERIMENTAL, Launcher) then
                    table.insert(ExperimentalLauncherReady, Launcher)
                    MissileCount = MissileCount + NukeSiloAmmoCount
                elseif NukeSiloAmmoCount > 0 then
                    table.insert(LauncherReady, Launcher)
                    MissileCount = MissileCount + NukeSiloAmmoCount
                end
                LauncherCount = LauncherCount + 1
                -- count experimental launcher seraphim
            end
            EnemyAntiMissile = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * ((categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3) + (categories.SHIELD * categories.EXPERIMENTAL)), Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: ************************************************************************************************')
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: Checking for Targets. Launcher:('..LauncherCount..') Ready:('..table.getn(LauncherReady)..') Full:('..table.getn(LauncherFull)..') - Missiles:('..MissileCount..') - EnemyAntiMissile:('..table.getn(EnemyAntiMissile)..')')
            end
            -- Don't check all nuke functions if we have no missile.
            if LauncherCount < 1 or ( table.getn(LauncherReady) < 1 and table.getn(LauncherFull) < 1 ) then
                continue
            end
            ---------------------------------------------------------------------------------------------------
            -- PrimaryTarget, launch a single nuke on primary targets.
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Unprotected) Experimental PrimaryTarget ')
            end
            if 1 == 1 and aiBrain.PrimaryTarget and table.getn(LauncherReady) > 0 and EntityCategoryContains(categories.EXPERIMENTAL, aiBrain.PrimaryTarget) then
                -- Only shoot if the target is not protected by antimissile or experimental shields
                if not self:IsTargetNukeProtectedSorianEdit(aiBrain.PrimaryTarget, EnemyAntiMissile) then
                    -- Lead target function
                    if TargetPos then
                        -- Only shoot if we are not damaging our own structures
                        if aiBrain:GetNumUnitsAroundPoint(categories.STRUCTURE, TargetPos, 50 , 'Ally') <= 0 then
                            if not self:NukeSingleAttack(HighMissileCountLauncherReady, TargetPos) then
                                if self:NukeSingleAttack(LauncherReady, TargetPos) then
                                    if NUKEDEBUG then
                                        LOG('* AI-Uveso: * NukePlatoonSorianEdit: (Unprotected) Experimental PrimaryTarget FIRE LauncherReady!')
                                    end
                                    NukeLaunched = true
                                end
                            end
                        else
                            if NUKEDEBUG then
                                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Unprotected) Experimental PrimaryTarget FIRE HighMissileCountLauncherReady!')
                            end
                            NukeLaunched = true
                        end
                    end
                end
            end
            ---------------------------------------------------------------------------------------------------
            -- first try to target all targets that are not protected from enemy anti missile
            ---------------------------------------------------------------------------------------------------
            EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE - categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND - categories.TECH2 , Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
            EnemyTargetPositions = {}
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Unprotected) EnemyUnits. Checking enemy units: '..table.getn(EnemyUnits))
            end
            for _, EnemyTarget in EnemyUnits do
                -- get position of the possible next target
                local EnemyTargetPos = EnemyTarget:GetPosition() or nil
                if not EnemyTargetPos then continue end
                local ToClose = false
                -- loop over all already attacked targets
                for _, ETargetPosition in EnemyTargetPositions do
                    -- Check if the target is closeer then 40 to an already attacked target
                    if VDist2(EnemyTargetPos[1],EnemyTargetPos[3],ETargetPosition[1],ETargetPosition[3]) < 40 then
                        ToClose = true
                        break -- break out of the EnemyTargetPositions loop
                    end
                end
                if ToClose then
                    continue -- Skip this enemytarget and check the next
                end
                -- Check if the target is not protected by an antinuke
                if not self:IsTargetNukeProtectedSorianEdit(EnemyTarget, EnemyAntiMissile) then
                    table.insert(EnemyTargetPositions, EnemyTargetPos)
                end
            end
            ---------------------------------------------------------------------------------------------------
            -- Now, if we have unprotected targets, shot at it
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Unprotected) EnemyUnits: Unprotected enemy units: '..table.getn(EnemyTargetPositions))
            end
            if 1 == 1 and table.getn(EnemyTargetPositions) > 0 and table.getn(LauncherReady) > 0 then
                -- loopß over all targets
                self:NukeJerichoAttackSorianEdit(aiBrain, LauncherReady, EnemyTargetPositions, false)
                NukeLaunched = true
            end
            ---------------------------------------------------------------------------------------------------
            -- Try to overwhelm anti nuke, search for targets
            ---------------------------------------------------------------------------------------------------
            EnemyProtectorsNum = 0
            TargetPosition = false
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Check for MissileCount > 8  [ '..MissileCount..' > 8 ]')
            end
            if 1 == 1 and MissileCount > 8 and table.getn(EnemyAntiMissile) > 0 then
                if NUKEDEBUG then
                    LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) MissileCount, EnemyAntiMissile  [ '..MissileCount..', '..table.getn(EnemyAntiMissile)..' ]')
                end
                local AntiMissileRanger = {}
                -- get a list with all antinukes and distance to each other
                for MissileIndex, AntiMissileSTART in EnemyAntiMissile do
                    AntiMissileRanger[MissileIndex] = 0
                    -- get the location of AntiMissile
                    local AntiMissilePosSTART = AntiMissileSTART:GetPosition() or nil
                    if not AntiMissilePosSTART then break end
                    for _, AntiMissileEND in EnemyAntiMissile do
                        local AntiMissilePosEND = AntiMissileSTART:GetPosition() or nil
                        if not AntiMissilePosEND then continue end
                        local dist = VDist2(AntiMissilePosSTART[1],AntiMissilePosSTART[3],AntiMissilePosEND[1],AntiMissilePosEND[3])
                        AntiMissileRanger[MissileIndex] = AntiMissileRanger[MissileIndex] + dist
                    end
                end
                -- find the least protected anti missile
                local HighestDistance = 0
                local HighIndex = false
                for MissileIndex, MissileRange in AntiMissileRanger do
                    if MissileRange > HighestDistance then
                        HighestDistance = MissileRange
                        HighIndex = MissileIndex
                    end
                end
                if HighIndex and EnemyAntiMissile[HighIndex] and not EnemyAntiMissile[HighIndex].Dead then
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Antimissile with highest distance to other antimissiles has HighIndex = '..HighIndex)
                    end
                    -- kill the launcher will all missiles we have
                    EnemyTarget = EnemyAntiMissile[HighIndex]
                    TargetPosition = EnemyTarget:GetPosition() or false
                elseif EnemyAntiMissile[1] and not EnemyAntiMissile[1].Dead then
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Targetting Antimissile[1]')
                    end
                    EnemyTarget = EnemyAntiMissile[1]
                    TargetPosition = EnemyTarget:GetPosition() or false
                end
                -- Scan how many antinukes are protecting the least defended target:
                local ProtectorUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * ((categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3) + (categories.SHIELD * categories.EXPERIMENTAL)), TargetPosition, 90, 'Enemy')
                if ProtectorUnits then
                    EnemyProtectorsNum = table.getn(ProtectorUnits)
                end
            end
            ---------------------------------------------------------------------------------------------------
            -- Try to overwhelm anti nuke, search for targets
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) missiles > antimissiles  [ '..MissileCount..' > '..(EnemyProtectorsNum * 8)..' ]')
            end
            if 1 == 1 and EnemyTarget and TargetPosition and EnemyProtectorsNum > 0 and MissileCount > EnemyProtectorsNum * 8 then
                -- Fire as long as the target exists
                if NUKEDEBUG then
                    LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) while EnemyTarget do ')
                end
                while EnemyTarget and not EnemyTarget.Dead do
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Loop!')
                    end
                    local missile = false
                    for k, Launcher in platoonUnits do
                        if not Launcher or Launcher.Dead or Launcher:BeenDestroyed() then
                            -- We found a dead unit inside this platoon. Disband the Platoon; It will be reformed
                            -- needs PlatoonDisbandNoAssign, or launcher will stop building nukes if the Platoon is disbanded
                            self:PlatoonDisbandNoAssign()
                            return
                        end
                        if NUKEDEBUG then
                            LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Fireing Nuke: '..repr(k))
                        end
                        if Launcher:GetNukeSiloAmmoCount() > 0 then
                            if Launcher:GetNukeSiloAmmoCount() > 1 then
                                missile = true
                            end
                            IssueNuke({Launcher}, TargetPosition)
                            table.remove(LauncherReady, k)
                            MissileCount = MissileCount - 1
                            NukeLaunched = true
                        end
                        if not EnemyTarget or EnemyTarget.Dead then
                            if NUKEDEBUG then
                                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Target is dead. break fire loop')
                            end
                            break -- break the "for Index, Launcher in platoonUnits do" loop
                        end
                    end
                    if not missile then
                        if NUKEDEBUG then
                            LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Nukes are empty')
                        end
                        break -- break the "while EnemyTarget do" loop
                    end
                    if NukeLaunched then
                        if NUKEDEBUG then
                            LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Overwhelm) Nukes launched')
                        end
                        break -- break the "while EnemyTarget do" loop
                    end
                end
            end
            ---------------------------------------------------------------------------------------------------
            -- Jericho! Check if we can attack all targets at the same time
            ---------------------------------------------------------------------------------------------------
            EnemyTargetPositions = {}
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Jericho) Searching for EnemyTargetPositions')
            end
            for _, EnemyTarget in EnemyUnits do
                -- get position of the possible next target
                local EnemyTargetPos = EnemyTarget:GetPosition() or nil
                if not EnemyTargetPos then continue end
                local ToClose = false
                -- loop over all already attacked targets
                for _, ETargetPosition in EnemyTargetPositions do
                    -- Check if the target is closer then 40 to an already attacked target
                    if VDist2(EnemyTargetPos[1],EnemyTargetPos[3],ETargetPosition[1],ETargetPosition[3]) < 40 then
                        ToClose = true
                        break -- break out of the EnemyTargetPositions loop
                    end
                end
                if ToClose then
                    continue -- Skip this enemytarget and check the next
                end
                table.insert(EnemyTargetPositions, EnemyTargetPos)
            end
            ---------------------------------------------------------------------------------------------------
            -- Now, if we have more launchers ready then targets start Jericho bombardment
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Jericho) Checking for Launcher:('..LauncherCount..') Ready:('..table.getn(LauncherReady)..') Full:('..table.getn(LauncherFull)..') - Missiles:('..MissileCount..') - Enemy Targets:('..table.getn(EnemyTargetPositions)..')')
            end
            if 1 == 1 and table.getn(LauncherReady) >= table.getn(EnemyTargetPositions) and table.getn(EnemyTargetPositions) > 0 and table.getn(LauncherFull) > 0 then
                if NUKEDEBUG then
                    LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: Jericho!')
                end
                -- loopß over all targets
                self:NukeJerichoAttackSorianEdit(aiBrain, LauncherReady, EnemyTargetPositions, false)
                NukeLaunched = true
            end
            ---------------------------------------------------------------------------------------------------
            -- If we have an launcher with 5 missiles fire one.
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Checking for Full Launchers. Launcher:('..LauncherCount..') Ready:('..table.getn(LauncherReady)..') Full:('..table.getn(LauncherFull)..') - Missiles:('..MissileCount..')')
            end
            if 1 == 1 and table.getn(LauncherFull) > 0 then
                if NUKEDEBUG then
                    LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) - Launcher is full!')
                end
                EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.EXPERIMENTAL, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
                if table.getn(EnemyUnits) > 0 then
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Enemy Experimental Buildings: ('..table.getn(EnemyUnits)..')')
                    end
                end
                if table.getn(EnemyUnits) <= 0 then
                    EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.TECH3 , Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Enemy TECH3 Buildings: ('..table.getn(EnemyUnits)..')')
                    end
                end
                if table.getn(EnemyUnits) <= 0 then
                    EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.MOBILE * categories.EXPERIMENTAL - categories.AIR, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Enemy Experimental Units: ('..table.getn(EnemyUnits)..')')
                    end
                end
                if table.getn(EnemyUnits) <= 0 then
                    EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE , Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Enemy Buildings: ('..table.getn(EnemyUnits)..')')
                    end
                end
                if table.getn(EnemyUnits) <= 0 then
                    EnemyUnits = aiBrain:GetUnitsAroundPoint(categories.MOBILE - categories.AIR, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Enemy Mobile Units: ('..table.getn(EnemyUnits)..')')
                    end
                end
                if table.getn(EnemyUnits) > 0 then
                    if NUKEDEBUG then
                        LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) MissileCount ('..MissileCount..') > EnemyUnits ('..table.getn(EnemyUnits)..')')
                    end
                    EnemyTargetPositions = {}
                    -- get enemy target positions
                    for _, EnemyTarget in EnemyUnits do
                        -- get position of the possible next target
                        local EnemyTargetPos = EnemyTarget:GetPosition() or nil
                        if not EnemyTargetPos then continue end
                        local ToClose = false
                        -- loop over all already attacked targets
                        for _, ETargetPosition in EnemyTargetPositions do
                            -- Check if the target is closeer then 40 to an already attacked target
                            if VDist2(EnemyTargetPos[1],EnemyTargetPos[3],ETargetPosition[1],ETargetPosition[3]) < 40 then
                                ToClose = true
                                break -- break out of the EnemyTargetPositions loop
                            end
                        end
                        if ToClose then
                            continue -- Skip this enemytarget and check the next
                        end
                        table.insert(EnemyTargetPositions, EnemyTargetPos)
                    end
                end
            end
            ---------------------------------------------------------------------------------------------------
            -- Now, if we have targets, shot at it
            ---------------------------------------------------------------------------------------------------
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: (Launcher Full) Attack only with full Launchers. Launcher:('..LauncherCount..') Ready:('..table.getn(LauncherReady)..') Full:('..table.getn(LauncherFull)..') - Missiles:('..MissileCount..') - Enemy Targets:('..table.getn(EnemyTargetPositions)..')')
            end
            if 1 == 1 and table.getn(EnemyTargetPositions) > 0 and table.getn(LauncherFull) > 0 then
                self:NukeJerichoAttackSorianEdit(aiBrain, LauncherFull, EnemyTargetPositions, true)
                NukeLaunched = true
            end
            if NUKEDEBUG then
                LOG('* AI-SorianEdit: * NukePlatoonSorianEdit: END. Launcher:('..LauncherCount..') Ready:('..table.getn(LauncherReady)..') Full:'..table.getn(LauncherFull)..' - Missiles:('..MissileCount..')')
            end
            if NukeLaunched == true then
                --LOG('* AI-SorianEdit: Fired nuke(s), waiting...')
                coroutine.yield(450)-- wait 45 seconds for the missile flight, then get new targets
            end
        end -- while aiBrain:PlatoonExists(self) do
    end,
    
    LeadNukeTargetSorianEdit = function(self, target)
        local TargetPos
        -- Get target position in 1 second intervals.
        -- This allows us to get speed and direction from the target
        local TargetStartPosition=0
        local Target1SecPos=0
        local Target2SecPos=0
        local XmovePerSec=0
        local YmovePerSec=0
        local XmovePerSecCheck=-1
        local YmovePerSecCheck=-1
        -- Check if the target is runing straight or circling
        -- If x/y and xcheck/ycheck are equal, we can be sure the target is moving straight
        -- in one direction. At least for the last 2 seconds.
        local LoopSaveGuard = 0
        while target and not target.Dead and (XmovePerSec ~= XmovePerSecCheck or YmovePerSec ~= YmovePerSecCheck) and LoopSaveGuard < 10 do
            if not target or target.Dead then return false end
            -- 1st position of target
            TargetPos = target:GetPosition()
            TargetStartPosition = {TargetPos[1], 0, TargetPos[3]}
            coroutine.yield(10)
            -- 2nd position of target after 1 second
            TargetPos = target:GetPosition()
            Target1SecPos = {TargetPos[1], 0, TargetPos[3]}
            XmovePerSec = (TargetStartPosition[1] - Target1SecPos[1])
            YmovePerSec = (TargetStartPosition[3] - Target1SecPos[3])
            coroutine.yield(10)
            -- 3rd position of target after 2 seconds to verify straight movement
            TargetPos = target:GetPosition()
            Target2SecPos = {TargetPos[1], TargetPos[2], TargetPos[3]}
            XmovePerSecCheck = (Target1SecPos[1] - Target2SecPos[1])
            YmovePerSecCheck = (Target1SecPos[3] - Target2SecPos[3])
            --We leave the while-do check after 10 loops (20 seconds) and try collateral damage
            --This can happen if a player try to fool the targetingsystem by circling a unit.
            LoopSaveGuard = LoopSaveGuard + 1
        end
        if not target or target.Dead then return false end
        local MissileImpactTime = 25
        -- Create missile impact corrdinates based on movePerSec * MissileImpactTime
        local MissileImpactX = Target2SecPos[1] - (XmovePerSec * MissileImpactTime)
        local MissileImpactY = Target2SecPos[3] - (YmovePerSec * MissileImpactTime)
        return {MissileImpactX, Target2SecPos[2], MissileImpactY}
    end,

    NukeSingleAttackSorianEdit = function(self, Launchers, EnemyTargetPosition)
        --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: Launcher count: '..table.getn(Launchers))
        if table.getn(Launchers) <= 0 then
            --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: No Launcher ready.')
            return false
        end
        -- loop over all nuke launcher
        for k, Launcher in Launchers do
            if not Launcher or Launcher.Dead or Launcher:BeenDestroyed() then
                -- We found a dead unit inside this platoon. Disband the Platoon; It will be reformed
                -- needs PlatoonDisbandNoAssign, or launcher will stop building nukes if the Platoon is disbanded
                --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: Found destroyed launcher inside platoon. Disbanding...')
                self:PlatoonDisbandNoAssign()
                return
            end
            -- check if the target is closer then 20000
            LauncherPos = Launcher:GetPosition() or nil
            if not LauncherPos then
                --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: no Launcher Pos. Skiped')
                continue
            end
            if not EnemyTargetPosition then
                --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: no Target Pos. Skiped')
                continue
            end
            if VDist2(LauncherPos[1],LauncherPos[3],EnemyTargetPosition[1],EnemyTargetPosition[3]) > 20000 then
                --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: Target out of range. Skiped')
                -- Target is out of range, skip this launcher
                continue
            end
            -- Attack the target
            --LOG('* AI-SorianEdit: ** NukeSingleAttackSorianEdit: Attacking Enemy Position!')
            IssueNuke({Launcher}, EnemyTargetPosition)
            -- stop seraching for available launchers and check the next target
            return true
        end
    end,

    NukeJerichoAttackSorianEdit = function(self, aiBrain, Launchers, EnemyTargetPositions, LaunchAll)
        --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: Launcher: '..table.getn(Launchers))
        if table.getn(Launchers) <= 0 then
            --LOG('* AI-SorianEdit: * NukeSingleAttackSorianEdit: Launcher empty')
            return false
        end
        for _, ActualTargetPos in EnemyTargetPositions do
            -- loop over all nuke launcher
            for k, Launcher in Launchers do
                if not Launcher or Launcher.Dead or Launcher:BeenDestroyed() then
                    -- We found a dead unit inside this platoon. Disband the Platoon; It will be reformed
                    -- needs PlatoonDisbandNoAssign, or launcher will stop building nukes if the Platoon is disbanded
                    --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: Found destroyed launcher inside platoon. Disbanding...')
                    if aiBrain:PlatoonExists(self) then
                        self:PlatoonDisbandNoAssign()
                    end
                    return
                end
                -- check if the target is closer then 20000
                LauncherPos = Launcher:GetPosition() or nil
                if not LauncherPos then
                    --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: no Launcher Pos. Skiped')
                    continue
                end
                if not ActualTargetPos then
                    --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: no Target Pos. Skiped')
                    continue
                end
                if VDist2(LauncherPos[1],LauncherPos[3],ActualTargetPos[1],ActualTargetPos[3]) > 20000 then
                    --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: Target out of range. Skiped')
                    -- Target is out of range, skip this launcher
                    continue
                end
                -- Attack the target
                --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: Attacking Enemy Position!')
                IssueNuke({Launcher}, ActualTargetPos)
                -- remove the launcher from the table, so it can't be used for the next target
                table.remove(Launchers, k)
                -- stop seraching for available launchers and check the next target
                break -- for k, Launcher in Launcher do
            end
            --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: Launcher after shoot: '..table.getn(Launchers))
            if table.getn(Launchers) < 1 then
                --LOG('* AI-SorianEdit: * NukeJerichoAttackSorianEdit: All Launchers are bussy! Break!')
                -- stop seraching for targets, we don't hava a launcher ready.
                break -- for _, ActualTargetPos in EnemyTargetPositions do
            end
        end
        if table.getn(Launchers) > 0 and LaunchAll == true then
            self:NukeJerichoAttackSorianEdit(aiBrain, Launchers, EnemyTargetPositions, true)
        end
    end,

    IsTargetNukeProtectedSorianEdit = function(self, Target, EnemyAntiMissile)
        TargetPos = Target:GetPosition() or nil
        if not TargetPos then
            -- we don't have a target position, so we return ture like we have a protected target.
            return true
        end
        for _, AntiMissile in EnemyAntiMissile do
            if not AntiMissile or AntiMissile.Dead or AntiMissile:BeenDestroyed() then continue end
            -- if the launcher is still in build, don't count it.
            local FractionComplete = AntiMissile:GetFractionComplete() or nil
            if not FractionComplete then continue end
            if FractionComplete < 1 then
                --LOG('* AI-SorianEdit: * IsTargetNukeProtectedSorianEdit: Target TAntiMissile:GetFractionComplete() < 1')
                continue
            end
            -- get the location of AntiMissile
            local AntiMissilePos = AntiMissile:GetPosition() or nil
            if not AntiMissilePos then
               --LOG('* AI-SorianEdit: * IsTargetNukeProtectedSorianEdit: Target AntiMissilePos NIL')
                continue 
            end
            -- Check if our target is inside range of an antimissile
            if VDist2(TargetPos[1],TargetPos[3],AntiMissilePos[1],AntiMissilePos[3]) < 90 then
                --LOG('* AI-SorianEdit: * IsTargetNukeProtectedSorianEdit: Target in range of Nuke Anti Missile. Skiped')
                return true
            end
        end
        return false
    end,

    SACUTeleportSorianEdit = function(self)
        --LOG('* AI-SorianEdit: * SACUTeleportSorianEdit: Start ')
        -- SACU need to move out of the gate first
        coroutine.yield(50)
        local aiBrain = self:GetBrain()
        local platoonUnits
        local platoonPosition = self:GetPlatoonPosition()
        local TargetPosition
        AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        -- start upgrading all SubCommanders as teleporter
        while aiBrain:PlatoonExists(self) do
            local allEnhanced = true
            platoonUnits = self:GetPlatoonUnits()
            for k, unit in platoonUnits do
                IssueStop({unit})
                IssueClearCommands({unit})
                coroutine.yield(1)
                if not unit.Dead then
                    for k, Assister in platoonUnits do
                        if not Assister.Dead and Assister ~= unit then
                            -- only assist if we have the energy for it
                            if aiBrain:GetEconomyTrend('ENERGY')*10 > 5000 or aiBrain.PriorityManager.HasParagon then
                                --LOG('* AI-Uveso: * SACUTeleportAI: IssueGuard({Assister}, unit) ')
                                IssueGuard({Assister}, unit)
                            end
                        end
                    end
                    self:BuildSACUEnhancementsSorianEdit(unit)
                    coroutine.yield(1)
                    if not unit:HasEnhancement('Teleporter') then
                        --LOG('* AI-SorianEdit: * SACUTeleportSorianEdit: Not teleporter enhanced')
                        allEnhanced = false
                    else
                        --LOG('* AI-SorianEdit: * SACUTeleportSorianEdit: Has teleporter installed')
                    end
                end
            end
            if allEnhanced == true then
                --LOG('* AI-SorianEdit: * SACUTeleportSorianEdit: allEnhanced == true ')
                break
            end
            coroutine.yield(50)
        end
        --
        local MoveToCategories = {}
        if self.PlatoonData.MoveToCategories then
            for k,v in self.PlatoonData.MoveToCategories do
                table.insert(MoveToCategories, v )
            end
        else
            LOG('* AI-SorianEdit: * SACUTeleportSorianEdit: MoveToCategories missing in platoon '..self.BuilderName)
        end
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
        self:SetPrioritizedTargetList('Attack', WeaponTargetCategories)
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory or 'ALLUNITS'
        local maxRadius = self.PlatoonData.SearchRadius or 100
        -- search for a target
        local Target
        while not Target do
            coroutine.yield(50)
            Target, _, _, _ = AIUtils.AIFindNearestCategoryTeleportLocationSorianEdit(aiBrain, platoonPosition, maxRadius, MoveToCategories, TargetSearchCategory, false)
        end
        platoonUnits = self:GetPlatoonUnits()
        if Target and not Target.Dead then
            TargetPosition = Target:GetPosition()
            for k, unit in platoonUnits do
                if not unit.Dead then
                    if not unit:HasEnhancement('Teleporter') then
                        --WARN('* AI-SorianEdit: * SACUTeleportSorianEdit: Unit has no transport enhancement!')
                        continue
                    end
                    --IssueStop({unit})
                    coroutine.yield(2)
                    IssueTeleport({unit}, SUtils.RandomizePosition(TargetPosition))
                end
            end
        else
            --LOG('* AI-SorianEdit: SACUTeleportSorianEdit: No target, disbanding platoon!')
            self:PlatoonDisband()
            return
        end
        coroutine.yield(30)
        -- wait for the teleport of all unit
        local count = 0
        local UnitTeleporting = 0
        while aiBrain:PlatoonExists(self) do
            platoonUnits = self:GetPlatoonUnits()
            UnitTeleporting = 0
            for k, unit in platoonUnits do
                if not unit.Dead then
                    if unit:IsUnitState('Teleporting') then
                        UnitTeleporting = UnitTeleporting + 1
                    end
                end
            end
            --LOG('* AI-SorianEdit: SACUTeleportSorianEdit: Units Teleporting :'..UnitTeleporting )
            if UnitTeleporting == 0 then
                break
            end
            coroutine.yield(10)
        end        
        -- Fight
        coroutine.yield(1)
        for k, unit in platoonUnits do
            if not unit.Dead then
                IssueStop({unit})
                coroutine.yield(2)
                IssueMove({unit}, TargetPosition)
            end
        end
        coroutine.yield(50)
        self:LandAttackSorianEdit()
        if aiBrain:PlatoonExists(self) then
            self:PlatoonDisband()
        end
    end,

    BuildSACUEnhancementsSorianEdit = function(platoon,unit)
        local EnhancementsByUnitID = {
            -- UEF
            ['uel0301'] = {'xxx', 'xxx', 'xxx'},
            -- Aeon
            ['ual0301'] = {'StabilitySuppressant', 'Teleporter'},
            -- Cybram
            ['url0301'] = {'xxx', 'xxx', 'xxx'},
            -- Seraphim
            ['xsl0301'] = {'DamageStabilization', 'Shield', 'Teleporter'},
            -- Nomads
            ['xnl0301'] = {'xxx', 'xxx', 'xxx'},
        }
        local CRDBlueprint = unit:GetBlueprint()
        --LOG('* AI-SorianEdit: BlueprintId RAW:'..repr(CRDBlueprint.BlueprintId))
        --LOG('* AI-SorianEdit: BlueprintId clean: '..repr(string.gsub(CRDBlueprint.BlueprintId, "(%a+)(%d+)_(%a+)", "%1".."%2")))
        local ACUUpgradeList = EnhancementsByUnitID[string.gsub(CRDBlueprint.BlueprintId, "(%a+)(%d+)_(%a+)", "%1".."%2")]
        --LOG('* AI-SorianEdit: ACUUpgradeList '..repr(ACUUpgradeList))
        local NextEnhancement = false
        local HaveEcoForEnhancement = false
        for _,enhancement in ACUUpgradeList or {} do
            local wantedEnhancementBP = CRDBlueprint.Enhancements[enhancement]
            --LOG('* AI-SorianEdit: wantedEnhancementBP '..repr(wantedEnhancementBP))
            if not wantedEnhancementBP then
                SPEW('* AI-SorianEdit: BuildSACUEnhancementsSorianEdit: no enhancement found for ('..string.gsub(CRDBlueprint.BlueprintId, "(%a+)(%d+)_(%a+)", "%1".."%2")..') = '..repr(enhancement))
            elseif unit:HasEnhancement(enhancement) then
                NextEnhancement = false
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit: Enhancement is already installed: '..enhancement)
            elseif platoon:EcoGoodForUpgradeSorianEdit(unit, wantedEnhancementBP) then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit: Eco is good for '..enhancement)
                if not NextEnhancement then
                    NextEnhancement = enhancement
                    HaveEcoForEnhancement = true
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: *** Set as Enhancememnt: '..NextEnhancement)
                end
            else
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit: Eco is bad for '..enhancement)
                if not NextEnhancement then
                    NextEnhancement = enhancement
                    HaveEcoForEnhancement = false
                    -- if we don't have the eco for this ugrade, stop the search
                    --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: canceled search. no eco available')
                end
            end
        end
        if NextEnhancement and HaveEcoForEnhancement then
            --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit Building '..NextEnhancement)
            if platoon:BuildEnhancementSorianEdit(unit, NextEnhancement) then
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit returned true'..NextEnhancement)
            else
                --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit returned false'..NextEnhancement)
            end
            return
        end
        --LOG('* AI-SorianEdit: * ACUAttackSorianEdit: BuildSACUEnhancementsSorianEdit returned false')
        return
    end,


    TacticalSorianEdit = function(self)
        self:Stop()
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local platoonUnits = self:GetPlatoonUnits()
        local unit

        if not aiBrain:PlatoonExists(self) then return end

        --GET THE Launcher OUT OF THIS PLATOON
        for k, v in platoonUnits do
            if EntityCategoryContains(categories.STRUCTURE * categories.TACTICALMISSILEPLATFORM, v) then
                unit = v
                break
            end
        end

        if not unit then return end

        local bp = unit:GetBlueprint()
        local weapon = bp.Weapon[1]
        local maxRadius = weapon.MaxRadius
        local minRadius = weapon.MinRadius
        unit:SetAutoMode(true)

        --DUNCAN - commented out
        --local atkPri = { 'COMMAND', 'STRUCTURE STRATEGIC', 'STRUCTURE DEFENSE', 'CONSTRUCTION', 'EXPERIMENTAL MOBILE LAND', 'TECH3 MOBILE LAND',
        --    'TECH2 MOBILE LAND', 'TECH1 MOBILE LAND', 'ALLUNITS' }

        --DUNCAN - added energy production, removed construction, repriotised.
        self:SetPrioritizedTargetList('Attack', {
            categories.COMMAND,
            categories.EXPERIMENTAL,
            categories.MASSEXTRACTION * categories.TECH3,
            categories.ENERGYPRODUCTION * categories.TECH3,
            categories.MASSEXTRACTION * categories.TECH2,
            categories.ENERGYPRODUCTION * categories.TECH2,
            categories.STRUCTURE,
            categories.TECH3 * categories.MOBILE})
        while aiBrain:PlatoonExists(self) do
            local target = false
            local blip = false
            while unit:GetTacticalSiloAmmoCount() < 1 or not target do
                WaitSeconds(7)
                target = false
                while not target do

                    --DUNCAN - Commented out
                    --if aiBrain:GetCurrentEnemy() and aiBrain:GetCurrentEnemy().Result == "defeat" then
                    --    aiBrain:PickEnemyLogic()
                    --end
                    --target = AIUtils.AIFindBrainTargetInRange(aiBrain, self, 'Attack', maxRadius, atkPri, aiBrain:GetCurrentEnemy())

                    if not target then
                        target = self:FindPrioritizedUnit('Attack', 'Enemy', true, unit:GetPosition(), maxRadius)
                    end
                    if target then
                        break
                    end
                    WaitSeconds(3)
                    if not aiBrain:PlatoonExists(self) then
                        return
                    end
                end
            end
            if not target.Dead then
                --LOG('*AI DEBUG: Firing Tactical Missile at enemy swine!')
                IssueTactical({unit}, target)
            end
            WaitSeconds(3)
        end
    end,
    
    ScoutingSorianEdit = function(self)
        AIAttackUtils.GetMostRestrictiveLayer(self)

        if self.MovementLayer == 'Air' then
            return self:AirScoutingSorianEdit()
        else
            return self:LandScoutingSorianEdit(false)
        end
    end,
	
    FighterBomberSelect = function(self)
        local aiBrain = self:GetBrain()
		local pos = self:GetPlatoonPosition()
		local EnemyACUs = {}
		local SnipeTargets = {}
		local Snipe = false
        local AirTarget = ( aiBrain:GetNumUnitsAroundPoint( (categories.MOBILE * categories.ANTIAIR), pos, 512, 'Enemy') )

		for k, brain in ArmyBrains do
			if IsEnemy(aiBrain:GetArmyIndex(), brain:GetArmyIndex()) then
				local EACU = brain:GetListOfUnits( categories.COMMAND, false)
				-- LOG('*AI --------------------------------------- FighterBomberSelect: GetListOfUnits: '..repr(EACU))
				for ke, ve in EACU do
					table.insert(EnemyACUs, ve)
				end
			end
		end
		
        -- LOG('*AI --------------------------------------- FighterBomberSelect: FighterBomberSelect ACU targets: '..repr(EnemyACUs))

		for ka, va in EnemyACUs do
			local ACUpos = va:GetPosition()
			-- LOG('*AI --------------------------------------- FighterBomberSelect: ACU targets Acu position:'..repr(ACUpos))
			local EnemyAA = aiBrain:GetNumUnitsAroundPoint((categories.LAND * categories.ANTIAIR - categories.TECH1), ACUpos, 60, 'Enemy')
			
			-- LOG('*AI --------------------------------------- FighterBomberSelect: ACU targets AA: '..repr(EnemyAA)..' Acu position:'..repr(ACUpos))
			
			if EnemyAA <= 4 then
				table.insert(SnipeTargets, va)
				Snipe = true
			end
		end

		if Snipe then
			for ks, vs in SnipeTargets do
				self:AttackTarget(vs)
				while not vs.Dead do
					WaitSeconds(10)
				end
			end
        elseif AirTarget >= 10 then
            return self:GuardBaseSorianEdit()
        else
            return self:InterceptorBomberGunshipSorianEdit()
        end
    end,

    AirScoutingSorianEdit = function(self)
        local patrol = self.PlatoonData.Patrol or false
        local scout = self:GetPlatoonUnits()[1]
        if not scout then
            return
        end
        local aiBrain = self:GetBrain()

        if not aiBrain.InterestList then
            aiBrain:BuildScoutLocationsSorianEdit()
        end

        if scout:TestToggleCaps('RULEUTC_CloakToggle') then
            scout:EnableUnitIntel('Toggle', 'Cloak')
        end
		
		while not scout.Dead do
			local targetArea = false
			local highPri = false

			local mustScoutArea, mustScoutIndex = aiBrain:GetUntaggedMustScoutArea()
			local unknownThreats = aiBrain:GetThreatsAroundPosition(scout:GetPosition(), 16, true, 'Unknown')
			
			if mustScoutArea then
				mustScoutArea.TaggedBy = scout
				targetArea = mustScoutArea.Position
			elseif table.getn(unknownThreats) > 0 and unknownThreats[1][3] > 25 then
				aiBrain:AddScoutArea({unknownThreats[1][1], 0, unknownThreats[1][2]})
			elseif aiBrain.IntelData.AirHiPriScouts < aiBrain.NumOpponents and aiBrain.IntelData.AirLowPriScouts < 1
			and table.getn(aiBrain.InterestList.HighPriority) > 0 then
				aiBrain.IntelData.AirHiPriScouts = aiBrain.IntelData.AirHiPriScouts + 1
				highPri = true
				targetData = aiBrain.InterestList.HighPriority[1]
				targetData.LastScouted = GetGameTimeSeconds()
				targetArea = targetData.Position
				aiBrain:SortScoutingAreas(aiBrain.InterestList.HighPriority)
			elseif aiBrain.IntelData.AirLowPriScouts < 1 and table.getn(aiBrain.InterestList.LowPriority) > 0 then
				aiBrain.IntelData.AirHiPriScouts = 0
				aiBrain.IntelData.AirLowPriScouts = aiBrain.IntelData.AirLowPriScouts + 1

				targetData = aiBrain.InterestList.LowPriority[1]
				targetData.LastScouted = GetGameTimeSeconds()
				targetArea = targetData.Position

				aiBrain:SortScoutingAreas(aiBrain.InterestList.LowPriority)
			else
				aiBrain.IntelData.AirLowPriScouts = 0
				aiBrain.IntelData.AirHiPriScouts = 0
			end
			
			if targetArea then
				self:Stop()
				local vec = self:DoAirScoutVecs(scout, targetArea)

				while not scout.Dead and not scout:IsIdleState() do
					if VDist2Sq(vec[1], vec[3], scout:GetPosition()[1], scout:GetPosition()[3]) < 15625 then
					   if mustScoutArea then
							for idx,loc in aiBrain.InterestList.MustScout do
								if loc == mustScoutArea then
								   table.remove(aiBrain.InterestList.MustScout, idx)
								   break
								end
							end
						end
						break
					end
					if VDist3(scout:GetPosition(), targetArea) < 25 then
						break
					end
					coroutine.yield(50)
				end
			else
				coroutine.yield(10)
			end
			
			coroutine.yield(1)
		end
    end,

    LandScoutingSorianEdit = function(self, timelimit)
        AIAttackUtils.GetMostRestrictiveLayer(self)

        local aiBrain = self:GetBrain()
        local scout = self:GetPlatoonUnits()[1]
		local starttime = GetGameTimeSeconds()
		local currenttime = GetGameTimeSeconds()

		if not scout or scout.Dead or scout:BeenDestroyed() then
			self:PlatoonDisband()
		end
		
        if not aiBrain.InterestList then
            aiBrain:BuildScoutLocationsSorianEdit()
        end
		
        if scout:TestToggleCaps('RULEUTC_CloakToggle') then
            scout:SetScriptBit('RULEUTC_CloakToggle', false)
        end

        while aiBrain:PlatoonExists(self) do
		
			if not scout or scout.Dead or scout:BeenDestroyed() then
				self:PlatoonDisband()
			end
		
			currenttime = GetGameTimeSeconds()
			if timelimit and (currenttime > (starttime+timelimit)) then
				-- LOG('-------------- CurrOffset: '..repr((starttime+timelimit))..' at time: '..repr(currenttime))
				IssueClearCommands(self)
				break
			end
			
            local targetData = false

            if aiBrain.IntelData.HiPriScouts < aiBrain.NumOpponents and table.getn(aiBrain.InterestList.HighPriority) > 0 then
                targetData = aiBrain.InterestList.HighPriority[1]
                aiBrain.IntelData.HiPriScouts = aiBrain.IntelData.HiPriScouts + 1
                targetData.LastScouted = GetGameTimeSeconds()

                aiBrain:SortScoutingAreas(aiBrain.InterestList.HighPriority)

            elseif table.getn(aiBrain.InterestList.LowPriority) > 0 then
                targetData = aiBrain.InterestList.LowPriority[1]
                aiBrain.IntelData.HiPriScouts = 0
                targetData.LastScouted = GetGameTimeSeconds()

                aiBrain:SortScoutingAreas(aiBrain.InterestList.LowPriority)
            else

                aiBrain.IntelData.HiPriScouts = 0
            end

            if targetData then
                local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer, scout:GetPosition(), targetData.Position, 6, 1000)
                IssueClearCommands(self)

                if path then
                    local pathLength = table.getn(path)
                    for i=1, pathLength-1 do
						if not scout or scout.Dead or scout:BeenDestroyed() then
							break
						end
                        self:MoveToLocation(path[i], false)
                    end
                end

                self:MoveToLocation(targetData.Position, false)

                while not scout.Dead and not scout:IsIdleState() do
                    coroutine.yield(25)
                end
            end
			
            coroutine.yield(10)
        end
    end,

    -- Function: MergeWithNearbyPlatoons
    --    self - the single platoon to run the AI on
    --    planName - AI plan to merge with
    --    radius - merge with platoons in this radius 
    --    planmatchrequired     - if true merge platoons only with same builder name AND the same plan
    --                          - if false then merging will be done with all platoons using same plan
    --    mergelimit - if set, the merge can only be taken upto that size
    --
    -- Finds platoon nearby (when self platoon is not near a base) and merge with them if they're a good fit.
    --      Dont allow smaller platoons to merge larger platoons into themselves
    --   Returns:  
    --       nil if no merge was done, true if a merge was done
    
    -- NOTE: The platoon executing this function will 'grab' units
    --      from the allied platoons - so in effect, it's reinforcing itself

    -- 90% of This Work is from Sprouto

    MergeWithNearbyPlatoonsSorianEdit = function( self, aiBrain, planName, radius, planmatchrequired, mergelimit )

        if self.UsingTransport then
            return false
        end
        
        if not PlatoonExists(aiBrain,self) then
            return false
        end

        local platoonUnits = GetPlatoonUnits(self)
        local platooncount = 0

        for _,v in platoonUnits do
            if not v.Dead then
                platooncount = platooncount + 1
            end
        end

        if (mergelimit and platooncount > mergelimit) or platooncount < 1 then
            return false
        end
        
        local platPos = SorianEditCOPY(GetPlatoonPosition(self))
        local radiusSq = radius*radius  -- maximum range to check allied platoons --

        -- we cant be within 1/3 that range to our own base --
--[[
        for _, base in aiBrain.BuilderManagers do
            if VDist2Sq( platPos[1],platPos[3], base.Position[1],base.Position[3] ) <= ( radiusSq / 3 ) then
                return false
            end
        end
--]]

        -- get a list of all the platoons for this brain
        local GetPlatoonsList = moho.aibrain_methods.GetPlatoonsList
        local AlliedPlatoons = SorianEditCOPY(GetPlatoonsList(aiBrain))
        
        SorianEditSORT(AlliedPlatoons, function(a,b) return VDist2Sq(GetPlatoonPosition(a)[1],GetPlatoonPosition(a)[3], platPos[1],platPos[3]) < VDist2Sq(GetPlatoonPosition(b)[1],GetPlatoonPosition(b)[3], platPos[1],platPos[3]) end)
        
        local mergedunits = false
        local allyPlatoonSize, validUnits, counter = 0
        
        --LOG("*AI DEBUG "..aiBrain.Nickname.." "..self.BuilderName.." checking MERGE WITH for "..repr(table.getn(AlliedPlatoons)))
        
        local count = 0
        
        -- loop thru all the platoons in the list
        for _,aPlat in AlliedPlatoons do
            -- ignore yourself
            if aPlat == self then
                continue
            end
            count = count + 1
            -- if allied platoon is busy (not necessarily transports - this is really a general 'busy' flag --
            if aPlat.UsingTransport then
                continue
            end
            
            -- not only the plan must match but the buildername as well
            if planmatchrequired and aPlat.BuilderName != self.BuilderName then
                continue
            end
            
            -- otherwise it must a least have the same plan
            if aPlat.PlanName != planName then
                continue
            end
            
            -- and be on the same movement layer
            if self.MovementLayer != aPlat.MovementLayer then
                continue
            end
            
            -- check distance of allied platoon -- as soon as we hit one farther away then we're done
            if VDist2Sq(platPos[1],platPos[3], GetPlatoonPosition(aPlat)[1],GetPlatoonPosition(aPlat)[3]) > radiusSq then
                break
            end
            
            -- get the allied platoons size
            allyPlatoonSize = 0
            
            -- mark the allied platoon as being busy
            aPlat.UsingTransport = true
            
            local aPlatUnits = GetPlatoonUnits(aPlat)
            
            validUnits = {}
            counter = 0
            
            -- count and check validity of allied units
            for _,u in aPlatUnits do
                if not u.Dead then
                    allyPlatoonSize = allyPlatoonSize + 1
                    if not IsUnitState(u,'Attached' )then
                        -- if we have space in our platoon --
                        if (counter + platooncount) <= mergelimit then
                            validUnits[counter+1] = u
                            counter = counter + 1
                        end
                    end
                end
            end

            -- if no valid units or we are smaller than the allied platoon then dont allow
            if counter < 1 or platooncount < allyPlatoonSize or allyPlatoonSize == 0 then
                continue
            end

            -- otherwise we do the merge
            if ScenarioInfo.PlatoonMergeDialog then
                LOG("*AI DEBUG "..aiBrain.Nickname.." MERGE_WITH "..repr(self.BuilderName).." takes "..counter.." units from "..aPlat.BuilderName.." now has "..platooncount+counter)
            end
            
            -- unmark the allied platoon
            aPlat.UsingTransport = false
            -- assign the valid units to us - this may end the allied platoon --
            AssignUnitsToPlatoon( aiBrain, self, validUnits, 'Attack', 'none' )
            -- add the new units to our count --
            platooncount = platooncount + counter
            -- flag that we did a merge --
            mergedunits = true
            
        end
        --LOG("*AI DEBUG "..aiBrain.Nickname.." "..self.BuilderName.." checked "..count.." platoons")
        return mergedunits
    end,

    ReturnToBaseSorianEdit = function( self, aiBrain )
		-- since RTB always deals with MOBILE units we use the Entity based GetPosition
		local GetPosition = moho.entity_methods.GetPosition
		local GetCommandQueue = moho.unit_methods.GetCommandQueue
		
		local VDist3 = VDist3
		local VDist2 = VDist2
		
		if not aiBrain then
			aiBrain = GetBrain(self)
		end

		if self == aiBrain.ArmyPool or not PlatoonExists(aiBrain, self) then
			WARN("*AI DEBUG ArmyPool or nil in RTB")
			return
		end
		
		if self.DistressResponseAIRunning then
			self.DistressResponseAIRunning = false
		end

		if self.MoveThread then
			self:KillMoveThread()
		end
		
		if not self.MovementLayer then
			GetMostRestrictiveLayer(self)
		end
		
		-- assume platoon is dead 
		local platoonDead = true
		-- set the desired RTBLocation (specified base, source base or false)
        local RTBLocation = self.RTBLocation or self.LocationType or false
		-- flag for experimentals (no air transports)
		local experimental = PlatoonCategoryCount(self, categories.EXPERIMENTAL) > 0
		-- assume no engineer in platoon
		local engineer = false
		-- process the units to identify engineers and the CDR
		-- and to determine which base to RTB to
		for k,v in GetPlatoonUnits(self) do
			-- set the 'platoonDead' to false
			if not v.Dead then
				platoonDead = false
				-- set the 'engineer' flag
				if SorianEditENTITY( categories.ENGINEER, v ) then
					engineer = v
					-- Engineer naming
                    if v.BuilderName and ScenarioInfo.NameEngineers then
						if not SorianEditENTITY( categories.COMMAND, v ) then
							v:SetCustomName("Eng "..v.Sync.id.." RTB from "..v.BuilderName.." to "..v.LocationType )
						end
                    end
					-- force CDR to disband - he never leaves home
	                if SorianEditENTITY( categories.COMMAND, v ) then
						self:PlatoonDisband( aiBrain )
						return
					end
					RTBLocation = v.LocationType
				end
				
				-- if no platoon RTBLocation then force one
				if not RTBLocation or RTBLocation == "Any" then
					-- if the unit has a LocationType and it exists -- we might use that for the platoon
					if v.LocationType then
						if RTBLocation != "Any" and aiBrain.BuilderManagers[v.LocationType].EngineerManager.Active then
							self.LocationType = v.LocationType
							RTBLocation = v.LocationType
						else
						
							-- find the closest manager 
							if self.MovementLayer == "Land" then
								-- dont use naval bases for land --
								LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.BuilderName).." seeks ONLY Land Bases")
								self.LocationType = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(self), false, false )
								RTBLocation = self.LocationType
							else
								if self.MovementLayer == "Air" or self.MovementLayer == "Amphibious" then
									-- use any kind of base --
									self.LocationType = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(self), true, false )
									RTBLocation = self.LocationType
								else
									-- use only naval bases for 'Sea' platoons
									LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.Buildername).." seeks ONLY Naval bases")
									self.LocationType = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(self), true, true )
									RTBLocation = self.LocationType
								end
							end
							LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.BuilderName).." using RTBLocation "..repr(RTBLocation))
						end
					end
				end
				
				-- default attached processing (something is not doing this properly)
				if v:IsUnitState('Attached') then
					v:DetachFrom()
					v:SetCanTakeDamage(true)
					v:SetDoNotTarget(false)
					v:SetReclaimable(true)
					v:SetCapturable(true)
					v:ShowBone(0, true)
					v:MarkWeaponsOnTransport(v, false)
				end
			end
        end

		-- exit if no units --
		if platoonDead then
            return 
		end
		
		if ScenarioInfo.PlatoonDialog then
			LOG("*AI DEBUG Platoon "..aiBrain.Nickname.." "..repr(self.BuilderName).." begins RTB to "..repr(RTBLocation) )
		end
		
       	IssueClearCommands( GetPlatoonUnits(self) )
        
        local platPos = SorianEditCOPY(GetPlatoonPosition(self))
		local lastpos = SorianEditCOPY(GetPlatoonPosition(self))
		local transportLocation = false	
        local baseName, base
        local bestBase = false
        local bestBaseName = ""
        local bestDistance = 99999999
		local distance = 0
		local bases = aiBrain.BuilderManagers
		
		-- confirm RTB location exists or pick closest
		if bases and platPos then
			-- if specified base exists and is active - use it
			-- otherwise locate nearest suitable base as RTBLocation
			if RTBLocation and bases[RTBLocation].EngineerManager.Active then
				bestBase = bases[RTBLocation]
				bestBaseName = RTBLocation
                RTBLocation = bestBase.Position
			else
				RTBLocation = 'Any'
				-- loop thru all existing 'active' bases and use the closest suitable base --
				-- if no base -- use 'MAIN' --
				for baseName, base in bases do
					-- if the base is active --
					if base.EngineerManager.Active then
						-- record distance to base
						distance = VDist2Sq( platPos[1],platPos[3], base.Position[1],base.Position[3] )
						-- is this base suitable for this platoon 
						if (distance < bestDistance) and ( (RTBLocation == 'Any') or (not engineer and not RTBLocation) ) then
							-- dont allow RTB to Naval Bases for Land --
							-- and dont allow RTB to anything BUT Naval for Water
							if (self.MovementLayer == 'Land' and base.BaseType == "Sea") or
							   (self.MovementLayer == 'Water' and base.BaseType != "Sea") then
								continue
							else
								bestBase = base
								bestBaseName = baseName
								RTBLocation = bestBase.Position
								bestDistance = distance
							end
						end
					end
				end
				if not bestBase then
					LOG("*AI DEBUG "..aiBrain.Nickname.." RTB "..repr(self.BuilderName).." Couldn't find base "..repr(RTBLocation).." - using MAIN")
					bestBase = aiBrain.BuilderManagers['MAIN']
					bestBaseName = 'MAIN'
					RTBLocation = bestBase.Position
				end
			end

			-- set transportlocation - engineers always use base centre	
			if bestBase.Position then
				transportLocation = table.copy(bestBase.Position)
			else
				LOG("*AI DEBUG "..aiBrain.Nickname.." RTB cant locate a bestBase")
				return self:PlatoonDisband(aiBrain)
			end
			
			-- others will seek closest rally point of that base
			if not engineer then
				-- use the base generated rally points
				local rallypoints = table.copy(bestBase.RallyPoints)
				-- sort the rallypoints for closest to the platoon --
				SorianEditSORT( rallypoints, function(a,b) return VDist2Sq( a[1],a[3], platPos[1],platPos[3] ) < VDist2Sq( b[1],b[3], platPos[1],platPos[3] ) end )
				transportLocation = table.copy(rallypoints[1])
				-- if cannot find rally marker - use base centre
				if not transportLocation then
					transportLocation = table.copy(bestBase.Position)
				end
			end
            RTBLocation[2] = GetTerrainHeight( RTBLocation[1], RTBLocation[3] )
			transportLocation[2] = GetTerrainHeight(transportLocation[1],transportLocation[3])
		else
            LOG("*AI DEBUG "..aiBrain.Nickname.." RTB reports no platoon position or no bases")
			return self:PlatoonDisband(aiBrain)
        end

		distance = VDist2Sq( platPos[1],platPos[3], RTBLocation[1],RTBLocation[3] )

		-- Move the platoon to the transportLocation either by ground, transport or teleportation (engineers only)
		-- NOTE: distance is calculated above - it's always distance from the base (RTBLocation) - not from the transport location - 
        -- NOTE: When the platoon is within 75 of the base we just bypass this code
        if platPos and transportLocation and distance > (60*60) then
            local mythreat = self:CalculatePlatoonThreat('Overall', categories.ALLUNITS)
            if mythreat < 10 then
				mythreat = 10
            end
			-- set marker radius for path finding
			local markerradius = 150
			if self.MovementLayer == 'Air' or self.MovementLayer == 'Water' then
				markerradius = 200
			end
			
            -- we use normal threat first
            local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit( aiBrain, self, self.MovementLayer, platPos, transportLocation, mythreat, markerradius )
			-- then we'll try elevated threat
			if not path then
			-- we use an elevated threat value to help insure that we'll get a path
				path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit( aiBrain, self, self.MovementLayer, platPos, transportLocation, mythreat * 3, markerradius )
			end
			-- engineer teleportation
			if engineer and engineer:HasEnhancement('Teleporter') then
				path = {transportLocation}
				distance = 1
				IssueTeleport( {engineer}, transportLocation )
			end

			-- if there is no path try transport call
			if (not path) and PlatoonExists(aiBrain, self) then
				local usedTransports = false
				-- try to use transports --
				if (self.MovementLayer == 'Land' or self.MovementLayer == 'Amphibious') and not experimental then
					usedTransports = self:SendPlatoonWithTransportsNoCheckSE( aiBrain, transportLocation, 4, false )
				end
				-- if no transport reply resubmit LAND platoons, others will set a direct path
				if not usedTransports and PlatoonExists(aiBrain,self) then
					if self.MovementLayer == 'Land' then
                        --LOG("*AI DEBUG "..aiBrain.Nickname.." No path "..reason.." and no transport during RTB to "..repr(RTBLocation).." - reissuing RTB for "..repr(self.BuilderName).." lifetime stats "..repr( self:GetPlatoonLifetimeStats() ).." Creation Time was "..repr(self.CreationTime).." Currently "..repr(LOUDTIME()))
						coroutine.yield(35)
						return self:SetAIPlan('ReturnToBaseAI',aiBrain)
					else
                        self:Stop()
						LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.BuilderName).." No path - Moving directly to transportLocation "..repr(transportLocation).." in RTB - distance "..repr(math.sqrt(distance)))
						path = { transportLocation }
					end
				end
			end
			-- execute the path movement
			if path then
				if PlatoonExists(aiBrain, self) then
					self.MoveThread = self:ForkThread( self.MovePlatoon, path, 'GrowthFormation', false)
				end
			end
		else
			-- closer than 75 - move directly --
			if platPos and transportLocation then
                --self:Stop()
				self:MoveToLocation(transportLocation, true)
			end
		end
		--LOG("*AI DEBUG "..aiBrain.Nickname.." RTB "..repr(self.BuilderName).." Moving to transportLocation - distance "..repr(math.sqrt(distance)))
		
		-- At this point the platoon is on its way back to base (or may be there)
		local count = false
		local StuckCount = 0
		local nocmdactive = false	-- this will bypass the nocmdactive check the first time
        local timer = SorianEditTIME()
        local StartMoveTime = SorianEditFLOOR(timer)
		local calltransport = 3	-- make immediate call for transport --
		-- Monitor the platoons distance to the base watching for death, stuck or idle, and checking for transports
        while (not count) and PlatoonExists(aiBrain, self) and distance > (60*60) do
			--LOG("*AI DEBUG "..aiBrain.Nickname.." RTB "..repr(self.BuilderName).." watching travel - RTBLocation is "..repr(RTBLocation).." distance is "..repr(math.sqrt(distance)))
			-- check units for idle or stuck --
            for _,v in GetPlatoonUnits(self) do
				if not v.Dead then
					if nocmdactive then
						if SorianEditGETN(GetCommandQueue(v)) > 0 or (not v:IsIdleState()) then
							nocmdactive = false
						else
							--LOG("*AI DEBUG "..aiBrain.Nickname.." RTB "..self.BuilderName.." has "..LOUDGETN(GetCommandQueue(v)).." CMD queue - Idle State is "..repr(v:IsIdleState()))
						end
					end
					-- look for stuck units after 90 seconds
					if (SorianEditTIME() - StartMoveTime) > 90 then
						local unitpos = SorianEditCOPY(GetPosition(v))
						-- if the unit hasn't gotten within range of the platoon
						if VDist2Sq( platPos[1],platPos[3], unitpos[1],unitpos[3] ) > (80*80)  then
							if not SorianEditENTITY(categories.EXPERIMENTAL,v) then
								if not v.WasWarped then
									WARN("*AI DEBUG "..aiBrain.Nickname.." RTB "..self.BuilderName.." Unit warped in RTB to "..repr(platPos))
									Warp( v, platPos )
									IssueMove( {v}, RTBLocation)
									v.WasWarped = true
								else
									WARN("*AI DEBUG "..aiBrain.Nickname.." RTB "..self.BuilderName.." Unit at "..repr(unitpos).." from platoon at "..repr(platPos).." Killed in RTB")
									v:Kill()
								end
							end
						end
					end
				end
            end
			-- while moving - check distance and call for transport --
			if PlatoonExists(aiBrain, self) then
				-- get either a position or use the destination (trigger an end)
				platPos = SorianEditCOPY(GetPlatoonPosition(self) or RTBLocation)
				distance = VDist2Sq( platPos[1],platPos[3], RTBLocation[1],RTBLocation[3] )
				usedTransports = false
				-- call for transports for those platoons that need it -- standard or if stuck
				if (not experimental) and (self.MovementLayer == 'Land' or self.MovementLayer == 'Amphibious')  then
					if ( distance > (300*300) or StuckCount > 5 ) and platPos and transportLocation and PlatoonExists(aiBrain, self) then
						-- if calltransport counter is 3 check for transport and reset the counter
						-- thru this mechanism we only call for tranport every 4th loop (40 seconds)
						if calltransport > 2 then
							usedTransports = self:SendPlatoonWithTransportsNoCheckSE( aiBrain, transportLocation, 1, false )
							calltransport = 0
							-- if we used tranports we need to update position and distance
							if usedTransports then
								platPos = SorianEditCOPY(GetPlatoonPosition(self))
								distance = VDist2Sq( platPos[1],platPos[3], RTBLocation[1],RTBLocation[3] )
								usedTransports = false
							end
						else
							calltransport = calltransport + 1
						end
					end
				end
			end
			-- while moving - check for proximity to base (not transportlocation) --
			if PlatoonExists(aiBrain, self) and RTBLocation then
				-- proximity to base --
				if distance <= (75*75) then
					count = true -- we are near the base - trigger the end of the loop
                    break
				end
				-- proximity to transportlocation --
                if transportLocation and VDist2Sq( platPos[1],platPos[3], transportLocation[1],transportLocation[3]) < (35*35) then
                    count = true
                    break
                end
				
				-- if haven't moved much -- 
				if not count and ( lastpos and VDist2Sq( lastpos[1],lastpos[3], platPos[1],platPos[3] ) < 0.15 ) then
					StuckCount = StuckCount + 1
				else
					lastpos = SorianEditCOPY(platPos)
					StuckCount = 0
				end
			end
			-- if platoon idle or base is now inactive -- resubmit platoon if not dead --
			if PlatoonExists(aiBrain, self) and (StuckCount > 10 or nocmdactive or (not aiBrain.BuilderManagers[bestBaseName])) then
				if self.MoveThread then
					self:KillMoveThread()
				end
				
				local platooncount = 0
				-- count units and clear out dead
				for k,v in GetPlatoonUnits(self) do
					if not v.Dead then
						platooncount = platooncount + 1
					end
				end
				-- dead platoon
                if platooncount == 0 then
                	return
                end                
                
				-- if there is only one unit -- just move it - otherwise resubmit to RTB
                if platooncount == 1 and aiBrain.BuilderManagers[bestBaseName] then
                    IssueMove( GetPlatoonUnits(self), RTBLocation)
                    StuckCount = 0
                    count = false
				else
					local units = GetPlatoonUnits(self)
                	IssueClearCommands( units )
                    local ident = Random(1,999999)
					returnpool = aiBrain:MakePlatoon('ReturnToBase '..tostring(ident), 'none' )
                    returnpool.PlanName = 'ReturnToBaseAI'
                    returnpool.BuilderName = 'RTBStuck'
                    returnpool.BuilderLocation = self.LocationType or false
					returnpool.RTBLocation = self.RTBLocation or false
					returnpool.MovementLayer = self.MovementLayer
					
					--LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.BuilderName).." "..repr(nocmdactive).." "..repr(StuckCount).." from "..repr(self.BuilderLocation).." at "..repr(GetPlatoonPosition(returnpool)).." Stuck in RTB to "..repr(self.BuilderLocation).." "..math.sqrt(distance))					
					for _,u in units do
						if not u.Dead then
							if math.sqrt(distance) > 150 then
								AssignUnitsToPlatoon( aiBrain, returnpool, {u}, 'Unassigned', 'None' )
								u.PlatoonHandle = {returnpool}
								u.PlatoonHandle.PlanName = 'ReturnToBaseAI'
							else
								IssueMove( {u}, RTBLocation )
							end
						end
					end
					
					if not returnpool.BuilderLocation then
						GetMostRestrictiveLayer(returnpool)
						if returnpool.MovementLayer == "Land" then
							-- dont use naval bases for land --
							returnpool.BuilderLocation = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(returnpool), false )
						else
							if returnpool.MovementLayer == "Air" or returnpool.PlatoonLayer == "Amphibious" then
								-- use any kind of base --
								returnpool.BuilderLocation = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(returnpool), true, false )
							else
								-- use only naval bases --
								returnpool.BuilderLocation = AIFindClosestBuilderManagerName( aiBrain, GetPlatoonPosition(returnpool), true, true )
							end
						end
						returnpool.RTBLocation = returnpool.BuilderLocation	-- this should insure the RTB to a particular base
						--LOG("*AI DEBUG "..aiBrain.Nickname.." Platoon "..repr(returnpool.BuilderName).." submitted to "..repr(returnpool.BuilderLocation))
					end
                    count = true -- signal the end of the primary loop
					-- send the new platoon off to RTB
					returnpool:SetAIPlan('ReturnToBaseAI', aiBrain)
					coroutine.yield(2)
					break
				end
			end
			nocmdactive = true	-- this will trigger the nocmdactive check on the next pass
			coroutine.yield(55)
        end
        
		if PlatoonExists(aiBrain, self) then
			if self.MoveThread then
				self:KillMoveThread()
			end
			-- all units are spread out to the rally points except engineers (we want them back to work ASAP)
			if not engineer then
				import('/lua/AI/SorianEditutilities.lua').DisperseUnitsToRallyPoints( aiBrain, GetPlatoonUnits(self), RTBLocation, aiBrain.BuilderManagers[bestBaseName].RallyPoints or false )
			else
				-- without this, engineers will continue right to the heart of the base
				self:Stop()
			end
			self:PlatoonDisband(aiBrain)
		end
    end,

    PlatoonGenerateSafePathToSorianEdit = function( aiBrain, platoon, platoonLayer, start, destination, threatallowed, MaxMarkerDist)
		local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
		local GetThreatBetweenPositions = moho.aibrain_methods.GetThreatBetweenPositions
		local VDist2Sq = VDist2Sq
		local VDist2 = VDist2
		-- types of threat to look at based on composition of platoon
		local ThreatTable = { Land = 'AntiSurface', Water = 'AntiSurface', Amphibious = 'AntiSurface', Air = 'AntiAir', }
		local threattype = ThreatTable[platoonLayer]
		-- threatallowed controls how much threat is considered acceptable at any point
		local threatallowed = threatallowed or 5
		-- step size is used when making DestinationBetweenPoints checks
		-- the value of 70 is relatively safe to use to avoid intervening terrain issues
		local stepsize = 100
		-- air platoons can look much further off the line since they generally ignore terrain anyway
		-- this larger step makes looking for destination much less costly in processing
		if platoonLayer == 'Air' then
			stepsize = 240
		end
		
		if start and destination then
			local distance = VDist2( start[1],start[3], destination[1],destination[3] )
			if distance <= stepsize then
				return {destination}, 'Direct', distance
			elseif platoonLayer == 'Amphibious' then
				stepsize = 125
				if distance <= stepsize then
					return {destination}, 'Direct', distance
				end
			elseif platoonLayer == 'Water' then
				stepsize = 175
				if distance <= stepsize then
					return {destination}, 'Direct', distance
				end
			elseif platoonLayer == 'Air' then
				stepsize = 250
				if distance <= stepsize or GetThreatBetweenPositions( aiBrain, start, destination, nil, threattype) < threatallowed then
					return {destination}, 'Direct', distance
				end
			end
		else
			if not destination then
				LOG("*AI DEBUG "..aiBrain.Nickname.." Generate Safe Path "..platoonLayer.." had a bad destination "..repr(destination))
				return false, 'Badlocations', 0
			else
				LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(platoon.BuilderName).." Generate Safe Path "..platoonLayer.." had a bad start "..repr(start))
				return {destination}, 'Direct', 9999
			end
		end
		-- MaxMarkerDist controls the range we look for markers AND the range we use when making threat checks
		local MaxMarkerDist = MaxMarkerDist or 160
		local radiuscheck = MaxMarkerDist * MaxMarkerDist
		local threatradius = MaxMarkerDist * .33
		local stepcheck = stepsize * stepsize
		-- get all the layer markers -- table format has 5 values (posX,posY,posZ, nodeName, graph)
		local markerlist = ScenarioInfo.PathGraphs['RawPaths'][platoonLayer] or false
		
		--** A Whole set of localized function **--
		-------------------------------------------
		
		local AIGetThreatLevelsAroundPoint = function( position, threatradius )
			if threattype == 'AntiAir' then
				return aiBrain:GetThreatAtPosition( position, 0, true, 'AntiAir')	--airthreat
			elseif threattype == 'AntiSurface' then
				return aiBrain:GetThreatAtPosition( position, 0, true, 'AntiSurface')	--surthreat
			elseif threattype == 'AntiSub' then
				return aiBrain:GetThreatAtPosition( position, 0, true, 'AntiSub')	--subthreat
			elseif threattype == 'Economy' then
				return aiBrain:GetThreatAtPosition( position, 0, true, 'Economy')	--ecothreat
			else
				return aiBrain:GetThreatAtPosition( position, 0, true, 'Overall')	--airthreat + ecothreat + surthreat + subthreat
			end
		end

		-- checks if destination is somewhere between two points
		local DestinationBetweenPoints = function( destination, start, finish )
			-- using the distance between two nodes
			-- calc how many steps there will be in the line
			local steps = SorianEditFLOOR( VDist2(start[1], start[3], finish[1], finish[3]) / stepsize )
			if steps > 0 then
				-- and the size of each step
				local xstep = (start[1] - finish[1]) / steps
				local ystep = (start[3] - finish[3]) / steps
				-- check the steps from start to one less than then destination
				for i = 1, steps - 1 do
					-- if we're within the stepcheck ogrids of the destination then we found it
					if VDist2Sq(start[1] - (xstep * i), start[3] - (ystep * i), destination[1], destination[3]) < stepcheck then
						return true
						
					end
				end	
			end
			return false
		end
		-- this function will return a 3D position and a named marker
		local GetClosestSafePathNodeInRadiusByLayer = function( location, seeksafest, goalseek, threatmodifier )
			if markerlist then
				local positions = {}
				local counter = 0
				local VDist3Sq = VDist3Sq
				-- sort the table by closest to the given location
				SorianEditSORT(markerlist, function(a,b) return VDist3Sq( a.position, location ) < VDist3Sq( b.position, location ) end)
				-- traverse the list and make a new list of those with allowable threat and within range
				-- since the source table is already sorted by range, the output table will be created in a sorted order
				for nodename,v in markerlist do
					-- process only those entries within the radius
					if VDist3Sq( v.position, location ) <= radiuscheck then
						-- add only those with acceptable threat to the new list
						-- if seeksafest or goalseek flag is set we'll build a table of points with allowable threats
						-- otherwise we'll just take the closest one
						if AIGetThreatLevelsAroundPoint( v.position, threatradius) <= (threatallowed * threatmodifier) then
							if seeksafest or goalseek then
								positions[counter+1] = { AIGetThreatLevelsAroundPoint( v.position, threatradius), v.node, v.position }
								counter = counter + 1
							else
								return ScenarioInfo.PathGraphs[platoonLayer][v.node], v.node or GetPathGraphs()[platoonLayer][v.node], v.node
							end
						end
					end
				end
				-- resort positions to be closest to goalseek position
				-- just a note here -- the goalseek position is often sent WITHOUT a vertical indication so I had to use VDIST2 rather than VDIST 3 to be sure
				if goalseek then
					SorianEditSORT(positions, function(a,b) return VDist2Sq( a[3][1],a[3][3], goalseek[1],goalseek[3] ) < VDist2Sq( b[3][1],b[3][3], goalseek[1],goalseek[3] ) end)
				end
				--LOG("*AI DEBUG Sorted positions for destination "..repr(goalseek).." are "..repr(positions))
				local bestThreat = (threatallowed * threatmodifier)
				local bestMarker = positions[1][2]	-- defalut to the one closest to goal 	--false
				-- loop thru to find one with lowest threat	-- if all threats are equal we'll end up with the closest
				if seeksafest then
					for _,v in positions do
						if v[1] < bestThreat then
							bestThreat = v[1]
							bestMarker = v[2]
						end
					end
				end
				if bestMarker then
					return ScenarioInfo.PathGraphs[platoonLayer][bestMarker],bestMarker or GetPathGraphs()[platoonLayer][bestMarker],bestMarker
				end
			end
			return false, false
		end	

		local AddBadPath = function( layer, startnode, endnode )
			if not ScenarioInfo.BadPaths[layer][startnode] then
				ScenarioInfo.BadPaths[layer][startnode] = {}
			end

			if not ScenarioInfo.BadPaths[layer][startnode][endnode] then
				ScenarioInfo.BadPaths[layer][startnode][endnode] = {}
				if not ScenarioInfo.BadPaths[layer][endnode] then
					ScenarioInfo.BadPaths[layer][endnode] = {}
				end
				ScenarioInfo.BadPaths[layer][endnode][startnode] = {}
			end
		end
		-- this flag is set but passed into the path generator
		-- was originally used to allow the path generator to 'cut corners' on final step
		local testPath = true
		
		if platoonLayer == 'Air' or platoonLayer == 'Amphibious' then
			testPath = true
		end
		-- Get the closest safe node at platoon position which is closest to the destination
		local startNode, startNodeName = GetClosestSafePathNodeInRadiusByLayer( start, false, destination, 2 )

		if not startNode and platoonLayer == 'Amphibious' then
			--LOG("*AI DEBUG "..aiBrain.Nickname.." GenerateSafePath "..platoon.BuilderName.." "..threatallowed.." fails no safe "..platoonLayer.." startnode within "..MaxMarkerDist.." of "..repr(start).." - trying Land")
			platoonLayer = 'Land'
			startNode, startNodeName = GetClosestSafePathNodeInRadiusByLayer( start, false, destination, 2 )
		end
	
		if not startNode then
			--LOG("*AI DEBUG "..aiBrain.Nickname.." GenerateSafePath "..repr(platoon.BuilderName).." "..threatallowed.." finds no safe "..platoonLayer.." startnode within "..MaxMarkerDist.." of "..repr(start).." - failing")
			coroutine.yield(1)
			return false, 'NoPath'
		end
		
		if DestinationBetweenPoints( destination, start, startNode.position ) then
			--LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(platoon.BuilderName).." finds destination between current position and startNode")
			return {destination}, 'Direct', 0.9
		end
    
		-- Get the closest safe node at the destination which is cloest to the start
		local endNode, endNodeName = GetClosestSafePathNodeInRadiusByLayer( destination, true, false, 1 )
		if not endNode then
			--LOG("*AI DEBUG "..aiBrain.Nickname.." GenerateSafePath "..repr(platoon.BuilderName).." "..threatallowed.." finds no safe "..platoonLayer.." endnode within "..MaxMarkerDist.." of "..repr(destination).." - failing")
			coroutine.yield(1)
			return false, 'NoPath'
		end
		
		if startNodeName == endNodeName then
			--LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(platoon.BuilderName).." GenerateSafePath has same start and end node "..repr(startNodeName))
			return {destination}, 'Direct', 1
		end
		
		local path = false
		local pathlength = VDist2(start[1],start[3],startNode.position[1],startNode.position[3])
		local BadPath = ScenarioInfo.BadPaths[platoonLayer]
		-- if the nodes are not in the bad path cache generate a path for them
		-- Generate the safest path between the start and destination nodes
		if not BadPath[startNodeName][endNodeName] then
			-- add the platoons request for a path to the respective path generator for that layer
			SorianEditINSERT(aiBrain.PathRequests[platoonLayer], {
															Dest = destination,
															EndNode = endNode,
															Location = start,
															Platoon = platoon, 
															StartNode = startNode,
															Stepsize = stepsize,
															Testpath = testPath,
															ThreatLayer = threattype,
															ThreatWeight = threatallowed,
			} )

			aiBrain.PathRequests['Replies'][platoon] = false
            local Replies = aiBrain.PathRequests['Replies']
			local waitcount = 1
			-- loop here until reply or 90 seconds
			while waitcount < 100 do
				coroutine.yield(3)
				waitcount = waitcount + 1
				if Replies[platoon].path then
					break
				end
			end
		
			if waitcount < 100 then
				path = Replies[platoon].path
				pathlength = pathlength + Replies[platoon].length
			else
				Replies[platoon] = false
				return false, 'NoResponse',0
			end
			Replies[platoon] = false
		end

		if not path or path == 'NoPath' then
			-- if no path can be found (versus too much threat or no reply) then add to badpath cache
			if path == 'NoPath' and not BadPath[startNodeName][endNodeName] then
				ForkTo(AddBadPath, platoonLayer, startNodeName, endNodeName )
			end
			return false, 'NoPath', 0
		end
		path[table.getn(path)+1] = destination
		return path, 'Pathing', pathlength
	end,

	--  Function: MergeIntoNearbyPlatoons
	--  This is a variation of the MergeWithNearbyPlatoons 
	--	this one will 'insert' units into another platoon.
	--  used when a depleted platoon would otherwise retreat
    MergeIntoNearbyPlatoons = function( self, aiBrain, planName, radius, planmatchrequired, mergelimit )
        if self.UsingTransport then 
            return false
        end
		if not PlatoonExists(aiBrain,self) then
			return false
		end
        local platPos = GetPlatoonPosition(self) or false
		if not platPos then
			return false
		end
        local radiusSq = radius*radius
        for _, base in aiBrain.BuilderManagers do
            if VDist2Sq( platPos[1],platPos[3], base.Position[1],base.Position[3] ) <= ( radiusSq / 2 ) then
                return false
            end 
        end
        -- get all the platoons
		local GetPlatoonsList = moho.aibrain_methods.GetPlatoonsList
        local AlliedPlatoons = GetPlatoonsList(aiBrain)
		SorianEditSORT(AlliedPlatoons, function(a,b) return VDist2Sq(GetPlatoonPosition(a)[1],GetPlatoonPosition(a)[3], platPos[1],platPos[3]) < VDist2Sq(GetPlatoonPosition(b)[1],GetPlatoonPosition(b)[3], platPos[1],platPos[3]) end)
        for _,aPlat in AlliedPlatoons do
            if aPlat == self then
                continue
            end
			if VDist2Sq(platPos[1],platPos[3], GetPlatoonPosition(aPlat)[1],GetPlatoonPosition(aPlat)[3]) > radiusSq then
				break
			end
            if aPlat.UsingTransport then
                continue
            end
			if planmatchrequired and aPlat.BuilderName != self.BuilderName then
				continue
			end
            if aPlat.PlanName != planName then
                continue
            end
            if self.MovementLayer != aPlat.MovementLayer then
                continue
            end
			
            local validUnits = {}
			local counter = 0
			local units = GetPlatoonUnits(self)
			
			for _,u in units do
                if (not u.Dead) and (not u:IsUnitState( 'Attached' )) then
                    validUnits[counter+1] = u
					counter = counter + 1
                end
            end
			
            if counter > 0 then
				if ScenarioInfo.PlatoonMergeDialog then
					LOG("*AI DEBUG "..aiBrain.Nickname.." "..repr(self.BuilderName).." with "..counter.." units MERGE_INTO "..repr(aPlat.BuilderName))
				end
				AssignUnitsToPlatoon( aiBrain, aPlat, validUnits, 'Attack', 'GrowthFormation' )
				IssueMove( validUnits, aPlat:GetPlatoonPosition() )
				return true
			end
        end
		return false
    end,

    GuardMarkerSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local platLoc = self:GetPlatoonPosition()
        if not aiBrain:PlatoonExists(self) or not platLoc then
            return
        end

        -----------------------------------------------------------------------
        -- Platoon Data
        -----------------------------------------------------------------------
        -- type of marker to guard
        -- Start location = 'Start Location'... see MarkerTemplates.lua for other types
        local markerType = self.PlatoonData.MarkerType or 'Expansion Area'
        -- what should we look for for the first marker?  This can be 'Random',
        -- 'Threat' or 'Closest'
        local moveFirst = self.PlatoonData.MoveFirst or 'Threat'
        -- should our next move be no move be (same options as before) as well as 'None'
        -- which will cause the platoon to guard the first location they get to
        local moveNext = self.PlatoonData.MoveNext or 'None'
        -- Minimum distance when looking for closest
        local avoidClosestRadius = self.PlatoonData.AvoidClosestRadius or 0
        -- set time to wait when guarding a location with moveNext = 'None'
        local guardTimer = self.PlatoonData.GuardTimer or 0
        -- threat type to look at
        local threatType = self.PlatoonData.ThreatType or 'AntiSurface'
        -- should we look at our own threat or the enemy's
        local bSelfThreat = self.PlatoonData.SelfThreat or false
        -- if true, look to guard highest threat, otherwise,
        -- guard the lowest threat specified
        local bFindHighestThreat = self.PlatoonData.FindHighestThreat or false
        -- minimum threat to look for
        local minThreatThreshold = self.PlatoonData.MinThreatThreshold or -1
        -- maximum threat to look for
        local maxThreatThreshold = self.PlatoonData.MaxThreatThreshold  or 99999999
        -- Avoid bases (true or false)
        local bAvoidBases = self.PlatoonData.AvoidBases or false
        -- Radius around which to avoid the main base
        local avoidBasesRadius = self.PlatoonData.AvoidBasesRadius or 0
        -- Use Aggresive Moves Only
        local bAggroMove = self.PlatoonData.AggressiveMove or false
        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'
        -----------------------------------------------------------------------
        AIAttackUtils.GetMostRestrictiveLayer(self)
        self:SetPlatoonFormationOverride(PlatoonFormation)
        local markerLocations = AIUtils.AIGetMarkerLocations(aiBrain, markerType)

        local bestMarker = false

        if not self.LastMarker then
            self.LastMarker = {nil,nil}
        end

        -- look for a random marker
        if moveFirst == 'Random' then
            if table.getn(markerLocations) <= 2 then
                self.LastMarker[1] = nil
                self.LastMarker[2] = nil
            end
            for _,marker in RandomIter(markerLocations) do
                if table.getn(markerLocations) <= 2 then
                    self.LastMarker[1] = nil
                    self.LastMarker[2] = nil
                end
                if self:AvoidsBasesSorian(marker.Position, bAvoidBases, avoidBasesRadius) then
                    if self.LastMarker[1] and marker.Position[1] == self.LastMarker[1][1] and marker.Position[3] == self.LastMarker[1][3] then
                        continue
                    end
                    if self.LastMarker[2] and marker.Position[1] == self.LastMarker[2][1] and marker.Position[3] == self.LastMarker[2][3] then
                        continue
                    end
                    bestMarker = marker
                    break
                end
            end
        elseif moveFirst == 'Threat' then
            --Guard the closest least-defended marker
            local bestMarkerThreat = 0
            if not bFindHighestThreat then
                bestMarkerThreat = 99999999
            end

            local bestDistSq = 99999999


            -- find best threat at the closest distance
            for _,marker in markerLocations do
                local markerThreat
                local enemyThreat
                markerThreat = aiBrain:GetThreatAtPosition(marker.Position, 0, true, 'Economy', enemyIndex)
                enemyThreat = aiBrain:GetThreatAtPosition(marker.Position, 1, true, 'AntiSurface', enemyIndex)
                --LOG('Best pre calculation marker threat is '..markerThreat..' at position'..repr(marker.Position))
                --LOG('Surface Threat at marker is '..enemyThreat..' at position'..repr(marker.Position))
                if enemyThreat > 1 and markerThreat then
                    markerThreat = markerThreat / enemyThreat
                end
                --LOG('Best marker threat is '..markerThreat..' at position'..repr(marker.Position))
                local distSq = VDist2Sq(marker.Position[1], marker.Position[3], platLoc[1], platLoc[3])
    
                if markerThreat >= minThreatThreshold and markerThreat <= maxThreatThreshold then
                    if self:AvoidsBases(marker.Position, bAvoidBases, avoidBasesRadius) then
                        if self.IsBetterThreat(bFindHighestThreat, markerThreat, bestMarkerThreat) then
                            bestDistSq = distSq
                            bestMarker = marker
                            bestMarkerThreat = markerThreat
                        elseif markerThreat == bestMarkerThreat then
                            if distSq < bestDistSq then
                                bestDistSq = distSq
                                bestMarker = marker
                                bestMarkerThreat = markerThreat
                            end
                        end
                    end
                end
            end

        else
            -- if we didn't want random or threat, assume closest (but avoid ping-ponging)
            local bestDistSq = 99999999
            if table.getn(markerLocations) <= 2 then
                self.LastMarker[1] = nil
                self.LastMarker[2] = nil
            end
            for _,marker in markerLocations do
                local distSq = VDist2Sq(marker.Position[1], marker.Position[3], platLoc[1], platLoc[3])
                if self:AvoidsBasesSorian(marker.Position, bAvoidBases, avoidBasesRadius) and distSq > (avoidClosestRadius * avoidClosestRadius) then
                    if distSq < bestDistSq then
                        if self.LastMarker[1] and marker.Position[1] == self.LastMarker[1][1] and marker.Position[3] == self.LastMarker[1][3] then
                            continue
                        end
                        if self.LastMarker[2] and marker.Position[1] == self.LastMarker[2][1] and marker.Position[3] == self.LastMarker[2][3] then
                            continue
                        end
                        bestDistSq = distSq
                        bestMarker = marker
                    end
                end
            end
        end

        -- did we find a threat?
        local usedTransports = false
        if bestMarker then
            self.LastMarker[2] = self.LastMarker[1]
            self.LastMarker[1] = bestMarker.Position
            --LOG("GuardMarker: Attacking " .. bestMarker.Name)
            local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer, self:GetPlatoonPosition(), bestMarker.Position, 200)
            --local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingExSE(self, bestMarker.Position)
            IssueClearCommands(self:GetPlatoonUnits())
            if path then
                local position = self:GetPlatoonPosition()
                if VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 512 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsSorian(aiBrain, self, bestMarker.Position, true, false, false)
                elseif VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 256 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsSorian(aiBrain, self, bestMarker.Position, false, false, false)
                end
                if not usedTransports then
                    local pathLength = table.getn(path)
                    for i=1, pathLength-1 do
                        if bAggroMove then
                            self:AggressiveMoveToLocation(path[i])
                        else
                            self:MoveToLocation(path[i], false)
                        end
                    end
                end
            elseif (not path and reason == 'NoPath') then
                usedTransports = AIAttackUtils.SendPlatoonWithTransportsSorian(aiBrain, self, bestMarker.Position, true, false, true)
            else
                self:PlatoonDisband()
                return
            end

            if not path and not usedTransports then
                self:PlatoonDisband()
                return
            end

            if moveNext == 'None' then
                -- guard
                IssueGuard(self:GetPlatoonUnits(), bestMarker.Position)
                -- guard forever
                if guardTimer <= 0 then return end
            else
                -- otherwise, we're moving to the location
                self:AggressiveMoveToLocation(bestMarker.Position)
            end

            -- wait till we get there
            local oldPlatPos = self:GetPlatoonPosition()
            local StuckCount = 0
            repeat
                WaitSeconds(5)
                platLoc = self:GetPlatoonPosition()
                if VDist3(oldPlatPos, platLoc) < 1 then
                    StuckCount = StuckCount + 1
                else
                    StuckCount = 0
                end
                if StuckCount > 5 then
                    return self:GuardMarkerSorianEdit()
                end
                oldPlatPos = platLoc
            until VDist2Sq(platLoc[1], platLoc[3], bestMarker.Position[1], bestMarker.Position[3]) < 64 or not aiBrain:PlatoonExists(self)

            -- if we're supposed to guard for some time
            if moveNext == 'None' then
                -- this won't be 0... see above
                WaitSeconds(guardTimer)
                self:PlatoonDisband()
                return
            end

            if moveNext == 'Guard Base' then
                return self:GuardBaseSorianEdit()
            end

            -- we're there... wait here until we're done
            local numGround = aiBrain:GetNumUnitsAroundPoint((categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            while numGround > 0 and aiBrain:PlatoonExists(self) do
                WaitSeconds(Random(5,10))
                numGround = aiBrain:GetNumUnitsAroundPoint((categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            end

            if not aiBrain:PlatoonExists(self) then
                return
            end

            -- set our MoveFirst to our MoveNext
            self.PlatoonData.MoveFirst = moveNext
            return self:GuardMarkerSorianEdit()
        else
            -- no marker found, disband!
            self:PlatoonDisband()
        end
    end,

    GuardBaseSorianEdit = function(self)
        self:Stop()
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local target = false
        local basePosition = false
        AIAttackUtils.GetMostRestrictiveLayer(self)

        if self.PlatoonData.LocationType and self.PlatoonData.LocationType != 'NOTMAIN' then
            basePosition = aiBrain.BuilderManagers[self.PlatoonData.LocationType].Position
        else
            local platoonPosition = GetPlatoonPosition(self)
            if platoonPosition then
                basePosition = aiBrain:FindClosestBuilderManagerPosition(GetPlatoonPosition(self))
            end
        end

        if not basePosition then
            return
        end

        --DUNCAN - changed from 75, added home radius
        local guardRadius = self.PlatoonData.GuardRadius or 200
        local homeRadius = self.PlatoonData.HomeRadius or 200

        local guardType = self.PlatoonData.GuardType

        while aiBrain:PlatoonExists(self) do
            if self.MovementLayer == 'Air' then
                target = self:FindClosestUnit('Attack', 'Enemy', true, categories.MOBILE * categories.AIR - categories.WALL)
            else
                target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.WALL)
            end

            if target and not target.Dead and VDist3(target:GetPosition(), basePosition) < guardRadius then
                if guardType == 'AntiAir' then
                    self:Stop()
                    self:AggressiveMoveToLocation(target:GetPosition())
                elseif guardType == 'Bomber' then
                    self:Stop()
                    self:AttackTarget(target)
                else
                    self:Stop()
                    self:AggressiveMoveToLocation(target:GetPosition())
                end
            else
                return self:SimpleReturnToBaseSorianEdit(true)
                --local PlatoonPosition = GetPlatoonPosition(self)
                --if PlatoonPosition and VDist3(basePosition, PlatoonPosition) > homeRadius then
                    --DUNCAN - still try to move closer to the base if outside the radius
                    --local position = AIUtils.RandomLocation(basePosition[1],basePosition[3])
                    --self:Stop()
                    --self:MoveToLocation(position, false)
                --end
            end
            coroutine.yield(20)
        end
    end,

    AttackForceSorianEdit = function(self)
        self:Stop()
        local aiBrain = self:GetBrain()

        -- get units together
        if not self:GatherUnits() then
            return
        end

        -- Setup the formation based on platoon functionality

        local platoonUnits = GetPlatoonUnits(self)
        local numberOfUnitsInPlatoon = table.getn(platoonUnits)
        local oldNumberOfUnitsInPlatoon = numberOfUnitsInPlatoon
        local stuckCount = 0

        self.PlatoonAttackForce = true
        -- formations have penalty for taking time to form up... not worth it here
        -- maybe worth it if we micro
        --self:SetPlatoonFormationOverride('GrowthFormation')
        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'
        self:SetPlatoonFormationOverride(PlatoonFormation)
		
		local OriginalSurfaceThreat = self:CalculatePlatoonThreat('AntiSurface', categories.ALLUNITS)

        while aiBrain:PlatoonExists(self) do
            local pos = GetPlatoonPosition(self) -- update positions; prev position done at end of loop so not done first time

            -- if we can't get a position, then we must be dead
            if not pos then
                break
            end


            -- if we're using a transport, wait for a while
            if self.UsingTransport then
                coroutine.yield(100)
                continue
            end

            self.MergeWithNearbyPlatoonsSorianEdit( self, aiBrain, 'AttackForceSorianEdit', 30, false, 100)

            -- rebuild formation
            platoonUnits = GetPlatoonUnits(self)
            numberOfUnitsInPlatoon = table.getn(platoonUnits)
            -- if we have a different number of units in our platoon, regather
            if (oldNumberOfUnitsInPlatoon != numberOfUnitsInPlatoon) then
                self:StopAttack()
                self:SetPlatoonFormationOverride(PlatoonFormation)
            end
            oldNumberOfUnitsInPlatoon = numberOfUnitsInPlatoon

            -- deal with lost-puppy transports
            local strayTransports = {}
            for k,v in platoonUnits do
                if EntityCategoryContains(categories.TRANSPORTATION, v) then
                    table.insert(strayTransports, v)
                end
            end
            if table.getn(strayTransports) > 0 then
                local dropPoint = pos
                dropPoint[1] = dropPoint[1] + Random(-3, 3)
                dropPoint[3] = dropPoint[3] + Random(-3, 3)
                IssueTransportUnload(strayTransports, dropPoint)
                coroutine.yield(100)
                local strayTransports = {}
                for k,v in platoonUnits do
                    local parent = v:GetParent()
                    if parent and EntityCategoryContains(categories.TRANSPORTATION, parent) then
                        table.insert(strayTransports, parent)
                        break
                    end
                end
                if table.getn(strayTransports) > 0 then
                    local MAIN = aiBrain.BuilderManagers.MAIN
                    if MAIN then
                        dropPoint = MAIN.Position
                        IssueTransportUnload(strayTransports, dropPoint)
                        coroutine.yield(300)
                    end
                end
                self.UsingTransport = false
                AIUtils.ReturnTransportsToPoolSE(strayTransports, true)
                platoonUnits = GetPlatoonUnits(self)
            end


            --Disband platoon if it's all air units, so they can be picked up by another platoon
            local mySurfaceThreat = AIAttackUtils.GetSurfaceThreatOfUnits(self)
            if mySurfaceThreat == 0 and AIAttackUtils.GetAirThreatOfUnits(self) > 0 then
                self:PlatoonDisband()
                return
            end

            local cmdQ = {}
            -- fill cmdQ with current command queue for each unit
            for k,v in platoonUnits do
                if not v.Dead then
                    local unitCmdQ = v:GetCommandQueue()
                    for cmdIdx,cmdVal in unitCmdQ do
                        table.insert(cmdQ, cmdVal)
                        break
                    end
                end
            end

            -- if we're on our final push through to the destination, and we find a unit close to our destination
            local closestTarget = self:FindClosestUnit('attack', 'enemy', true, categories.ALLUNITS)
            local nearDest = false
            local oldPathSize = table.getn(self.LastAttackDestination)
            if self.LastAttackDestination then
                nearDest = oldPathSize == 0 or VDist3(self.LastAttackDestination[oldPathSize], pos) < 20
            end

            -- if we're near our destination and we have a unit closeby to kill, kill it
            if table.getn(cmdQ) <= 1 and closestTarget and VDist3(closestTarget:GetPosition(), pos) < 20 and nearDest then
                self:StopAttack()
                if PlatoonFormation != 'No Formation' then
                    IssueFormAttack(platoonUnits, closestTarget, PlatoonFormation, 0)
                else
                    IssueAttack(platoonUnits, closestTarget)
                end
                cmdQ = {1}
            -- if we have nothing to do, try finding something to do
            elseif table.getn(cmdQ) == 0 then
                self:StopAttack()
                cmdQ = AIAttackUtils.AIPlatoonSquadAttackVector(aiBrain, self)
                stuckCount = 0
            -- if we've been stuck and unable to reach next marker? Ignore nearby stuff and pick another target
            elseif self.LastPosition and VDist2Sq(self.LastPosition[1], self.LastPosition[3], pos[1], pos[3]) < (self.PlatoonData.StuckDistance or 16) then
                stuckCount = stuckCount + 1
                if stuckCount >= 2 then
                    self:StopAttack()
                    cmdQ = AIAttackUtils.AIPlatoonSquadAttackVector(aiBrain, self)
                    stuckCount = 0
                end
            else
                stuckCount = 0
            end

            self.LastPosition = pos

            if table.getn(cmdQ) == 0 then
                -- if we have a low threat value, then go and defend an engineer or a base
                if mySurfaceThreat < 4
                    and mySurfaceThreat > 0
                    and not self.PlatoonData.NeverGuard
                    and not (self.PlatoonData.NeverGuardEngineers and self.PlatoonData.NeverGuardBases)
                then
                    --LOG('*DEBUG: Trying to guard')
                    return self:GuardBase(self.AttackForceSorianEdit)
                end

                -- we have nothing to do, so find the nearest base and disband
                if not self.PlatoonData.NeverMerge then
                    return self:SimpleReturnToBaseSorianEdit()
                end
                coroutine.yield(50)
            else
                -- wait a little longer if we're stuck so that we have a better chance to move
                WaitSeconds(Random(5,11) + 2 * stuckCount)
            end
            coroutine.yield(1)
        end
    end,
	
    StrikeForceAIRNGSE = function(self)
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local data = self.PlatoonData
        local categoryList = {}
        local atkPri = {}
        local basePosition = false
        local platoonPosition
        local platoonLimit = self.PlatoonData.PlatoonLimit or 18
        local mergeRequired = false
        local platoonCount = 0
        local myThreat
        local unitPos
        local alpha
        local x
        local y
        local smartPos
        local platoonUnits = GetPlatoonUnits(self)
        local enemyRadius = 40
        local MaxPlatoonWeaponRange
        local target
        local acuTargeting = false
        local acuTargetIndex = {}
        local blip = false
        local maxRadius = data.SearchRadius or 50
        local movingToScout = false
        local mainBasePos = aiBrain.BuilderManagers['MAIN'].Position
        
        if platoonUnits > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    if EntityCategoryContains(categories.SCOUT, v) then
                        self.ScoutPresent = true
                    end
                    for _, weapon in ALLBPS[v.UnitId].Weapon or {} do
                        -- unit can have MaxWeaponRange entry from the last platoon
                        if not v.MaxWeaponRange or weapon.MaxRadius > v.MaxWeaponRange then
                            -- save the weaponrange 
                            v.MaxWeaponRange = weapon.MaxRadius * 0.9 -- maxrange minus 10%
                            -- save the weapon balistic arc, we need this later to check if terrain is blocking the weapon line of sight
                            if weapon.BallisticArc == 'RULEUBA_LowArc' then
                                v.WeaponArc = 'low'
                            elseif weapon.BallisticArc == 'RULEUBA_HighArc' then
                                v.WeaponArc = 'high'
                            else
                                v.WeaponArc = 'none'
                            end
                        end
                        if not MaxPlatoonWeaponRange or MaxPlatoonWeaponRange < v.MaxWeaponRange then
                            MaxPlatoonWeaponRange = v.MaxWeaponRange
                        end
                    end
                    if v:TestToggleCaps('RULEUTC_StealthToggle') then
                        v:SetScriptBit('RULEUTC_StealthToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_CloakToggle') then
                        v:SetScriptBit('RULEUTC_CloakToggle', false)
                    end
                    -- prevent units from reclaiming while attack moving
                    v:RemoveCommandCap('RULEUCC_Reclaim')
                    v:RemoveCommandCap('RULEUCC_Repair')
                    v.smartPos = {0,0,0}
                    if not v.MaxWeaponRange then
                        --WARN('Scanning: unit ['..repr(v.UnitId)..'] has no MaxWeaponRange - '..repr(self.BuilderName))
                    end
                end
            end
        end
        
        if data.TargetSearchPriorities then
            --LOG('TargetSearch present for '..self.BuilderName)
            for k,v in data.TargetSearchPriorities do
                RNGINSERT(atkPri, v)
            end
        else
            if data.PrioritizedCategories then
                for k,v in data.PrioritizedCategories do
                    RNGINSERT(atkPri, v)
                end
            end
        end
        if data.PrioritizedCategories then
            for k,v in data.PrioritizedCategories do
                RNGINSERT(categoryList, v)
            end
        end
        AIAttackUtils.GetMostRestrictiveLayer(self)
        
        -- Removing ALLUNITS so we rely on the builder config. Stops bombers trying to attack fighters.
        --RNGINSERT(atkPri, categories.ALLUNITS)
        --RNGINSERT(categoryList, categories.ALLUNITS)

        --LOG('Platoon is '..self.BuilderName..' table'..repr(categoryList))
        self:SetPrioritizedTargetList('Attack', categoryList)
        AIAttackUtils.GetMostRestrictiveLayer(self)

        if data.LocationType then
            basePosition = aiBrain.BuilderManagers[data.LocationType].Position
        end
        local myThreat = self:CalculatePlatoonThreat('AntiSurface', categories.ALLUNITS)
        --LOG('StrikeForceAI my threat is '..myThreat)
        --LOG('StrikeForceAI my movement layer is '..self.MovementLayer)
        if aiBrain.EnemyIntel.EnemyThreatCurrent.ACUGunUpgrades > 0 and myThreat > 0 and self.MovementLayer == 'Air' then
            for k, v in aiBrain.EnemyIntel.ACU do
                if v.OnField and v.Gun then
                    acuTargeting = true
                    RNGINSERT(acuTargetIndex, k)
                end
            end
        end
        while PlatoonExists(aiBrain, self) do
            if not target or target.Dead then
                if aiBrain:GetCurrentEnemy() and aiBrain:GetCurrentEnemy().Result == "defeat" then
                    aiBrain:PickEnemyLogicRNG()
                end
                -- if acuTargeting and not data.ACUOnField then
                    -- --LOG('GUN ACU OnField LOOKING FOR TARGET')
                    -- target = SUtils.AIFindACUTargetInRangeRNG(aiBrain, self, 'Attack', maxRadius, myThreat)
                -- end
                if not target and self.MovementLayer == 'Air' then
                    --LOG('Checking for possible acu snipe')
                    local enemyACUIndexes = {}
                    -- for k, v in aiBrain.EnemyIntel.ACU do
                        -- if v.Hp != 0 and v.LastSpotted != 0 then
                            -- --LOG('ACU has '..v.Hp..' last spotted at '..v.LastSpotted..' our threat is '..myThreat)
                            -- if ((v.Hp / 275) < myThreat or v.Hp < 2000) and ((GetGameTimeSeconds() - 120) < v.LastSpotted) then
                                -- --LOG('ACU Target valid, adding to index list')
                                -- RNGINSERT(enemyACUIndexes, k)
                            -- end
                        -- end
                    -- end
                    -- if RNGGETN(enemyACUIndexes) > 0 then
                        -- --LOG('There is an ACU that could be sniped, look for targets')
                        -- target = SUtils.AIFindACUTargetInRangeRNG(aiBrain, self, 'Attack', maxRadius, myThreat, enemyACUIndexes)
                        -- if target then
                            -- --LOG('ACU found that coule be sniped, set to target')
                        -- end
                    -- end
                    if not target and myThreat > 8 and data.UnitType != 'GUNSHIP' then
                        --LOG('Checking for director target')
                        target = aiBrain:CheckDirectorTargetAvailable('AntiAir', myThreat)
                        if target then
                            --LOG('Target ID is '..target.UnitId)
                        end
                    end
                end
                
                if not target then
                    --LOG('Standard Target search for strikeforce platoon ')
                    if data.ACUOnField then
                        --LOG('Platoon has ACUOnField data, searching for energy to kill')
                        target = SUtils.AIFindBrainTargetInRangeRNG(aiBrain, self, 'Attack', maxRadius, atkPri, false, myThreat, acuTargetIndex)
                    elseif data.Defensive then
                        target = SUtils.AIFindBrainTargetInRangeOrigRNG(aiBrain, basePosition, self, 'Attack', maxRadius , atkPri, aiBrain:GetCurrentEnemy())
                    elseif data.AvoidBases then
                        --LOG('Avoid Bases is set to true')
                        target = SUtils.AIFindBrainTargetInRangeRNG(aiBrain, self, 'Attack', maxRadius , atkPri, data.AvoidBases, myThreat)
                    else
                        local mult = { 1,10,25 }
                        for _,i in mult do
                            target = SUtils.AIFindBrainTargetInRangeRNG(aiBrain, self, 'Attack', maxRadius * i, atkPri, false, myThreat)
                            if target then
                                break
                            end
                            WaitTicks(10) --DUNCAN - was 3
                            if not PlatoonExists(aiBrain, self) then
                                return
                            end
                        end
                    end
                end
                
                -- Check for experimentals but don't attack if they have strong antiair threat unless close to base.
                local newtarget
                if AIAttackUtils.GetSurfaceThreatOfUnits(self) > 0 then
                    newtarget = self:FindClosestUnit('Attack', 'Enemy', true, categories.EXPERIMENTAL * (categories.LAND + categories.NAVAL + categories.STRUCTURE))
                elseif AIAttackUtils.GetAirThreatOfUnits(self) > 0 then
                    newtarget = self:FindClosestUnit('Attack', 'Enemy', true, categories.EXPERIMENTAL * categories.AIR)
                end

                if newtarget then
                    local targetExpPos
                    local targetExpThreat
                    if self.MovementLayer == 'Air' then
                        targetExpPos = newtarget:GetPosition()
                        targetExpThreat = GetThreatAtPosition(aiBrain, targetExpPos, aiBrain.BrainIntel.IMAPConfig.Rings, true, 'AntiAir')
                        --LOG('Target Air Threat is '..targetExpThreat)
                        --LOG('My Air Threat is '..myThreat)
                        if myThreat > targetExpThreat then
                            target = newtarget
                        elseif VDist2Sq(targetExpPos[1], targetExpPos[3], mainBasePos[1], mainBasePos[3]) < 22500 then
                            target = newtarget
                        end
                    else
                        target = newtarget
                    end
                end

                if not target and platoonCount < platoonLimit then
                    --LOG('StrikeForceAI mergeRequired set true')
                    mergeRequired = true
                end

                if target and not target.Dead then
                    if self.MovementLayer == 'Air' then
                        local targetPosition = target:GetPosition()
                        platoonPosition = GetPlatoonPosition(self)
                        platoonCount = RNGGETN(GetPlatoonUnits(self))
                        local targetDistance = VDist2Sq(platoonPosition[1], platoonPosition[3], targetPosition[1], targetPosition[3])
                        local path = false
                        if targetDistance < 10000 then
                            self:Stop()
                            self:AttackTarget(target)
                        else
                            local path, reason, totalThreat = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer, platoonPosition, targetPosition, 10 , 10000)
                            self:Stop()
                            if path then
                                local pathLength = RNGGETN(path)
                                if not totalThreat then
                                    totalThreat = 1
                                end
                                --LOG('Total Threat for air is '..totalThreat)
                                local averageThreat = totalThreat / pathLength
                                local pathDistance
                                --LOG('StrikeForceAI average path threat is '..averageThreat)
                                --LOG('StrikeForceAI platoon threat is '..myThreat)
                                if averageThreat < myThreat or platoonCount >= platoonLimit then
                                    --LOG('StrikeForce air assigning path')
                                    for i=1, pathLength do
                                        self:MoveToLocation(path[i], false)
                                        while PlatoonExists(aiBrain, self) do
                                            platoonPosition = GetPlatoonPosition(self)
                                            targetPosition = target:GetPosition()
                                            targetDistance = VDist2Sq(platoonPosition[1], platoonPosition[3], targetPosition[1], targetPosition[3])
                                            if targetDistance < 10000 then
                                                --LOG('strikeforce air attack command on target')
                                                self:Stop()
                                                self:AttackTarget(target)
                                                break
                                            end
                                            pathDistance = VDist2Sq(path[i][1], path[i][3], platoonPosition[1], platoonPosition[3])
                                            if pathDistance < 900 then
                                                -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                                                self:Stop()
                                                break
                                            end
                                            --LOG('Waiting to reach target loop')
                                            WaitTicks(10)
                                        end
                                        if not target or target.Dead then
                                            target = false
                                            --LOG('Target dead or lost during strikeforce')
                                            break
                                        end
                                    end
                                else
                                    --LOG('StrikeForceAI Path threat is too high, waiting and merging')
                                    mergeRequired = true
                                    target = false
                                    WaitTicks(30)
                                end
                            else
                                self:AttackTarget(target)
                            end
                        end
                    else
                        self:AttackTarget(target)
                        while PlatoonExists(aiBrain, self) do
                            if data.AggressiveMove then
                                SquadPosition = self:GetSquadPosition('Attack') or nil
                                if not SquadPosition then break end
                                local enemyUnitCount = GetNumUnitsAroundPoint(aiBrain, categories.MOBILE * categories.LAND - categories.SCOUT - categories.ENGINEER, SquadPosition, enemyRadius, 'Enemy')
                                if enemyUnitCount > 0 then
                                    --LOG('Strikeforce land detected close target starting micro')
                                    target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.NAVAL - categories.AIR - categories.SCOUT - categories.WALL)
                                    local attackSquad = self:GetSquadUnits('Attack')
                                    IssueClearCommands(attackSquad)
                                    while PlatoonExists(aiBrain, self) do
                                        if target and not target.Dead then
                                            local targetPosition = target:GetPosition()
                                            local microCap = 50
                                            for _, unit in attackSquad do
                                                microCap = microCap - 1
                                                if microCap <= 0 then break end
                                                if unit.Dead then continue end
                                                if not unit.MaxWeaponRange then
                                                    continue
                                                end
                                                unitPos = unit:GetPosition()
                                                alpha = math.atan2 (targetPosition[3] - unitPos[3] ,targetPosition[1] - unitPos[1])
                                                x = targetPosition[1] - math.cos(alpha) * (unit.MaxWeaponRange or MaxPlatoonWeaponRange)
                                                y = targetPosition[3] - math.sin(alpha) * (unit.MaxWeaponRange or MaxPlatoonWeaponRange)
                                                smartPos = { x, GetTerrainHeight( x, y), y }
                                                -- check if the move position is new or target has moved
                                                if VDist2( smartPos[1], smartPos[3], unit.smartPos[1], unit.smartPos[3] ) > 0.7 or unit.TargetPos ~= targetPosition then
                                                    -- clear move commands if we have queued more than 4
                                                    if RNGGETN(unit:GetCommandQueue()) > 2 then
                                                        IssueClearCommands({unit})
                                                        coroutine.yield(3)
                                                    end
                                                    -- if our target is dead, jump out of the "for _, unit in self:GetPlatoonUnits() do" loop
                                                    IssueMove({unit}, smartPos )
                                                    if target.Dead then break end
                                                    IssueAttack({unit}, target)
                                                    --unit:SetCustomName('Fight micro moving')
                                                    unit.smartPos = smartPos
                                                    unit.TargetPos = targetPosition
                                                -- in case we don't move, check if we can fire at the target
                                                else
                                                    local dist = VDist2( unit.smartPos[1], unit.smartPos[3], unit.TargetPos[1], unit.TargetPos[3] )
                                                    if targetPosition and aiBrain:CheckBlockingTerrain(unitPos, targetPosition, unit.WeaponArc) then
                                                        --unit:SetCustomName('Fight micro WEAPON BLOCKED!!! ['..repr(target.UnitId)..'] dist: '..dist)
                                                        IssueMove({unit}, targetPosition )
                                                    else
                                                        --unit:SetCustomName('Fight micro SHOOTING ['..repr(target.UnitId)..'] dist: '..dist)
                                                    end
                                                end
                                            end
                                        else
                                            break
                                        end
                                        WaitTicks(10)
                                    end
                                end
                            end
                            if not target or target.Dead then
                                break
                            end
                            WaitTicks(30)
                        end
                    end
                elseif data.Defensive then 
                    WaitTicks(30)
                    return self:SetAIPlanRNG('ReturnToBaseAIRNG', true)
                elseif target.Dead then
                    --LOG('Strikeforce Target Dead performing loop')
                    target = false
                    WaitTicks(10)
                    continue
                else
                    --LOG('Strikeforce No Target we should be returning to base')
                    WaitTicks(30)
                    return self:SetAIPlanRNG('ReturnToBaseAIRNG', true)
                end
            end
            WaitTicks(30)
            if not target and self.MovementLayer == 'Air' and mergeRequired then
                --LOG('StrkeForce Air AI Attempting Merge')
                self:MoveToLocation(mainBasePos, false)
                local baseDist
                --LOG('StrikefoceAI Returning to base')
                myThreat = self:CalculatePlatoonThreat('AntiSurface', categories.ALLUNITS)
                while PlatoonExists(aiBrain, self) do
                    platoonPosition = GetPlatoonPosition(self)
                    baseDist = VDist2Sq(platoonPosition[1], platoonPosition[3], mainBasePos[1], mainBasePos[3])
                    if baseDist < 6400 then
                        break
                    end
                    if not target and myThreat > 8 and data.UnitType != 'GUNSHIP' then
                        --LOG('Checking for director target')
                        target = aiBrain:CheckDirectorTargetAvailable('AntiAir', myThreat)
                        if target then
                            break
                        end
                    end
                    --LOG('StrikeforceAI base distance is '..baseDist)
                    WaitTicks(50)
                end
                --LOG('MergeRequired, performing merge')
                self:Stop()
                self:MergeWithNearbyPlatoonsRNG('StrikeForceAIRNG', 60, 20, true)
                mergeRequired = false
            end
        end
    end,

    StrikeForceSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local data = self.PlatoonData
        local categoryList = {}
        local atkPri = {}
        if data.PrioritizedCategories then
            for k,v in data.PrioritizedCategories do
                table.insert(atkPri, v)
                table.insert(categoryList, ParseEntityCategory(v))
            end
        end
        table.insert(atkPri, 'ALLUNITS')
        table.insert(categoryList, categories.ALLUNITS)
        self:SetPrioritizedTargetList('Attack', categoryList)
        local target
        local blip = false
        local maxRadius = data.SearchRadius or 50
        local movingToScout = false
        while aiBrain:PlatoonExists(self) do
            if not target or target.Dead then
                if aiBrain:GetCurrentEnemy() and aiBrain:GetCurrentEnemy().Result == "defeat" then
                    aiBrain:PickEnemyLogic()
                end
                local mult = { 1,10,25 }
                for _,i in mult do
                    target = AIUtils.AIFindBrainTargetInRange(aiBrain, self, 'Attack', maxRadius * i, atkPri, aiBrain:GetCurrentEnemy())
                    if target then
                        break
                    end
                    WaitSeconds(1) --DUNCAN - was 3
                    if not aiBrain:PlatoonExists(self) then
                        return
                    end
                end

                --target = self:FindPrioritizedUnit('Attack', 'Enemy', true, self:GetPlatoonPosition(), maxRadius)

                --DUNCAN - added to target experimentals if they exist.
                local newtarget
                if AIAttackUtils.GetSurfaceThreatOfUnits(self) > 0 then
                    newtarget = self:FindClosestUnit('Attack', 'Enemy', true, categories.EXPERIMENTAL * (categories.LAND + categories.NAVAL + categories.STRUCTURE))
                elseif AIAttackUtils.GetAirThreatOfUnits(self) > 0 then
                    newtarget = self:FindClosestUnit('Attack', 'Enemy', true, categories.EXPERIMENTAL * categories.AIR)
                end
                if newtarget then
                    target = newtarget
                end

                if target then
                    self:Stop()
                    if not data.UseMoveOrder then
                        self:AttackTarget(target)
                    else
                        self:MoveToLocation(table.copy(target:GetPosition()), false)
                    end
                    movingToScout = false
                elseif not movingToScout then
                    movingToScout = true
                    self:Stop()
                    for k,v in AIUtils.AIGetSortedMassLocations(aiBrain, 10, nil, nil, nil, nil, self:GetPlatoonPosition()) do
                        if v[1] < 0 or v[3] < 0 or v[1] > ScenarioInfo.size[1] or v[3] > ScenarioInfo.size[2] then
                            --LOG('*AI DEBUG: STRIKE FORCE SENDING UNITS TO WRONG LOCATION - ' .. v[1] .. ', ' .. v[3])
                        end
                        self:MoveToLocation((v), false)
                    end
                end
            end
            WaitSeconds(7)
        end
    end,

    MassRaidSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        --LOG('Platoon ID is : '..self:GetPlatoonUniqueName())
        local platLoc = GetPlatoonPosition(self)

        if not aiBrain:PlatoonExists(self) or not platLoc then
            return
        end

        -----------------------------------------------------------------------
        -- Platoon Data
        -----------------------------------------------------------------------
        -- Include mass markers that are under water
        local includeWater = self.PlatoonData.IncludeWater or false

        local waterOnly = self.PlatoonData.WaterOnly or false

        -- Minimum distance when looking for closest
        local avoidClosestRadius = self.PlatoonData.AvoidClosestRadius or 0

        -- if true, look to guard highest threat, otherwise,
        -- guard the lowest threat specified
        local bFindHighestThreat = self.PlatoonData.FindHighestThreat or false

        -- minimum threat to look for
        local minThreatThreshold = self.PlatoonData.MinThreatThreshold or -1
        -- maximum threat to look for
        local maxThreatThreshold = self.PlatoonData.MaxThreatThreshold  or 99999999

        -- Avoid bases (true or false)
        local bAvoidBases = self.PlatoonData.AvoidBases or false

        -- Radius around which to avoid the main base
        local avoidBasesRadius = self.PlatoonData.AvoidBasesRadius or 0

        -- Use Aggresive Moves Only
        local bAggroMove = self.PlatoonData.AggressiveMove or false

        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'

        local maxPathDistance = self.PlatoonData.MaxPathDistance or 200

        -----------------------------------------------------------------------
        local markerLocations

        AIAttackUtils.GetMostRestrictiveLayer(self)
        self:SetPlatoonFormationOverride(PlatoonFormation)
        
        markerLocations = SUtils.AIGetMassMarkerLocations(aiBrain, includeWater, waterOnly)
        
        local bestMarker = false

        if not self.LastMarker then
            self.LastMarker = {nil,nil}
        end

        -- look for a random marker
        --[[Marker table examples for better understanding what is happening below 
        info: Marker Current{ Name="Mass7", Position={ 189.5, 24.240200042725, 319.5, type="VECTOR3" } }
        info: Marker Last{ { 374.5, 20.650400161743, 154.5, type="VECTOR3" } }
        ]] 

        local bestMarkerThreat = 0
        if not bFindHighestThreat then
            bestMarkerThreat = 99999999
        end

        local bestDistSq = 99999999

        if aiBrain:GetCurrentEnemy() then
           enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            --LOG('Enemy Index is '..enemyIndex)
        end
        -- find best threat at the closest distance
        for _,marker in markerLocations do
            local markerThreat
            local enemyThreat
            markerThreat = aiBrain:GetThreatAtPosition(marker.Position, 0, true, 'Economy', enemyIndex)
            enemyThreat = aiBrain:GetThreatAtPosition(marker.Position, 1, true, 'AntiSurface', enemyIndex)
            --LOG('Best pre calculation marker threat is '..markerThreat..' at position'..repr(marker.Position))
            --LOG('Surface Threat at marker is '..enemyThreat..' at position'..repr(marker.Position))
            if enemyThreat > 1 and markerThreat then
                markerThreat = markerThreat / enemyThreat
            end
            --LOG('Best marker threat is '..markerThreat..' at position'..repr(marker.Position))
            local distSq = VDist2Sq(marker.Position[1], marker.Position[3], platLoc[1], platLoc[3])

            if markerThreat >= minThreatThreshold and markerThreat <= maxThreatThreshold then
                if self:AvoidsBases(marker.Position, bAvoidBases, avoidBasesRadius) then
                    if self.IsBetterThreat(bFindHighestThreat, markerThreat, bestMarkerThreat) then
                        bestDistSq = distSq
                        bestMarker = marker
                        bestMarkerThreat = markerThreat
                    elseif markerThreat == bestMarkerThreat then
                        if distSq < bestDistSq then
                            bestDistSq = distSq
                            bestMarker = marker
                            bestMarkerThreat = markerThreat
                        end
                    end
                end
            end
        end

        --LOG('* AI-RNG: Best Marker Selected is at position'..repr(bestMarker.Position))
        
        if bestMarker.Position == nil and GetGameTimeSeconds() > 900 then
            --LOG('Best Marker position was nil and game time greater than 15 mins, switch to hunt ai')
            return self:LandAttackSorianEdit()
        elseif bestMarker.Position == nil then
            --LOG('Best Marker position was nil, select random')
            if table.getn(markerLocations) <= 2 then
                self.LastMarker[1] = nil
                self.LastMarker[2] = nil
            end
            for _,marker in RandomIter(markerLocations) do
                if table.getn(markerLocations) <= 2 then
                    self.LastMarker[1] = nil
                     self.LastMarker[2] = nil
                end
                if self:AvoidsBases(marker.Position, bAvoidBases, avoidBasesRadius) then
                    if self.LastMarker[1] and marker.Position[1] == self.LastMarker[1][1] and marker.Position[3] == self.LastMarker[1][3] then
                        continue
                    end
                    if self.LastMarker[2] and marker.Position[1] == self.LastMarker[2][1] and marker.Position[3] == self.LastMarker[2][3] then
                        continue
                    end
                    bestMarker = marker
                    break
                end
            end
        end

        local usedTransports = false

        if bestMarker then
            self.LastMarker[2] = self.LastMarker[1]
            self.LastMarker[1] = bestMarker.Position
            --LOG("GuardMarker: Attacking " .. bestMarker.Name)
            local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer, GetPlatoonPosition(self), bestMarker.Position, 100, maxPathDistance)
            local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingExSE(self, bestMarker.Position)
            IssueClearCommands(GetPlatoonUnits(self))
            if path then
                local position = GetPlatoonPosition(self)
                if not success or VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 512 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, true)
                elseif VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 256 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, false)
                end
                if not usedTransports then
                    local pathLength = table.getn(path)
                    for i=1, pathLength - 1 do
                        --LOG('* AI-RNG: * MassRaidRNG: moving to destination. i: '..i..' coords '..repr(path[i]))
                        if bAggroMove then
                            self:AggressiveMoveToLocation(path[i])
                        else
                            self:MoveToLocation(path[i], false)
                        end
                        --LOG('* AI-RNG: * MassRaidRNG: moving to Waypoint')
                        local PlatoonPosition
                        local Lastdist
                        local dist
                        local Stuck = 0
                        while aiBrain:PlatoonExists(self) do
                            PlatoonPosition = GetPlatoonPosition(self) or nil
                            if not PlatoonPosition then break end
                            dist = VDist2Sq(path[i][1], path[i][3], PlatoonPosition[1], PlatoonPosition[3])
                            -- are we closer then 15 units from the next marker ? Then break and move to the next marker
                            if dist < 400 then
                                -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                                self:Stop()
                                break
                            end
                            -- Do we move ?
                            if Lastdist ~= dist then
                                Stuck = 0
                                Lastdist = dist
                            -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
                            else
                                Stuck = Stuck + 1
                                if Stuck > 15 then
                                    --LOG('* AI-RNG: * MassRaidRNG: Stucked while moving to Waypoint. Stuck='..Stuck..' - '..repr(path[i]))
                                    self:Stop()
                                    break
                                end
                            end
                            WaitTicks(15)
                        end
                    end
                end
            elseif (not path and reason == 'NoPath') then
                --LOG('Guardmarker requesting transports')
                local foundTransport = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, true)
                --DUNCAN - if we need a transport and we cant get one the disband
                if not foundTransport then
                    --LOG('Guardmarker no transports')
                    self:PlatoonDisband()
                    return
                end
                --LOG('Guardmarker found transports')
            else
                self:PlatoonDisband()
                return
            end

            if (not path or not success) and not usedTransports then
                self:PlatoonDisband()
                return
            end

            self:AggressiveMoveToLocation(bestMarker.Position)

            -- wait till we get there
            local oldPlatPos = GetPlatoonPosition(self)
            local StuckCount = 0
            repeat
                WaitTicks(50)
                platLoc = GetPlatoonPosition(self)
                if VDist3(oldPlatPos, platLoc) < 1 then
                    StuckCount = StuckCount + 1
                else
                    StuckCount = 0
                end
                if StuckCount > 5 then
					WaitTicks(10)
                    LOG('MassRaidAI stuck count over 5, restarting')
                    return self:MassRaidSorianEdit()
                end
                oldPlatPos = platLoc
            until VDist2Sq(platLoc[1], platLoc[3], bestMarker.Position[1], bestMarker.Position[3]) < 64 or not aiBrain:PlatoonExists(self)

            -- we're there... wait here until we're done
            local numGround = aiBrain:GetNumUnitsAroundPoint((categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            while numGround > 0 and aiBrain:PlatoonExists(self) do
                WaitTicks(Random(50,100))
                --LOG('Still enemy stuff around marker position')
                numGround = aiBrain:GetNumUnitsAroundPoint((categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            end

            if not aiBrain:PlatoonExists(self) then
                return
            end
			WaitTicks(10)
            LOG('MassRaidAI restarting')
            return self:MassRaidSorianEdit()
        else
            -- no marker found, disband!
            self:PlatoonDisband()
        end
    end,

    PlatoonCallForHelpSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local checkTime = self.PlatoonData.DistressCheckTime or 7
        local pos = self:GetPlatoonPosition()
        while aiBrain:PlatoonExists(self) and pos do
            if not self.DistressCall then
                local threat = aiBrain:GetThreatAtPosition(pos, 0, true, 'AntiSurface')
                if threat and threat > 1 then
                    --LOG('*AI DEBUG: Platoon Calling for help')
                    aiBrain:BaseMonitorPlatoonDistress(self, threat)
                    self.DistressCall = true
                end
            end
            WaitSeconds(checkTime)
        end
    end,

    DistressResponseSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        while aiBrain:PlatoonExists(self) do
            -- In the loop so they may be changed by other platoon things
            local distressRange = self.PlatoonData.DistressRange or aiBrain.BaseMonitor.DefaultDistressRange
            local reactionTime = self.PlatoonData.DistressReactionTime or aiBrain.BaseMonitor.PlatoonDefaultReactionTime
            local threatThreshold = self.PlatoonData.ThreatSupport or 1
            local platoonPos = self:GetPlatoonPosition()
            if platoonPos and not self.DistressCall then
                -- Find a distress location within the platoons range
                local distressLocation = aiBrain:BaseMonitorDistressLocation(platoonPos, distressRange, threatThreshold)
                local moveLocation

                -- We found a location within our range! Activate!
                if distressLocation then
                    --LOG('*AI DEBUG: ARMY '.. aiBrain:GetArmyIndex() ..': --- DISTRESS RESPONSE AI ACTIVATION ---')

                    -- Backups old ai plan
                    local oldPlan = self:GetPlan()
                    if self.AiThread then
                        self.AIThread:Destroy()
                    end

                    -- Continue to position until the distress call wanes
                    repeat
                        moveLocation = distressLocation
                        self:Stop()
                        local cmd = self:AggressiveMoveToLocation(distressLocation)
                        repeat
                            WaitSeconds(reactionTime)
                            if not aiBrain:PlatoonExists(self) then
                                return
                            end
                        until not self:IsCommandsActive(cmd) or aiBrain:GetThreatAtPosition(moveLocation, 0, true, 'Overall') <= threatThreshold


                        platoonPos = self:GetPlatoonPosition()
                        if platoonPos then
                            -- Now that we have helped the first location, see if any other location needs the help
                            distressLocation = aiBrain:BaseMonitorDistressLocation(platoonPos, distressRange)
                            if distressLocation then
                                self:AggressiveMoveToLocation(distressLocation)
                            end
                        end
                    -- If no more calls or we are at the location; break out of the function
                    until not distressLocation or (distressLocation[1] == moveLocation[1] and distressLocation[3] == moveLocation[3])

                    --LOG('*AI DEBUG: '..aiBrain.Name..' DISTRESS RESPONSE AI DEACTIVATION - oldPlan: '..oldPlan)
                    self:SetAIPlan(oldPlan)
                end
            end
            WaitSeconds(11)
        end
    end,

    HeroFightPlatoonSorianEdit = function(self)
        local aiBrain = self:GetBrain()
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
		
		self.TrackThread = false
        -- this will set self.MovementLayer to the platoon
        AIAttackUtils.GetMostRestrictiveLayer(self)

        -- get categories where we want to move this platoon - (primary platoon targets)
        local MoveToCategories = {}
        if self.PlatoonData.MoveToCategories then
            for k,v in self.PlatoonData.MoveToCategories do
                table.insert(MoveToCategories, v )
            end
        else
            LOG('* AI-SE: * HeroFightPlatoon: MoveToCategories missing in platoon '..self.BuilderName)
        end

        -- get categories at what we want a unit to shoot at - (primary unit targets)
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
        self:SetPrioritizedTargetList('Attack', WeaponTargetCategories)

        -- calcuate maximum weapon range for every unit inside this platoon
        -- also switch on things like stealth and cloak
        local MaxPlatoonWeaponRange
        local ExperimentalInPlatoon = false
        local UnitBlueprint
        local YawMin = 0
        local YawMax = 0
        local TargetHug = self.PlatoonData.TargetHug
        local HasMainRearWeapon
        for _, unit in self:GetPlatoonUnits() do
            -- continue with the next unit if this unit is dead
            if unit.Dead then continue end
            UnitBlueprint = unit:GetBlueprint()
            -- remove INSIGNIFICANTUNIT units from the platoon (drones, buildbots etc)
            if UnitBlueprint.CategoriesHash.INSIGNIFICANTUNIT then
                --AIDebug('* AI-Uveso: HeroFightPlatoon: -- unit ['..repr(unit.UnitId)..'] is a INSIGNIFICANTUNIT.  Removing from platoon...  - '..repr( unit:GetBlueprint().General.UnitName or "Unknown" )..' ('..repr( unit:GetBlueprint().Description or "Unknown" )..'')
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
                continue
            end
            -- remove POD units from the platoon
            if UnitBlueprint.CategoriesHash.POD then
                --AIDebug('* AI-Uveso: HeroFightPlatoon: -- unit ['..repr(unit.UnitId)..'] is a POD UNIT.  Removing from platoon...  - '..repr( unit:GetBlueprint().General.UnitName or "Unknown" )..' ('..repr( unit:GetBlueprint().Description or "Unknown" )..'')
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
                continue
            end
            -- remove DRONE units from the platoon
            if UnitBlueprint.CategoriesHash.DRONE then
                --AIDebug('* AI-Uveso: HeroFightPlatoon: -- unit ['..repr(unit.UnitId)..'] is a DRONE UNIT.  Removing from platoon...  - '..repr( unit:GetBlueprint().General.UnitName or "Unknown" )..' ('..repr( unit:GetBlueprint().Description or "Unknown" )..'')
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
                continue
            end
            -- remove OPERATION units from the platoon
            if UnitBlueprint.CategoriesHash.OPERATION then
                --AIDebug('* AI-Uveso: HeroFightPlatoon: -- unit ['..repr(unit.UnitId)..'] is a OPERATION UNIT.  Removing from platoon...  - '..repr( unit:GetBlueprint().General.UnitName or "Unknown" )..' ('..repr( unit:GetBlueprint().Description or "Unknown" )..'')
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
                continue
            end
            -- Seraphim land Experimentals should always move close to the target
            if UnitBlueprint.CategoriesHash.EXPERIMENTAL and UnitBlueprint.CategoriesHash.SERAPHIM and UnitBlueprint.CategoriesHash.LAND then
                TargetHug = true
            end
            -- get the maximum weapopn range of this unit
            for _, weapon in UnitBlueprint.Weapon or {} do
                -- filter dummy weapons
                if weapon.Damage < 1 or weapon.MaxRadius < 1 then
                    continue
                end
                -- filter anti air weapons if we have a land platoon
                if self.MovementLayer == "Land" then
                    if weapon.WeaponCategory == 'Anti Air' then
                        --AIWarn("* AI-Uveso: HeroFightPlatoon: -- Land unit ["..repr(unit.UnitId).."] ignoring AntiAir Weapon "..repr(weapon.DisplayName))
                        continue
                    end
                end
                HasMainRearWeapon = false
                if UnitBlueprint.CategoriesHash.EXPERIMENTAL and UnitBlueprint.Physics.StandUpright then
                    -- for Experiemtnals with 2 legs
                    unit.HasMainRearWeapon = false
                elseif not unit.HasMainRearWeapon then
					
                    -- check weapon angle    pitch ^    yaw >
                    YawMin = false
                    YawMax = false
                    if weapon.HeadingArcCenter and weapon.HeadingArcRange then
                        if weapon.TurretYaw and weapon.TurretYawRange then
                            YawMin = weapon.HeadingArcCenter + weapon.TurretYaw - weapon.TurretYawRange
                            YawMax = weapon.HeadingArcCenter + weapon.TurretYaw + weapon.HeadingArcRange
                        else
                            YawMin = weapon.HeadingArcCenter - weapon.HeadingArcRange
                            YawMax = weapon.HeadingArcCenter + weapon.HeadingArcRange
                        end
                    elseif weapon.TurretYaw and weapon.TurretYawRange then
                        YawMin = weapon.TurretYaw - weapon.TurretYawRange
                        YawMax = weapon.TurretYaw + weapon.TurretYawRange
                    end
                    if YawMin and YawMax then
                        -- front unit side
                        if YawMin <= -180 and YawMax >= 180 then
                            --AILog('* AI-Uveso: Unit ['..unit.UnitId..'] can fire 360° front')
                            HasMainRearWeapon = true
                        end
                        -- left unit side
                        if YawMin <= -225 and YawMax >= -135 then
                            --AILog('* AI-Uveso: Unit ['..unit.UnitId..'] can fire 90° rear (left)')
                            HasMainRearWeapon = true
                        end
                        -- right unit side
                        if YawMin <= 135 and YawMax >= 225 then
                            --AILog('* AI-Uveso: Unit ['..unit.UnitId..'] can fire 90° rear (right)')
                            HasMainRearWeapon = true
                        end
                        -- back unit side
                        if YawMin <= -202.5 and YawMax >= 202.5 then
                            --AILog('* AI-Uveso: Unit ['..unit.UnitId..'] can fire 45° rear')
                            HasMainRearWeapon = true
                        end
                    end
                end
               
                -- unit can have MainWeaponDamage entry from the last platoon
                if not unit.MainWeaponDamage or weapon.Damage >= unit.MainWeaponDamage then
                    -- use the range from the biggest weapon
                    unit.MainWeaponDamage = weapon.Damage
                    if HasMainRearWeapon then
                        unit.HasMainRearWeapon = HasMainRearWeapon
                    end
                    -- exclude missiles
                    if weapon.WeaponCategory ~= 'Missile' then
                        -- save the weaponrange 
                        unit.MaxWeaponRange = weapon.MaxRadius * 0.9 -- maxrange minus 10%
                        -- save the weapon balistic arc, we need this later to check if terrain is blocking the weapon line of sight
                        if weapon.BallisticArc == 'RULEUBA_LowArc' then
                            unit.WeaponArc = 'low'
                        elseif weapon.BallisticArc == 'RULEUBA_HighArc' then
                            unit.WeaponArc = 'high'
                        else
                            unit.WeaponArc = 'none'
                        end
                        -- check for the overall range of the platoon
                        if not MaxPlatoonWeaponRange or MaxPlatoonWeaponRange > unit.MaxWeaponRange then
                            MaxPlatoonWeaponRange = unit.MaxWeaponRange
                        end
                    else
                        -- save a backup weapon in case we have only missiles or longrange weapons
                        unit.MaxWeaponRangeBackup = weapon.MaxRadius * 0.9 -- maxrange minus 10%
                        if weapon.BallisticArc == 'RULEUBA_LowArc' then
                            unit.WeaponArcBackup = 'low'
                        elseif weapon.BallisticArc == 'RULEUBA_HighArc' then
                            unit.WeaponArcBackup = 'high'
                        else
                            unit.WeaponArcBackup = 'none'
                        end
                    end
                end
            end
            -- in case we have not a normal weapons, use the backupweapon if available
            if not unit.MaxWeaponRange and unit.MaxWeaponRangeBackup then
                unit.MaxWeaponRange = unit.MaxWeaponRangeBackup
                unit.WeaponArc = unit.WeaponArcBackup
            end
            -- Search all platoon units and activate Stealth and Cloak (mostly Modded units)
            if unit.TestToggleCaps then
                if unit:TestToggleCaps('RULEUTC_StealthToggle') then
                    unit:SetScriptBit('RULEUTC_StealthToggle', false)
                end
                if unit:TestToggleCaps('RULEUTC_CloakToggle') then
                    unit:SetScriptBit('RULEUTC_CloakToggle', false)
                end
            else
                -- AIWarn("missing unit function TestToggleCaps()")
            end
            -- search if we have an experimental inside the platoon so we can't use transports
            if not ExperimentalInPlatoon and EntityCategoryContains(categories.EXPERIMENTAL, unit) then
                ExperimentalInPlatoon = true
            end
            -- ToDo: prevent units from reclaiming while attack moving (maybe not working !?!)
            unit:RemoveCommandCap('RULEUCC_Reclaim')
            unit:RemoveCommandCap('RULEUCC_Repair')
            -- create a table for individual unit position
            unit.smartPos = {0,0,0}
            unit.UnitMassCost = UnitBlueprint.Economy.BuildCostMass
            -- we have no weapon; check if we have a shield, stealth field or cloak field
            if not unit.MaxWeaponRange then
                -- does the unit has no weapon but a shield ?
                if UnitBlueprint.CategoriesHash.SHIELD then
                    --AILog('* AI-Uveso: Scanning: unit ['..repr(unit.UnitId)..'] Is a IsShieldOnlyUnit')
                    unit.IsShieldOnlyUnit = true
                end
                if UnitBlueprint.Intel.RadarStealthField then
                    --AILog('* AI-Uveso: Scanning: unit ['..repr(unit.UnitId)..'] Is a RadarStealthField Unit')
                    unit.IsShieldOnlyUnit = true
                end
                if UnitBlueprint.Intel.CloakField then
                    --AILog('* AI-Uveso: Scanning: unit ['..repr(unit.UnitId)..'] Is a CloakField Unit')
                    unit.IsShieldOnlyUnit = true
                end
                if UnitBlueprint.CategoriesHash.ANTIAIR then
                    --AILog('* AI-Uveso: Scanning: unit ['..repr(unit.UnitId)..'] Is a IsShieldOnlyUnit')
                    unit.IsShieldOnlyUnit = true
                end
            end
            -- debug for modded units that have no weapon and no shield or stealth/cloak
            -- things like seraphim restauration field
            if not unit.MaxWeaponRange and not unit.IsShieldOnlyUnit then
                -- AIWarn('* AI-Uveso: Scanning: unit ['..repr(unit.UnitId)..'] has no MaxWeaponRange and no stealth/cloak - '..repr(self.BuilderName), true, UvesoOffsetPlatoonLUA)
                -- Don't know what to do with this unit, lets move it behind the platoon
                unit.IsShieldOnlyUnit = true
            end
            unit.IamLost = 0
        end
        if not MaxPlatoonWeaponRange then
            if aiBrain:PlatoonExists(self) then
                self:PlatoonDisband()
            end
            return
        end
        -- we only see targets from this targetcategories.
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory
        if not TargetSearchCategory then
            WARN('* AI-Uveso: Missing TargetSearchCategory in builder: '..repr(self.BuilderName))
            TargetSearchCategory = categories.ALLUNITS
        end
        -- additional variables we need inside the platoon loop
        local TargetInPlatoonRange
        local target
        local TargetPos
        local LastTargetPos
		self.TargetData = target
        local UnitWithPath
        local UnitNoPath
        local path
        self.PathData = path
        local reason
        local unitPos
        local alpha
        local x
        local y
        local smartPos = {}
        local UnitToCover = nil
        local CoverIndex = 0
        local UnitMassCost = {}
        local maxRadius = self.PlatoonData.SearchRadius or 1000
        local WantsTransport = false
        local GetTargetsFromBase = self.PlatoonData.GetTargetsFromBase
        local DirectMoveEnemyBase = self.PlatoonData.DirectMoveEnemyBase
        local ThreatWeight = self.PlatoonData.AttackEnemyStrength
        local basePosition
        local PlatoonCenterPosition = self:GetPlatoonPosition()
        local bAggroMove = true -- Platoons will not react to nearby enemies if this is false
		local mythreat = self:CalculatePlatoonThreat('Overall', categories.ALLUNITS)
		local OriginalSurfaceThreat = self:CalculatePlatoonThreat('Overall', categories.ALLUNITS)
		local merged = false
        if TargetHug then
            bAggroMove = false
        end
        if self.MovementLayer == 'Water' then
            -- we could search for the nearest naval base here, but buildposition is almost at the same location
            basePosition = PlatoonCenterPosition
        else
            -- land and air units are assigned to mainbase
            basePosition = aiBrain.BuilderManagers['MAIN'].Position
        end
        local GetTargetsFrom = basePosition
        if DirectMoveEnemyBase then
            local ClosestEnemyBaseDistance
            local ClosestEnemyBaseLocation
            for index, brain in ArmyBrains do
                if brain.BuilderManagers['MAIN'] then
                    if brain.BuilderManagers['MAIN'].FactoryManager.Location then
                        local Baselocation = aiBrain.BuilderManagers['MAIN'].Position
                        local EnemyBaseLocation = brain.BuilderManagers['MAIN'].Position
                        local dist = VDist2( Baselocation[1], Baselocation[3], EnemyBaseLocation[1], EnemyBaseLocation[3] )
                        if dist < 10 then continue end
                        if not ClosestEnemyBaseDistance or ClosestEnemyBaseDistance > dist then
                            ClosestEnemyBaseLocation = EnemyBaseLocation
                            ClosestEnemyBaseDistance = dist
                        end
                    end
                end
            end
            if ClosestEnemyBaseLocation then
                GetTargetsFrom = ClosestEnemyBaseLocation
            end
        end
        -- platoon loop
        --self:RenamePlatoon('MAIN loop')
        while aiBrain:PlatoonExists(self) do
            while not aiBrain:IsOpponentAIRunning() do
                coroutine.yield(10)
            end
            -- remove the Blocked flag from all unts. (at this point we don't have a target or the target is dead or we clean a leftover from the last platoon call)
            for _, unit in self:GetPlatoonUnits() or {} do
                unit.Blocked = false
            end
            -- wait a bit here, so continue commands can't deadloop/freeze the game
            coroutine.yield(3)
            if self.UsingTransport then
                continue
            end
            PlatoonCenterPosition = self:GetPlatoonPosition()
            if not PlatoonCenterPosition[1] then
                if aiBrain:PlatoonExists(self) then
                    self:PlatoonDisband()
                end
                return
            end
			
			-- mythreat = self:CalculatePlatoonThreat('Overall', categories.ALLUNITS)
            -- if mythreat <= (OriginalSurfaceThreat * 0.4) then
				-- self.MergeIntoNearbyPlatoons( self, aiBrain, 'HeroFightPlatoonSorianEdit', 100, false)
				-- if self.TrackThread or self.TrackThread ~= false then
					-- self:KillThread(TrackThread)
					-- self.TrackThread = false
				-- end
                -- target = nil
                -- path = nil
				-- return self:SetAIPlan('HeroFightPlatoonSorianEdit',aiBrain)
			-- end
			
			-- merged = self.MergeWithNearbyPlatoonsSorianEdit( self, aiBrain, 'HeroFightPlatoonSorianEdit', 40, false, 100)
			-- if merged then
				-- if self.TrackThread or self.TrackThread ~= false then
					-- self:KillThread(TrackThread)
					-- self.TrackThread = false
				-- end
                -- target = nil
                -- path = nil
				-- return self:SetAIPlan('HeroFightPlatoonSorianEdit',aiBrain)
			-- end
			
            -- set target search center position
            -- if not GetTargetsFromBase then
                GetTargetsFrom = PlatoonCenterPosition
            -- end
			-- LOG('* AI-SorianEdit: * HeroFightPlatoonSorianEdit Do we search for a target?')
            -- Search for a target (don't remove the :BeenDestroyed() call!)
            if not target or target.Dead or target:BeenDestroyed() then
				-- LOG('* AI-SorianEdit: * HeroFightPlatoonSorianEdit: Calling AIFindNearestCategoryTargetInRange: position: '..repr(GetTargetsFrom)..' PlatoonCenterPosition: '..repr(PlatoonCenterPosition)..' maxRange: '..repr(maxRadius)..' MoveToCategories: '..repr(MoveToCategories)..' TargetSearchCategory: '..repr(TargetSearchCategory))
                UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', GetTargetsFrom, maxRadius, MoveToCategories, TargetSearchCategory, false ) -- note do not use SE version
                self.PathData = path
				target = UnitWithPath or UnitNoPath
				-- LOG('* AI-SorianEdit: * HeroFightPlatoonSorianEdit: AIFindNearestCategoryTargetInRange: path: '..repr(path)..' reason: '..repr(reason))
				self.TargetData = target
                if not target then
                    -- if we have amphibious units, try first a land path, so we don't need to go under water
                    if self.MovementLayer == "Amphibious" then
                        -- set platoon to land layer
                        self.MovementLayer = "Land"
                        -- search for a land path
                        UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', GetTargetsFrom, maxRadius, MoveToCategories, TargetSearchCategory, false )
                        -- reset platoon to amphibious layer
                        self.MovementLayer = "Amphibious"
                    else
                        UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', GetTargetsFrom, maxRadius, MoveToCategories, TargetSearchCategory, false, true )
                    end
                end
                target = UnitWithPath or UnitNoPath
				self.TargetData = target
            end
            -- -- remove target, if we are out of base range
            -- DistanceToBase = VDist2(PlatoonCenterPosition[1] or 0, PlatoonCenterPosition[3] or 0, basePosition[1] or 0, basePosition[3] or 0)
            -- if GetTargetsFromBase and DistanceToBase > maxRadius then
                -- target = nil
                -- path = nil
                -- if HERODEBUGSorianEdit then
                    -- self:RenamePlatoon('target to far from base')
                    -- coroutine.yield(10)
                -- end
            -- end
            -- check if the platoon died while the targeting function was searching for targets
            if not aiBrain:PlatoonExists(self) then
                return
			end
			mythreat = self:CalculatePlatoonThreat('Overall', categories.ALLUNITS)
			local SupportThreat = ((mythreat / 100) * ThreatWeight) * 2
			-- local SupportThreat = 1000
            -- move to the target
	
            if target and not target.Dead and not target:BeenDestroyed() then
                LastTargetPos = table.copy(target:GetPosition())
                -- are we outside weaponrange ? then move to the target
                if VDist2( PlatoonCenterPosition[1], PlatoonCenterPosition[3], LastTargetPos[1], LastTargetPos[3] ) > MaxPlatoonWeaponRange + 30 then
                    --self:RenamePlatoon('move to target -> out of weapon range')
                    -- if we have a path then use the waypoints 
                    if UnitWithPath and path and not self.PlatoonData.IgnorePathing then
                        --self:RenamePlatoon('move to target -> with waypoints')
                        -- move to the target with waypoints
                        if self.MovementLayer == 'Air' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('MovePath (Air)')
                                coroutine.yield(10)
                            end
                            self:MovePath(aiBrain, path, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory, ExperimentalInPlatoon)
                        elseif self.MovementLayer == 'Water' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('MovePath (Water)')
                                coroutine.yield(10)
                            end
                            self:MovePath(aiBrain, path, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory, ExperimentalInPlatoon)
                        else
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('MovePath with transporter layer('..self.MovementLayer..')')
                                coroutine.yield(10)
                            end
                            self:MoveToLocationInclTransportSorianEdit(target, LastTargetPos, bAggroMove, WantsTransport, basePosition, ExperimentalInPlatoon, MaxPlatoonWeaponRange, TargetSearchCategory, SupportThreat)
                        end
                    -- if we don't have a path, but UnitWithPath is true, then we have no map markers but PathCanTo() found a direct path
                    elseif UnitWithPath then
                        --self:RenamePlatoon('move to target -> without waypoints')
                        -- move to the target without waypoints
                        if self.MovementLayer == 'Air' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UWP MoveDirect (Air)')
                                coroutine.yield(10)
                            end
                            self:MoveDirect(aiBrain, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory)
                        elseif self.MovementLayer == 'Water' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UWP MoveDirect (Water)')
                                coroutine.yield(10)
                            end
                            self:MoveDirect(aiBrain, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory)
                        -- elseif self.MovementLayer == 'Amphibious' then
                            -- if HERODEBUGSorianEdit then
                                -- self:RenamePlatoon('UWP MoveDirect (Amphibious)')
                                -- coroutine.yield(10)
                            -- end
                            -- self:MoveDirect(aiBrain, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory)
                        else
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UWP MoveDirect with transporter layer('..self.MovementLayer..')')
                                coroutine.yield(10)
                            end
                            self:MoveToLocationInclTransportSorianEdit(target, LastTargetPos, bAggroMove, WantsTransport, basePosition, ExperimentalInPlatoon, MaxPlatoonWeaponRange, TargetSearchCategory, SupportThreat)
                        end
                    -- move to the target without waypoints using a transporter
                    elseif UnitNoPath then
                        -- we have a target but no path, Air can fly to it
                        if self.MovementLayer == 'Air' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UNP MoveDirect (Air)')
                                coroutine.yield(10)
                            end
                            self:MoveDirect(aiBrain, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory)
                        -- we have a target but no path, Naval can never reach it
                        elseif self.MovementLayer == 'Water' then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UNP No Naval path (Water)')
                                coroutine.yield(10)
                            end
                            target = nil
                            path = nil
                        else
                            self:Stop()
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('UWP MoveOnlyWithTransport MoveDirect instead layer('..self.MovementLayer..')')
                                coroutine.yield(10)
                            end
                            --self:RenamePlatoon('MoveOnlyWithTransport')
                            -- self:MoveDirect(aiBrain, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory) replace if transports break again
                            self:MoveWithTransportSorianEdit(aiBrain, bAggroMove, target, basePosition, ExperimentalInPlatoon, MaxPlatoonWeaponRange, TargetSearchCategory)
                        end
                    end
                end
            else
                target = nil
                path = nil
                LastTargetPos = nil
                -- no target, land units just wait for new targets, air and naval units return to their base
                if HERODEBUGSorianEdit then
                    self:RenamePlatoon('No target returning home')
                    coroutine.yield(10)
                end
                if self.MovementLayer == 'Air' then
                    --self:RenamePlatoon('move to base')
                    if VDist2(PlatoonCenterPosition[1] or 0, PlatoonCenterPosition[3] or 0, basePosition[1] or 0, basePosition[3] or 0) > 40 then
                        self:SetPlatoonFormationOverride('NoFormation')
                        self:SimpleReturnToBaseSorianEdit(basePosition)
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('returning (Air)')
                            coroutine.yield(10)
                        end
                        if aiBrain:PlatoonExists(self) then
                            self:PlatoonDisband()
                        end
                        return
                    else
                        -- we are at home and we don't have a target. Disband!
                        if aiBrain:PlatoonExists(self) then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('PlatoonDisband 1')
                                coroutine.yield(10)
                            end
                            self:PlatoonDisband()
                            return
                        end
                    end
                elseif self.MovementLayer == 'Water' then
                    --self:RenamePlatoon('move to base')
                    if VDist2(PlatoonCenterPosition[1] or 0, PlatoonCenterPosition[3] or 0, basePosition[1] or 0, basePosition[3] or 0) > 40 then
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('returning (Water)')
                            coroutine.yield(10)
                        end
                        self:SetPlatoonFormationOverride('NoFormation')
                        self:ForceReturnToNearestBaseAISE()
                        if aiBrain:PlatoonExists(self) then
                            self:PlatoonDisband()
                        end
                        return
                    else
                    -- we are at home and we don't have a target. Disband!
                        if HERODEBUG then
                            self:RenamePlatoon('move to New targets')
                            coroutine.yield(10)
                        end
                        -- no more targets found with platoonbuilder template settings. Set new targets to the platoon and continue
                        self.BuilderName = "old "..self.BuilderName
                        self.alternativPlan = true
                        self.PlatoonData.GetTargetsFromBase = false
                        self.PlatoonData.DirectMoveEnemyBase = false
                        self.PlatoonData.AggressiveMove = true
                        self.PlatoonData.SearchRadius = 10000
                        self.PlatoonData.AttackEnemyStrength = 1000000
                        self.PlatoonData.TargetSearchCategory = categories.ALLUNITS - categories.AIR
                        self.PlatoonData.MoveToCategories = { categories.ALLUNITS - categories.AIR }
                        self.PlatoonData.WeaponTargetCategories = { categories.EXPERIMENTAL, categories.COMMAND, categories.ALLUNITS }
                        coroutine.yield(10)
                        self:HeroFightPlatoonSorianEdit()
                        if aiBrain:PlatoonExists(self) then
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('PlatoonDisband 2')
                            end
                            self:PlatoonDisband()
                            return
                        end
                    end
				else
					-- local x = PlatoonCenterPosition[1]
					-- local z = PlatoonCenterPosition[3]
					-- local ex, ez = aiBrain:GetCurrentEnemy():GetArmyStartPos()
					-- -- DrawCircle({x,0,z}, 5, '19FF19')
					-- -- DrawCircle({ex,0,ez}, 5, 'FF0119')
					-- local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, 'Land', {x,0,z}, {ex,0,ez}, 1, 1025)
					-- if reason == 'PathOK' then
						-- if HERODEBUGSorianEdit then
							-- self:RenamePlatoon('scouting for targets')
							-- coroutine.yield(10)
						-- end
						
						-- for i = 1, 100 do
							-- local pathCount = table.getn(path)
							-- for i=1, pathCount do
								-- local Marker = path[i]
								-- local Marker2 = path[i+1]
								-- if Marker2 == nil then
									-- break
								-- end
								-- DrawLinePop({Marker[1], Marker[2], Marker[3]}, {Marker2[1], Marker2[2], Marker2[3]}, 'FC03C6')
							-- end
							-- coroutine.yield(10)
						-- end
						
						-- self:MovePath(aiBrain, path, bAggroMove, target, MaxPlatoonWeaponRange, TargetSearchCategory)
                        -- if aiBrain:PlatoonExists(self) then
                            -- self:PlatoonDisband()
                        -- end
						-- return
                    if GetTargetsFromBase or self.alternativPlan then
                    -- if we get targets from base then we are here to protect the base. Return to cover the base.
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('No BaseTarget, returning Home')
                            coroutine.yield(10)
                        end
                        self:ForceReturnToNearestBaseAISE()
                        if aiBrain:PlatoonExists(self) then
                            self:PlatoonDisband()
                        end
						return
                    else
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('move to New targets')
                            coroutine.yield(10)
                        end
                        -- no more targets found with platoonbuilder template settings. Set new targets to the platoon and continue
						-- self:LandScoutingSorianEdit(200)
                        self.BuilderName = "old "..self.BuilderName
                        self.alternativPlan = true
                        maxRadius = 10000
                        self.PlatoonData.GetTargetsFromBase = false
                        self.PlatoonData.DirectMoveEnemyBase = false
                        self.PlatoonData.AggressiveMove = true
                        self.PlatoonData.RequireTransport = false
                        self.PlatoonData.SearchRadius = 10000
                        self.PlatoonData.AttackEnemyStrength = 1000000
                        self.PlatoonData.TargetSearchCategory = categories.LAND
                        GetTargetsFromBase = false
                        self.PlatoonData.MoveToCategories = { categories.EXPERIMENTAL, categories.COMMAND, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                        self.PlatoonData.WeaponTargetCategories = { categories.EXPERIMENTAL, categories.COMMAND, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                        self.PlatoonData.TargetSearchCategory = categories.ALLUNITS - categories.AIR
                        TargetSearchCategory = categories.ALLUNITS - categories.AIR
                        self:SetPrioritizedTargetList('Attack', categories.ALLUNITS - categories.AIR)
                        coroutine.yield(10)
                        self:HeroFightPlatoonSorianEdit()
                        if aiBrain:PlatoonExists(self) then
                            self:PlatoonDisband()
                        end
                        return
                    end
                end
            end
			if ScenarioInfo.Options.SEPathing ~= 'No' and not self.TrackThread then
				self.TrackThread = self:ForkThread(SUtils.TrackPlatoon, aiBrain, target, path, MaxPlatoonWeaponRange)
			end
            -- in case we are using a transporter, do nothing. Wait for the transport!
            if self.UsingTransport then
                if HERODEBUGSorianEdit then
                    self:RenamePlatoon('Waiting for Transport')
                end
				coroutine.yield(10)
                -- continue
            end
            -- stop the platoon, now we are moving units instead of the platoon
            -- if aiBrain:PlatoonExists(self) then
                -- self:Stop()
                -- coroutine.yield(10)
                -- if LastTargetPos then
                    -- self:Patrol(LastTargetPos)
                -- else
                    -- self:Patrol(basePosition)
                -- end
            -- else
                -- return
            -- end
            -- fight
            if HERODEBUGSorianEdit then
                self:RenamePlatoon('moved, now fighting')
                coroutine.yield(10)
            end
            coroutine.yield(10)
            LastTargetPos = nil
            --self:RenamePlatoon('MICRO loop')
            while aiBrain:PlatoonExists(self) do
                while not aiBrain:IsOpponentAIRunning() do
                    coroutine.yield(10)
                end 
                if HERODEBUGSorianEdit then
                    self:RenamePlatoon('microing in 5 ticks')
                end
                -- wait a bit here, so continue commands can't deadloop/freeze the game
                coroutine.yield(20)
                --LOG('* AI-Uveso: * HeroFightPlatoon: Starting micro loop')
                PlatoonCenterPosition = self:GetPlatoonPosition()
                if not PlatoonCenterPosition then
                    --WARN('* AI-Uveso: PlatoonCenterPosition not existent')
                    if aiBrain:PlatoonExists(self) then
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('PlatoonDisband 3')
                        end
                        self:PlatoonDisband()
                    end
                    return
                end
				
                if HERODEBUGSorianEdit then
                    self:RenamePlatoon('AIFindNearestCategoryTargetInCloseRangeSorianEdit')
                end
				
                -- get a target on every loop, so we can see targets that are moving closer
                if TargetHug then
					TargetInPlatoonRange = self:FindClosestUnit('Attack', 'Enemy', true, TargetSearchCategory)
                else
                    TargetInPlatoonRange = self:FindClosestUnit('Attack', 'Enemy', true, (categories.ALLUNITS - categories.WALL))
                end

                -- check if the target is in range
                if TargetInPlatoonRange then
                    LastTargetPos = TargetInPlatoonRange:GetPosition()
                    if self.MovementLayer == 'Air' then
                        if VDist2( PlatoonCenterPosition[1], PlatoonCenterPosition[3], LastTargetPos[1], LastTargetPos[3] ) > MaxPlatoonWeaponRange + 60 then
                            -- Air target is to far away, remove it and lets get a new main target 
                            TargetInPlatoonRange = false
                        end
                    else
                        if VDist2( PlatoonCenterPosition[1], PlatoonCenterPosition[3], LastTargetPos[1], LastTargetPos[3] ) > MaxPlatoonWeaponRange + 35 then
                            -- land/naval target is to far away, remove it and lets get a new main target 
                            TargetInPlatoonRange = false
                        end
                    end
                end

                if HERODEBUGSorianEdit then
                    if TargetInPlatoonRange then
                        if TargetInPlatoonRange.Dead then
                            self:RenamePlatoon('TargetInPlatoonRange = Dead')
                        else
                            self:RenamePlatoon('TargetInPlatoonRange true')
                        end
                    else
                        self:RenamePlatoon('TargetInPlatoonRange = NIL')
                    end
                end
                    coroutine.yield(10)
                if TargetInPlatoonRange and not TargetInPlatoonRange.Dead then
                    --LOG('* AI-Uveso: * HeroFightPlatoon: TargetInPlatoonRange: ['..repr(TargetInPlatoonRange.UnitId)..']')
                    if AIUtils.IsNukeBlastAreaSE(aiBrain, LastTargetPos) then
                        -- continue the "while aiBrain:PlatoonExists(self) do" loop
                        continue
                    end
                    if self.MovementLayer == 'Air' then
                        -- remove target, if we are out of base range
                        DistanceToBase = VDist2(PlatoonCenterPosition[1] or 0, PlatoonCenterPosition[3] or 0, basePosition[1] or 0, basePosition[3] or 0)
                        if GetTargetsFromBase and DistanceToBase > maxRadius then
                            TargetInPlatoonRange = nil
                            if HERODEBUGSorianEdit then
                                self:RenamePlatoon('micro attack AIR DistanceToBase > maxRadius')
                                coroutine.yield(10)
                            end
                            break
                        end
                        -- else attack
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('micro attack AIR')
                            coroutine.yield(10)
                        end
                        if not TargetInPlatoonRange.Dead then
                            self:AttackTarget(TargetInPlatoonRange)
                        end
                    else
                        if HERODEBUGSorianEdit then
                            self:RenamePlatoon('micro attack Land')
                            coroutine.yield(10)
                        end
                        --LOG('* AI-Uveso: * HeroFightPlatoon: Fight micro LAND start')
                        --self:RenamePlatoon('Fight micro LAND start')
                        -- bring all platoon units in optimal range to the target
                        UnitMassCost = {}
                        ------------------------------------------------------------------------------
                        -- First micro turn for attack untis, second turn is for cover/shield units --
                        ------------------------------------------------------------------------------
                        for _, unit in self:GetPlatoonUnits() or {} do
                            if unit.Dead then
                                continue
                            end
                            -- don't move shield units in the first turn
                            if unit.IsShieldOnlyUnit then
                                continue
                            end
                            -- clear move commands if we have queued more than 2
                            if table.getn(unit:GetCommandQueue()) > 1 then
                                IssueClearCommands({unit})
                            end
                            unitPos = unit:GetPosition()
                            if unit.Blocked then
                                -- Weapoon fire is blocked, move to the target as close as possible.
                                -- smartPos = { LastTargetPos[1] + (Random(-5, 5)/10), LastTargetPos[2], LastTargetPos[3] + (Random(-5, 5)/10) }
                            else
                                alpha = math.atan2 (LastTargetPos[3] - unitPos[3] ,LastTargetPos[1] - unitPos[1])
                                x = LastTargetPos[1] - math.cos(alpha) * (unit.MaxWeaponRange or MaxPlatoonWeaponRange)
                                y = LastTargetPos[3] - math.sin(alpha) * (unit.MaxWeaponRange or MaxPlatoonWeaponRange)
                                smartPos = { x, GetTerrainHeight( x, y), y }
                            end
                            -- if we need to get as close to the target as possible, then just run to the target position
                            if TargetHug then
                                IssueMove({unit}, { LastTargetPos[1] + Random(-1, 1), LastTargetPos[2], LastTargetPos[3] + Random(-1, 1) } )
                            -- check if the move position is new or target has moved
                            -- if we don't have a rear weapon then attack (will move in circles otherwise)
                            elseif not unit.HasRearWeapon and VDist2( unitPos[1], unitPos[3], LastTargetPos[1], LastTargetPos[3] ) > (unit.MaxWeaponRange or MaxPlatoonWeaponRange) then
                                if HERODEBUGSorianEdit then
                                    self:RenamePlatoon('micro attack Land No RearWeapon')
                                    coroutine.yield(10)
                                end
                                if not TargetInPlatoonRange.Dead then
                                    IssueAttack({unit}, TargetInPlatoonRange)
                                end
                            elseif unit.HasRearWeapon and ( VDist2( smartPos[1], smartPos[3], unit.smartPos[1], unit.smartPos[3] ) > 0.7 or VDist2( LastTargetPos[1], LastTargetPos[3], unit.TargetPos[1], unit.TargetPos[3] ) > 0.7 ) then
                                if HERODEBUGSorianEdit then
                                    self:RenamePlatoon('micro attack Land has RearWeapon')
                                    coroutine.yield(10)
                                end
                                -- in case we have a new target, delete the Blocked flag
                                if unit.TargetPos ~= LastTargetPos then
                                    unit.Blocked = false
                                end
                                -- check if we are far away fromthe platoon. maybe we have a stucked unit here
                                -- can also be a unit that needs to deploy for weapon fire
                                if VDist2( unitPos[1], unitPos[3], PlatoonCenterPosition[1], PlatoonCenterPosition[3] ) > 100.0 then
                                    if not unit:IsMoving() then
                                        unit.IamLost = unit.IamLost + 1
                                    end
                                else
                                    unit.IamLost = 0
                                end
                                if unit.IamLost > 5 then
                                    WARN('* AI-SorianEdit: We have a LOST (stucked) unit. Killing it!!! Distance to platoon: '..math.floor(VDist2( unitPos[1], unitPos[3], PlatoonCenterPosition[1], PlatoonCenterPosition[3]))..' pos: ( '..math.floor(unitPos[1])..' , '..math.floor(unitPos[3])..' )' )
                                    -- stucked units can't be unstucked, even with a forked thread and hammering movement commands. Let's kill it !!!
                                    unit:Kill()
                                end
                                IssueMove({unit}, smartPos )
                                if HERODEBUGSorianEdit then
                                    unit:SetCustomName('Fight micro moving')
                                    coroutine.yield(10)
                                end
                                unit.smartPos = smartPos
                                unit.TargetPos = LastTargetPos
                            -- in case we don't move, check if we can fire at the target
							else
                                if LastTargetPos and aiBrain:CheckBlockingTerrain(unitPos, LastTargetPos, unit.WeaponArc) then
                                    if HERODEBUGSorianEdit then
                                        unit:SetCustomName('WEAPON BLOCKED!!! ['..repr(TargetInPlatoonRange.UnitId)..']')
                                        coroutine.yield(10)
                                    end
                                    unit.Blocked = true
                                else
                                    if HERODEBUGSorianEdit then
                                        unit:SetCustomName('SHOOTING ['..repr(TargetInPlatoonRange.UnitId)..']')
                                    end
                                    unit.Blocked = false
                                    if not TargetInPlatoonRange.Dead then
                                        -- set the target as focus, we are in range, the unit will shoot without attack command
                                        coroutine.yield(10)
                                        unit:SetFocusEntity(TargetInPlatoonRange)
                                    end
                                end
                            end
                            -- use this table later to decide what unit we want to cover with shields
                            table.insert(UnitMassCost, {UnitMassCost = unit.UnitMassCost, smartPos = unit.smartPos, TargetPos = unit.TargetPos})
                        end -- end micro first turn 
                        if not UnitMassCost[1] then
                            -- we can just disband the platoon everywhere on the map.
                            -- the location manager will return these units to the nearest base for reassignment.
                            --self:RenamePlatoon('no Fighters -> Disbanded')
                            if aiBrain:PlatoonExists(self) then
                                if HERODEBUGSorianEdit then
                                    self:RenamePlatoon('PlatoonDisband 4')
                                    coroutine.yield(10)
                                end
                                self:PlatoonDisband()
                            end
                            return
                        end
                        table.sort(UnitMassCost, function(a, b) return a.UnitMassCost > b.UnitMassCost end)
                        ----------------------------------------------
                        -- Second micro turn for cover/shield units --
                        ----------------------------------------------
                        UnitToCover = nil
                        CoverIndex = 0
                        for _, unit in self:GetPlatoonUnits() do
                            if unit.Dead then continue end
                            -- don't use attack units here
                            if not unit.IsShieldOnlyUnit then
                                continue
                            end
                            unitPos = unit:GetPosition()
                            -- select a unit we want to cover. units with high mass cost first
                            CoverIndex = CoverIndex + 1
                            if not UnitMassCost[CoverIndex] then
                                if CoverIndex ~= 1 then
                                    CoverIndex = 1
                                end
                            end
                            UnitToCover = UnitMassCost[CoverIndex]
                            -- calculate a position behind the unit we want to cover (behind unit from enemy view)
                            if UnitToCover.smartPos and UnitToCover.TargetPos then
                                alpha = math.atan2 (UnitToCover.smartPos[3] - UnitToCover.TargetPos[3] ,UnitToCover.smartPos[1] - UnitToCover.TargetPos[1])
                                x = UnitToCover.smartPos[1] + math.cos(alpha) * 4
                                y = UnitToCover.smartPos[3] + math.sin(alpha) * 4
                                smartPos = { x, GetTerrainHeight( x, y), y }
                            else
                                smartPos = PlatoonCenterPosition
                            end
                            -- check if the move position is new or target has moved
                            if VDist2( smartPos[1], smartPos[3], unit.smartPos[1], unit.smartPos[3] ) > 0.7 then
                                -- clear move commands if we have queued more than 2
                                if table.getn(unit:GetCommandQueue()) > 1 then
                                    IssueClearCommands({unit})
                                end
                                -- if our target is dead, jump out of the "for _, unit in self:GetPlatoonUnits() do" loop
                                IssueMove({unit}, smartPos )
                                unit.smartPos = smartPos
                            end

                        end
                    end
                else
                    if HERODEBUGSorianEdit then
                        self:RenamePlatoon('no micro target')
                        coroutine.yield(10)
                    end
                    --LOG('* AI-Uveso: * HeroFightPlatoon: Fight micro No Target')
                    self:Stop()
                    -- break the fight loop and get new targets
                    break
                end
			end  -- fight end
        end
		
		
        if HERODEBUGSorianEdit then
            self:RenamePlatoon('PlatoonExists = false')
			coroutine.yield(10)
        end

        if aiBrain:PlatoonExists(self) then
            if HERODEBUGSorianEdit then
                self:RenamePlatoon('PlatoonDisband 5')
                coroutine.yield(10)
            end
            self:PlatoonDisband()
        end
    end,
	
    ForceReturnToNearestBaseAISE = function(self)
        local platPos = self:GetPlatoonPosition() or false
        if not platPos then
            return
        end
        local aiBrain = self:GetBrain()
        local nearestbase = false
        for k,v in aiBrain.BuilderManagers do
            -- check if we can move to this base
            if not AIUtils.ValidateLayerSorianEdit(v.FactoryManager.Location,self.MovementLayer) then
                --AILog('* AI-Uveso: ForceReturnToNearestBaseAISE Can\'t return to This base. Wrong movementlayer: '..repr(v.FactoryManager.LocationType))
                continue
            end
            local dist = VDist2( platPos[1], platPos[3], v.FactoryManager.Location[1], v.FactoryManager.Location[3] )
            if not nearestbase or nearestbase.dist > dist then
                nearestbase = {}
                nearestbase.Pos = v.FactoryManager.Location
                nearestbase.dist = dist
            end
        end
        if not nearestbase then
            return
        end
        self:Stop()
        self:MoveToLocationInclTransportSorianEdit(true, nearestbase.Pos, false, false, nearestbase.Pos, false)
        -- Disband the platoon so the locationmanager can assign a new task to the units.
        if HERODEBUGSorianEdit then
            self:RenamePlatoon('Disbanding in 3 sec.')
        end
        coroutine.yield(30)
        if HERODEBUGSorianEdit then
            self:RenamePlatoon('Disbanded')
        end
        if aiBrain:PlatoonExists(self) then
            self:PlatoonDisband()
        end
    end,
	-- Outdated Sorian AI to be replaced
	
    HuntAISorianEdit = function(self)
		-- if 1==1 then
            -- self:HeroFightPlatoonSorianEdit()
            -- return
        -- end
        self:Stop()
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local target
        local blip
        local platoonUnits = self:GetPlatoonUnits()
        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'
		
        self:SetPlatoonFormationOverride(PlatoonFormation)
        while aiBrain:PlatoonExists(self) do
            local mySurfaceThreat = AIAttackUtils.GetSurfaceThreatOfUnits(self)
            local inWater = AIAttackUtils.InWaterCheck(self)
            local pos = self:GetPlatoonPosition()
            local threatatLocation = aiBrain:GetThreatAtPosition(pos, 1, true, 'AntiSurface')
            target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.WALL - categories.AIR - categories.NAVAL - categories.SCOUT)
            if target then
                blip = target:GetBlip(armyIndex)
                self:Stop()
                if not inWater then
                    IssueAggressiveMove(platoonUnits, target:GetPosition())
                else
                    IssueMove(platoonUnits, target:GetPosition())
                end
            end
            WaitSeconds(10)
        end
    end,
	
    GuardBaseSorianEdit = function(self)
	-- if 1==1 then
            -- self:HeroFightPlatoonSorianEdit()
            -- return
        -- end
        self:Stop()
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local target = false
        local basePosition = false
        local radius = self.PlatoonData.Radius or 50000
        local patrolling = false

        if self.PlatoonData.LocationType and self.PlatoonData.LocationType != 'NOTMAIN' then
            basePosition = aiBrain.BuilderManagers[self.PlatoonData.LocationType].Position
        else
            local platoonPosition = self:GetPlatoonPosition()
            if platoonPosition then
                basePosition = aiBrain:FindClosestBuilderManagerPosition(self:GetPlatoonPosition())
        end
        end

        if not basePosition then
            return
        end

        local mapSizeX, mapSizeZ = GetMapSize()
        local T4Radius = math.sqrt((mapSizeX * mapSizeX) + (mapSizeZ * mapSizeZ)) / 2
        local guardRadius = self.PlatoonData.GuardRadius or math.sqrt((mapSizeX * mapSizeX) + (mapSizeZ * mapSizeZ)) / 2

        while aiBrain:PlatoonExists(self) do
            target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.WALL)
            local newtarget = false
            if aiBrain.T4ThreatFound['Air'] then
                newtarget = self:FindClosestUnit('Attack', 'Enemy', true, categories.EXPERIMENTAL * categories.AIR)
                if newtarget then
                    target = newtarget
                end
            end
            if target and newtarget and not target.Dead and target:GetFractionComplete() == 1
            and SUtils.XZDistanceTwoVectorsSq(target:GetPosition(), basePosition) < T4Radius * T4Radius then
                blip = target:GetBlip(armyIndex)
                self:Stop()
                self:AttackTarget(target)
                patrolling = false
            elseif target and not target.Dead and SUtils.XZDistanceTwoVectorsSq(target:GetPosition(), basePosition) < guardRadius * guardRadius then
                self:Stop()
                self:AggressiveMoveToLocation(target:GetPosition())
                patrolling = false
            elseif not patrolling then
                local position = AIUtils.RandomLocation(basePosition[1],basePosition[3])
                self:MoveToLocation(position, false)
                for k,v in AIUtils.GetBasePatrolPoints(aiBrain, basePosition, radius, 'Air') do
                    self:Patrol(v)
                end
                patrolling = true
            end
            WaitSeconds(5)
        end
    end,
	
    NavalAttackSorianEdit = function(self)
        -- if 1==1 then
            -- self:HeroFightPlatoonSorianEdit()
            -- return
        -- end 
        AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        -- Search all platoon units and activate Stealth and Cloak (mostly Modded units)
        local platoonUnits = self:GetPlatoonUnits()
        local PlatoonStrength = table.getn(platoonUnits)
        local ExperimentalInPlatoon = false
        local NukeUnit
        local aiBrain = self:GetBrain()
        if platoonUnits and PlatoonStrength > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    if v:TestToggleCaps('RULEUTC_StealthToggle') then
                        v:SetScriptBit('RULEUTC_StealthToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_CloakToggle') then
                        v:SetScriptBit('RULEUTC_CloakToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_JammingToggle') then
                        v:SetScriptBit('RULEUTC_JammingToggle', false)
                    end
                    if EntityCategoryContains(categories.EXPERIMENTAL, v) then
                        ExperimentalInPlatoon = true
                    end
					if EntityCategoryContains(categories.SILO * categories.NUKE, v) then
						NukeUnit = v
					end
                    -- prevent units from reclaiming while attack moving
                    v:RemoveCommandCap('RULEUCC_Reclaim')
                    v:RemoveCommandCap('RULEUCC_Repair')
                end
            end
        end
        if NukeUnit then
            local bp = NukeUnit:GetBlueprint()
            local weapon = bp.Weapon[1]
            local maxRadius = weapon.MaxRadius
            local nukePos, oldTargetLocation
            NukeUnit:SetAutoMode(true)
            while aiBrain:PlatoonExists(self) do
                while NukeUnit:GetNukeSiloAmmoCount() < 1 do
                    WaitSeconds(11)
                    if not  aiBrain:PlatoonExists(self) then
                        return
                    end
                end

                nukePos = import('/lua/ai/aibehaviors.lua').GetHighestThreatClusterLocation(aiBrain, NukeUnit)
                if nukePos then
                    IssueNuke({NukeUnit}, nukePos)
                    WaitSeconds(10)
                    IssueClearCommands({NukeUnit})
                end
                WaitSeconds(1)
            end
        end
        local MoveToCategories = {}
        if self.PlatoonData.MoveToCategories then
            for k,v in self.PlatoonData.MoveToCategories do
                table.insert(MoveToCategories, v )
            end
        else
            LOG('* AI-SorianEdit: * NavalAttackSorianEdit: MoveToCategories missing in platoon '..self.BuilderName)
        end
        -- Set the target list to all platoon units
        local WeaponTargetCategories = {}
        if self.PlatoonData.WeaponTargetCategories then
            for k,v in self.PlatoonData.WeaponTargetCategories do
                table.insert(WeaponTargetCategories, v )
            end
        elseif self.PlatoonData.MoveToCategories then
            WeaponTargetCategories = MoveToCategories
        end
        self:SetPrioritizedTargetList('Attack', WeaponTargetCategories)
        local aiBrain = self:GetBrain()
        local target
        local bAggroMove = self.PlatoonData.AggressiveMove
        local maxRadius = self.PlatoonData.SearchRadius or 250
        local PlatoonPos = self:GetPlatoonPosition()
        local LastTargetPos = PlatoonPos
        local DistanceToTarget = 0
        local basePosition = PlatoonPos   -- Platoons will be created near a base, so we can return to this position if we don't have targets.
        local losttargetnum = 0
        local TargetSearchCategory = self.PlatoonData.TargetSearchCategory or 'ALLUNITS'
        while aiBrain:PlatoonExists(self) do
            PlatoonPos = self:GetPlatoonPosition()
            -- only get a new target and make a move command if the target is dead or after 10 seconds
            if not target or target.Dead then
                UnitWithPath, UnitNoPath, path, reason = AIUtils.AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, self, 'Attack', PlatoonPos, maxRadius, MoveToCategories, TargetSearchCategory, false )
                if UnitWithPath then
                    losttargetnum = 0
                    self:Stop()
                    target = UnitWithPath
                    LastTargetPos = table.copy(target:GetPosition())
                    DistanceToTarget = VDist2(PlatoonPos[1] or 0, PlatoonPos[3] or 0, LastTargetPos[1] or 0, LastTargetPos[3] or 0)
                    if DistanceToTarget > 30 then
                        -- if we have a path then use the waypoints
                        if self.PlatoonData.IgnorePathing then
                            self:Stop()
                            self:AttackTarget(UnitWithPath)
                        elseif path then
                            self:MovePathSorianEdit(aiBrain, path, bAggroMove, target)
                        -- if we dont have a path, but UnitWithPath is true, then we have no map markers but PathCanTo() found a direct path
                        else
                            self:MoveDirect(aiBrain, bAggroMove, target)
                        end
                        -- We moved to the target, attack it now if its still exists
                        if aiBrain:PlatoonExists(self) and UnitWithPath and not UnitWithPath.Dead and not UnitWithPath:BeenDestroyed() then
                            self:Stop()
                            self:AttackTarget(UnitWithPath)
                        end
                    end
                else
                    -- we have no target return to main base
                    losttargetnum = losttargetnum + 1
                    if losttargetnum > 2 then
                        if not self.SuicideMode then
                            self.SuicideMode = true
                            self.PlatoonData.AttackEnemyStrength = 100
                            self.PlatoonData.GetTargetsFromBase = false
                            self.PlatoonData.MoveToCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self.PlatoonData.WeaponTargetCategories = { categories.EXPERIMENTAL, categories.TECH3, categories.TECH2, categories.ALLUNITS }
                            self:Stop()
                            self:SetPlatoonFormationOverride('NoFormation')
                            self:NavalAttackSorianEdit()
                        else
                            self:Stop()
                            self:SetPlatoonFormationOverride('NoFormation')
                            self:ForceReturnToNavalBaseSorianEdit(aiBrain, basePosition)
                        end
                    end
                end
            else
                if aiBrain:PlatoonExists(self) and target and not target.Dead and not target:BeenDestroyed() then
                    LastTargetPos = target:GetPosition()
                    -- check if the target is not in a nuke blast area
                    self:SetPlatoonFormationOverride('AttackFormation')
                    self:AttackTarget(target)
                    WaitSeconds(2)
                end
            end
            WaitSeconds(1)
        end
    end,
	
    NavalHuntAISE = function(self)
        self:Stop()
        local aiBrain = self:GetBrain()
        local armyIndex = aiBrain:GetArmyIndex()
        local blip
        local cmd = false
        local platoonUnits = self:GetPlatoonUnits()
        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'
        local NukeUnit
        local MaxPlatoonWeaponArc = 'none'
        local MaxPlatoonWeaponRange
        self:SetPlatoonFormationOverride(PlatoonFormation)
        local atkPri = { 'SPECIALHIGHPRI', 'STRUCTURE ANTINAVY', 'MOBILE NAVAL', 'STRUCTURE NAVAL', 'COMMAND', 'EXPERIMENTAL', 'STRUCTURE STRATEGIC EXPERIMENTAL', 'ARTILLERY EXPERIMENTAL', 'STRUCTURE ARTILLERY TECH3', 'STRUCTURE NUKE TECH3', 'STRUCTURE ANTIMISSILE SILO',
                            'STRUCTURE DEFENSE DIRECTFIRE', 'TECH3 MASSFABRICATION', 'TECH3 ENERGYPRODUCTION', 'STRUCTURE STRATEGIC', 'STRUCTURE DEFENSE', 'STRUCTURE', 'MOBILE', 'SPECIALLOWPRI', 'ALLUNITS' }
        local atkPriTable = {}
        for k,v in atkPri do
            table.insert(atkPriTable, ParseEntityCategory(v))
        end
        self:SetPrioritizedTargetList('Attack', atkPriTable)
        local maxRadius = 60000
		
        if platoonUnits > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    for _, weapon in v:GetBlueprint().Weapon or {} do
                        -- unit can have MaxWeaponRange entry from the last platoon
						-- save the weaponrange 
						v.MaxWeaponRange = weapon.MaxRadius * 0.97 -- maxrange minus 3%
                        if not MaxPlatoonWeaponArc or MaxPlatoonWeaponArc == 'high' then
                            -- save the weapon balistic arc, we need this later to check if terrain is blocking the weapon line of sight
                            if weapon.BallisticArc == 'RULEUBA_LowArc' then
								v.WeaponArc = 'low'
                            elseif weapon.BallisticArc == 'RULEUBA_HighArc' then
                                v.WeaponArc = 'high'
                            end
                        end
                    end
					if not MaxPlatoonWeaponArc or MaxPlatoonWeaponArc == 'high' and v.WeaponArc == 'low' then
						MaxPlatoonWeaponArc = v.WeaponArc
					end
					if not MaxPlatoonWeaponRange or MaxPlatoonWeaponRange < v.MaxWeaponRange then
						MaxPlatoonWeaponRange = v.MaxWeaponRange
					end
					if v:TestToggleCaps('RULEUTC_StealthToggle') then
						v:SetScriptBit('RULEUTC_StealthToggle', true)
					end
					if v:TestToggleCaps('RULEUTC_CloakToggle') then
						v:SetScriptBit('RULEUTC_CloakToggle', true)
					end
					if v:TestToggleCaps('RULEUTC_JammingToggle') then
						v:SetScriptBit('RULEUTC_JammingToggle', true)
					end
					if EntityCategoryContains(categories.EXPERIMENTAL, v) then
						ExperimentalInPlatoon = true
					end
					if EntityCategoryContains(categories.SILO * categories.NUKE - categories.BATTLESHIP, v) then
						NukeUnit = v
					end
					-- prevent units from reclaiming while attack moving
					v:RemoveCommandCap('RULEUCC_Reclaim')
					v:RemoveCommandCap('RULEUCC_Repair')
					if v:GetCurrentLayer() == 'Sub' then
						continue
					end
					if v:TestCommandCaps('RULEUCC_Dive') and v.UnitId != 'uas0401' then
						IssueDive({v})
					end
                    if not v.MaxWeaponRange then
                        WARN('Scanning: unit ['..repr(v.UnitId)..'] has no MaxWeaponRange - '..repr(self.BuilderName))
                    end
                end
            end
        end
        if NukeUnit then
            local bp = NukeUnit:GetBlueprint()
            local weapon = bp.Weapon[1]
            local maxRadius = weapon.MaxRadius + 20
            local nukePos, oldTargetLocation
            NukeUnit:SetAutoMode(true)
            while aiBrain:PlatoonExists(self) do
                while NukeUnit:GetNukeSiloAmmoCount() < 1 do
                    if not  aiBrain:PlatoonExists(self) then
                        return
                    end
                    coroutine.yield(10)
                end

                nukePos = import('/lua/ai/aibehaviors.lua').GetHighestThreatClusterLocation(aiBrain, NukeUnit)
                if nukePos then
                    IssueNuke({NukeUnit}, nukePos)
                    IssueClearCommands({NukeUnit})
                end
                coroutine.yield(10)
            end
        end
        AIAttackUtils.GetMostRestrictiveLayer(self) -- this will set self.MovementLayer to the platoon
        while aiBrain:PlatoonExists(self) do
			self:Stop()
			-- patrol while we dont have a target
			scoutPath = AIUtils.AIGetSortedNavalLocations(self:GetBrain())
			for k, v in scoutPath do
				if NavUtils.CanPathTo(self.MovementLayer, self:GetPlatoonPosition(), v) then
					self:AggressiveMoveToLocation(v)
				end
			end
			-- look for a target
			local target, NavalBombardPos
			while not target do
				target, NavalBombardPos = AIUtils.AIFindNearestCategoryTargetInLongRangeSorianEdit(aiBrain, self, self:GetPlatoonPosition(), maxRadius, atkPriTable, categories.ALLUNITS, aiBrain:GetCurrentEnemy(), true, MaxPlatoonWeaponRange, MaxPlatoonWeaponArc)
				if not target then
					target = self:FindClosestUnit('Attack', 'Enemy', true, categories.MOBILE * categories.NAVAL - categories.WALL)
				end
				if not target then
					target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.WALL - categories.SCOUT - categories.AIR)
				end
				coroutine.yield(10)
			end
			-- stop patrolling
			self:Stop()
            if target then
                -- blip = target:GetBlip(armyIndex)
                self:Stop()
				if not NavalBombardPos then
					cmd = self:AggressiveMoveToLocation(target:GetPosition())
				elseif NavalBombardPos then
					cmd = self:MoveToLocation(NavalBombardPos)
				end
				while not target.Dead do
					coroutine.yield(10)
				end
            end
            coroutine.yield(10)
        end
    end,
	
    SorianManagerEngineerAssistAI = function(self)
        self:ManagerEngineerAssistAI()
    end,
	
    MassRaidRNG = function(self)
        local aiBrain = self:GetBrain()
        --LOG('Platoon ID is : '..self:GetPlatoonUniqueName())
        local platLoc = GetPlatoonPosition(self)

        if not PlatoonExists(aiBrain, self) or not platLoc then
            return
        end

        -----------------------------------------------------------------------
        -- Platoon Data
        -----------------------------------------------------------------------
        -- Include mass markers that are under water
        local includeWater = self.PlatoonData.IncludeWater or false

        local waterOnly = self.PlatoonData.WaterOnly or false

        -- Minimum distance when looking for closest
        local avoidClosestRadius = self.PlatoonData.AvoidClosestRadius or 0

        -- if true, look to guard highest threat, otherwise,
        -- guard the lowest threat specified
        local bFindHighestThreat = self.PlatoonData.FindHighestThreat or false

        -- minimum threat to look for
        local minThreatThreshold = self.PlatoonData.MinThreatThreshold or -1
        -- maximum threat to look for
        local maxThreatThreshold = self.PlatoonData.MaxThreatThreshold  or 99999999

        -- Avoid bases (true or false)
        local bAvoidBases = self.PlatoonData.AvoidBases or false

        -- Radius around which to avoid the main base
        local avoidBasesRadius = self.PlatoonData.AvoidBasesRadius or 0

        -- Use Aggresive Moves Only
        local bAggroMove = self.PlatoonData.AggressiveMove or false

        local PlatoonFormation = self.PlatoonData.UseFormation or 'NoFormation'

        local maxPathDistance = self.PlatoonData.MaxPathDistance or 200

        -----------------------------------------------------------------------
        local markerLocations
        local enemyRadius = 40
        local MaxPlatoonWeaponRange
        local atkPri = {}
        local categoryList = {}

        AIAttackUtils.GetMostRestrictiveLayer(self)
        self:SetPlatoonFormationOverride(PlatoonFormation)
        local platoonUnits = GetPlatoonUnits(self)
        if platoonUnits > 0 then
            for k, v in platoonUnits do
                if not v.Dead then
                    for _, weapon in v:GetBlueprint().Weapon or {} do
                        -- unit can have MaxWeaponRange entry from the last platoon
                        if not v.MaxWeaponRange or weapon.MaxRadius > v.MaxWeaponRange then
                            -- save the weaponrange 
                            v.MaxWeaponRange = weapon.MaxRadius * 0.9 -- maxrange minus 10%
                            -- save the weapon balistic arc, we need this later to check if terrain is blocking the weapon line of sight
                            if weapon.BallisticArc == 'RULEUBA_LowArc' then
                                v.WeaponArc = 'low'
                            elseif weapon.BallisticArc == 'RULEUBA_HighArc' then
                                v.WeaponArc = 'high'
                            else
                                v.WeaponArc = 'none'
                            end
                        end
                        if not MaxPlatoonWeaponRange or MaxPlatoonWeaponRange < v.MaxWeaponRange then
                            MaxPlatoonWeaponRange = v.MaxWeaponRange
                        end
                    end
                    if v:TestToggleCaps('RULEUTC_StealthToggle') then
                        v:SetScriptBit('RULEUTC_StealthToggle', false)
                    end
                    if v:TestToggleCaps('RULEUTC_CloakToggle') then
                        v:SetScriptBit('RULEUTC_CloakToggle', false)
                    end
                    -- prevent units from reclaiming while attack moving
                    v:RemoveCommandCap('RULEUCC_Reclaim')
                    v:RemoveCommandCap('RULEUCC_Repair')
                    v.smartPos = {0,0,0}
                    if not v.MaxWeaponRange then
                        WARN('Scanning: unit ['..repr(v.UnitId)..'] has no MaxWeaponRange - '..repr(self.BuilderName))
                    end
                end
            end
        end

        if self.PlatoonData.TargetSearchPriorities then
            --LOG('TargetSearch present for '..self.BuilderName)
            for k,v in self.PlatoonData.TargetSearchPriorities do
                table.insert(atkPri, v)
            end
        else
            if self.PlatoonData.PrioritizedCategories then
                for k,v in self.PlatoonData.PrioritizedCategories do
                    table.insert(atkPri, v)
                end
            end
        end
        if self.PlatoonData.PrioritizedCategories then
            for k,v in self.PlatoonData.PrioritizedCategories do
                table.insert(categoryList, v)
            end
        end

        markerLocations = SUtils.AIGetMassMarkerLocations(aiBrain, includeWater, waterOnly)
        
        local bestMarker = false

        if not self.LastMarker then
            self.LastMarker = {nil,nil}
        end

        -- look for a random marker
        --[[Marker table examples for better understanding what is happening below 
        info: Marker Current{ Name="Mass7", Position={ 189.5, 24.240200042725, 319.5, type="VECTOR3" } }
        info: Marker Last{ { 374.5, 20.650400161743, 154.5, type="VECTOR3" } }
        ]] 

        local bestMarkerThreat = 0
        if not bFindHighestThreat then
            bestMarkerThreat = 99999999
        end

        local bestDistSq = 99999999
        -- find best threat at the closest distance
        for _,marker in markerLocations do
            local markerThreat
            local enemyThreat
            markerThreat = GetThreatAtPosition(aiBrain, marker.Position, 0, true, 'Economy')
            if self.MovementLayer == 'Water' then
                enemyThreat = GetThreatAtPosition(aiBrain, marker.Position, 1, true, 'AntiSub')
            else
                enemyThreat = GetThreatAtPosition(aiBrain, marker.Position, 1, true, 'AntiSurface')
            end
            --LOG('Best pre calculation marker threat is '..markerThreat..' at position'..repr(marker.Position))
            --LOG('Surface Threat at marker is '..enemyThreat..' at position'..repr(marker.Position))
            if enemyThreat > 1 and markerThreat then
                markerThreat = markerThreat / enemyThreat
            end
            --LOG('Best marker threat is '..markerThreat..' at position'..repr(marker.Position))
            local distSq = VDist2Sq(marker.Position[1], marker.Position[3], platLoc[1], platLoc[3])

            if markerThreat >= minThreatThreshold and markerThreat <= maxThreatThreshold then
                if self:AvoidsBases(marker.Position, bAvoidBases, avoidBasesRadius) then
                    if self.IsBetterThreat(bFindHighestThreat, markerThreat, bestMarkerThreat) then
                        bestDistSq = distSq
                        bestMarker = marker
                        bestMarkerThreat = markerThreat
                    elseif markerThreat == bestMarkerThreat then
                        if distSq < bestDistSq then
                            bestDistSq = distSq
                            bestMarker = marker
                            bestMarkerThreat = markerThreat
                        end
                    end
                end
            end
        end
        --[[
        if waterOnly then
            if bestMarker then
                LOG('Water based best marker is  '..repr(bestMarker))
                LOG('Best marker threat is '..bestMarkerThreat)
            else
                LOG('Water based no best marker')
            end
        end]]

        --LOG('* AI-RNG: Best Marker Selected is at position'..repr(bestMarker.Position))
        
        if bestMarker.Position == nil and GetGameTimeSeconds() > 900 and self.MovementLayer ~= 'Water' then
            --LOG('Best Marker position was nil and game time greater than 15 mins, switch to hunt ai')
            return self:HuntAISorianEdit()
        elseif bestMarker.Position == nil then
            --LOG('Best Marker position was nil, select random')
            if table.getn(markerLocations) <= 2 then
                self.LastMarker[1] = nil
                self.LastMarker[2] = nil
            end
            for _,marker in RandomIter(markerLocations) do
                if table.getn(markerLocations) <= 2 then
                    self.LastMarker[1] = nil
                     self.LastMarker[2] = nil
                end
                if self:AvoidsBases(marker.Position, bAvoidBases, avoidBasesRadius) then
                    if self.LastMarker[1] and marker.Position[1] == self.LastMarker[1][1] and marker.Position[3] == self.LastMarker[1][3] then
                        continue
                    end
                    if self.LastMarker[2] and marker.Position[1] == self.LastMarker[2][1] and marker.Position[3] == self.LastMarker[2][3] then
                        continue
                    end
                    bestMarker = marker
                    break
                end
            end
        end

        local usedTransports = false

        if bestMarker then
            self.LastMarker[2] = self.LastMarker[1]
            self.LastMarker[1] = bestMarker.Position
            --LOG("GuardMarker: Attacking " .. bestMarker.Name)
            local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, self.MovementLayer, GetPlatoonPosition(self), bestMarker.Position, 100 , maxPathDistance)
            local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingExSE(self, bestMarker.Position)
            IssueClearCommands(GetPlatoonUnits(self))
            if path then
                local position = GetPlatoonPosition(self)
                if not success or VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 512 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, true)
                elseif VDist2(position[1], position[3], bestMarker.Position[1], bestMarker.Position[3]) > 256 then
                    usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, false)
                end
                if usedTransports then
                    --LOG('usedTransports is true')
                end
                if not usedTransports then
                    local pathLength = table.getn(path)
                    for i=1, pathLength - 1 do
                        --LOG('* AI-RNG: * MassRaidRNG: moving to destination. i: '..i..' coords '..repr(path[i]))
                        if bAggroMove then
                            self:AggressiveMoveToLocation(path[i])
                        else
                            self:MoveToLocation(path[i], false)
                        end
                        --LOG('* AI-RNG: * MassRaidRNG: moving to Waypoint')
                        local PlatoonPosition
                        local Lastdist
                        local dist
                        local Stuck = 0
                        while PlatoonExists(aiBrain, self) do
                            PlatoonPosition = GetPlatoonPosition(self) or nil
                            if not PlatoonPosition then break end
                            dist = VDist2Sq(path[i][1], path[i][3], PlatoonPosition[1], PlatoonPosition[3])
                            -- are we closer then 15 units from the next marker ? Then break and move to the next marker
                            if dist < 400 then
                                -- If we don't stop the movement here, then we have heavy traffic on this Map marker with blocking units
                                self:Stop()
                                break
                            end
                            -- Do we move ?
                            if Lastdist ~= dist then
                                Stuck = 0
                                Lastdist = dist
                            -- No, we are not moving, wait 100 ticks then break and use the next weaypoint
                            else
                                Stuck = Stuck + 1
                                if Stuck > 15 then
                                    --LOG('* AI-RNG: * MassRaidRNG: Stucked while moving to Waypoint. Stuck='..Stuck..' - '..repr(path[i]))
                                    self:Stop()
                                    break
                                end
                            end
                            if bAggroMove then
                                local enemyUnitCount = GetNumUnitsAroundPoint(aiBrain, categories.MOBILE * categories.LAND - categories.SCOUT - categories.ENGINEER, PlatoonPosition, enemyRadius, 'Enemy')
                                if enemyUnitCount > 0 then
                                    -- local target = self:FindClosestUnit('Attack', 'Enemy', true, categories.ALLUNITS - categories.NAVAL - categories.AIR - categories.SCOUT - categories.WALL)
                                    local target = SUtils.AIFindBrainTargetInCloseRangeRNG(aiBrain, self, PlatoonPosition, 'Attack', enemyRadius, categories.ALLUNITS - categories.NAVAL - categories.AIR - categories.SCOUT - categories.WALL, atkPri, false)
                                    local attackSquad = self:GetSquadUnits('Attack')
                                    IssueClearCommands(attackSquad)
                                    while PlatoonExists(aiBrain, self) do
                                        if target and not target.Dead then
                                            local targetPosition = target:GetPosition()
                                            microCap = 50
                                            for _, unit in attackSquad do
                                                microCap = microCap - 1
                                                if microCap <= 0 then break end
                                                if unit.Dead then continue end
                                                if not unit.MaxWeaponRange then
                                                    continue
                                                end
                                                unitPos = unit:GetPosition()
                                                alpha = math.atan2 (targetPosition[3] - unitPos[3] ,targetPosition[1] - unitPos[1])
                                                x = targetPosition[1] - math.cos(alpha) * (unit.MaxWeaponRange or MaxPlatoonWeaponRange)
                                                y = targetPosition[3] - math.sin(alpha) * (unit.MaxWeaponRangeor or MaxPlatoonWeaponRange)
                                                smartPos = { x, GetTerrainHeight( x, y), y }
                                                -- check if the move position is new or target has moved
                                                if VDist2( smartPos[1], smartPos[3], unit.smartPos[1], unit.smartPos[3] ) > 0.7 or unit.TargetPos ~= targetPosition then
                                                    -- clear move commands if we have queued more than 4
                                                    if table.getn(unit:GetCommandQueue()) > 2 then
                                                        IssueClearCommands({unit})
                                                        coroutine.yield(3)
                                                    end
                                                    -- if our target is dead, jump out of the "for _, unit in self:GetPlatoonUnits() do" loop
                                                    IssueMove({unit}, smartPos )
                                                    if target.Dead then break end
                                                    IssueAttack({unit}, target)
                                                    --unit:SetCustomName('Fight micro moving')
                                                    unit.smartPos = smartPos
                                                    unit.TargetPos = targetPosition
                                                -- in case we don't move, check if we can fire at the target
                                                else
                                                    local dist = VDist2( unit.smartPos[1], unit.smartPos[3], unit.TargetPos[1], unit.TargetPos[3] )
                                                    if targetPosition and aiBrain:CheckBlockingTerrain(unitPos, targetPosition, unit.WeaponArc) then
                                                        --unit:SetCustomName('Fight micro WEAPON BLOCKED!!! ['..repr(target.UnitId)..'] dist: '..dist)
                                                        IssueMove({unit}, targetPosition )
                                                    else
                                                        --unit:SetCustomName('Fight micro SHOOTING ['..repr(target.UnitId)..'] dist: '..dist)
                                                    end
                                                end
                                            end
                                        else
                                            break
                                        end
                                    WaitTicks(10)
                                    end
                                end
                            end
                            WaitTicks(15)
                        end
                    end
                end
            elseif (not path and reason == 'NoPath') then
                --LOG('Guardmarker requesting transports')
                usedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, self, bestMarker.Position, true)
                --DUNCAN - if we need a transport and we cant get one the disband
                if not usedTransports then
                    --LOG('MASSRAID no transports')
                    self:PlatoonDisband()
                    return
                end
                --LOG('Guardmarker found transports')
            else
                --LOG('Path error in MASSRAID')
                self:PlatoonDisband()
                return
            end
            if usedTransports then
                --LOG('usedTransports is true')
            end

            if (not path or not success) and not usedTransports then
                --LOG('not path or not success or not usedTransports MASSRAID')
                self:PlatoonDisband()
                return
            end
            
            if aiBrain:CheckBlockingTerrain(GetPlatoonPosition(self), bestMarker.Position, 'none') then
                self:MoveToLocation(bestMarker.Position, false)
            else
                self:AggressiveMoveToLocation(bestMarker.Position)
            end

            -- wait till we get there
            local oldPlatPos = GetPlatoonPosition(self)
            local StuckCount = 0
            repeat
                WaitTicks(50)
                platLoc = GetPlatoonPosition(self)
                if VDist3(oldPlatPos, platLoc) < 1 then
                    StuckCount = StuckCount + 1
                else
                    StuckCount = 0
                end
                if StuckCount > 5 then
                    LOG('MassRaidAI stuck count over 5, restarting')
					WaitTicks(10)
                    return self:MassRaidRNG()
                end
                oldPlatPos = platLoc
            until VDist2Sq(platLoc[1], platLoc[3], bestMarker.Position[1], bestMarker.Position[3]) < 64 or not PlatoonExists(aiBrain, self)

            -- we're there... wait here until we're done
            local numGround = GetNumUnitsAroundPoint(aiBrain, (categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            while numGround > 0 and PlatoonExists(aiBrain, self) do
                WaitTicks(Random(50,100))
                --LOG('Still enemy stuff around marker position')
                numGround = GetNumUnitsAroundPoint(aiBrain, (categories.LAND + categories.NAVAL + categories.STRUCTURE), bestMarker.Position, 15, 'Enemy')
            end

            if not PlatoonExists(aiBrain, self) then
                return
            end
            LOG('MassRaidAI restarting')
			WaitTicks(10)
            return self:MassRaidRNG()
        else
            -- no marker found, disband!
            --LOG('no marker found, disband MASSRAID')
            self:PlatoonDisband()
        end
		WaitTicks(50)
    end,

    TMLAISE = function(self)
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local TML
        for k, v in platoonUnits do
            if not v.Dead and EntityCategoryContains(categories.STRUCTURE * categories.TACTICALMISSILEPLATFORM * categories.TECH2, v) then
                TML = v
                break
            end
        end
        SUtils.TMLAIThread(self,TML,aiBrain)
        self:PlatoonDisband()
    end,
}