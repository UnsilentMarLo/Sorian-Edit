--***************************************************************************
--*
--**  File     :  /lua/sim/StrategyBuilder.lua
--**
--**  Summary  : Strategy Builder class
--**
--**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local Builder = import("/lua/sim/builder.lua").Builder

-- StrategyBuilderSpec
-- This is the spec to have analyzed by the StrategyManager
--{
--   BuilderData = {
--       Some stuff could go here, eventually.
--   }
--}

---@class StrategyBuilder : Builder
StrategyBuilder = Class(Builder) {
    ---@param self StrategyBuilder
    ---@param brain AIBrain
    ---@param data table
    ---@param locationType string
    ---@return boolean
    Create = function(self,brain,data,locationType)
        Builder.Create(self,brain,data,locationType)
        self:SetStrategyActive(false)
        return true
    end,

    ---@param self StrategyBuilder
    ---@param bool boolean
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

    ---@param self StrategyBuilder
    ---@return boolean
    IsStrategyActive = function(self)
        return self.Active
    end,
	
    StrategyBlocked = function(self)
        return self.Blocked
    end,

    ---@param self StrategyBuilder
    ---@return Builder|false
    GetActivateBuilders = function(self)
        if Builders[self.BuilderName].AddBuilders then
            return Builders[self.BuilderName].AddBuilders
        end
        return false
    end,

    ---@param self StrategyBuilder
    ---@return Builder|false
    GetRemoveBuilders = function(self)
        if Builders[self.BuilderName].RemoveBuilders then
            return Builders[self.BuilderName].RemoveBuilders
        end
        return false
    end,

    ---@param self StrategyBuilder
    ---@return Builder|false
    GetStrategyTime = function(self)
        if Builders[self.BuilderName].StrategyTime then
            return Builders[self.BuilderName].StrategyTime
        end
        return false
    end,
	
    GetStrategyTimeActive = function(self)
        if self.StrategyTimeActive then
			if GetGameTimeSeconds() > self.StrategyTimeActive then
				return true
			end
		end
        return false
    end,

    ---@param self StrategyBuilder
    ---@return boolean
    IsInterruptStrategy = function(self)
        if Builders[self.BuilderName].InterruptStrategy then
            return true
        end
        return false
    end,

    ---@param self StrategyBuilder
    ---@return Builder|false
    GetStrategyType = function(self)
        if Builders[self.BuilderName].StrategyType then
            return Builders[self.BuilderName].StrategyType
        end
        return false
    end,
	
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

    ---@param self StrategyBuilder
    ---@param builderManager BuilderManager
    ---@return boolean
    CalculatePriority = function(self, builderManager)
        self.PriorityAltered = false
        -- Builders can have a function to update the priority
        if Builders[self.BuilderName].PriorityFunction then
            local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
            if newPri > 100 then
                newPri = 100
            elseif newPri < 0 then
                newPri = 0
            end
            if newPri != self.Priority then
                self.Priority = newPri
                self.SetByStrat = true
                self.PriorityAltered = true
            end
        end

        -- Returns true if a priority change happened
        local returnVal = self.PriorityAltered
        return returnVal
    end,
}

---@param brain AIBrain
---@param data table
---@param locationType string
---@return string|false
function CreateStrategy(brain, data, locationType)
    local builder = StrategyBuilder()
    if builder:Create(brain, data, locationType) then
        return builder
    end
    return false
end

-- imports kept for backwards compatibility with mods
local AIUtils = import("/lua/ai/aiutilities.lua")