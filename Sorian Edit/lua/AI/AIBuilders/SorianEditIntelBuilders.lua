--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditIntelBuilders.lua
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
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Intel Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditAirScoutFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Scout - Init',
        PlatoonTemplate = 'T1AirScout',
        Priority = 170600, --700,
        BuilderConditions = {
            { SBC, 'LessThanGameTime', { 300 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.SCOUT * categories.AIR}},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Scout',
        PlatoonTemplate = 'T1AirScout',
        Priority = 1700, --700,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { SIBC, 'HaveLessThanUnitsForMapSize', { {[256] = 2, [512] = 4, [1024] = 6, [2048] = 8, [4096] = 8}, categories.SCOUT * categories.AIR}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.AIR * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, categories.AIR * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.SCOUT * categories.AIR } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Scout - Lower Pri',
        PlatoonTemplate = 'T1AirScout',
        Priority = 1501, --500,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { SIBC, 'HaveLessThanUnitsForMapSize', { {[256] = 4, [512] = 6, [1024] = 8, [2048] = 10, [4096] = 12}, categories.SCOUT * categories.AIR}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.AIR * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, categories.AIR * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.SCOUT * categories.AIR } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Scout',
        PlatoonTemplate = 'T2AirScout',
        Priority = 1800, --601,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.SCOUT * categories.AIR}}, --1
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.AIR * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, categories.AIR * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.SCOUT * categories.AIR } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Scout - Lower Pri',
        PlatoonTemplate = 'T2AirScout',
        Priority = 1601, --500,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 15, categories.SCOUT * categories.AIR}}, --3
            --CanBuildFirebase { 500, 500 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.TECH3 * categories.FACTORY * categories.AIR } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.AIR * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, categories.AIR * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.SCOUT * categories.AIR } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Scout',
        PlatoonTemplate = 'T3AirScout',
        Priority = 2900, --701,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 12, categories.INTELLIGENCE * categories.AIR * categories.TECH3 }}, --1
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.AIR * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.INTELLIGENCE * categories.AIR * categories.TECH3 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Scout - Lower Pri',
        PlatoonTemplate = 'T3AirScout',
        Priority = 2701, --700,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { SIBC, 'HaveLessThanUnitsForMapSize', { {[256] = 4, [512] = 6, [1024] = 8, [2048] = 10, [4096] = 12}, categories.INTELLIGENCE * categories.AIR * categories.TECH3}},
            --CanBuildFirebase { 500, 500 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.AIR * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.INTELLIGENCE * categories.AIR * categories.TECH3 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Air',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditAirScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Scout - No Build',
        PlatoonTemplate = 'T1AirScoutFormSorianEdit',
        Priority = 650,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        InstanceCount = 30,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Scout - No Build',
        PlatoonTemplate = 'T3AirScoutFormSorianEdit',
        Priority = 750,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        InstanceCount = 30,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditLandScoutFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Land Scout Initial',
        PlatoonTemplate = 'T1LandScout',
        Priority = 1875,
        BuilderConditions = {
            { SBC, 'LessThanGameTime', { 300 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.1 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Land Scout Initial - 10 x 10',
        PlatoonTemplate = 'T1LandScout',
        Priority = 875,
        BuilderConditions = {
            { SBC, 'MapLessThan', {1000, 1000} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.8 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
        Builder {
        BuilderName = 'SorianEdit T1 Land Scout Initial - 5 x 5',
        PlatoonTemplate = 'T1LandScout',
        Priority = 875,
        BuilderConditions = {
            { SBC, 'LessThanGameTime', { 600 } },
            { SBC, 'MapLessThan', {500, 500} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.8 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
    --Builder {
    --    BuilderName = 'SorianEdit T1 Land Scout',
    --    PlatoonTemplate = 'T1LandScout',
    --    Priority = 850,
    --    BuilderConditions = {
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY - categories.TECH1 }},
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.LAND * categories.SCOUT }},
    --        -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.SCOUT * categories.LAND } },
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			-- { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			-- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
    --    },
    --    BuilderType = 'Land',
    --},
    Builder {
        BuilderName = 'SorianEdit T1 Land Scout Ratio Build',
        PlatoonTemplate = 'T1LandScout',
        Priority = 1250,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.06, 0.15 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 0.55 }},
            { SBC, 'HaveUnitRatioSorian', { 0.1, categories.LAND * categories.SCOUT, '<=', categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.LAND * categories.MOBILE * categories.SCOUT - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditLandScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Land Scout Form init',
        BuilderConditions = {
            { SBC, 'LessThanGameTime', { 300 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.LAND - categories.TECH1 }},
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        PlatoonTemplate = 'T1LandScoutFormSorianEdit',
        Priority = 10000, --725,
        InstanceCount = 30,
        BuilderData = {
            UseCloak = true,
        },
        LocationType = 'LocationType',
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Land Scout Form',
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.AIR * categories.TECH3 }},
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        PlatoonTemplate = 'T1LandScoutFormSorianEdit',
        Priority = 10000, --725,
        InstanceCount = 30,
        BuilderData = {
            UseCloak = true,
        },
        LocationType = 'LocationType',
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditRadarEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Radar Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 960,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER - categories.COMMAND - categories.TECH1 } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE}},
            -- { EBC, 'GreaterThanEconIncome',  { 0.5, 15 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1Radar',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Radar Engineer - T2',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 960,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE}},
            -- { EBC, 'GreaterThanEconIncome',  { 0.5, 15 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1Radar',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Radar Engineer - T3',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 960,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE}},
            -- { EBC, 'GreaterThanEconIncome',  { 0.5, 15 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1Radar',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Radar Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER - categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE}},
            -- { EBC, 'GreaterThanEconIncome',  { 7.5, 100}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T2Radar',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Omni Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.OMNI * categories.STRUCTURE } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE * categories.TECH3 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T3Radar',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditRadarUpgradeBuildersMain',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Radar Upgrade',
        PlatoonTemplate = 'T1RadarUpgrade',
        Priority = 200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 } },
        },
        BuilderType = 'Any',
        FormDebugFunction = function()
            local test = false
        end,
    },
    Builder {
        BuilderName = 'SorianEdit T2 Radar Upgrade',
        PlatoonTemplate = 'T2RadarUpgrade',
        Priority = 300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.OMNI * categories.STRUCTURE } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.OMNI * categories.STRUCTURE } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, (categories.RADAR + categories.OMNI) * categories.STRUCTURE }},
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditRadarUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Radar Upgrade',
        PlatoonTemplate = 'T1RadarUpgrade',
        Priority = 200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RADAR * categories.STRUCTURE * categories.TECH2, 'RADAR STRUCTURE' }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 } },
        },
        BuilderType = 'Any',
        FormDebugFunction = function()
            local test = false
        end,
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSonarEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Sonar Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { MABC, 'MarkerLessThanDistance',  { 'Naval Area', 200} },
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER - categories.COMMAND - categories.TECH1} },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.SONAR * categories.STRUCTURE } },
            -- { EBC, 'GreaterThanEconIncome',  { 0.5, 150 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1Sonar',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Sonar Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { MABC, 'MarkerLessThanDistance',  { 'Naval Area', 200}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.SONAR * categories.STRUCTURE } },
            -- { EBC, 'GreaterThanEconIncome',  { 0.5, 150 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T2Sonar',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditCounterIntelBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Counter Intel Near Factory',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH2}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.COUNTERINTELLIGENCE * categories.TECH2}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T2RadarJammer',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditRadarUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Radar Upgrade Expansion',
        PlatoonTemplate = 'T1RadarUpgrade',
        Priority = 200,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { EBC, 'GreaterThanEconIncome',  { 4, 200 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.RADAR * categories.TECH2 * categories.STRUCTURE } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RADAR * categories.STRUCTURE * categories.TECH2, 'RADAR STRUCTURE' }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Radar Upgrade Expansion',
        PlatoonTemplate = 'T2RadarUpgrade',
        Priority = 300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { EBC, 'GreaterThanEconIncome',  { 9, 1000}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.OMNI * categories.STRUCTURE } },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.OMNI * categories.STRUCTURE } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSonarUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Sonar Upgrade',
        PlatoonTemplate = 'T1SonarUpgrade',
        Priority = 200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SONAR * categories.TECH1}},
            -- { EBC, 'GreaterThanEconIncome',  { 5, 15}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Sonar Upgrade',
        PlatoonTemplate = 'T2SonarUpgrade',
        Priority = 300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { MIBC, 'FactionIndex', { 1, 2, 3, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads 
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SONAR * categories.TECH2}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.SONAR * categories.TECH3}},
            -- { EBC, 'GreaterThanEconIncome',  { 10, 600}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSonarUpgradeBuildersSmall',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Sonar Upgrade Small',
        PlatoonTemplate = 'T1SonarUpgrade',
        Priority = 200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SONAR * categories.TECH2}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            -- { EBC, 'GreaterThanEconIncome',  { 5, 15}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Sonar Upgrade Small',
        PlatoonTemplate = 'T2SonarUpgrade',
        Priority = 300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { MIBC, 'FactionIndex', { 1, 2, 3, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads 
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SONAR * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.SONAR * categories.TECH3}},
            -- { EBC, 'GreaterThanEconIncome',  { 10, 600}},
            -- { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
    },
}
	do
	LOG('--------------------- SorianEdit Intel Builders loaded')
	end
