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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
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
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstructionLandHigherPriority',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEditT2 Land Factory Builder Higher Pri',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1250,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'LAND' } },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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

    Builder {
        BuilderName = 'SorianEdit T1 Factory Engineer - Overbuild',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 800,
        InstanceCount = 4,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 200 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                    'T1AirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T2 Factory Engineer - Overbuild',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 800,
        InstanceCount = 4,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH2 - categories.SUPPORTFACTORY} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2SupportLandFactory',
                    'T2SupportAirFactory',
                },
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T3 Factory Engineer - Overbuild',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 800,
        InstanceCount = 4,
        BuilderConditions = {
			{ UCBC, 'UnitCapCheckLess', { .6 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'GreaterThanGameTimeSeconds', { 200 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.8, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
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
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'LAND' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
    Builder {
        BuilderName = 'SorianEditCDR T1 Land Factory Higher Pri - Init',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'LAND FACTORY'}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
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
        BuilderName = 'SorianEdit T1 Land Factory Higher Pri - Init',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 975, --950,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'LAND FACTORY'}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY LAND' }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 165 } },
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
        BuilderName = 'SorianEdit T1 Land Factory Higher Pri',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 975, --950,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'AIR FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR' }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 165 } },
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 975, --950,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 4, 'FACTORY LAND' }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 165 } },
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
    Builder {
        BuilderName = 'SorianEditCDR T1 Land Factory Higher Pri',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'AIR FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
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
        BuilderName = 'SorianEditCDR T1 Air Factory Higher Pri',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 6, 'FACTORY LAND' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
            -- { UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'LAND', 'AIR' } },
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
    Builder {
        BuilderName = 'SorianEdit CDR T1 Land Factory Balance',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
            -- { UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'LAND', 'AIR' } },
        },
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

    -- ============================
    --     Air Factory Builders
    -- ============================
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder Balance',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 906,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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

    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory Balance',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 906,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'AIR', 'LAND' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryConstruction Air',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - Air',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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

    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory - Air',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                },
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
        BuilderName = 'SorianEdit CDR T1 Land Factory',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.95, 1.1} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
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
        BuilderName = 'SorianEdit T1 Land Factory Builder - Dead ACU',
        PlatoonTemplate = 'AnyEngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - Dead ACU',
        PlatoonTemplate = 'AnyEngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.4 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3, ENGINEER TECH2' } },
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'AIR FACTORY' } },
            -- { MIBC, 'ArmyNeedsTransports', {} },
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SBC, 'HaveUnitRatioSorian', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'GATE TECH3 STRUCTURE' }},
            -- { UCBC, 'FactoryCapCheck', { 'LocationType', 'Gate' } },
            -- { IBC, 'BrainNotLowMassMode', {} },
            -- { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .85 } },
            -- { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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

