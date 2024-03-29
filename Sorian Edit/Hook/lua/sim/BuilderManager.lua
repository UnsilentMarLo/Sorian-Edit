-- AI DEBUG Platoon builder names. (prints to the game.log)
local AntiSpamList = {}
local AntiSpamCounter = 0
local LastBuilder = ''
local DEBUGBUILDER = {}

WARN('[sorianeditutilities.lua ------------------------ SorianEditBuilderManager.')

-- Hook for debugging
SorianEditBuilderManager = BuilderManager
BuilderManager = Class(SorianEditBuilderManager) {

    SorianEditSortBuilderList = function(self, bType)
       -- Only use this with AI-SorianEdit
        if not self.Brain.sorianedit then
			WARN('[sorianeditutilities.lua ------------------------ not sorianbrain loading default SortBuilderList.')
            return SorianEditBuilderManager.SorianEditSortBuilderList(self, bType)
        end
		WARN('[sorianeditutilities.lua ------------------------ sorianbrain loading SorianEditSortBuilderList.')
        -- Make sure there is a type
        if not self.BuilderData[bType] then
            error('*BUILDMANAGER ERROR: Trying to sort platoons of invalid builder type - ' .. bType)
            return false
        end
        -- bubblesort self.BuilderData[bType].Builders
        local count=table.getn(self.BuilderData[bType].Builders)
        local Sorting
        repeat
            Sorting = false
            count = count - 1
            for i = 1, count do
                if self.BuilderData[bType].Builders[i].Priority < self.BuilderData[bType].Builders[i + 1].Priority then
                    self.BuilderData[bType].Builders[i], self.BuilderData[bType].Builders[i + 1] = self.BuilderData[bType].Builders[i + 1], self.BuilderData[bType].Builders[i]
                    Sorting = true
                end
            end
        until Sorting == false
        -- mark the table as sorted
        self.BuilderData[bType].NeedSort = false
    end,

    -- Hook for SorianEdit AI debug
    SorianEditGetHighestBuilder = function(self,bType,factory)
       -- Only use this with AI-SorianEdit
        if not self.Brain.sorianedit then
			WARN('[sorianeditutilities.lua ------------------------ not sorianbrain loading default GetHighestBuilder.')
            return SorianEditBuilderManager.SorianEditGetHighestBuilder(self,bType,factory)
        end
		WARN('[sorianeditutilities.lua ------------------------ sorianbrain loading SorianEditGetHighestBuilder.')
        if not self.BuilderData[bType] then
            error('*BUILDERMANAGER ERROR: Invalid builder type - ' .. bType)
        end
        if not self.Brain.BuilderManagers[self.LocationType] then
            return false
        end
        self.NumGet = self.NumGet + 1
        local found = false
        local possibleBuilders = {}
        -- Print the whole builder table into the game.log. 
        if self.Brain[ScenarioInfo.Options.AIBuilderNameDebug] then
            if not DEBUGBUILDER[ScenarioInfo.Options.AIBuilderNameDebug] then
                DEBUGBUILDER[ScenarioInfo.Options.AIBuilderNameDebug] = true
                for k,v in self.BuilderData[bType].Builders do
                    LOG('* '..ScenarioInfo.Options.AIBuilderNameDebug..'-AI: Builder ['..bType..']: Priority = '..v.Priority..' - possibleBuilders = '..repr(v.BuilderName))
                end
            end
        end
        for k,v in self.BuilderData[bType].Builders do
            if v.Priority >= 1 and (not found or v.Priority == found) and v:GetBuilderStatus() and self:BuilderParamCheck(v,factory) then
                if not self:SorianEditIsPlatoonBuildDelayed(v.DelayEqualBuildPlatoons) then
                    found = v.Priority
                    table.insert(possibleBuilders, k)
                    --LOG('* AI DEBUG: SorianEditGetHighestBuilder(): Priority = '..found..' - possibleBuilders = '..repr(v.BuilderName))
                end
            elseif found and v.Priority < found then
                break
            end
        end
        if found and found > 0 then
            local whichBuilder = Random(1,table.getn(possibleBuilders))
            -- DEBUG SPAM - Start
            -- If we have a builder that is repeating (Happens when buildconditions are true, but the builder can't find anything to build/assist or a build location)
            local BuilderName = self.BuilderData[bType].Builders[ possibleBuilders[whichBuilder] ].BuilderName
            if BuilderName ~= LastBuilder then
                LastBuilder = BuilderName
                AntiSpamCounter = 0
            elseif not AntiSpamList[BuilderName] then
                AntiSpamCounter = AntiSpamCounter + 1
                if AntiSpamCounter > 20 then
                    -- Warn the programmer that something is going wrong.
                    WARN('* AI DEBUG: SorianEditGetHighestBuilder(): PlatoonBuilder is spaming. Maybe wrong Buildconditions for Builder = '..self.BuilderData[bType].Builders[ possibleBuilders[whichBuilder] ].BuilderName..' ?!?')
                    AntiSpamCounter = 0
                    AntiSpamList[BuilderName] = true
                end                
            end
            -- DEBUG SPAM - End
            if self.Brain[ScenarioInfo.Options.AIBuilderNameDebug] or ScenarioInfo.Options.AIBuilderNameDebug == 'all' then
                -- building Mass percent bar
                local percent = self.Brain:GetEconomyStoredRatio('MASS')
                local massBar = ''
                local count = 1
                for i = count, percent*20 do
                    massBar = massBar..'#'
                    count = count + 1
                end
                for i = count, 20 do
                    massBar = massBar..'~'
                end
                -- building Mass percent bar
                local percent = self.Brain:GetEconomyStoredRatio('ENERGY')
                local energyBar = ''
                local count = 1
                for i = count, percent*20 do
                    energyBar = energyBar..'#'
                    count = count + 1
                end
                for i = count, 20 do
                    energyBar = energyBar..'~'
                end
                -- format priority numbers
                local PrioText = ''
                local Priolen = string.len(found)
                if 6 > Priolen then
                    PrioText = string.rep('  ', 6 - Priolen) .. found
                end
                LOG(' M: ['..massBar..']  E: ['..energyBar..']  -  BuilderPriority = '..PrioText..' - SelectedBuilder = '..self.BuilderData[bType].Builders[ possibleBuilders[whichBuilder] ].BuilderName)
            end
            return self.BuilderData[bType].Builders[ possibleBuilders[whichBuilder] ]
        end
        return false
    end,

    -- Hook needed for vanilla game
    SorianEditIsPlatoonBuildDelayed = function(self, DelayEqualBuildPlatoons)
        if DelayEqualBuildPlatoons then
            local CheckDelayTime = GetGameTimeSeconds()
            local PlatoonName = DelayEqualBuildPlatoons[1]
            if not self.Brain.DelayEqualBuildPlatoons[PlatoonName] or self.Brain.DelayEqualBuildPlatoons[PlatoonName] < CheckDelayTime then
                LOG('Setting '..DelayEqualBuildPlatoons[2]..' sec. delaytime for builder ['..PlatoonName..']')
                self.Brain.DelayEqualBuildPlatoons[PlatoonName] = CheckDelayTime + DelayEqualBuildPlatoons[2]
                return false
            else
                LOG('Builder ['..PlatoonName..'] still delayed for '..(CheckDelayTime - self.Brain.DelayEqualBuildPlatoons[PlatoonName])..' seconds.')
                return true
            end
        end
    end,
	
    SetBuilderPriority = function(self,builderName,priority,temporary,setbystrat)
        if not self.Brain.sorianedit then
            return SorianEditBuilderManager.SetBuilderPriority(self,builderName,priority,temporary,setbystrat)
        end
        -- LOG('------------------------------------ SetBuilderPriority called for: ['..repr(builderName)..'] with prio '..repr(priority)..' temporary bool:'..repr(temporary)..' setbystrat bool:'..repr(setbystrat))
        for _,bType in self.BuilderData do
            for _,builder in bType.Builders do
                if builder.BuilderName == builderName then
					-- LOG('------------------------------------ SetBuilderPriority reached SetPriority for: ['..repr(builderName)..'] == '..repr(builder.BuilderName))
                    builder:SetPriority(priority, temporary, setbystrat)
                    return
                end
            end
        end
    end,

    ResetBuilderPriority = function(self,builderName)
        if not self.Brain.sorianedit then
            return SorianEditBuilderManager.ResetBuilderPriority(self,builderName)
        end
        -- LOG('------------------------------------ ResetBuilderPriority called for: ['..repr(builderName)..']')
        for _,bType in self.BuilderData do
            for _,builder in bType.Builders do
                if builder.BuilderName == builderName then
                    builder:ResetPriority()
                    return
                end
            end
        end
    end,
	
    ManagerLoopBody = function(self,builder,bType)
        if builder:CalculatePriority(self) then
            self.BuilderData[bType].NeedSort = true
        end
        -- builder:CheckBuilderConditions(self.Brain)
    end,
}

