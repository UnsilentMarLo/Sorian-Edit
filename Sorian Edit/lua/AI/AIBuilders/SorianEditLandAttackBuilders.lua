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
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Land attack Builders loading')
	end

BuilderGroup {
    BuilderGroupName = 'SorianEditT1LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Tank - init',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 1825,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'LessThanGameTimeSeconds', { 150 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.LAND * categories.MOBILE * categories.TECH1 - categories.DIRECTFIRE }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Tank',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 1225,
        --Priority = 950,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.06, 0.15 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.55 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 4, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Land',
    },
    -- T1 Artillery, built in a ratio to tanks before tech 2
    Builder {
        BuilderName = 'SorianEdit T1 Mortar',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 930,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.06, 0.1 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 - categories.SCOUT }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - Not T1',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 1300, --600,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH1 - categories.SCOUT }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH1, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
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
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 830,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ANTIAIR * categories.MOBILE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.ANTIAIR * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.COMMAND}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mobile AA - Response',
        PlatoonTemplate = 'T1LandAA',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 950,
        BuilderConditions = {
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
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
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Artillery - water map',
        PlatoonTemplate = 'T1LandArtillery',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1200,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.2 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.ANTIAIR * (categories.HOVER + categories.AMPHIBIOUS) } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY LAND TECH2, FACTORY LAND TECH3' }},
        },
        BuilderType = 'Land',
    },
}

-- ------------------------------------------
-- -- T1 Response Builder
-- -- Used to respond to the sight of tanks nearby
-- ------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1ReactionDF',
    BuildersType = 'FactoryBuilder',
    -- Builder {
        -- BuilderName = 'SorianEdit T1 Tank Enemy Nearby',
        -- PlatoonTemplate = 'T1LandDFTank',
        -- Priority = 900,
        -- BuilderConditions = {
			-- { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            -- -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        -- },
        -- BuilderType = 'Land',
    -- },
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
        Priority = 1200,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- MML's, built in a ratio to directfire units
    Builder {
        BuilderName = 'SorianEdit T2 MML',
        PlatoonTemplate = 'T2LandArtillery',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH2 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.45, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.COMMAND}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1200,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2MobileShields',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 4, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.2, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND}},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - T3 Factories',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 3, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.2, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND}},
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
        BuilderName = 'SorianEdit T2 Tank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2 - water map',
        PlatoonTemplate = 'T2AttackTank',
        Priority = 1300,
        BuilderType = 'Land',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - Tech 2 - water map',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.MOBILE * categories.HOVER * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileAA - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAA',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.ANTIAIR * (categories.HOVER + categories.AMPHIBIOUS) } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.DIRECTFIRE * (categories.HOVER + categories.AMPHIBIOUS) } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ UCBC, 'CanBuildCategory', { categories.MOBILE * categories.LAND * categories.TECH2 * categories.DIRECTFIRE * (categories.HOVER + categories.AMPHIBIOUS) } },
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1950,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
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
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.2, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.COMMAND}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak Response',
        PlatoonTemplate = 'T2LandAA',
        Priority = 1000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH2 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 1950,
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
        Priority = 1950,
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
        Priority = 1950,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery - tough def',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 1950,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Flak',
        PlatoonTemplate = 'T3LandAA',
        Priority = 1950,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ANTIAIR * categories.MOBILE * categories.TECH3 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.ANTIAIR * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3SniperBots',
        PlatoonTemplate = 'T3SniperBots',
        Priority = 1850,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.BOT * categories.INDIRECTFIRE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.BOT * categories.INDIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - (categories.BOT * categories.INDIRECTFIRE) - categories.COMMAND}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileMissile',
        PlatoonTemplate = 'T3MobileMissile',
        Priority = 1850,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileShields',
        PlatoonTemplate = 'T3MobileShields',
        Priority = 1850,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.MOBILE * categories.TECH3 * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.4, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.COMMAND}},
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
        Priority = 1200,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			{ UCBC, 'PoolLessAtLocation', { 'LocationType', 2, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.TECH2 }},
            -- { SBC, 'HaveUnitRatioSorian', { 0.3, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.TECH2, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA Response',
        PlatoonTemplate = 'T3LandAA',
        Priority = 1200,
        BuilderConditions = {
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 1945,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 SiegeBot Enemy Nearby',
        PlatoonTemplate = 'T3LandBot',
        Priority = 1935,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
        BuilderType = 'Land',
    },
}

-- ===================== --
--     Form Builders
-- ===================== --
BuilderGroup {
    BuilderGroupName = 'SorianEditUnitCapLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    --[[ Builder {
        BuilderName = 'SorianEdit Unit Cap Default Land Attack',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'UnitCapCheckGreater', { .95 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T1',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 15, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 720 } },
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T2',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 25, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1220 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T3',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1720 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    }, ]]--
}

BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack Default',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1500,
        InstanceCount = 15,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
            -- WeaponTargetCategories = {
                -- categories.EXPERIMENTAL * categories.LAND,
                -- categories.COMMAND,
                -- categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.INDIRECTFIRE * categories.LAND,
                -- categories.DIRECTFIRE * categories.LAND,
                -- categories.ANTIAIR * categories.LAND,
                -- categories.MOBILE * categories.LAND,
            -- },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND - categories.ENGINEER } },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Artillery Attack Default',
        PlatoonTemplate = 'LandAttackSorianEditArty',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
            -- WeaponTargetCategories = {
                -- categories.EXPERIMENTAL * categories.LAND,
                -- categories.COMMAND,
                -- categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.INDIRECTFIRE * categories.LAND,
                -- categories.DIRECTFIRE * categories.LAND,
                -- categories.ANTIAIR * categories.LAND,
                -- categories.MOBILE * categories.LAND,
            -- },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND - categories.ENGINEER } },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
	
-- Builder {
        -- BuilderName = 'SorianEdit Amphibious Water Attack - Default',
        -- PlatoonTemplate = 'LandAttackLargeSorianEdit amphib',
        -- --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        -- PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        -- Priority = 1200,
        -- InstanceCount = 15,
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- SearchRadius = BaseEnemyZone, --  = 20000,
            -- GetTargetsFromBase = false,
            -- RequireTransport = false,
            -- AggressiveMove = false,
            -- AttackEnemyStrength = 120,
            -- -- IgnorePathing = false,
            -- TargetSearchCategory = categories.ALLUNITS - categories.AIR,
            -- MoveToCategories = {
                -- categories.MOBILE * categories.LAND,
                -- categories.COMMAND,
                -- categories.STRUCTURE,
            -- },
            -- -- WeaponTargetCategories = {
                -- -- categories.EXPERIMENTAL * categories.LAND,
                -- -- categories.COMMAND,
                -- -- categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                -- -- categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                -- -- categories.INDIRECTFIRE * categories.LAND,
                -- -- categories.DIRECTFIRE * categories.LAND,
                -- -- categories.ANTIAIR * categories.LAND,
                -- -- categories.MOBILE * categories.LAND,
            -- -- },
        -- },
        -- BuilderConditions = {
            -- { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND - categories.ENGINEER} },
			-- -- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        -- },
    -- },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Medium',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1300,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
            -- WeaponTargetCategories = {
                -- categories.EXPERIMENTAL * categories.LAND,
                -- categories.COMMAND,
                -- categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.INDIRECTFIRE * categories.LAND,
                -- categories.DIRECTFIRE * categories.LAND,
                -- categories.ANTIAIR * categories.LAND,
                -- categories.MOBILE * categories.LAND,
            -- },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 20, categories.MOBILE * categories.LAND - categories.ENGINEER} },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Large',
        PlatoonTemplate = 'LandAttackLargeSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
            -- WeaponTargetCategories = {
                -- categories.EXPERIMENTAL * categories.LAND,
                -- categories.COMMAND,
                -- categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                -- categories.INDIRECTFIRE * categories.LAND,
                -- categories.DIRECTFIRE * categories.LAND,
                -- categories.ANTIAIR * categories.LAND,
                -- categories.MOBILE * categories.LAND,
            -- },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.ENGINEER} },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentLandAttackFormBuildersUseTransport',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack Default',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = true,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 2, categories.MOBILE * categories.LAND - categories.ENGINEER } },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Artillery Attack Default',
        PlatoonTemplate = 'LandAttackSorianEditArty',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = true,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 2, categories.MOBILE * categories.LAND * categories.INDIRECTFIRE - categories.ENGINEER } },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Medium',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = true,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 20, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Large',
        PlatoonTemplate = 'LandAttackLargeSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = true,
            AggressiveMove = false,
            AttackEnemyStrength = 120,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',

    -- Hunts for mass locations with Economic threat value of no more than 2 mass extractors
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Early Game',
        PlatoonTemplate = 'MassHuntersCategorySorianEditSmall',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 600,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 140 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 2, categories.MOBILE * categories.LAND - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = 512,
            LocationType = 'LocationType',
            IncludeWater = false,
            IgnoreFriendlyBase = true,
            MaxPathDistance = 512,
            FindHighestThreat = true,
            MaxThreatThreshold = 6000,
            MinThreatThreshold = 1000,   
            AvoidBases = true,
            AvoidBasesRadius = 100,
            AggressiveMove = false,
            AvoidClosestRadius = 100,
            UseFormation = 'None',
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            TargetSearchPriorities = {
                categories.MASSEXTRACTION,
                categories.MASSFABRICATION,
                categories.ENERGYPRODUCTION,
                categories.ALLUNITS,
            },
            PrioritizedCategories = {
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MASSEXTRACTION,
                categories.ENERGYPRODUCTION,
                categories.MASSFABRICATION,
                categories.ALLUNITS,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    -- Mid Game Mass Hunter
    -- Used after 10, goes after mass locations
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Mid Game',
        PlatoonTemplate = 'MassHuntersCategorySorianEditLarge',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 990,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 600 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 15, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
				---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            },
        BuilderData = {
            SearchRadius = 512,
            LocationType = 'LocationType',
            IncludeWater = false,
            IgnoreFriendlyBase = true,
            MaxPathDistance = 512,
            FindHighestThreat = true,
            MaxThreatThreshold = 6000,
            MinThreatThreshold = 1000,   
            AvoidBases = true,
            AvoidBasesRadius = 100,
            AggressiveMove = false,
            AvoidClosestRadius = 100,
            UseFormation = 'None',
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            TargetSearchPriorities = {
                categories.MASSEXTRACTION,
                categories.MASSFABRICATION,
                categories.ENERGYPRODUCTION,
                categories.ALLUNITS,
            },
            PrioritizedCategories = {
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MASSEXTRACTION,
                categories.ENERGYPRODUCTION,
                categories.MASSFABRICATION,
                categories.ALLUNITS,
            },
        },
        InstanceCount = 4,
        BuilderType = 'Any',
    },


    -- Early Game Start Location Attack
    -- Used in the first 12 minutes to attack starting location areas
    -- The platoon then stays at that location and disbands after a certain amount of time
    -- Also the platoon carries an engineer with it
    Builder {
        BuilderName = 'SorianEdit Start Location Attack',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                -- --{ UCBC, 'LessThanGameTimeSeconds', { 720 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
				---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Small',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
				---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Medium',
        PlatoonTemplate = 'LandAttackPlatoonSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 20, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
				---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 6,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T2/T3 Land Weak Enemy Response',
        --PlatoonTemplate = 'StrikeForceMediumSorianEdit',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND * (categories.TECH2 + categories.TECH3) - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 1000}},
            { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND * (categories.TECH2 + categories.TECH3)  - categories.ENGINEER } },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Land Weak Enemy Response - T1',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND * categories.TECH1 - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 350}},
            { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND * categories.TECH1  - categories.ENGINEER } },
			---- { MIBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
        },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },


    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Small Map',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 850,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
                { SBC, 'MapLessThan', {1000, 1000}},
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'}, 
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 825,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Amphib L1',
        PlatoonTemplate = 'LandAttackLargeSorianEdit amphib',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 850,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
                { SBC, 'MapLessThan', {1000, 1000}},
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Amphib L',
        PlatoonTemplate = 'LandAttackLargeSorianEdit amphib',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'}, 
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 825,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
	
    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Amphib S',
        PlatoonTemplate = 'LandAttackLargeSorianEdit amphib S',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'}, 
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 825,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            SearchRadius = BaseEnemyZone, --  = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 1200,
            -- IgnorePathing = false,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.SCOUT,
            MoveToCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.MOBILE * categories.LAND * categories.INDIRECTFIRE,
                categories.MOBILE * categories.LAND * categories.DIRECTFIRE - categories.SCOUT,
                categories.MOBILE * categories.LAND * categories.ANTIAIR,
                categories.STRUCTURE * categories.ECONOMIC,
                categories.STRUCTURE * categories.ANTIAIR,
                categories.MOBILE * categories.LAND,
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMiscLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    --[[ Builder {
        BuilderName = 'SorianEdit T1 Tanks - Engineer Guard',
        PlatoonTemplate = 'T1EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 750,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            ---- { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 } },
            --CanBuildFirebase { 500, 500 }},
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Tanks - Engineer Guard',
        PlatoonTemplate = 'T2EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 0,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 - categories.TECH2} },
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Tanks - Engineer Guard',
        PlatoonTemplate = 'T3EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 0,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER * categories.TECH3} },
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Tanks - T4 Guard',
        PlatoonTemplate = 'T3ExpGuard',
        PlatoonAIPlan = 'GuardExperimentalSorianEdit',
        Priority = 750,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.LAND * categories.MOBILE - categories.TECH1 - categories.ANTIAIR - categories.SCOUT - categories.ENGINEER - categories.ual0303} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.EXPERIMENTAL * categories.LAND}},
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    }, ]]--
}
	do
	LOG('--------------------- SorianEdit Land attack Builders loaded')
	end
