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

    -- For AI Patch V8. (Patched) patch for faster location search, needs AddBuilderManagers
    SEGetManagerCount = function(self, type)
        local count = 0
        for k, v in self.BuilderManagers do
            if not v.BaseType then
                continue
            end
            if type then
                if type == 'Start Location' and v.BaseType ~= 'MAIN' and v.BaseType ~= 'Blank Marker' then
                    continue
                elseif type == 'Naval Area' and v.BaseType ~= 'Naval Area' then
                    continue
                elseif type == 'Expansion Area' and v.BaseType ~= 'Expansion Area' and v.BaseType ~= 'Large Expansion Area' then
                    continue
                end
            end

            if v.EngineerManager:GetNumCategoryUnits('Engineers', categories.ALLUNITS) <= 0 and v.FactoryManager:GetNumCategoryFactories(categories.ALLUNITS) <= 0 then
                continue
            end

            count = count + 1
        end
        return count
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
            MapInfo.RecordPlayerStartLocations()
            MapInfo.RecordMexNearStartPosition(iArmyNo, iBuildDistance + 8 + 2)
            self.sorianedit = true
            self:ForkThread(self.SEParseIntelThread)
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

}
