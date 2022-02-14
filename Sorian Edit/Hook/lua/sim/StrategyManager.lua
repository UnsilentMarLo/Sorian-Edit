SorianEditStrategyManager = StrategyManager
StrategyManager = Class(SorianEditStrategyManager) {
    -- Create = function(self, brain, lType, location, radius, useCenterPoint)
        -- BuilderManager.Create(self,brain)

        -- self.Location = location
        -- self.Radius = radius
        -- self.LocationType = lType

        -- self.LastChange = 0
        -- self.NextChange = 300
        -- self.LastStrategy = false
        -- self.OverallStrategy = false
        -- self.OverallPriority = 0

        -- self.UseCenterPoint = useCenterPoint or false

        -- self:AddBuilderType('Any')

        -- #self:LoadStrategies()
    -- end,

    -- AddBuilder = function(self, builderData, locationType, builderType)
        -- local newBuilder = StrategyBuilder.CreateStrategy(self.Brain, builderData, locationType)
        -- self:AddInstancedBuilder(newBuilder, builderType)
        -- return newBuilder
    -- end,

    -- # Load all strategies in the Strategy List table
    -- LoadStrategies = function(self)
        -- for i,v in StrategyList do
            -- self:AddBuilder(v)
        -- end
    -- end,

    ExecuteChanges = function(self, builder)
        if not self.Brain.sorianedit then
            return SorianEditStrategyManager.ExecuteChanges(self, builder)
        end
        local turnOff = builder:GetRemoveBuilders()
        local turnOn = builder:GetActivateBuilders()
        for mname, manager in turnOff do
            for _, bname in manager do
                local Managers = self.Brain.BuilderManagers[self.LocationType]
                Managers[mname]:SetBuilderPriority(bname, 0, true, true)
				LOG('-------------- StrategyManager, removed Builders from Builder: '..bname)
            end
        end
        for mname, manager in turnOn do
            for _, bname in manager do
                local Managers = self.Brain.BuilderManagers[self.LocationType]
                local newPriority = Managers[mname]:GetActivePriority(bname)
                Managers[mname]:SetBuilderPriority(bname, newPriority, true, true)
				LOG('-------------- StrategyManager, added Builders from Builder: '..bname)
            end
        end
        builder:SetStrategyActive(true, false)
    end,

    UndoChanges = function(self, builder)
        if not self.Brain.sorianedit then
            return SorianEditStrategyManager.UndoChanges(self, builder)
        end
        local turnOn = builder:GetRemoveBuilders()
        local turnOff = builder:GetActivateBuilders()
        for mname, manager in turnOff do
            for _, bname in manager do
                local Managers = self.Brain.BuilderManagers[self.LocationType]
                Managers[mname]:ResetBuilderPriority(bname)
				LOG('-------------- StrategyManager, undid add Builders from Builder: '..bname)
            end
        end
        for mname, manager in turnOn do
            for _, bname in manager do
                local Managers = self.Brain.BuilderManagers[self.LocationType]
                Managers[mname]:ResetBuilderPriority(bname)
				LOG('-------------- StrategyManager, undid remove Builders from Builder: '..bname)
            end
        end
        builder:SetStrategyActive(false, true)
    end,

    ManagerLoopBody = function(self,builder,bType)
        BuilderManager.ManagerLoopBody(self,builder,bType)
        if not self.Brain.sorianedit then
            return SorianEditStrategyManager.ManagerLoopBody(self,builder,bType)
        end

        if builder.Priority >= 100 and not builder:IsStrategyActive() and builder:BuilderConditionTest(self.Brain) then
            LOG('*AI DEBUG: '..self.Brain.Nickname..' '..SUtils.TimeConvert(GetGameTimeSeconds())..' Activating Strategy: '..builder.BuilderName..' Priority: '..builder.Priority)
            self:ExecuteChanges(builder)
        elseif builder:IsStrategyActive() and (builder.Priority < 100 or not builder:BuilderConditionTest(self.Brain)) or builder:GetStrategyTimeActive() then
            LOG('*AI DEBUG: '..self.Brain.Nickname..' '..SUtils.TimeConvert(GetGameTimeSeconds())..' Deactivating Strategy: '..builder.BuilderName..' Priority: '..builder.Priority)
            self:UndoChanges(builder)
        end
		WaitSeconds(5)
    end,
}