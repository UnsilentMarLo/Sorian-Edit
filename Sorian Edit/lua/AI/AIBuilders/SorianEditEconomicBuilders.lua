--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/AIEconomicBuilders.lua
--**
--**  Summary  : Default economic builders for skirmish
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local BBTmplFile = '/lua/basetemplates.lua'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'							
local ExBaseTmpl = 'ExpansionBaseTemplates'
local Adj2x2Tmpl = 'Adjacency2x2'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/AITargetManager.lua').GetDangerZoneRadii()

	do
	LOG('--------------------- SorianEdit Eco Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- ============
    --    TECH 1
    -- ============
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Minimum',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 2900,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.MOBILE * categories.ENGINEER * categories.TECH1 }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 90 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH1 * categories.ENGINEER } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Pool',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 1125, --800,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.15 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.55 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Overflow',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 4125, --800,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.45, 0.0 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Constant',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 3900,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 260 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH1 * categories.ENGINEER } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 2
    -- ============
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Init',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 4525,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.MOBILE * categories.TECH2 * categories.ENGINEER } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH2 * categories.ENGINEER } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Minimum',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 4500,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.06, 0.15 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.MOBILE * categories.ENGINEER * categories.TECH2 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH2 * categories.ENGINEER } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 1',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 4400,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.55 }},
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.ENGINEER - categories.TECH1 - categories.COMMAND - categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 3
    -- ============
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Init',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 12250,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.MOBILE * categories.TECH3 * categories.ENGINEER } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH3 * categories.ENGINEER } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Minimum',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 3235,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH3 * categories.ENGINEER } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 1',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 12800,
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.ENGINEER - categories.TECH2 - categories.TECH1 - categories.COMMAND } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.25, 1.25 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerNavalFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- ============
    --    TECH 1
    -- ============
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init - Naval',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH2 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH1 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
	
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Naval',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 450,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH2 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH1 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 2
    -- ============
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Naval',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 450,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH2 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
	
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Naval - init',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 1000,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH2 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 3
    -- ============
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Init - Naval',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 950,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH3 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler - Naval',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 1100,
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.TECH3 * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryBuildersExpansion rush',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 600,
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Init',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Init',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryBuilders - Rush',
    BuildersType = 'FactoryBuilder',
    -- ============
    --    TECH 1
    -- ============
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init - Rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, categories.ENGINEER * categories.TECH1 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 1 - Rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 825, --800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 10, categories.ENGINEER * categories.TECH1 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 2
    -- ============
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Init - Rush',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, categories.ENGINEER * categories.TECH2 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 1 - Rush',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, categories.ENGINEER * categories.TECH2 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, categories.FACTORY * categories.TECH3 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 3
    -- ============
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Init - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 1250,
        BuilderConditions = {
            { UCBC,'EngineerLessAtLocation', { 'LocationType', 15, categories.ENGINEER * categories.TECH3 }},
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 32, categories.ENGINEER * categories.TECH3 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 22, categories.ENGINEER * categories.TECH3 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3 - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3 Econ - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
}

BuilderGroup {
	BuilderGroupName = 'SorianEdit T3 Sub Commander',
    BuildersType = 'FactoryBuilder',
	
    Builder {
        BuilderName = 'Sorian Edit T3 SubCommander RAMBO',
        PlatoonTemplate = 'Sorian Edit T3 SACU RAMBO preset 12345',
        Priority = 1025,
        BuilderConditions = { 
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.35, 1.40 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.07, 0.01}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RAMBOPRESET }},
        },
        BuilderType = 'Gate',
    },
    Builder {
        BuilderName = 'Sorian Edit T3 SubCommander RAS',
        PlatoonTemplate = 'Sorian Edit T3 SACU RAS preset 123x5',
        Priority = 1035,
        BuilderConditions = {
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 1.2 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.05, 0.01}},
            { MIBC, 'FactionIndex', { 1, 2, 3, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
            { UCBC, 'HaveLessThanUnitsWithCategory', { 50, categories.ENGINEERPRESET + categories.RASPRESET } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.RASPRESET} },
        },
        BuilderType = 'Gate',
    },
    Builder {
        BuilderName = 'Sorian Edit T3 SubCommander ENGINEER - Seraphim',
        PlatoonTemplate = 'Sorian Edit T3 SACU ENGINEER preset 12345',
        Priority = 1020,
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 4 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
            { UCBC, 'EngineerCapCheck', { 'LocationType', 'SCU' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 50, categories.ENGINEERPRESET + categories.RASPRESET } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType',  3, categories.ENGINEERPRESET + categories.RASPRESET } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 10, categories.ENGINEERPRESET + categories.RASPRESET} },
        },
        BuilderType = 'Gate',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'SorianEdit CDR Initial Balanced',
        -- PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 20000000,
        BuilderConditions = {
		},
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            ScanWait = 60,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditACUBuilders',
    BuildersType = 'EngineerBuilder',
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Power - Init',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 4100000,
        BuilderConditions = {
			{ UCBC, 'LessThanGameTimeSeconds', { 150 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH1 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR Base Mex Init',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 4000000,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 150 } },
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 20, -500, 0, 0, 'AntiSurface', 1 }},
				{ UCBC, 'HaveLessThanUnitsWithCategory', {2, categories.MASSEXTRACTION * categories.TECH1 - categories.COMMAND } },
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Power - Init 2nd',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 2000000,
        BuilderConditions = {
			{ UCBC, 'LessThanGameTimeSeconds', { 150 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH1 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR Base Mex 2nd',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000000,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 120 } },
				{ UCBC, 'HaveLessThanUnitsWithCategory', {3, categories.MASSEXTRACTION * categories.TECH1 - categories.COMMAND } },
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 15, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit CDR Base Mex 2+ After Hydro',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 555000,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 140 } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.HYDROCARBON } },
				{ UCBC, 'HaveLessThanUnitsWithCategory', {4, categories.MASSEXTRACTION * categories.TECH1 - categories.COMMAND } },
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 20, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit CDR T1 Power - Init 2nd',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 400000,
        BuilderConditions = {
			{ UCBC, 'LessThanGameTimeSeconds', { 250 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH1 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Land - Init 2nd',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 390000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.23, 0.3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY } },
			{ SIBC, 'HaveLessThanMapSize', { 1025 } },
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air - Init 2nd aHydro',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 389900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.34 } },
			{ SBC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 100}},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'HYDROCARBON',
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air - Init 2nd',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 389900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.34 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.HYDROCARBON } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Land - Init 4',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 380000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.FACTORY } },
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air - Init 4 aHydro',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 380000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.FACTORY } },
			{ SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'HYDROCARBON',
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air - Init 4',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 380000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.HYDROCARBON } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.FACTORY } },
			{ SBC, 'CanPathToCurrentEnemy', { false, 'LocationType' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T1 Factory ACU - Overbuild',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 60 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 8, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND - categories.HYDROCARBON } },
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T2 Factory ACU - Overbuild',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 800,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH2 - categories.SUPPORTFACTORY} },
            { UCBC, 'GreaterThanGameTimeSeconds', { 400 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.4, 1.4 }}, -- { 1.0, 1.0 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2SupportLandFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit CDR T1 Power - additional',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 3500,
        BuilderConditions = {
            { EBC, 'LessThanEconStorageRatio', { 1.0, 0.2 } },
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.ENERGYPRODUCTION }},
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    -- CDR Assisting
    Builder {
        BuilderName = 'SorianEdit CDR Assist Hydrocarbon',
        PlatoonTemplate = 'CommanderAssist',
        Priority = 21000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuiltAtLocation', { 'LocationType', 0, categories.STRUCTURE * categories.HYDROCARBON }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Structure',
                AssistRange = 60,
                BeingBuiltCategories = {'STRUCTURE HYDROCARBON'},
                AssistUntilFinished = true,
            },
        }
    },
    -- CDR Assisting
    Builder {
        BuilderName = 'SorianEdit CDR Assist T4',
        PlatoonTemplate = 'CommanderAssistSorianEdit',
        Priority = 750,
        BuilderConditions = {
			{ UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'EXPERIMENTAL' }},
			-- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.2, 1.2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssisteeType = 'Engineer',
                AssistLocation = 'LocationType',
                AssistRange = 100,
                BeingBuiltCategories = {'EXPERIMENTAL'},
                Time = 60,
            },
        }
    },
    Builder {
       BuilderName = 'SorianEdit CDR Assist Factory Upgrade Tech 2',
       PlatoonTemplate = 'CommanderAssistSorianEdit',
       Priority = 6000,
       BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.6 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.9 }},
			{ UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.TECH2 * categories.FACTORY } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND } },
			-- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 } },
       },
       BuilderType = 'Any',
       BuilderData = {
           Assist = {
               AssistLocation = 'LocationType',
               AssisteeType = 'Factory',
               PermanentAssist = false,
               BeingBuiltCategories = {'FACTORY TECH2',},
               Time = 40,
           },
       }
    },
    Builder {
       BuilderName = 'SorianEdit CDR Assist Factory Upgrade Tech 3',
       PlatoonTemplate = 'CommanderAssistSorianEdit',
       Priority = 6000,
       BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.9 }},
           { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.TECH3 * categories.FACTORY } },
           { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TECH3 * categories.FACTORY } },
           -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 } },
       },
       BuilderType = 'Any',
       BuilderData = {
           Assist = {
               AssistLocation = 'LocationType',
               AssisteeType = 'Factory',
               PermanentAssist = false,
               BeingBuiltCategories = {'FACTORY TECH3',},
               Time = 40,
           },
       }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSCUUpgrades',
    BuildersType = 'EngineerBuilder',
    -- UEF
    Builder {
        BuilderName = 'SorianEdit UEF SCU Upgrade',
        PlatoonTemplate = 'SCUEnhance',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {1}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 }},
                { SBC, 'SCUNeedsUpgrade', { 'Pod' }},
            },
        Priority = 900,
        BuilderType = 'Any',
        BuilderData = {
            Enhancement = { 'ResourceAllocation', 'Pod' },
        },
    },
    -- Aeon
    Builder {
        BuilderName = 'SorianEdit Aeon SCU Upgrade',
        PlatoonTemplate = 'SCUEnhance',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {2}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 }},
                { SBC, 'SCUNeedsUpgrade', { 'EngineeringFocusingModule' }},
            },
        Priority = 900,
        BuilderType = 'Any',
        BuilderData = {
            Enhancement = { 'ResourceAllocation', 'EngineeringFocusingModule' },
        },
    },
    -- Cybran
    Builder {
        BuilderName = 'SorianEdit Cybran SCU Upgrade',
        PlatoonTemplate = 'SCUEnhance',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {3}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 }},
                { SBC, 'SCUNeedsUpgrade', { 'Switchback' }},
            },
        Priority = 900,
        BuilderType = 'Any',
        BuilderData = {
            Enhancement = { 'ResourceAllocation', 'Switchback' },
        },
    },
    -- Seraphim
    Builder {
        BuilderName = 'SorianEdit Seraphim SCU Upgrade',
        PlatoonTemplate = 'SCUEnhance',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {4}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 }},
                { SBC, 'SCUNeedsUpgrade', { 'EngineeringThroughput' }},
            },
        Priority = 900,
        BuilderType = 'Any',
        BuilderData = {
            Enhancement = { 'EngineeringThroughput' },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditACUUpgrades',
    BuildersType = 'EngineerBuilder', --'PlatoonFormBuilder',
    -- UEF
    Builder {
        BuilderName = 'SorianEdit UEF CDR Upgrade T3 Eng - Shields',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {1}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'ResourceAllocation', 'RightPodRemove', 'Shield' },
        },
    },

    -- Aeon
    Builder {
        BuilderName = 'SorianEdit Aeon CDR Upgrade AdvEng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {2}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'HeatSink', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Aeon CDR Upgrade T3 Eng - ResourceAdv - EnhSensor',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {2}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'HeatSink', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'Shield', 'HeatSink' },
        },
    },

    -- Cybran
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade AdvEng - Adv Eng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.2, 2.0 }},
                { MIBC, 'FactionIndex', {3}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { SBC, 'CmdrHasUpgrade', { 'MicrowaveLaserGenerator', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'StealthGenerator', 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade T3 Eng - Laser Gen',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {3}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'MicrowaveLaserGenerator', false }},
            },
        Priority = 0, --900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'MicrowaveLaserGenerator' },
        },
    },

    -- Seraphim
    Builder {
        BuilderName = 'SorianEdit Seraphim CDR Upgrade AdvEng - Resource - Crysalis',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {4}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedEngineering', 'RegenAura', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Seraphim CDR Upgrade T3 Eng - ResourceAdv - EnhSensor',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                { MIBC, 'FactionIndex', {4}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedRegenAura' },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1EngineerBuilders',
    BuildersType = 'EngineerBuilder',
    -- =====================================
    --     T1 Engineer Resource Builders
    -- =====================================
    Builder {
        BuilderName = 'SorianEdit T1 Hydrocarbon Engineer - init',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 5960000,
        BuilderConditions = {
                { SBC, 'CanBuildOnHydroLessThanDistance', { 'LocationType', 80, -500, 0, 0, 'AntiSurface', 1 }},
                -- { SBC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 200}},
            },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1HydroCarbon',
                }
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T1 Hydrocarbon Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 980,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION } },
                { SBC, 'CanBuildOnHydroLessThanDistance', { 'LocationType', 1600, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1HydroCarbon',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Engineer Reclaim',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1REC',
        Priority = 1000,
        InstanceCount = 1,
        BuilderConditions = {
                { EBC, 'LessThanEconStorageRatio', { 0.5, 2}},
                { SBC, 'ReclaimablesInArea', { 'LocationType', 75 }},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Engineer Reclaim - Low Mass',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1REC',
        Priority = 1000,
        InstanceCount = 4,
        BuilderConditions = {
                { SBC, 'ReclaimablesInArea', { 'LocationType', 500 }},
                { EBC, 'LessThanEconStorageRatio', { 0.2, 1}},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Engineer Reclaim - very Low Mass',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1REC',
        Priority = 2000,
        InstanceCount = 4,
        BuilderConditions = {
                { SBC, 'ReclaimablesInArea', { 'LocationType', 500 }},
                { EBC, 'LessThanEconStorageRatio', { 0.05, 1}},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Reclaim Old Pgens',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        PlatoonAIPlan = 'ReclaimStructuresAI',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ENERGYPRODUCTION * categories.TECH1 - categories.HYDROCARBON}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {categories.STRUCTURE * categories.TECH1 * categories.ENERGYPRODUCTION - categories.HYDROCARBON},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Find Unfinished',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        PlatoonAIPlan = 'ManagerEngineerFindUnfinished',
        Priority = 800,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE STRATEGIC, STRUCTURE ECONOMIC, STRUCTURE'},
                Time = 20,
            },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Repair',
        PlatoonTemplate = 'EngineerRepairSorianEdit',
        PlatoonAIPlan = 'RepairAI',
        Priority = 900,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'DamagedStructuresInArea', { 'LocationType', }},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mass Adjacency Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 122500,
        InstanceCount = 1,
        -- DelayEqualBuildPlatoons = {'MASSSTORAGE', 3},
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 6*60 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1,  categories.STRUCTURE * categories.MASSSTORAGE }},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 40, -3, 0, 0}},
			{ UCBC, 'HaveForEach', { categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3), 4, categories.STRUCTURE * categories.MASSSTORAGE }},
			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 2, categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) }},
            { UCBC, 'AdjacencyCheck', { 'LocationType', categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3), 10, 'ueb1106' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = categories.MASSEXTRACTION * (categories.TECH3 + categories.TECH2),
                AdjacencyDistance = 10,
                BuildClose = false,
                BuildStructures = {
                    'MassStorage',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energy Storage Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 800,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 410 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 1.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.STRUCTURE * categories.ENERGYSTORAGE }},
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ENERGYPRODUCTION * categories.HYDROCARBON }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
           -- { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION HYDROCARBON', 100, 'ueb1102' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'HYDROCARBON',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'EnergyStorage',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energy Storage Engineer min',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2000,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconIncome', { 3, 35 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.ENERGYSTORAGE }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'HYDROCARBON',
                AdjacencyPriority = {
                    categories.HYDROCARBON * categories.STRUCTURE,
                    categories.ENERGYPRODUCTION * categories.STRUCTURE,
                },
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'EnergyStorage',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energy',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2300,
        InstanceCount = 2,
        DelayEqualBuildPlatoons = {'CheapEnergyBuilding', 4},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.4 } },
            { EBC, 'LessThanEconTrend', { 10000.0, 0.8 }},
            -- { UCBC, 'CheckBuildPlatoonDelay', { 'CheapEnergyBuilding' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 50,
                maxUnits = 1,
                maxRadius = 2.5,
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energy minimum',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2300000,
        InstanceCount = 1,
        DelayEqualBuildPlatoons = {'CheapEnergyBuilding', 4},
        BuilderConditions = {
			{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.ENERGYPRODUCTION * categories.TECH1 - categories.COMMAND } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.HYDROCARBON }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 50,
                maxUnits = 1,
                maxRadius = 2.5,
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energyratio',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1200,
        InstanceCount = 2,
        DelayEqualBuildPlatoons = {'CheapEnergyBuilding', 4},
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 2*60 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.0 } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND } },
			{ UCBC, 'HaveForEach', { categories.FACTORY, 10, categories.ENERGYPRODUCTION}},
            -- { UCBC, 'CheckBuildPlatoonDelay', { 'CheapEnergyBuilding' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 50,
                maxUnits = 1,
                maxRadius = 2.5,
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Assist Engineer',
        PlatoonTemplate = 'EngineerAssistSorianEdit',
        Priority = 500,
        DelayEqualBuildPlatoons = {'EngineerAssistDelays', 4},
        InstanceCount = 8,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.ALLUNITS } },
            { UCBC, 'CheckBuildPlatoonDelay', { 'EngineerAssistDelays' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                AssisteeType = 'Engineer',
                Time = 30,
            },
        }
    },
    Builder {
       BuilderName = 'Sorian T1 Engineer Assist Mass Upgrade',
       PlatoonTemplate = 'EngineerAssistSorianEdit',
       Priority = 850,
       BuilderConditions = {
           { UCBC, 'BuildingGreaterAtLocation', { 'LocationType', 0, categories.MASSEXTRACTION * categories.TECH2 }},
           { UCBC, 'HaveLessThanUnitsWithCategory', { 5, categories.MASSEXTRACTION - categories.TECH1 - categories.COMMAND } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
           { SIBC, 'LessThanEconEfficiencyOverTime', { 1.5, 2.0 }},
       },
       InstanceCount = 2,
       BuilderType = 'Any',
       BuilderData = {
           Assist = {
               AssisteeType = 'Structure',
               AssistLocation = 'LocationType',
               BeingBuiltCategories = {'MASSEXTRACTION TECH2'},
               Time = 60,
           },
       }
    },
    Builder {
       BuilderName = 'Sorian T1 Engineer Assist T2 Factory Upgrade',
       PlatoonTemplate = 'EngineerAssistSorianEdit',
       Priority = 875,
       BuilderConditions = {
           { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH1}},
           { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.FACTORY * categories.TECH2 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
       },
       InstanceCount = 4,
       BuilderType = 'Any',
       BuilderData = {
           Assist = {
               AssistLocation = 'LocationType',
               PermanentAssist = false,
               BeingBuiltCategories = {'FACTORY TECH2'},
               AssisteeType = 'Factory',
               Time = 60,
           },
       }
    },
    Builder {
       BuilderName = 'Sorian T1 Engineer Assist T3 Factory Upgrade',
       PlatoonTemplate = 'EngineerAssistSorianEdit',
       Priority = 900,
       BuilderConditions = {
           { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH1}},
           { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.FACTORY * categories.TECH3 }},
           { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.TECH3 * categories.FACTORY } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
       },
       InstanceCount = 8,
       BuilderType = 'Any',
       BuilderData = {
           Assist = {
               AssistLocation = 'LocationType',
               PermanentAssist = false,
               BeingBuiltCategories = {'FACTORY TECH3'},
               AssisteeType = 'Factory',
               Time = 60,
           },
       }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2EngineerBuilders',
    BuildersType = 'EngineerBuilder',
    -- =====================================
    --     T2 Engineer Resource Builders
    -- =====================================
    Builder {
        BuilderName = 'SorianEdit T2 Mass Adjacency Engineer',
        PlatoonTemplate = 'AnyEngineerBuilderSorianEdit',
        Priority = 18050,
        -- DelayEqualBuildPlatoons = {'MASSSTORAGE', 3},
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 6*60 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3,  categories.STRUCTURE * categories.MASSSTORAGE }},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 256, -3, 0, 0}},
			{ UCBC, 'HaveForEach', { categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3), 4, categories.STRUCTURE * categories.MASSSTORAGE }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) }},
            { UCBC, 'AdjacencyCheck', { 'LocationType', categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3), 10, 'ueb1106' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = categories.MASSEXTRACTION * (categories.TECH3 + categories.TECH2),
                AdjacencyDistance = 10,
                BuildClose = false,
                BuildStructures = {
                    'MassStorage',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Energy Storage Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 12, categories.STRUCTURE * categories.ENERGYSTORAGE }},
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ENERGYPRODUCTION * categories.TECH2 }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
           -- { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION HYDROCARBON', 100, 'ueb1102' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'HYDROCARBON',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'EnergyStorage',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Reclaim Old Pgens',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ReclaimStructuresAI',
        Priority = 900,
        InstanceCount = 3,
        BuilderConditions = {
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ENERGYPRODUCTION * categories.TECH1 - categories.HYDROCARBON}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {categories.STRUCTURE * categories.TECH1 * categories.ENERGYPRODUCTION - categories.HYDROCARBON},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Find Unfinished',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ManagerEngineerFindUnfinished',
        Priority = 1800,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE STRATEGIC, STRUCTURE ECONOMIC, STRUCTURE'},
                Time = 20,
            },
        },
        BuilderType = 'Any',
    },

    -- =========================
    --     T2 ENGINEER ASSIST
    -- =========================
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Energy',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 900,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND } },
            { SIBC, 'LessThanEconEfficiencyOverTime', { 2.0, 1.5 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.5 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = { 'ENERGYPRODUCTION TECH3', 'ENERGYPRODUCTION TECH2', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Factory',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 500,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderConditions = {
            -- { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' } },
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.7 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                --BeingBuiltCategories = { 'MOBILE',},
                AssisteeType = 'Factory',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Engineer',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 500,

        InstanceCount = 6,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ALLUNITS' } },
            -- { UCBC, 'CheckBuildPlatoonDelay', { 'EngineerAssistDelays' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = { 'ALLUNITS' },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist T3 Factory Upgrade',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 975,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH2}},
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.FACTORY * categories.TECH3 }},
            -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 1.1 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.4 } },
        },
        InstanceCount = 5,
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = {'FACTORY TECH3'},
                AssisteeType = 'Factory',
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3EngineerBuilders',
    BuildersType = 'EngineerBuilder',
    -- =========================
    --     T3 ENGINEER BUILD
    -- =========================
    Builder {
        BuilderName = 'SorianEdit T3 Energy Storage Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 12, categories.STRUCTURE * categories.ENERGYSTORAGE }},
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, 'ENERGYPRODUCTION TECH3' }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
           -- { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION HYDROCARBON', 100, 'ueb1102' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'HYDROCARBON',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'EnergyStorage',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Strategic Missile Defence Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2000,
        BuilderConditions = {
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.10 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.75, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = categories.ENERGYPRODUCTION * categories.TECH3,
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Find Unfinished',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ManagerEngineerFindUnfinished',
        Priority = 1800,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE + categories.EXPERIMENTAL}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'EXPERIMENTAL, STRUCTURE STRATEGIC, STRUCTURE ECONOMIC, STRUCTURE'},
                Time = 20,
            },
        },
        BuilderType = 'Any',
    },
    -- =========================
    --     T3 ENGINEER ASSIST
    -- =========================
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist T3 Energy Production',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 947, --950,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.ENERGYPRODUCTION * categories.TECH3 }},
            { SIBC, 'LessThanEconEfficiencyOverTime', { 2, 1.3}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.5 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = {'ENERGYPRODUCTION TECH3'},
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Mass Fab',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 }},
                { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'MASSPRODUCTION TECH3' }},
                { SIBC, 'LessThanEconEfficiencyOverTime', { 0.9, 2.0}},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                BeingBuiltCategories = { 'MASSPRODUCTION TECH3', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Defenses',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 750,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 }},
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE DEFENSE' }},
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                BeingBuiltCategories = { 'STRUCTURE DEFENSE', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Shields',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 750,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE SHIELD' }},
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                BeingBuiltCategories = { 'STRUCTURE SHIELD', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Factory',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 700,
        InstanceCount = 5,
        BuilderConditions = {
            -- { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' }},
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                AssisteeType = 'Factory',
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Engineer',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        DelayEqualBuildPlatoons = {'EngineerAssistDelays', 4},
        Priority = 700,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE, EXPERIMENTAL' }},
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = { 'SHIELD STRUCTURE', 'DEFENSE ANTIAIR', 'DEFENSE DIRECTFIRE', 'DEFENSE ANTINAVY', 'ENERGYPRODUCTION',
                                        'EXPERIMENTAL', 'ALLUNITS', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'Sorianedit Mass Builders',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorianedit Mass 30',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 196000,
        InstanceCount = 3,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 100 } },
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 30, -500, 1000, 0, 'AntiSurface', 1 }}, 

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = false,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit early Mass 60',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 18700,
        InstanceCount = 2,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 100 } },
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 60, -500, 1000, 0, 'AntiSurface', 1 }}, 
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = false,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 60',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 18700,
        InstanceCount = 4,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 320 }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 60, -500, 1000, 0, 'AntiSurface', 1 }}, 
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 250 low prio',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2470,
        InstanceCount = 6,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 120 }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 1000, 0, 'AntiSurface', 1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = false,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 250',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 14700,
        InstanceCount = 2,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 320 }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 1000, 0, 'AntiSurface', 1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 1000 2',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 840,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 320 }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1000, -500, 1000, 0, 'AntiSurface', 1 }}, 
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENGINEER * categories.TECH1 }},

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianeditAssistNavy',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit Engineer Assist Naval Factory',
        PlatoonTemplate = 'EngineerAssistSorianEdit',
        Priority = 20000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = true,
                BeingBuiltCategories = {'NAVAL'},
                AssisteeType = 'Factory',
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianeditAssistFactoryPerm',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit Engineer Assist Factory',
        PlatoonTemplate = 'EngineerFactoryAssistSorianEditALL',
        Priority = 2000,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 120 }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.FACTORY * categories.TECH1 }},
        },
        BuilderData = {}
    },
}

BuilderGroup {
    BuilderGroupName = 'Sorianedit Mass Builders Tech 2',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorianedit Mass 30 T2',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH2',
        Priority = 1860,
        InstanceCount = 2,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 30, -500, 1000, 0, 'AntiSurface', 1 }}, 

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 60 T2',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH2',
        Priority = 1350,
        InstanceCount = 4,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 60, -500, 1000, 0, 'AntiSurface', 1 }}, 

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 1000 2+ T2',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH2',
        Priority = 1340,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        InstanceCount = 2,
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1000, -500, 1000, 0, 'AntiSurface', 1 }}, 

            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6, categories.ENGINEER * categories.TECH2 }},

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'Sorianedit Mass Builders Tech 3',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorianedit Mass 30 T3',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH3',
        Priority = 18600,
        InstanceCount = 2,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 30, -500, 1000, 0, 'AntiSurface', 1 }}, 

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T3Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 60 T3',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH3',
        Priority = 18500,
        InstanceCount = 2,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 60, -500, 1000, 0, 'AntiSurface', 1 }}, 

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T3Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorianedit Mass 1000 2+ T3',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH3',
        Priority = 1840,
        -- DelayEqualBuildPlatoons = {'MASSEXTRACTION', 3},
        InstanceCount = 2,
        BuilderConditions = {
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1000, -500, 1000, 0, 'AntiSurface', 1 }}, 

            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH1 }},

            -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
				NeedGuard = false,
				DesiresAssist = false,
                RepeatBuild = true,
                BuildStructures = {
                    'T3Resource',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'Sorianedit MassFab Builders',                              
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit MassFab T2',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH2',
        Priority = 15000,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'MASSFABRICATION TECH3' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.95}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH2 }},
			{ UCBC, 'HaveForEach', { categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH2, 4, categories.STRUCTURE * categories.MASSFABRICATION }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1MassCreation',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit MassFab T3',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH3',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.95}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3 }},
			{ UCBC, 'HaveForEach', { categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3, 2, categories.STRUCTURE * categories.MASSFABRICATION * categories.TECH3 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T3MassCreation',
                },
            }
        }
    },
}



BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerEnergyBuilders',
    BuildersType = 'EngineerBuilder',
    -- =====================================
    --     T2 Engineer Resource Builders
    -- =====================================
    Builder {
        BuilderName = 'SorianEdit T1 Power Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 4000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 150 } },
            { EBC, 'LessThanEconTrend', { 10000.0, 0.9 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION - categories.TECH1 - categories.COMMAND - categories.HYDROCARBON } },
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 50,
                maxUnits = 1,
                maxRadius = 2.5,
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 2250,
        InstanceCount = 1,
        BuilderConditions = {
            -- { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'TECH3 ENGINEER' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2}},
            { EBC, 'LessThanEconTrend', { 10000.0, 1.1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T2EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer - Overbuild',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 3000,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.0 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
            { EBC, 'LessThanEconTrend', { 10000.0, 1.5 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION TECH2',
                maxUnits = 1,
                maxRadius = 20,
                RepeatBuild = true,
                BuildStructures = {
                    'T2EnergyProduction',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T3 Power Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 55000,
        InstanceCount = 1,
        BuilderType = 'Any',
        BuilderConditions = {
            { EBC, 'LessThanEconTrend', { 10000.0, 0.8 }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.2, 0.1 }},
        },
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T3EnergyProduction',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer - init',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1250000,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH2}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T2EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Power Engineer - init',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1350000000,
        InstanceCount = 1,
        BuilderType = 'Any',
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 }},
        },
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY AIR',
                BuildStructures = {
                    'T3EnergyProduction',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerEnergyBuildersExpansions',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer Expansions',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
                { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ENERGYPRODUCTION * categories.TECH2 } },
                -- { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'TECH3 ENGINEER' }},
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH2}},
                -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
                { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = categories.FACTORY,
                AvoidCategory = 'ENERGYPRODUCTION TECH2',
                maxUnits = 4,
                maxRadius = 20,
                BuildStructures = {
                    'T2EnergyProduction',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Power Engineer Expansions',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1000,
        BuilderType = 'Any',
        BuilderConditions = {
                { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ENERGYPRODUCTION * categories.TECH3 } },
                -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
                { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            },
        BuilderData = {
            Construction = {
                BuildStructures = {
                   'T3EnergyProduction',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineeringSupportBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Engineering Support Cybran',
        PlatoonTemplate = 'CybranT2EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                BuildClose = true,
                FactionIndex = 3,
                BuildStructures = {
                    'T2EngineerSupport',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineering Support Cybran',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildClose = true,
                FactionIndex = 3,
                BuildStructures = {
                    'T2EngineerSupport',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineeringUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Engineeering Support Upgrade 1',
        PlatoonTemplate = 'T2Engineering1',
        Priority = 10,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineeering Support Upgrade 2',
        PlatoonTemplate = 'T2Engineering2',
        Priority = 5,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassFabPause',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'Mass Fabricator Pause',
        PlatoonTemplate = 'MassFabsSorianEdit',
        Priority = 300,
        InstanceCount = 3,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSFABRICATION}},
                { EBC, 'LessThanEconStorageRatio',  { 1.1, 0.6}},
            },
        BuilderType = 'Any',
        FormRadius = 10000,
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditAcuAttackFormBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEditLongRangeACUAttack',
        PlatoonTemplate = 'CDR Attack',
        Priority = 2500,
        InstanceCount = 1,
        BuilderData = {
            SearchRadius = 512,
            GetTargetsFromBase = true,
            RequireTransport = false,
            AttackEnemyStrength = 2000,
            IgnorePathing = true,
            NodeWeight = 10000,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL - (categories.MOBILE * categories.AIR) - categories.STRUCTURE,
            MoveToCategories = {
                categories.COMMAND,
                categories.LAND - categories.ANTIAIR,
                categories.LAND,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.LAND - categories.ANTIAIR - categories.ENGINEER,
                categories.LAND - categories.ENGINEER,
                categories.ECONOMIC,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 300 }},
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.STRUCTURE * categories.FACTORY * categories.LAND - categories.SUPPORTFACTORY } },
            { UCBC, 'EnemyUnitsGreaterAtLocationRadius', { 512, 'LocationType', 0, categories.ALLUNITS - (categories.ENGINEER * categories.TECH1 * categories.TECH2) - categories.AIR - categories.SCOUT }},
        },
        BuilderType = 'Any',
    },
	
    Builder {
        BuilderName = 'SorianEditLongRangeACUAttack Close',
        PlatoonTemplate = 'CDR Attack',
        Priority = 2500,
        InstanceCount = 1,
        BuilderData = {
            SearchRadius = 86,
            GetTargetsFromBase = true,
            RequireTransport = false,
            AttackEnemyStrength = 2000,
            IgnorePathing = true,
            NodeWeight = 10000,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL - (categories.MOBILE * categories.AIR) - categories.STRUCTURE,
            MoveToCategories = {
                categories.COMMAND,
                categories.LAND - categories.ANTIAIR,
                categories.LAND,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.LAND - categories.ANTIAIR - categories.ENGINEER,
                categories.LAND - categories.ENGINEER,
                categories.ECONOMIC,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 300 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.STRUCTURE * categories.FACTORY * categories.LAND - categories.SUPPORTFACTORY } },
            { UCBC, 'EnemyUnitsGreaterAtLocationRadius', { 86, 'LocationType', 0, categories.ALLUNITS - (categories.ENGINEER * categories.TECH1 * categories.TECH2) - categories.AIR - categories.SCOUT }},
        },
        BuilderType = 'Any',
    },
	
    Builder {
        BuilderName = 'SorianEditT3Teleport1',
        PlatoonTemplate = 'Sorian Edit T3 SACU Teleport 1 1',
        Priority = 21000,
        InstanceCount = 2,
        FormRadius = 10000,
        BuilderData = {
            SearchRadius = 10000,
            GetTargetsFromBase = false,
            AggressiveMove = false,
            AttackEnemyStrength = 50000,
            IgnorePathing = true,
            TargetSearchCategory = categories.STRUCTURE - categories.NAVAL,
            MoveToCategories = {
                categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH3,
                categories.STRUCTURE * categories.STRATEGIC * categories.ARTILLERY * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.STRATEGIC * categories.NUKE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.STRATEGIC * categories.ARTILLERY * categories.TECH3,
                categories.STRUCTURE * categories.STRATEGIC * categories.NUKE * categories.TECH3,
                categories.STRUCTURE * categories.SHIELD * categories.TECH3,
                categories.STRUCTURE * categories.MASSFABRICATION * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.COMMAND,
                categories.ALLUNITS,
            },
        },
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 2, 4 }},
            { UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 0, categories.SUBCOMMANDER} },
			{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.ALLUNITS, 'Enemy'}},
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEditT3Teleport3',
        PlatoonTemplate = 'Sorian Edit T3 SACU Teleport 3 3',
        Priority = 21000,
        InstanceCount = 1,
        FormRadius = 10000,
        BuilderData = {
            SearchRadius = 10000,
            GetTargetsFromBase = false,
            AggressiveMove = false,
            AttackEnemyStrength = 50000,
            IgnorePathing = true,
            TargetSearchCategory = categories.STRUCTURE - categories.NAVAL,
            MoveToCategories = {
                categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH3,
                categories.STRUCTURE * categories.STRATEGIC * categories.ARTILLERY * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.STRATEGIC * categories.NUKE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.STRATEGIC * categories.ARTILLERY * categories.TECH3,
                categories.STRUCTURE * categories.STRATEGIC * categories.NUKE * categories.TECH3,
                categories.STRUCTURE * categories.SHIELD * categories.TECH3,
                categories.STRUCTURE * categories.MASSFABRICATION * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.COMMAND,
                categories.ALLUNITS,
            },
        },
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 2, 4 }},
            { UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 0, categories.SUBCOMMANDER} },
			{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.ALLUNITS, 'Enemy'}},
        },
        BuilderType = 'Any',
    },
     
    Builder {
        BuilderName = 'SorianEditT3SACUAttack',
        PlatoonTemplate = 'Sorian Edit T3 SACU Fight 3 7',
        Priority = 500,
        InstanceCount = 4,
        FormRadius = 10000,
        BuilderData = {
            SearchRadius = BaseEnemyZone,
            GetTargetsFromBase = false,
            AggressiveMove = false,
            AttackEnemyStrength = 200,
            IgnorePathing = false,
            TargetSearchCategory = categories.STRUCTURE - categories.NAVAL,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.SHIELD,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.FACTORY * categories.TECH3,
                categories.COMMAND,
                categories.ALLUNITS,
            },
        },
        BuilderConditions = {
			{ UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 3, categories.SUBCOMMANDER} },
        },
        BuilderType = 'Any',
    },
}

	do
	LOG('--------------------- SorianEdit Eco Builders loaded')
	end
