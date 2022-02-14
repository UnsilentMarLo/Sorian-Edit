
SorianEditBuilder = Builder
Builder = Class(SorianEditBuilder) {
    Create = function(self, brain, data, locationType)
        -- make sure the table of strings exist, they are required for the builder
		
        if not self.Brain.sorianedit then
            return SorianEditBuilder.Create(self, brain, data, locationType)
        end
		
        local verifyDictionary = { 'Priority', 'BuilderName' }
        for k,v in verifyDictionary do
            if not self:VerifyDataName(v, data) then return false end
        end

        self.Priority = data.Priority

        self.StrategyTime = data.StrategyTime
		
        self.OriginalPriority = self.Priority

        self.Brain = brain
		
		self.OldPriority = false

        self.BuilderName = data.BuilderName

        self.DelayEqualBuildPlatoons = data.DelayEqualBuildPlatoons

        self.ReportFailure = data.ReportFailure

        self:SetupBuilderConditions(data, locationType)

        self.BuilderStatus = false

        return true
    end,

    -- GetPriority = function(self)
        -- return self.Priority
    -- end,

    -- GetActivePriority = function(self)
        -- if Builders[self.BuilderName].ActivePriority then
            -- return Builders[self.BuilderName].ActivePriority
        -- end
        -- return false
    -- end,

    SetPriority = function(self, val, temporary, setbystrat)
		-- LOG('-------------- SetPriority called for:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        if not self.Brain.sorianedit then
            return SorianEditBuilder.SetPriority(self, val, temporary, setbystrat)
        end
        if val != self.Priority then
			if temporary then
				if not self.OldPriority then
					self.OldPriority = self.Priority
				end
			end
			if setbystrat then
				self.SetByStrat = true
			end
            self.PriorityAltered = true
        end
		-- LOG('-------------- changing Builder:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' old priority:'..repr(self.OldPriority)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        self.Priority = val
    end,

    ResetPriority = function(self)
		-- LOG('-------------- ResetPriority called for:'..repr(self.BuilderName))
        if not self.Brain.sorianedit then
            return SorianEditBuilder.ResetPriority(self)
        end
		if self.OldPriority then
			self.Priority = self.OldPriority
			self.OldPriority = nil
		end
		-- LOG('-------------- resetting Builder:'..repr(self.BuilderName))
        self.PriorityAltered = false
    end,

    CalculatePriority = function(self, builderManager)
        if not self.Brain.sorianedit then
            return SorianEditBuilder.CalculatePriority(self, builderManager)
        end
		if Builders[self.BuilderName].PriorityFunction and not self.PriorityAltered then
			local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
			if newPri != self.Priority then
				self.Priority = newPri
				return true
			end
		elseif self.SetByStrat then
			return true
		end
		return false
    end,

    -- AdjustPriority = function(self, val)
        -- self.Priority = self.Priority + val
    -- end,

    -- GetBuilderData = function(self, locationType, builderData)
        -- # Get builder data out of the globals and convert data here
        -- local returnData = {}
        -- builderData = builderData or Builders[self.BuilderName].BuilderData
        -- for k,v in builderData do
            -- if type(v) == 'table' then
                -- returnData[k] = self:GetBuilderData(locationType, v)
            -- else
                -- if type(v) == 'string' and v == 'LocationType' then
                    -- returnData[k] = locationType
                -- else
                    -- returnData[k] = v
                -- end
            -- end
        -- end
        -- return returnData
    -- end,

    -- GetBuilderType = function(self)
        -- return Builders[self.BuilderName].BuilderType
    -- end,

    -- GetBuilderName = function(self)
        -- return self.BuilderName
    -- end,

    -- GetBuilderStatus = function(self)
        -- if self.GetStatusFunction then
            -- self.GetStatusFunction()
        -- end
        -- self:CheckBuilderConditions()
        -- return self.BuilderStatus
    -- end,

    -- GetPlatoonTemplate = function(self)
        -- if Builders[self.BuilderName].PlatoonTemplate then
            -- return Builders[self.BuilderName].PlatoonTemplate
        -- end
        -- return false
    -- end,

    -- GetPlatoonAIFunction = function(self)
        -- if Builders[self.BuilderName].PlatoonAIFunction then
            -- return Builders[self.BuilderName].PlatoonAIFunction
        -- end
        -- return false
    -- end,

    -- GetPlatoonAIPlan = function(self)
        -- if Builders[self.BuilderName].PlatoonAIPlan then
            -- return Builders[self.BuilderName].PlatoonAIPlan
        -- end
        -- return false
    -- end,

    -- GetPlatoonAddPlans = function(self)
        -- if Builders[self.BuilderName].PlatoonAddPlans then
            -- return Builders[self.BuilderName].PlatoonAddPlans
        -- end
        -- return false
    -- end,

    -- GetPlatoonAddFunctions = function(self)
        -- if Builders[self.BuilderName].PlatoonAddFunctions then
            -- return Builders[self.BuilderName].PlatoonAddFunctions
        -- end
        -- return false
    -- end,

    -- GetPlatoonAddBehaviors = function(self)
        -- if Builders[self.BuilderName].PlatoonAddBehaviors then
            -- return Builders[self.BuilderName].PlatoonAddBehaviors
        -- end
        -- return false
    -- end,

    -- BuilderConditionTest = function(self)
        -- for k,v in self.BuilderConditions do
            -- if not self.Brain.ConditionsMonitor:CheckKeyedCondition(v, self.ReportFailure) then
                -- self.BuilderStatus = false
                -- if self.ReportFailure then
                    -- LOG('*AI DEBUG: ' .. self.BuilderName .. ' - Failure Report Complete')
                -- end
                -- return false
            -- end
        -- end
        -- self.BuilderStatus = true
        -- return true
    -- end,

    -- SetupBuilderConditions = function(self, data, locationType)
        -- local tempConditions = {}
        -- if data.BuilderConditions then
            -- # Convert location type here
            -- for k,v in data.BuilderConditions do
                -- local bCond = table.deepcopy(v)
                -- if type(bCond[1]) == 'function' then
                    -- for pNum,param in bCond[2] do
                        -- if param == 'LocationType' then
                            -- bCond[2][pNum] = locationType
                        -- end
                    -- end
                -- else
                    -- for pNum,param in bCond[3] do
                        -- if param == 'LocationType' then
                            -- bCond[3][pNum] = locationType
                        -- end
                    -- end
                -- end
                -- table.insert(tempConditions, self.Brain.ConditionsMonitor:AddCondition(unpack(bCond)))
            -- end
        -- end
        -- self.BuilderConditions = tempConditions
    -- end,

    -- CheckBuilderConditions = function(self)
        -- self:BuilderConditionTest(self.Brain)
    -- end,

    -- VerifyDataName = function(self, valueName, data)
        -- if not data[valueName] and not data.BuilderName then
            -- error('*BUILDER ERROR: Invalid builder data missing: ' .. valueName .. ' - BuilderName not given')
            -- return false
        -- elseif not data[valueName] then
            -- error('*BUILDER ERROR: Invalid builder data missing: ' .. valueName .. ' - BuilderName given: ' .. data.BuilderName)
            -- return false
        -- end
        -- return true
    -- end,
}

SorianEditPlatoonBuilder = PlatoonBuilder
PlatoonBuilder = Class(SorianEditPlatoonBuilder) {

    SetPriority = function(self, val, temporary, setbystrat)
		-- LOG('-------------- SetPriority called for:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        if not self.Brain.sorianedit then
            return SorianEditPlatoonBuilder.SetPriority(self, val, temporary, setbystrat)
        end
        if val != self.Priority then
			if temporary then
				if not self.OldPriority then
					self.OldPriority = self.Priority
				end
			end
			if setbystrat then
				self.SetByStrat = true
			end
            self.PriorityAltered = true
        end
		-- LOG('-------------- changing Builder:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' old priority:'..repr(self.OldPriority)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        self.Priority = val
    end,

    ResetPriority = function(self)
		-- LOG('-------------- ResetPriority called for:'..repr(self.BuilderName))
        if not self.Brain.sorianedit then
            return SorianEditPlatoonBuilder.ResetPriority(self)
        end
		if self.OldPriority then
			self.Priority = self.OldPriority
			self.OldPriority = nil
		end
		-- LOG('-------------- resetting Builder:'..repr(self.BuilderName))
        self.PriorityAltered = false
    end,

    CalculatePriority = function(self, builderManager)
        if not self.Brain.sorianedit then
            return SorianEditPlatoonBuilder.CalculatePriority(self, builderManager)
        end
		if Builders[self.BuilderName].PriorityFunction and not self.PriorityAltered then
			local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
			if newPri != self.Priority then
				self.Priority = newPri
				return true
			end
		elseif self.SetByStrat then
			return true
		end
		return false
    end,

}

SorianEditFactoryBuilder = FactoryBuilder
FactoryBuilder = Class(SorianEditFactoryBuilder) {

    SetPriority = function(self, val, temporary, setbystrat)
		-- LOG('-------------- SetPriority called for:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        if not self.Brain.sorianedit then
            return SorianEditFactoryBuilder.SetPriority(self, val, temporary, setbystrat)
        end
        if val != self.Priority then
			if temporary then
				if not self.OldPriority then
					self.OldPriority = self.Priority
				end
			end
			if setbystrat then
				self.SetByStrat = true
			end
            self.PriorityAltered = true
        end
		-- LOG('-------------- changing Builder:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' old priority:'..repr(self.OldPriority)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        self.Priority = val
    end,

    ResetPriority = function(self)
		-- LOG('-------------- ResetPriority called for:'..repr(self.BuilderName))
        if not self.Brain.sorianedit then
            return SorianEditFactoryBuilder.ResetPriority(self)
        end
		if self.OldPriority then
			self.Priority = self.OldPriority
			self.OldPriority = nil
		end
		-- LOG('-------------- resetting Builder:'..repr(self.BuilderName))
        self.PriorityAltered = false
    end,

    CalculatePriority = function(self, builderManager)
        if not self.Brain.sorianedit then
            return SorianEditFactoryBuilder.CalculatePriority(self, builderManager)
        end
		if Builders[self.BuilderName].PriorityFunction and not self.PriorityAltered then
			local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
			if newPri != self.Priority then
				self.Priority = newPri
				return true
			end
		elseif self.SetByStrat then
			return true
		end
		return false
    end,

}


SorianEditEngineerBuilder = EngineerBuilder
EngineerBuilder = Class(SorianEditEngineerBuilder) {

    SetPriority = function(self, val, temporary, setbystrat)
		-- LOG('-------------- SetPriority called for:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        if not self.Brain.sorianedit then
            return SorianEditEngineerBuilder.SetPriority(self, val, temporary, setbystrat)
        end
        if val != self.Priority then
			if temporary then
				if not self.OldPriority then
					self.OldPriority = self.Priority
				end
			end
			if setbystrat then
				self.SetByStrat = true
			end
            self.PriorityAltered = true
        end
		-- LOG('-------------- changing Builder:'..repr(self.BuilderName)..' to new priority:'..repr(val)..' old priority:'..repr(self.OldPriority)..' bool temporary:'..repr(temporary)..' bool setbystrat:'..repr(setbystrat))
        self.Priority = val
    end,

    ResetPriority = function(self)
		-- LOG('-------------- ResetPriority called for:'..repr(self.BuilderName))
        if not self.Brain.sorianedit then
            return SorianEditEngineerBuilder.ResetPriority(self)
        end
		if self.OldPriority then
			self.Priority = self.OldPriority
			self.OldPriority = nil
		end
		-- LOG('-------------- resetting Builder:'..repr(self.BuilderName))
        self.PriorityAltered = false
    end,

    CalculatePriority = function(self, builderManager)
        if not self.Brain.sorianedit then
            return SorianEditEngineerBuilder.CalculatePriority(self, builderManager)
        end
		if Builders[self.BuilderName].PriorityFunction and not self.PriorityAltered then
			local newPri = Builders[self.BuilderName]:PriorityFunction(self.Brain)
			if newPri != self.Priority then
				self.Priority = newPri
				return true
			end
		elseif self.SetByStrat then
			return true
		end
		return false
    end,
	
}
