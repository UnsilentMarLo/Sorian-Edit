WARN('[sorianeditutilities.lua ------------------------ '..debug.getinfo(1).currentline..'] ----------------------------- File Offset.')

local MapInfo = import('/mods/Sorian Edit/lua/AI/mapinfo.lua')
local Utilities = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')

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
            LOG('*------------------------------- AI-sorian: OnCreateAI() found AI-sorian  Name: ('..self.Name..') - personality: ('..per..') ')
			
            local iArmyNo = Utilities.GetAIBrainArmyNumber(self)
            local iBuildDistance = self:GetUnitBlueprint('UAL0001').Economy.MaxBuildDistance
			
            MapInfo.RecordResourceLocations()
            MapInfo.RecordPlayerStartLocations(self)
            MapInfo.RecordMexNearStartPosition(iArmyNo, iBuildDistance + 2)
            -- MapInfo.EvaluateNavalAreas(iArmyNo)
            self.sorianedit = true
            self:ForkThread(self.SEParseIntelThread)
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
        end
    end,
	
    PickEnemySorianEdit = function(self)
        self.targetoveride = false
        while true do
            self:PickEnemyLogicSorian(true)
            WaitSeconds(120)
        end
    end,

    PickEnemyLogicSorianEdit = function(self, brainbool)
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
		if (not self:GetCurrentEnemy() or brainbool) and not self.targetoveride then
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

			for k, v in armyStrengthTable do
				-- Dont' target self
				if k == selfIndex then
					continue
				end

				-- Ignore allies
				if not v.Enemy then
					continue
				end

				-- If we have a better candidate; ignore really weak enemies
				if enemy and v.Strength < 20 then
					continue
				end

				-- The closer targets are worth more because then we get their mass spots
				local distanceWeight = 0.1
				local distance = VDist3(self:GetStartVector3f(), v.Position)
				local threatWeight = (1 / (distance * distanceWeight)) * v.Strength
				if not enemy or (threatWeight > enemyStrength) then
					if EvaluatePathForNewEnemy(v) then
					enemyStrength = threatWeight * 3
					enemy = v.Brain
					else
					enemyStrength = threatWeight
					enemy = v.Brain
					end
				end
			end

			if enemy then
				if not self:GetCurrentEnemy() or self:GetCurrentEnemy() ~= enemy then
					SUtils.AISendChat('allies', ArmyBrains[self:GetArmyIndex()].Nickname, 'targetchat', ArmyBrains[enemy:GetArmyIndex()].Nickname)
				end
				self:SetCurrentEnemy(enemy)
			end
		end
    end,
	
	EvaluatePathForNewEnemy = function(self, PotentialEnemy)
    -- We have no cached path. Searching now for a path.
    local AIAttackUtils = import('/lua/AI/aiattackutilities.lua')
    local startX, startZ = aiBrain:GetArmyStartPos()
    local enemyX, enemyZ
    enemyX, enemyZ = PotentialEnemy:GetArmyStartPos()

    -- path wit AI markers from our base to the enemy base
    local path, reason = AIAttackUtils.PlatoonGenerateSafePathTo(aiBrain, 'Land', {startX,0,startZ}, {enemyX,0,enemyZ}, 1000)
    -- if we have a path generated with AI path markers then....
		if path then
			return true
		-- if we not have a path
		else
			return false
		end
    end,

}
