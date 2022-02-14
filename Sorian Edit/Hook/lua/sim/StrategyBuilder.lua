local SUtils = import('/lua/AI/sorianutilities.lua')

SorianEditStrategyBuilder = StrategyBuilder
StrategyBuilder = Class(SorianEditStrategyBuilder) {
    -- Create = function(self,brain,data,locationType)
        -- Builder.Create(self,brain,data,locationType)
        -- self:SetStrategyActive(false, false)
        -- return true
    -- end,

    SetStrategyActive = function(self, bool, setbytimer)
        if not self.Brain.sorianedit then
            return SorianEditStrategyBuilder.SetStrategyActive(self, bool)
        end
        if bool then
            self.Active = true
            self.Blocked = false
			if self.StrategyTime then
				self.StrategyTimeActive = GetGameTimeSeconds() + self.StrategyTime
				LOG('*AI DEBUG: '..self.Brain.Nickname..' Trace:SetStrategyActive() StrategyTimeActive set to = '..SUtils.TimeConvert(self.StrategyTimeActive)' At Gametime: '..SUtils.TimeConvert(GetGameTimeSeconds()))
			else
				self.StrategyTimeActive = GetGameTimeSeconds() + 300
				LOG('*AI DEBUG: '..self.Brain.Nickname..' Trace:SetStrategyActive() StrategyTimeActive set to Gametime + 300: '..SUtils.TimeConvert(self.StrategyTimeActive)..' StrategyTime = '..repr(self.StrategyTime))
			end
            if Builders[self.BuilderName].OnStrategyActivate then
                Builders[self.BuilderName]:OnStrategyActivate(self.Brain)
            end
			LOG('*AI DEBUG: '..self.Brain.Nickname..' Activated Strategy: '..self.BuilderName)
        elseif setbytimer then
            self.Active = false
            self.Blocked = true
            if Builders[self.BuilderName].OnStrategyDeactivate then
                Builders[self.BuilderName]:OnStrategyDeactivate(self.Brain)
            end
			LOG('*AI DEBUG: '..self.Brain.Nickname..' Blocked and deactivated Strategy: '..self.BuilderName)
        else
            self.Active = false
            self.Blocked = false
            if Builders[self.BuilderName].OnStrategyDeactivate then
                Builders[self.BuilderName]:OnStrategyDeactivate(self.Brain)
            end
			LOG('*AI DEBUG: '..self.Brain.Nickname..' Deactivated Strategy: '..self.BuilderName)
        end
    end,

    -- IsStrategyActive = function(self)
        -- return self.Active
    -- end,
	
    StrategyBlocked = function(self)
        return self.Blocked
    end,

    -- GetActivateBuilders = function(self)
        -- if Builders[self.BuilderName].AddBuilders then
            -- return Builders[self.BuilderName].AddBuilders
        -- end
        -- return false
    -- end,

    -- GetRemoveBuilders = function(self)
        -- if Builders[self.BuilderName].RemoveBuilders then
            -- return Builders[self.BuilderName].RemoveBuilders
        -- end
        -- return false
    -- end,

    -- GetStrategyTime = function(self)
        -- if Builders[self.BuilderName].StrategyTime then
            -- return Builders[self.BuilderName].StrategyTime
        -- end
        -- return false
    -- end,
	
    GetStrategyTimeActive = function(self)
        if self.StrategyTimeActive then
			if GetGameTimeSeconds() > self.StrategyTimeActive then
				return true
			end
		end
        return false
    end,

    -- IsInterruptStrategy = function(self)
        -- if Builders[self.BuilderName].InterruptStrategy then
            -- return true
        -- end
        -- return false
    -- end,

    -- GetStrategyType = function(self)
        -- if Builders[self.BuilderName].StrategyType then
            -- return Builders[self.BuilderName].StrategyType
        -- end
        -- return false
    -- end,
	
    BuilderConditionTest = function(self)
        for k,v in self.BuilderConditions do
            if not self.Brain.ConditionsMonitor:CheckKeyedCondition(v, self.ReportFailure) then
                self.BuilderStatus = false
                if self.ReportFailure then
                    LOG('*AI DEBUG: ' .. self.BuilderName .. ' - Failure Report Complete')
                end
                return false
            end
        end
        self.BuilderStatus = true
        return true
    end,

    SetupBuilderConditions = function(self, data, locationType)
        local tempConditions = {}
        if data.BuilderConditions then
            # Convert location type here
            for k,v in data.BuilderConditions do
                local bCond = table.deepcopy(v)
                if type(bCond[1]) == 'function' then
                    for pNum,param in bCond[2] do
                        if param == 'LocationType' then
                            bCond[2][pNum] = locationType
                        end
                    end
                else
                    for pNum,param in bCond[3] do
                        if param == 'LocationType' then
                            bCond[3][pNum] = locationType
                        end
                    end
                end
                table.insert(tempConditions, self.Brain.ConditionsMonitor:AddCondition(unpack(bCond)))
            end
        end
        self.BuilderConditions = tempConditions
    end,

    CheckBuilderConditions = function(self)
        self:BuilderConditionTest(self.Brain)
    end,

    CalculatePriority = function(self, builderManager)
        if not self.Brain.sorianedit then
            return SorianEditStrategyBuilder.CalculatePriority(self, builderManager)
        end
        self.PriorityAltered = false
        -- Builders can have a function to update the priority
        if Builders[self.BuilderName].PriorityFunction then
            local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
            if newPri <= 0 then
                newPri = 0
            end
            if self.Blocked and self.StrategyTime then
				if self.StrategyTime then
					local StratPause = self.StrategyTime
				else
					local StratPause = 300
				end
				if GetGameTimeSeconds() >= self.StrategyTimeActive + StratPause then
					self.Blocked = false
					LOG('*AI DEBUG: '..self.Brain.Nickname..' Unblocked Strategy: '..self.BuilderName)
				else
					LOG('*AI DEBUG: '..self.Brain.Nickname..' Strategy is still Blocked: '..self.BuilderName)
					newPri = 0
				end
            end
            if newPri != self.Priority then
				LOG('*AI DEBUG: '..self.Brain.Nickname..' Recalculated Strategy: '..self.BuilderName..' Priority: '..self.Priority..' new priority: '..newPri)
                self.Priority = newPri
                self.SetByStrat = true
                self.PriorityAltered = true
            end
        end

        # Returns true if a priority change happened
        local returnVal = self.PriorityAltered
        return returnVal
    end,
}
