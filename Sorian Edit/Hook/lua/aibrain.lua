WARN('[sorianeditutilities.lua ------------------------ '..debug.getinfo(1).currentline..'] ----------------------------- File Offset.')

local MapInfo = import('/mods/Sorian Edit/lua/AI/mapinfo.lua')
local Utilities = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')
local AIAttackUtils = import('/lua/AI/aiattackutilities.lua')
local SUtils = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua')

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
			
            local iArmyNo = tonumber(string.sub(self.Name, 6 ))
            local iBuildDistance = self:GetUnitBlueprint('UAL0001').Economy.MaxBuildDistance
			
            self.sorianedit = true
            self:ForkThread(self.SEParseIntelThread)
            self:ForkThread(self.TauntThread)
			
            MapInfo.RecordResourceLocations()
            MapInfo.RecordPlayerStartLocations(self)
            MapInfo.RecordMexNearStartPosition(iArmyNo, iBuildDistance + 10)
            -- MapInfo.EvaluateNavalAreas(iArmyNo)
            LOG('*------------------------------- AI-sorian: OnCreateAI() found AI-sorian  Name: ('..self.Name..') - personality: ('..per..') Army spawn: ('..repr(iArmyNo)..') ')
        end
    end,
	
    -- SKIRMISH AI HELPER SYSTEMS
    InitializeSkirmishSystems = function(self)
        if not self.sorianedit then
            return OlderOldSorianEditAIBrainClass.InitializeSkirmishSystems(self)
        end
        if self.sorianedit then
            self.EnemyPickerThread = self:ForkThread(self.PickEnemySorianEdit)
        end
    end,

    SEParseIntelThread = function(self)
        while self.sorianedit do
            WaitTicks(120)
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

            if not self.InterestList or not self.InterestList.MustScout then
                error('Scouting areas must be initialized before calling AIBrain:ParseIntelThread.', 2)
            end
            if not self.T4ThreatFound then
                self.T4ThreatFound = {}
            end
            if not self.AttackPoints then
                self.AttackPoints = {}
            end
            if not self.AirAttackPoints then
                self.AirAttackPoints = {}
            end
            if not self.TacticalBases then
                self.TacticalBases = {}
            end
    
            local intelChecks = {
                -- ThreatType    = {max dist to merge points, threat minimum, timeout (-1 = never timeout), try for exact pos, category to use for exact pos}
                StructuresNotMex = {100, 0, 60, true, categories.STRUCTURE - categories.MASSEXTRACTION},
                Commander = {50, 0, 120, true, categories.COMMAND},
                Experimental = {50, 0, 120, true, categories.EXPERIMENTAL},
                Artillery = {50, 1150, 120, true, categories.ARTILLERY * categories.TECH3},
                Land = {100, 50, 120, false, nil},
            }
    
            local numchecks = 0
            local checkspertick = 5
            local changed = false
            for threatType, v in intelChecks do
                local threats = self:GetThreatsAroundPosition(self.BuilderManagers.MAIN.Position, 16, true, threatType)
                for _, threat in threats do
                    local dupe = false
                    local newPos = {threat[1], 0, threat[2]}
                    numchecks = numchecks + 1
                    for _, loc in self.InterestList.HighPriority do
                        if loc.Type == threatType and VDist2Sq(newPos[1], newPos[3], loc.Position[1], loc.Position[3]) < v[1] * v[1] then
                            dupe = true
                            loc.LastUpdate = GetGameTimeSeconds()
                            break
                        end
                    end

                    if not dupe then
                        -- Is it in the low priority list?
                        for i = 1, table.getn(self.InterestList.LowPriority) do
                            local loc = self.InterestList.LowPriority[i]
                            if VDist2Sq(newPos[1], newPos[3], loc.Position[1], loc.Position[3]) < v[1] * v[1] and threat[3] > v[2] then
                                -- Found it in the low pri list. Remove it so we can add it to the high priority list.
                                table.remove(self.InterestList.LowPriority, i)
                                break
                            end
                        end
                        -- Check for exact position?
                        if threat[3] > v[2] and v[4] and v[5] then
                            local nearUnits = self:GetUnitsAroundPoint(v[5], newPos, v[1], 'Enemy')
                            if not table.empty(nearUnits) then
                                local unitPos = nearUnits[1]:GetPosition()
                                if unitPos then
                                    newPos = {unitPos[1], 0, unitPos[3]}
                                end
                            end
                        end
                        -- Threat high enough?
                        if threat[3] > v[2] then
                            changed = true
                            table.insert(self.InterestList.HighPriority,
                                {
                                    Position = newPos,
                                    Type = threatType,
                                    Threat = threat[3],
                                    LastUpdate = GetGameTimeSeconds(),
                                    LastScouted = GetGameTimeSeconds(),
                                }
                            )
                        end
                    end
                    -- Reduce load on game
                    if numchecks > checkspertick then
                        WaitTicks(1)
                        numchecks = 0
                    end
                end
            end
            numchecks = 0

            -- Get rid of outdated intel
            for k, v in self.InterestList.HighPriority do
                if not v.Permanent and intelChecks[v.Type][3] > 0 and v.LastUpdate + intelChecks[v.Type][3] < GetGameTimeSeconds() then
                    self.InterestList.HighPriority[k] = nil
                    changed = true
                end
            end

            -- Rebuild intel table if there was a change
            if changed then
                self.InterestList.HighPriority = self:RebuildTable(self.InterestList.HighPriority)
            end

            -- Sort the list based on low long it has been since it was scouted
            table.sort(self.InterestList.HighPriority, function(a, b)
                if a.LastScouted == b.LastScouted then
                    local MainPos = self.BuilderManagers.MAIN.Position
                    local distA = VDist2(MainPos[1], MainPos[3], a.Position[1], a.Position[3])
                    local distB = VDist2(MainPos[1], MainPos[3], b.Position[1], b.Position[3])

                    return distA < distB
                else
                    return a.LastScouted < b.LastScouted
                end
            end)

            -- Draw intel data on map
            if not self.IntelDebugThread then
              self.IntelDebugThread = self:ForkThread(SUtils.DrawIntel)
            end
            -- Handle intel data if there was a change
            if changed then
                SUtils.AIHandleIntelData(self)
            end
            -- SUtils.AICheckForWeakEnemyBase(self)
        end
    end,
	
    TauntThread = function(self)
        while self.sorianedit do
            WaitSeconds(30+Random(-10, 50))
			import('/lua/AI/sorianutilities.lua').AIRandomizeTaunt(self)
            WaitTicks(8*10*(60+Random(-20, 20)))
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
