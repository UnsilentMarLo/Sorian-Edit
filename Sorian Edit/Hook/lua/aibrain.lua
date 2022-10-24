WARN('[sorianeditutilities.lua ------------------------ '..debug.getinfo(1).currentline..'] ----------------------------- File Offset.')

local MapInfo = import('/mods/Sorian Edit/lua/AI/mapinfo.lua')
local Utilities = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')
local AIAttackUtils = import('/lua/AI/aiattackutilities.lua')
local SUtils = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua')
local NavGenerator = import('/lua/sim/NavGenerator.lua')

OlderOldSorianEditAIBrainClass = AIBrain
AIBrain = Class(OlderOldSorianEditAIBrainClass) {

    -- For AI Patch V8 (Patched) add BaseType for function SEGetManagerCount
    -- Hook AI-SorianEdit. Removing the StrategyManager
    AddBuilderManagers = function(self, position, radius, baseName, useCenter)
       -- Only use this with AI-SorianEdit
        if not self.sorianedit and not self.sorianeditadaptivecheat and not self.sorianeditadaptive then
            return OlderOldSorianEditAIBrainClass.AddBuilderManagers(self, position, radius, baseName, useCenter)
        end
        self.BuilderManagers[baseName] = {
            FactoryManager = FactoryManager.CreateFactoryBuilderManager(self, baseName, position, radius, useCenter),
            PlatoonFormManager = PlatoonFormManager.CreatePlatoonFormManager(self, baseName, position, radius, useCenter),
            EngineerManager = EngineerManager.CreateEngineerManager(self, baseName, position, radius),
            StrategyManager = StratManager.CreateStrategyManager(self, baseName, position, radius),

            -- Table to track consumption
            MassConsumption = {
                Resources = {Units = {}, Drain = 0, },
                Units = {Units = {}, Drain = 0, },
                Defenses = {Units = {}, Drain = 0, },
                Upgrades = {Units = {}, Drain = 0, },
                Engineers = {Units = {}, Drain = 0, },
                TotalDrain = 0,
            },
            BuilderHandles = {},
            Position = position,
            BaseType = Scenario.MasterChain._MASTERCHAIN_.Markers[baseName].type or 'MAIN',
        }
        self.NumBases = self.NumBases + 1
    end,

    -- Hook AI-SorianEdit, set self.SorianEdit = true
    OnCreateAI = function(self, planName)
        OlderOldSorianEditAIBrainClass.OnCreateAI(self, planName)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality
        if string.find(per, 'sorianedit') or string.find(per, 'sorianeditadaptive') or string.find(per, 'sorianeditadaptivecheat') then
		
			if not NavGenerator.IsGenerated() then
				NavGenerator.Generate()
			end
			
            local iArmyNo = tonumber(string.sub(self.Name, 6 ))
            local iBuildDistance = self:GetUnitBlueprint('UAL0001').Economy.MaxBuildDistance
			
            self.sorianedit = true
            self.WantedDefensivePoints = {},
            self:ForkThread(self.SEParseIntelThread)
            self:ForkThread(self.TauntThread)
			
            MapInfo.RecordResourceLocations()
            MapInfo.RecordPlayerStartLocations(self)
            MapInfo.RecordMexNearStartPosition(iArmyNo, iBuildDistance + 10)
            MapInfo.RecordAttackVectorsStartPosition(self)
            self:ForkThread(self.DefensivePointsThread)
			
            -- self:ForkThread(self.VisualThread)
            -- MapInfo.EvaluateNavalAreas(iArmyNo)
            LOG('*------------------------------- AI-sorian: OnCreateAI() found AI-sorian  Name: ('..self.Name..') - personality: ('..per..') Army spawn: ('..repr(iArmyNo)..') ')
        end
    end,
	
    -- SKIRMISH AI HELPER SYSTEMS
    InitializeSkirmishSystems = function(self)
        OlderOldSorianEditAIBrainClass.InitializeSkirmishSystems(self)
        if self.sorianedit then
            self.EnemyPickerThread = self:ForkThread(self.PickEnemySorianEdit)
        else
            self.EnemyPickerThread = self:ForkThread(self.PickEnemy)
        end
    end,
	
    SEBaseMonitorThread = function(self)
       -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SEBaseMonitorThread(self)
        end
        coroutine.yield(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    SEEconomyMonitor = function(self)
        -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SEEconomyMonitor(self)
        end
        coroutine.yield(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(self.SEEconomyMonitorThread)
        self.SEEconomyMonitorThread = nil
    end,

   SEExpansionHelpThread = function(self)
       -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SEExpansionHelpThread(self)
        end
        coroutine.yield(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    SEInitializeEconomyState = function(self)
        -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SEInitializeEconomyState(self)
        end
    end,

    SEOnIntelChange = function(self, blip, reconType, val)
        -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SEOnIntelChange(self, blip, reconType, val)
        end
    end,

    SESetupAttackVectorsThread = function(self)
       -- Only use this with AI-SorianEdit
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.SESetupAttackVectorsThread(self)
        end
        coroutine.yield(10)
        -- We are leaving this forked thread here because we don't need it.
        KillThread(CurrentThread())
    end,

    SEParseIntelThread = function(self)
        while self.sorianedit do
            WaitTicks(50)
            allyScore = 0
            enemyScore = 0

            for k, brain in ArmyBrains do
                if ArmyIsCivilian(brain:GetArmyIndex()) then
                elseif IsAlly( self:GetArmyIndex(), brain:GetArmyIndex() ) then
                    allyScore = allyScore + table.getn(self:GetListOfUnits( categories.MOBILE * categories.AIR - categories.ENGINEER - categories.SCOUT, false, false))
                elseif IsEnemy( self:GetArmyIndex(), brain:GetArmyIndex() ) then
                    enemyScore = enemyScore + table.getn(brain:GetListOfUnits( categories.MOBILE * categories.AIR - categories.ENGINEER - categories.SCOUT, false, false))
                end
            end

            if enemyScore ~= 0 then
                if allyScore == 0 then
                   allyScore = 1
                end
                self.MyAirRatio = allyScore / enemyScore
            else
                self.MyAirRatio = 0.01
            end
        end
    end,
	
    DefensivePointsThread = function(self)
        while self.sorianedit do
			self.WantedDefensivePoints = {}
			
			if self:GetCurrentEnemy() then
				local estartX, estartZ = self:GetCurrentEnemy():GetArmyStartPos()
				local selfIndex = tonumber(string.sub(self.Name, 6 ))
				local maxdist = VDist2Sq(estartX, estartZ, MapInfo.PlayerStartPoints[selfIndex][1], MapInfo.PlayerStartPoints[selfIndex][3])
				for k, DefensivePoint in MapInfo.ArmyVectorPoints[selfIndex] do
					if VDist2Sq(DefensivePoint[1], DefensivePoint[3], estartX, estartZ) <= maxdist then
						self.WantedDefensivePoints[k] = DefensivePoint
					end
				end
			end
			coroutine.yield(60)
        end
    end,
	
    VisualThread = function(self)
        while self.sorianedit do
			for k, ArmyPoints in MapInfo.ArmyVectorPoints do
				local pos = MapInfo.PlayerStartPoints[k]
				for kp, vp in ArmyPoints do
					DrawCircle(vp, 10, '09FF00')
					DrawLinePop(vp, pos, '09FF00')
				end
			end
			for kp, dp in self.WantedDefensivePoints do
				DrawCircle(dp, 10, 'F54242')
			end
			coroutine.yield(1)
        end
    end,
	
    PickEnemySorianEdit = function(self)
		-- LOG('* AI-SorianEdit: PickEnemySorianEdit: --------------- PickEnemySorianEdit Thread started')
        self.targetoveride = false
        while true do
            self:PickEnemyLogicSorianEdit(true)
            WaitSeconds(120)
        end
    end,
	
    ---@param self AIBrain
    BuildScoutLocationsSorianEdit = function(self)
        local aiBrain = self
        local opponentStarts = {}
        local allyStarts = {}
        if not aiBrain.InterestList then
            aiBrain.InterestList = {}
            aiBrain.IntelData.HiPriScouts = 0
            aiBrain.IntelData.AirHiPriScouts = 0
            aiBrain.IntelData.AirLowPriScouts = 0

            -- Add each enemy's start location to the InterestList as a new sub table
            aiBrain.InterestList.HighPriority = {}
            aiBrain.InterestList.LowPriority = {}
            aiBrain.InterestList.MustScout = {}

            local myArmy = ScenarioInfo.ArmySetup[self.Name]

            if ScenarioInfo.Options.TeamSpawn == 'fixed' then
                -- Spawn locations were fixed. We know exactly where our opponents are.
                -- Don't scout areas owned by us or our allies.
                local numOpponents = 0
                for i = 1, 16 do
                    local army = ScenarioInfo.ArmySetup['ARMY_' .. i]
                    local startPos = ScenarioUtils.GetMarker('ARMY_' .. i).position

                    if army and startPos then
                        if army.ArmyIndex ~= myArmy.ArmyIndex and (army.Team ~= myArmy.Team or army.Team == 1) then
                            -- Add the army start location to the list of interesting spots.
                            opponentStarts['ARMY_' .. i] = startPos
                            numOpponents = numOpponents + 1
                            table.insert(aiBrain.InterestList.HighPriority,
                                {
                                    Position = startPos,
                                    Type = 'StructuresNotMex',
                                    LastScouted = 0,
                                    LastUpdate = 0,
                                    Threat = 75,
                                    Permanent = true,
                                }
                            )
                        else
                            allyStarts['ARMY_' .. i] = startPos
                        end
                    end
                end
                aiBrain.NumOpponents = numOpponents

                -- For each vacant starting location, check if it is closer to allied or enemy start locations (within 100 ogrids)
                -- If it is closer to enemy territory, flag it as high priority to scout.
                local starts = AIUtils.AIGetMarkerLocations(aiBrain, 'Start Location')
                for _, loc in starts do
                    -- If vacant
                    if not opponentStarts[loc.Name] and not allyStarts[loc.Name] then
                        local closestDistSq = 999999999
                        local closeToEnemy = false

                        for _, pos in opponentStarts do
                            local distSq = VDist2Sq(pos[1], pos[3], loc.Position[1], loc.Position[3])
                            -- Make sure to scout for bases that are near equidistant by giving the enemies 100 ogrids
                            if distSq-10000 < closestDistSq then
                                closestDistSq = distSq-10000
                                closeToEnemy = true
                            end
                        end

                        for _, pos in allyStarts do
                            local distSq = VDist2Sq(pos[1], pos[3], loc.Position[1], loc.Position[3])
                            if distSq < closestDistSq then
                                closestDistSq = distSq
                                closeToEnemy = false
                                break
                            end
                        end

                        if closeToEnemy then
                            table.insert(aiBrain.InterestList.LowPriority,
                                {
                                    Position = loc.Position,
                                    Type = 'StructuresNotMex',
                                    LastScouted = 0,
                                    LastUpdate = 0,
                                    Threat = 0,
                                    Permanent = true,
                                }
                            )
                        end
                    end
                end
            else -- Spawn locations were random. We don't know where our opponents are. Add all non-ally start locations to the scout list
                local numOpponents = 0
                for i = 1, 16 do
                    local army = ScenarioInfo.ArmySetup['ARMY_' .. i]
                    local startPos = ScenarioUtils.GetMarker('ARMY_' .. i).position

                    if army and startPos then
                        if army.ArmyIndex == myArmy.ArmyIndex or (army.Team == myArmy.Team and army.Team ~= 1) then
                            allyStarts['ARMY_' .. i] = startPos
                        else
                            numOpponents = numOpponents + 1
                        end
                    end
                end
                aiBrain.NumOpponents = numOpponents

                -- If the start location is not ours or an ally's, it is suspicious
                local starts = AIUtils.AIGetMarkerLocations(aiBrain, 'Start Location')
                for _, loc in starts do
                    -- If vacant
                    if not allyStarts[loc.Name] then
                        table.insert(aiBrain.InterestList.HighPriority,
                            {
                                Position = loc.Position,
                                LastScouted = 0,
                                LastUpdate = 0,
                                Threat = 0,
                                Permanent = true,
                            }
                        )
                    end
                end
            end

			-- also scout Expansion points
			local Expansionpointslarge = AIUtils.AIGetMarkerLocations(aiBrain, 'Large Expansion Area')
			for _, loc in Expansionpointslarge do
				-- If vacant
				table.insert(aiBrain.InterestList.HighPriority,
					{
						Position = loc.Position,
						LastScouted = 0,
						LastUpdate = 0,
						Threat = 0,
						Permanent = true,
					}
				)
			end
			
			-- also scout small Expansion points
			local Expansionpointssmall = AIUtils.AIGetMarkerLocations(aiBrain, 'Expansion Area')
			for _, loc in Expansionpointslarge do
				-- If vacant
				table.insert(aiBrain.InterestList.LowPriority,
					{
						Position = loc.Position,
						LastScouted = 0,
						LastUpdate = 0,
						Threat = 0,
						Permanent = true,
					}
				)
			end

            aiBrain:ForkThread(self.ParseIntelThreadSorian)
        end
    end,

    PickEnemyLogicSorianEdit = function(self, brainbool)
		-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- PickEnemyLogicSorianEdit called')
        local armyStrengthTable = {}
        local selfIndex = self:GetArmyIndex()
        for _, v in ArmyBrains do
            local insertTable = {
                Enemy = true,
                Strength = 0,
                Position = false,
                Brain = v,
            }
            -- Share resources with friends but don't regard their strength
            if IsAlly(selfIndex, v:GetArmyIndex()) then
                self:SetResourceSharing(true)
                insertTable.Enemy = false
            elseif not IsEnemy(selfIndex, v:GetArmyIndex()) then
                insertTable.Enemy = false
            end

            insertTable.Position, insertTable.Strength = self:GetHighestThreatPosition(2, true, 'Structures', v:GetArmyIndex())
            armyStrengthTable[v:GetArmyIndex()] = insertTable
        end

		local findEnemy = false
		if ((not self:GetCurrentEnemy()) or brainbool) and not self.targetoveride then
			findEnemy = true
		elseif self:GetCurrentEnemy() then
			local cIndex = self:GetCurrentEnemy():GetArmyIndex()
			-- If our enemy has been defeated or has less than 20 strength, we need a new enemy
			if self:GetCurrentEnemy():IsDefeated() or armyStrengthTable[cIndex].Strength < 20 then
				findEnemy = true
			end
		end
		
		if findEnemy then
			local enemyStrength = false
			local enemy = false
			
			-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- findEnemy called: ')

			for k, v in armyStrengthTable do
				-- Dont' target self
				if k == selfIndex then
					continue
				end

				-- Ignore allies
				if not v.Enemy then
					continue
				end

				-- -- If we have a better candidate; ignore really weak enemies
				-- if enemy and v.Strength < 20 then
					-- continue
				-- end

				-- The closer targets are worth more because then we get their mass spots
				local distanceWeight = 0.1
				local distance = VDist3(self:GetStartVector3f(), v.Position)
				local threatWeight = (1 / (distance * distanceWeight)) * v.Strength
				if not enemy or (threatWeight > enemyStrength) then
					if self:EvaluatePathForNewEnemy(v, v.Position) then
					-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- EvaluatePathForNewEnemy returned true')
					enemyStrength = threatWeight * 10
					enemy = v.Brain
					else
					enemyStrength = threatWeight
					enemy = v.Brain
					end
				end
			end

			if enemy then
				if not self:GetCurrentEnemy() or self:GetCurrentEnemy() ~= enemy then
					import('/lua/AI/sorianutilities.lua').AISendChat('allies', ArmyBrains[self:GetArmyIndex()].Nickname, 'targetchat', ArmyBrains[enemy:GetArmyIndex()].Nickname)
				end
				self:SetCurrentEnemy(enemy)
			end
		end
    end,

	EvaluatePathForNewEnemy = function(self, PotentialEnemy, pos)
	-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- EvaluatePathForNewEnemy called: ')
    -- We have no cached path. Searching now for a path.
    local startX, startZ = self:GetArmyStartPos()

    -- path wit AI markers from our base to the enemy base
	-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- EvaluatePathForNewEnemy calling: PlatoonGenerateSafePathToSorianEdit')
    local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(self, 'Land', {startX,0,startZ}, pos, 10, 10000)
	-- LOG('* AI-SorianEdit: PickEnemyLogicSorianEdit: --------------- EvaluatePathForNewEnemy called: PlatoonGenerateSafePathToSorianEdit with reason:'..repr(reason))
    -- if we have a path generated with AI path markers then....
		if path then
            -- SUtils.VisualizeEnemy(self, path) does not work
			return true
		-- if we not have a path
		end
		return false
    end
}
