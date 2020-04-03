#***************************************************************************
#*
#**  File     :  /mods/Sorian edit/lua/ai/SorianEditFactoryConstructionBuilders.lua
#**
#**  Summary  : Default economic builders for skirmish
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ExBaseTmpl = '/mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditExpansionBalancedFull.lua'
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
local SIBC = '/mods/Sorian edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian edit/lua/editor/SorianEditBuildConditions.lua'

local ExtractorToFactoryRatio = 2.2

BuilderGroup {
    BuilderGroupName = 'SorianEditLandInitialFactoryConstruction',
    BuildersType = 'EngineerBuilder',
    # =======================================
    #     Land Factory Builders - Initial
    # =======================================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder - Initial',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
        Priority = 750,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'LAND' } },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEditT3 Land Factory Builder Higher Pri',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 750,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'LAND' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEditCDR T1 Land Factory Higher Pri - Init',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'LAND FACTORY'}},
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
        Priority = 975, #950,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'LAND FACTORY'}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY LAND' }},
            { SBC, 'GreaterThanGameTime', { 165 } },
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
        Priority = 975, #950,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'AIR FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR' }},
            { SBC, 'GreaterThanGameTime', { 165 } },
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
        Priority = 975, #950,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
            { SBC, 'GreaterThanGameTime', { 165 } },
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
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'AIR FACTORY'}},
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
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            #{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
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
    # =============================
    #     Land Factory Builders
    # =============================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder Balance',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
            #{ UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'LAND', 'AIR' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR T1 Land Factory Balance',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
            #{ UCBC, 'FactoryRatioLessAtLocation', { 'LocationType', 'LAND', 'AIR' } },
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

    # ============================
    #     Air Factory Builders
    # ============================
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder Balance',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 906,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory Balance',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 906,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory - Air',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
    # =============================
    #     Land Factory Builders
    # =============================
    Builder {
        BuilderName = 'SorianEdit T1 Land Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        },
    },
    Builder {
        BuilderName = 'SorianEdit CDR T1 Land Factory',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        },
    },

    # ============================
    #     Air Factory Builders
    # ============================
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
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
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    # ====================================== #
    #     Air Factories + Transport Need
    # ====================================== #
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Transport Needed',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3, ENGINEER TECH2' } },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'AIR FACTORY' } },
            { MIBC, 'ArmyNeedsTransports', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'HaveUnitRatio', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },

    # =============================
    #     Quantum Gate Builders
    # =============================
    Builder {
        BuilderName = 'SorianEdit T3 Gate Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950, #850,
        BuilderConditions = {
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' }},
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSPRODUCTION TECH3' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'GATE TECH3 STRUCTURE' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Gate' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .85 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T3QuantumGate',
                },
                Location = 'LocationType',
                #AdjacencyCategory = 'ENERGYPRODUCTION',
            }
        }
    },
}
