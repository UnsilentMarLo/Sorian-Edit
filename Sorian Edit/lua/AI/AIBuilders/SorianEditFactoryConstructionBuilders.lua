--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditFactoryConstructionBuilders.lua
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
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

local ExtractorToFactoryRatio = 2.2

	do
	LOG('--------------------- SorianEdit Factory Construction Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditLandInitialFactoryConstruction',
    BuildersType = 'EngineerBuilder',
    -- =======================================
    --     Land Factory Builders - Initial
    -- =======================================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder - Initial',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 5900000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.24, 0.4 } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY LAND' }},
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - Initial',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 5900000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.24, 0.4 } },
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY AIR' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstructionLandHigherPriority',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEditT2 Land Factory Builder Higher Pri',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 2250,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.3, 0.35 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 8, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T2SupportLandFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T1 Factory Engineer - Overbuild',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1200,
        InstanceCount = 2,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 200 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 8, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T2 Factory Engineer - Overbuild',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 8, 'FACTORY LAND' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH2 - categories.SUPPORTFACTORY} },
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2SupportLandFactory',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Engineer - Overbuild',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1200,
        InstanceCount = 1,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 200 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 8, 'FACTORY AIR' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T2 Air Factory Engineer - Overbuild',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY AIR' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH2 - categories.SUPPORTFACTORY} },
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2SupportAirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T3 Factory Engineer - Overbuild',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2500,
        InstanceCount = 4,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'GreaterThanGameTimeSeconds', { 200 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3SupportLandFactory',
                    'T3SupportAirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEditT3 Land Factory Builder Higher Pri',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 750,
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'LAND' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T3SupportLandFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Higher Pri',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2475, --950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.6 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 135 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 4, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Higher Pri',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 3975, --950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.0 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY LAND' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY AIR' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstruction Balance',
    BuildersType = 'EngineerBuilder',
    -- =============================
    --     Land Factory Builders
    -- =============================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder Balance',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1105,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.0 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    -- ============================
    --     Air Factory Builders
    -- ============================
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder Balance',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1106,
        BuilderConditions = {
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'AIR', 'LAND' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstruction Air',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - Air',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        BuilderConditions = {
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstruction',
    BuildersType = 'EngineerBuilder',
    -- =============================
    --     Land Factory Builders
    -- =============================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder - Dead ACU',
        PlatoonTemplate = 'AnyEngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'COMMAND', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        },
    },

    -- ============================
    --     Air Factory Builders
    -- ============================
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 2000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ UCBC, 'HaveForEach', { categories.LAND * categories.FACTORY, 1, categories.AIR * categories.FACTORY}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - Dead ACU',
        PlatoonTemplate = 'AnyEngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'COMMAND', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    -- ====================================== --
    --     Air Factories + Transport Need
    -- ====================================== --
    --[[ Builder {
        BuilderName = 'SorianEdit T1 Air Factory Transport Needed',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3, ENGINEER TECH2' } },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'AIR FACTORY' } },
            -- { MIBC, 'ArmyNeedsTransports', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SBC, 'HaveUnitRatioSorian', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    }, --]]

    -- =============================
    --     Quantum Gate Builders
    -- =============================
    Builder {
        BuilderName = 'SorianEdit T3 Gate Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1550, --850,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'GATE TECH3 STRUCTURE' }},
            { UCBC, 'UnitCapCheckLess', { .85 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T3QuantumGate',
                },
                Location = 'LocationType',
                --AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
}
	do
	LOG('--------------------- SorianEdit Factory Construction Builders loaded')
	end

