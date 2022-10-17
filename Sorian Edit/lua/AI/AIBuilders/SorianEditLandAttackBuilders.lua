--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditLandAttackBuilders.lua
--**
--**  Summary  : Default economic builders for skirmish
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local BBTmplFile = '/lua/basetemplates.lua'
local ExBaseTmpl = 'ExpansionBaseTemplates'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'
local Adj2x2Tmpl = 'Adjacency2x2'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'

local SUtils = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/AITargetManager.lua').GetDangerZoneRadii()

	do
	LOG('--------------------- SorianEdit Land attack Builders loading')
	end
	
local TurtleAttackPrio = function(self, aiBrain)
	local ratio = 0
	local Prio1 = self.Priority
	local Prio2 = 0
	
	for k, brain in ArmyBrains do
		if ArmyIsCivilian(brain:GetArmyIndex()) then
		elseif IsEnemy( aiBrain:GetArmyIndex(), brain:GetArmyIndex() ) then
			local EnemyLand = table.getn(brain:GetListOfUnits( categories.MOBILE * categories.LAND - categories.ENGINEER - categories.SCOUT, false))
			local EnemyDefense = table.getn(brain:GetListOfUnits( categories.STRUCTURE * categories.DEFENSE, false)) * 4
			ratio = EnemyDefense / EnemyLand
		end
	end
	
	-- example: 5 Pd / 20 Land units = 0.25 * 4 = 1
	
	-- LOG('*AI DEBUG: --------------  Grabbing Turtle ratio, its: '..ratio..'!')
	
	if ratio < 0.9 then
	-- LOG('*AI DEBUG: --------------  Turtle Attack Prio Function returned false, 0')
		return 0, false
	else
		Prio2 = Prio1 * ratio * 2
	-- LOG('*AI DEBUG: --------------  Turtle Attack Prio returned true, its: '..Prio2..'!')
		return Prio2, true
	end
end

BuilderGroup {
    BuilderGroupName = 'SorianEditT1LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- Builder {
        -- BuilderName = 'SorianEdit T1 Tank - init',
        -- PlatoonTemplate = 'T1LandDFTank',
        -- Priority = 4125,
        -- BuilderConditions = {
			-- { UCBC, 'LessThanGameTimeSeconds', { 140 } },
			-- { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.15 } },
			-- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.LAND * categories.SCOUT }},
			-- { UCBC, 'PoolLessAtLocation', { 'LocationType', 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 }},
        -- },
        -- BuilderType = 'Land',
    -- },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 59000000,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, categories.ENGINEER * categories.TECH1 }},
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Tank',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 2225,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.15 } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Land',
    },
    -- T1 Artillery, built in a ratio to tanks before tech 2
    Builder {
        BuilderName = 'SorianEdit T1 Mortar',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 2225,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.15 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 - categories.SCOUT }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - Not T1',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 2225, --600,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.15 } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH3' }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.SCOUT }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1 }},
            { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.COMMAND}},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T1 Mobile AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mobile AA',
        PlatoonTemplate = 'T1LandAA',
        -- PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 2225,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 - categories.SCOUT }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.LAND * categories.ANTIAIR * categories.MOBILE }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T1 Amphibious 
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1Land - water map',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mobile - water map',
        PlatoonTemplate = 'T1LandDFTank',
        -- PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1225,
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Artillery - water map',
        PlatoonTemplate = 'T1LandArtillery',
        -- PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1225,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.ANTIAIR * (categories.HOVER + categories.AMPHIBIOUS) } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T2 Factories
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- Tech 2 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 2600,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 2600,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- MML's, built in a ratio to directfire units
    Builder {
        BuilderName = 'SorianEdit T2 MML',
        PlatoonTemplate = 'T2LandArtillery',
        Priority = 2600,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH2 }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.COMMAND}},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 MML Enemy Turtle',
        PlatoonTemplate = 'T2LandArtillery',
        Priority = 2600,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH2 }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 3100,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 2600,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2MobileShields',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 2600,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'CanBuildCategory', { categories.LAND * categories.MOBILE * categories.SHIELD * categories.DEFENSE - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 4, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            { UCBC, 'HaveForEach', { categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.COMMAND, 0.2, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields Enemy Turtle',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 2600,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'CanBuildCategory', { categories.LAND * categories.MOBILE * categories.SHIELD * categories.DEFENSE - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 4, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - T3 Factories',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 3025,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ UCBC, 'CanBuildCategory', { categories.LAND * categories.MOBILE * categories.SHIELD * categories.DEFENSE - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 3, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            { SBC, 'HaveUnitRatioSorian', { 0.2, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.COMMAND}},
        },
    },
}

------------------------------------------
-- T2 Factories - Naval Map
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandFactoryBuilders - water map',
    BuildersType = 'FactoryBuilder',
    -- Tech 2 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2 - water map aeon',
        PlatoonTemplate = 'T2AttackTank',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - Tech 2 - water map',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.MOBILE * categories.HOVER * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.COMMAND}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileAA - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAA',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.ANTIAIR * (categories.HOVER + categories.AMPHIBIOUS) } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.DIRECTFIRE * (categories.HOVER + categories.AMPHIBIOUS) } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 2500,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.DIRECTFIRE * (categories.HOVER + categories.AMPHIBIOUS) } },
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 2925,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
            { SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.DIRECTFIRE * (categories.HOVER + categories.AMPHIBIOUS) } },
        },
    },
}

------------------------------------------
-- T2 Response Builder
-- Used to respond to the sight of tanks nearby
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2ReactionDF',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Tank Enemy Nearby',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 2500,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T2 AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak',
        PlatoonTemplate = 'T2LandAA',
        Priority = 3500,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.COMMAND }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak Response',
        PlatoonTemplate = 'T2LandAA',
        Priority = 2500,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T3 Land
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- T3 Tank
    Builder {
        BuilderName = 'SorianEdit T3 Siege Assault Bot',
        PlatoonTemplate = 'T3LandBot',
        Priority = 3950,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3ArmoredAssault',
        PlatoonTemplate = 'T3ArmoredAssault',
        Priority = 39500,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
    },
    -- T3 Artilery
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 40000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3 }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery Enemy Turtle',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 40000,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3 }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery - tough def',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 40000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3 }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Flak',
        PlatoonTemplate = 'T3LandAA',
        Priority = 40000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.9 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.TECH2 - categories.COMMAND }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3SniperBots',
        PlatoonTemplate = 'T3SniperBots',
        Priority = 40000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.BOT * categories.INDIRECTFIRE }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3SniperBots Enemy Turtle',
        PlatoonTemplate = 'T3SniperBots',
        Priority = 40000,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.BOT * categories.INDIRECTFIRE }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileMissile',
        PlatoonTemplate = 'T3MobileMissile',
        Priority = 40000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileMissile Enemy Turtle',
        PlatoonTemplate = 'T3MobileMissile',
        Priority = 40000,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileShields',
        PlatoonTemplate = 'T3MobileShields',
        Priority = 40000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
			{ UCBC, 'CanBuildCategory', { categories.LAND * categories.MOBILE * categories.TECH3 * categories.SHIELD * categories.DEFENSE - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.MOBILE * categories.TECH3 * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            { SBC, 'HaveUnitRatioSorian', { 0.2, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.COMMAND}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileShields Enemy Turtle',
        PlatoonTemplate = 'T3MobileShields',
        Priority = 40000,
        PriorityFunction = TurtleAttackPrio,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'CanBuildCategory', { categories.LAND * categories.MOBILE * categories.TECH3 * categories.SHIELD * categories.DEFENSE - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.MOBILE * categories.TECH3 * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
        },
    },
}

------------------------------------------
-- T3 AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA',
        PlatoonTemplate = 'T3LandAA',
        Priority = 3200,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.60, 0.8 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.TECH2 }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.COMMAND - categories.TECH2, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA Response',
        PlatoonTemplate = 'T3LandAA',
        Priority = 3200,
        BuilderConditions = {
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.60, 0.8 }},
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T3 Response
-----------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3ReactionDF',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Assault Enemy Nearby',
        PlatoonTemplate = 'T3ArmoredAssault',
        Priority = 3945,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 SiegeBot Enemy Nearby',
        PlatoonTemplate = 'T3LandBot',
        Priority = 3935,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.65, 0.75 }},
        },
        BuilderType = 'Land',
    },
}

-- ===================== --
--     Form Builders
-- ===================== --

BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack Default',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        Priority = 1000,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 95,
            TargetSearchCategory = (categories.MOBILE * categories.LAND - categories.SCOUT) + (categories.STRUCTURE * categories.ECONOMIC) - categories.WALL,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.COMMAND,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 2, categories.MOBILE * categories.LAND - categories.ENGINEER } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Medium',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        Priority = 1300,
        InstanceCount = 24,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 95,
            TargetSearchCategory = (categories.MOBILE * categories.LAND - categories.SCOUT) + (categories.STRUCTURE * categories.ECONOMIC) - categories.WALL,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.COMMAND,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 5, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Large',
        PlatoonTemplate = 'LandAttackLargeSorianEdit',
        Priority = 1400,
        InstanceCount = 12,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 95,
            TargetSearchCategory = (categories.MOBILE * categories.LAND - categories.SCOUT) + (categories.STRUCTURE * categories.ECONOMIC) - categories.WALL,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.COMMAND,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 12, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Early Game',
        PlatoonTemplate = 'MassHuntersCategorySorianEditSmall',
        Priority = 1600,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 140 } },
				{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, categories.MOBILE * categories.LAND - categories.ENGINEER } },
            },
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            AggressiveMove = true,
            AvoidBases = true,
            AvoidBasesRadius = 150,
            PrioritizedCategories = {
                'STRUCTURE ECONOMIC',
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Late Game',
        PlatoonTemplate = 'MassHuntersCategorySorianEditLarge',
        Priority = 1500,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 440 } },
				{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 4, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            AggressiveMove = true,
            AvoidBases = true,
            AvoidBasesRadius = 150,
            PrioritizedCategories = {
                'STRUCTURE ECONOMIC',
            },
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol',
        PlatoonTemplate = 'StartLocationAttackSorianEdit',
        Priority = 2000,
        BuilderConditions = {
                { UCBC, 'LessThanGameTimeSeconds', { 220 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 75,
            MarkerType = 'Start Location',
            MoveFirst = 'Closest',
            LocationType = 'LocationType',
            MoveNext = 'None',
            AvoidBases = true,
            AvoidBasesRadius = 100,
            AggressiveMove = false,
            AvoidClosestRadius = 50,
            GuardTimer = 30,
            UseFormation = 'None',
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
}
	do
	LOG('--------------------- SorianEdit Land attack Builders loaded')
	end
