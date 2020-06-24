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

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- ============
    --    TECH 1
    -- ============
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 18, 'ENGINEER TECH1' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 1',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 825, --800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 18, 'ENGINEER TECH1' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 2',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
            { IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ============
    --    TECH 2
    -- ============
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Init',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 15, 'ENGINEER TECH2' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 1',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 20, 'ENGINEER TECH2' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 15, categories.MOBILE - categories.ENGINEER}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 2',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 30, categories.MOBILE - categories.ENGINEER}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
            { IBC, 'BrainNotLowMassMode', {} },
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
        Priority = 950,
        BuilderConditions = {
            { UCBC,'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 15, 'ENGINEER TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 15, categories.MOBILE - categories.ENGINEER}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 2',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 25, 'ENGINEER TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 30, categories.MOBILE - categories.ENGINEER}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 45, categories.MOBILE - categories.ENGINEER}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3 Econ',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 960,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.85, 0.85 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ====================
    --    SUB COMMANDERS
    -- ====================
    Builder {
        BuilderName = 'SorianEdit T3 Sub Commander',
        PlatoonTemplate = 'T3LandSubCommander',
        Priority = 950,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'SCU' } },
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Gate',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerFactoryBuildersExpansion rush',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Init Expansion rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 1200,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 7, 'ENGINEER TECH1' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH2' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
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
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH1' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 1 - Rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 825, --800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 10, 'ENGINEER TECH1' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
            { IBC, 'BrainNotLowMassMode', {} },
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
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH2' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 1 - Rush',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 800,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH2' }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T2BuildEngineer',
        Priority = 700,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH2' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech2' } },
            --{ IBC, 'BrainNotLowMassMode', {} },
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
            { UCBC,'EngineerLessAtLocation', { 'LocationType', 15, 'ENGINEER TECH3' }},
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 32, 'ENGINEER TECH3' }},
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 2 - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 22, 'ENGINEER TECH3' }},
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3 - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Disband - Filler 3 Econ - Rush',
        PlatoonTemplate = 'T3BuildEngineer',
        Priority = 950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.85, 0.85 } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'All',
    },

    -- ====================
    --    SUB COMMANDERS
    -- ====================
    Builder {
        BuilderName = 'SorianEdit T3 Sub Commander - Rush',
        PlatoonTemplate = 'T3LandSubCommander',
        Priority = 950,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'SCU' } },
            --{ IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
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
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                    'T1Resource',	
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Initial PreBuilt Balanced',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Air Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'SorianEdit CDR Initial Air',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                    'T1Resource',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Initial PreBuilt Air',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Naval Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'SorianEdit CDR Initial Naval',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                    'T1Resource',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Initial PreBuilt Naval',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Rush Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'SorianEdit CDR Initial Land Rush',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Delay = 165,
            aggroCDR = true,
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                    'T1Resource',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Initial PreBuilt Land Rush',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian', },
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Delay = 165,
            aggroCDR = true,
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1LandFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditACUAttack',
    BuildersType = 'EngineerBuilder',
    Builder {    
        BuilderName = 'SorianEdit CDR Attack',
        PlatoonTemplate = 'CommanderAttackSorianEdit',
        Priority = 875,
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 165 }},
            { UCBC, 'LessThanGameTimeSeconds', { 1200 }},
            { SBC, 'ClosestEnemyLessThan', { 750 } },
            { SBC, 'EnemyToAllyRatioLessOrEqual', { 1.0 } },
            { SBC, 'IsBadMap', { false } },
            { SIBC, 'CDRHealthGreaterThan', { .85, .35 }},
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditACUBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit CDR Single T1Resource',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 0, --950, Probably unneeded, removed for testing
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 40, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1Resource',
                },
            }
        }
    },

    Builder {    
        BuilderName = 'SorianEdit CDR T1 Power',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 875,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
            { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3'}},
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                --AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Base D',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 0, 'DEFENSE TECH1' }},
            { MABC, 'MarkerLessThanDistance',  { 'Rally Point', 50 }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.95, 1.2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BaseTemplate = ExBaseTmpl,
                BuildClose = false,
                NearMarkerType = 'Rally Point',
                ThreatMin = -5,
                ThreatMax = 700,
                ThreatRings = 0,
                BuildStructures = {
                    'T1GroundDefense',
                    'T1AADefense',
                }
            }
        }
    },
    -- CDR Assisting
    Builder {
        BuilderName = 'SorianEdit CDR Assist T2/T3 Power',
        PlatoonTemplate = 'CommanderAssistSorianEdit',
        Priority = 700,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
            { SIBC, 'LessThanEconEfficiencyOverTime', { 2.0, 1.3 }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssisteeType = 'Engineer',
                AssistLocation = 'LocationType',
                AssistRange = 100,
                BeingBuiltCategories = {'ENERGYPRODUCTION TECH3', 'ENERGYPRODUCTION TECH2'},
                Time = 20,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit CDR Assist Engineer',
        PlatoonTemplate = 'CommanderAssistSorianEdit',
        Priority = 500,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ALLUNITS' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.05 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssistRange = 100,
                AssisteeType = 'Engineer',
                Time = 30,
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
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.2, 1.2 } },
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
    --Builder {
    --    BuilderName = 'SorianEdit CDR Assist Factory Upgrade Tech 2',
    --    PlatoonTemplate = 'CommanderAssistSorianEdit',
    --    Priority = 800,
    --    BuilderConditions = {
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'TECH2 FACTORY' } },
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH2, FACTORY TECH3' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 } },
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --    },
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            AssisteeType = 'Factory',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'FACTORY TECH2',},
    --            Time = 40,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'SorianEdit CDR Assist Factory Upgrade Tech 3',
    --    PlatoonTemplate = 'CommanderAssistSorianEdit',
    --    Priority = 800,
    --    BuilderConditions = {
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'TECH3 FACTORY' } },
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'TECH3 FACTORY' } },
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 } },
    --    },
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            AssisteeType = 'Factory',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'FACTORY TECH3',},
    --            Time = 40,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'SorianEdit CDR Assist Mass Extractor Upgrade',
    --    PlatoonTemplate = 'CommanderAssistSorianEdit',
    --    Priority = 0,
    --    BuilderConditions = {
    --        { UCBC, 'BuildingGreaterAtLocation', { 'LocationType', 0, 'TECH2 MASSEXTRACTION' } },
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' } },
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --    },
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssisteeType = 'Structure',
    --            AssistLocation = 'LocationType',
    --            BeingBuiltCategories = {'MASSEXTRACTION'},
    --            Time = 30,
    --        },
    --    }
    --},
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSCUUpgrades',
    BuildersType = 'EngineerBuilder',
    -- UEF
    Builder {
        BuilderName = 'SorianEdit UEF SCU Upgrade',
        PlatoonTemplate = 'SCUEnhance',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'SCUNeedsUpgrade', { 'Pod' }},
                { MIBC, 'FactionIndex', {1}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'SCUNeedsUpgrade', { 'EngineeringFocusingModule' }},
                { MIBC, 'FactionIndex', {2}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'SCUNeedsUpgrade', { 'Switchback' }},
                { MIBC, 'FactionIndex', {3}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'SCUNeedsUpgrade', { 'EngineeringThroughput' }},
                { MIBC, 'FactionIndex', {4}},
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
        BuilderName = 'SorianEdit UEF CDR Upgrade AdvEng - Pods',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'LeftPod', 'RightPod', 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit UEF CDR Upgrade T3 Eng - Shields',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {1}},
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
        BuilderName = 'SorianEdit Aeon CDR Upgrade AdvEng - Resource - Crysalis',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'HeatSink', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {2}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'HeatSink', false }},
                { MIBC, 'FactionIndex', {2}},
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
        BuilderName = 'SorianEdit Cybran CDR Upgrade AdvEng - Laser Gen',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { SBC, 'CmdrHasUpgrade', { 'MicrowaveLaserGenerator', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'StealthGenerator', 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade T3 Eng - Resource',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'MicrowaveLaserGenerator', false }},
                { MIBC, 'FactionIndex', {3}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {4}},
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
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { MIBC, 'FactionIndex', {4}},
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900, --1002, --980
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENGINEER * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION } },
                { SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'HYDROCARBON'}},
                { SBC, 'CanBuildOnHydroLessThanDistance', { 'LocationType', 200, -500, 0, 0, 'AntiSurface', 1 }},
                --{ SBC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 200}},
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 980,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENGINEER * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'HYDROCARBON'}},
                { SBC, 'CanBuildOnHydroLessThanDistance', { 'LocationType', 600, -500, 0, 0, 'AntiSurface', 1 }},
                --{ SBC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 200}},
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
        PlatoonTemplate = 'EngineerBuilderSorianEditALLTECH',
        PlatoonAIPlan = 'ReclaimAI',
        Priority = 1000,
        InstanceCount = 8,
        BuilderConditions = {
                { MIBC, 'ReclaimablesInArea', { 'LocationType', }},

                { EBC, 'LessThanEconStorageRatio', { 0.95, 1}},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Engineer Reclaim - Low Mass',
        PlatoonTemplate = 'EngineerBuilderSorianEditALLTECH',
        PlatoonAIPlan = 'ReclaimAI',
        Priority = 1000,
        InstanceCount = 4,
        BuilderConditions = {
                { MIBC, 'ReclaimablesInArea', { 'LocationType', }},

                { EBC, 'LessThanEconStorageRatio', { 0.35, 1}},
            },
        BuilderData = {
            LocationType = 'LocationType',
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Engineer Reclaim Old Pgens',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ReclaimStructuresAI',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.TECH2 * categories.ENERGYPRODUCTION}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {'STRUCTURE ENERGYPRODUCTION TECH1 DRAGBUILD'},
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Engineer Find Unfinished',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
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
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Find Low Shield',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ManagerEngineerFindLowShield',
        Priority = 1801,
        InstanceCount = 3,
        BuilderConditions = {
                { SBC, 'ShieldDamaged', { 'LocationType'}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE SHIELD TECH2, STRUCTURE SHIELD TECH3'},
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 450, -3, 0, 0}},
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3', 250, 'ueb1106' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION TECH3, MASSEXTRACTION TECH2',
                AdjacencyDistance = 250,
                BuildClose = false,
                ThreatMin = -3,
                ThreatMax = 700,
                ThreatRings = 0,
                BuildStructures = {
                    'MassStorage',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Energy Storage Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = -1,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, 'ENERGYPRODUCTION TECH1' }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION TECH1', 100, 'ueb1105' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH1',
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'CheapEnergyBuilding', 4},
        BuilderConditions = {
            { UCBC, 'UnitCapCheckLess', { .7 } },
            { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            { UCBC, 'CheckBuildPlattonDelay', { 'CheapEnergyBuilding' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY TECH1',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },

    -- =========================
    --     T1 ENGINEER ASSIST
    -- =========================
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist Factory',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 600,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    InstanceCount = 5,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            AssisteeType = 'Factory',
    --            Time = 30,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist FactoryLowerPri',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 500,
    --    InstanceCount = 50,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            AssisteeType = 'Factory',
    --            Time = 30,
    --        },
    --    }
    --},
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Assist Engineer',
        PlatoonTemplate = 'EngineerAssistSorian',
        Priority = 500,
        DelayEqualBuildPlattons = {'EngineerAssistDelays', 4},
        InstanceCount = 50,
        BuilderConditions = {
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ALLUNITS' } },
            { UCBC, 'CheckBuildPlattonDelay', { 'EngineerAssistDelays' }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
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
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist Shield',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 825,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE SHIELD' }},
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    InstanceCount = 2,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            AssisteeType = 'Engineer',
    --            BeingBuiltCategories = {'SHIELD STRUCTURE'},
    --            Time = 60,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist Mass Upgrade',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 850,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'BuildingGreaterAtLocation', { 'LocationType', 0, 'MASSEXTRACTION TECH2'}},
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --        { SIBC, 'LessThanEconEfficiencyOverTime', { 1.5, 2.0 }},
    --    },
    --    InstanceCount = 2,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssisteeType = 'Structure',
    --            AssistLocation = 'LocationType',
    --            BeingBuiltCategories = {'MASSEXTRACTION TECH2'},
    --            Time = 60,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist Power',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 900,
    --    BuilderConditions = {
    --        { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'PRODUCTSORIAN' }},
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
    --        { SIBC, 'LessThanEconEfficiencyOverTime', { 2.0, 1.4 }},
    --    },
    --    InstanceCount = 2,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'ENERGYPRODUCTION TECH3', 'ENERGYPRODUCTION TECH2', 'PRODUCTSORIAN'},
    --            AssisteeType = 'Engineer',
    --            Time = 60,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist Transport',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 875,
    --    BuilderConditions = {
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'TRANSPORTFOCUS' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    InstanceCount = 2,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'TRANSPORTFOCUS'},
    --            AssisteeType = 'Factory',
    --            Time = 60,
    --        },
    --    },
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist T2 Factory Upgrade',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 875,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENGINEER TECH1'}},
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'FACTORY TECH2' }},
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    InstanceCount = 4,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'FACTORY TECH2'},
    --            AssisteeType = 'Factory',
    --            Time = 60,
    --        },
    --    }
    --},
    --Builder {
    --    BuilderName = 'Sorian T1 Engineer Assist T3 Factory Upgrade',
    --    PlatoonTemplate = 'EngineerAssistSorian',
    --    Priority = 900,
    --    BuilderConditions = {
    --        { IBC, 'BrainNotLowPowerMode', {} },
    --        { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENGINEER TECH1'}},
    --        { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'FACTORY TECH3' }},
    --        { UCBC, 'HaveLessThanUnitsWithCategory', { 3, 'TECH3 FACTORY' } },
    --        --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
    --    },
    --    InstanceCount = 8,
    --    BuilderType = 'Any',
    --    BuilderData = {
    --        Assist = {
    --            AssistLocation = 'LocationType',
    --            PermanentAssist = false,
    --            BeingBuiltCategories = {'FACTORY TECH3'},
    --            AssisteeType = 'Factory',
    --            Time = 60,
    --        },
    --    }
    --},
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2EngineerBuilders',
    BuildersType = 'EngineerBuilder',
    -- =====================================
    --     T2 Engineer Resource Builders
    -- =====================================
    Builder {
        BuilderName = 'SorianEdit T2 Mass Adjacency Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
            --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH1' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 250, -3, 0, 0}},
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3', 250, 'ueb1106' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3',
                AdjacencyDistance = 250,
                BuildClose = false,
                ThreatMin = -3,
                ThreatMax = 700,
                ThreatRings = 0,
                BuildStructures = {
                    'MassStorage',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Energy Storage Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = -1,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, 'ENERGYPRODUCTION TECH2' }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION TECH2', 100, 'ueb1105' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH2',
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
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.TECH2 * categories.ENERGYPRODUCTION}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {'STRUCTURE ENERGYPRODUCTION TECH1 DRAGBUILD'},
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
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Find Low Shield',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ManagerEngineerFindLowShield',
        Priority = 1801,
        InstanceCount = 3,
        BuilderConditions = {
                { SBC, 'ShieldDamaged', { 'LocationType'}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE SHIELD TECH2, STRUCTURE SHIELD TECH3'},
                Time = 20,
            },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Repair',
        PlatoonTemplate = 'T2EngineerRepairSorianEdit',
        PlatoonAIPlan = 'RepairAI',
        Priority = 925,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'DamagedStructuresInArea', { 'LocationType', }},
            },
        BuilderData = {
            LocationType = 'LocationType',
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
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { SIBC, 'LessThanEconEfficiencyOverTime', { 2.0, 1.5 }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.5 } },
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
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
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
        BuilderName = 'SorianEdit T2 Engineer Assist Transport',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 875,
        BuilderConditions = {
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'TRANSPORTFOCUS' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = {'TRANSPORTFOCUS'},
                AssisteeType = 'Factory',
                Time = 60,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Engineer',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 500,

        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ALLUNITS' } },
            { UCBC, 'CheckBuildPlattonDelay', { 'EngineerAssistDelays' }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
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
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENGINEER TECH1'}},
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'FACTORY TECH3' }},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 1.1 }},
            { IBC, 'BrainNotLowPowerMode', {} },
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
        Priority = -1,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, 'ENERGYPRODUCTION TECH3' }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
            { IBC, 'BrainNotLowMassMode', {} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'ENERGYPRODUCTION TECH3', 100, 'ueb1105' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH3',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'EnergyStorage',
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
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Find Low Shield',
        PlatoonTemplate = 'T3EngineerBuilderOnlySorianEdit',
        PlatoonAIPlan = 'ManagerEngineerFindLowShield',
        Priority = 1801,
        InstanceCount = 3,
        BuilderConditions = {
                { SBC, 'ShieldDamaged', { 'LocationType'}},
            },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE SHIELD TECH2, STRUCTURE SHIELD TECH3'},
                Time = 20,
            },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Repair',
        PlatoonTemplate = 'T3EngineerRepairSorianEdit',
        PlatoonAIPlan = 'RepairAI',
        Priority = 925,
        InstanceCount = 2,
        BuilderConditions = {
                { SBC, 'DamagedStructuresInArea', { 'LocationType', }},
            },
        BuilderData = {
            LocationType = 'LocationType',
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
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'ENERGYPRODUCTION TECH3' }},
            { SIBC, 'LessThanEconEfficiencyOverTime', { 2, 1.3}},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.5 } },
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
        BuilderName = 'SorianEdit T3 Engineer Assist Transport',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'TRANSPORTFOCUS' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = {'TRANSPORTFOCUS'},
                AssisteeType = 'Factory',
                Time = 60,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Mass Fab',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' }},
                { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'MASSPRODUCTION TECH3' }},
                { SIBC, 'LessThanEconEfficiencyOverTime', { 0.9, 2.0}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 1.1}},
                { IBC, 'BrainNotLowPowerMode', {} },
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
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' }},
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE DEFENSE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
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
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.1} },
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
        InstanceCount = 20,
        BuilderConditions = {
            --{ UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1} },
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
        DelayEqualBuildPlattons = {'EngineerAssistDelays', 4},
        Priority = 700,
        InstanceCount = 20,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE, EXPERIMENTAL' }},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                PermanentAssist = false,
                BeingBuiltCategories = { 'SHIELD STRUCTURE', 'DEFENSE ANTIAIR', 'DEFENSE DIRECTFIRE', 'DEFENSE ANTINAVY', 'PRODUCTSORIAN',
                                        'EXPERIMENTAL', 'ALLUNITS', },
                AssisteeType = 'Engineer',
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerMassBuilders - Naval',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 150 - Naval', --150
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 100, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 250 - Naval',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 980,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 450 - Naval',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 970,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 450, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 1500 - Naval',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 850,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            --NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 250 - Naval',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 975,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 1500 - Naval',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0, --875,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 250 range - Naval',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 975,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 1500 range - Naval',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0, --850,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mass Fab Engineer - Naval',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSFABRICATION' } },
                { SIBC, 'LessThanEconEfficiencyOverTime', { 0.91, 2.0}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 1.25}},
                { EBC, 'LessThanEconStorageRatio', { 0.75, 2 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSPRODUCTION TECH3' } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'PRODUCTSORIAN',
                BuildStructures = {
                    'T3MassCreation',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerMassBuilders - Rush',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 100 - Rush', --150
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 100, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 250 - Rush',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 970,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 450 - Rush',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 800, --910,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 450, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 1500 - Rush',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 850,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            --NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 250 - Rush',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 975,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 1500 - Rush',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0, --875,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 250 range - Rush',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 975,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 1500 range - Rush',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0, --850,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mass Fab Engineer - Rush',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSFABRICATION' } },
                { SIBC, 'LessThanEconEfficiencyOverTime', { 0.91, 2.0}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 1.25}},
                { EBC, 'LessThanEconStorageRatio', { 0.75, 2 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSPRODUCTION TECH3' } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'PRODUCTSORIAN',
                BuildStructures = {
                    'T3MassCreation',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerMassBuildersLowerPri - Rush',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 100 Low - Rush', --150
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 100, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 350 Low - Rush',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 700,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 1500 Low - Rush',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 650,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            --NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2ResourceEngineer 150 Low - Rush',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 150, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 350 Low - Rush',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 850,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 1500 Low - Rush',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 750,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 350 range Low - Rush',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 1500 range Low - Rush',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 750,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerMassBuildersHighPri',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 150', --150
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 150, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 250',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 970,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 450',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 910,
        InstanceCount = 4,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 450, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 1500',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 850,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            --NeedGuard = true,				 
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 250',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 975,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 1500',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0, --875,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'EngineerLessAtLocation', { 'LocationType', 6, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 250 range',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 975,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 1500 range',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0, --850,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mass Fab Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'MASSFABRICATION' } },
                { SIBC, 'LessThanEconEfficiencyOverTime', { 0.91, 2.0}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.4, 1.25}},
                { EBC, 'LessThanEconStorageRatio', { 0.75, 2 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3' } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSPRODUCTION TECH3' } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                AdjacencyCategory = 'PRODUCTSORIAN',
                BuildStructures = {
                    'T3MassCreation',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerMassBuildersLowerPri',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 150 Low',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 150, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 350 Low',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 700,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1ResourceEngineer 1500 Low',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 650,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH2, ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {				   
            --NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2ResourceEngineer 150 Low',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 150, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 350 Low',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 850,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 T2Resource Engineer 1500 Low',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 750,
        InstanceCount = 2,
        BuilderConditions = {
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH3'}},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 350 range Low',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 850,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 350, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 T3Resource Engineer 1500 range Low',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 750,
        BuilderConditions = {
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1500, -500, 0, 0, 'AntiSurface', 1 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1200,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3'}},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T1 Power Engineer - Overbuild',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1175,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'LessThanEconTrend', { 10000.0, 75.0 }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 120 } },
            { IBC, 'BrainNotLowMassMode', {} },
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3'}},
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.5 }},
        },
        --InstanceCount = 2,
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildStructures = {
                    'T1EnergyProduction',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 3, 'TECH3 ENGINEER' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' } },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
            { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            --{ SIBC, 'LessThanEconTrend', { 100000, 45}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION TECH2',
                maxUnits = 4,
                maxRadius = 20,
                BuildStructures = {
                    'T2EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Power Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1200,
        InstanceCount = 1,
        BuilderType = 'Any',
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
            { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
        },
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AvoidCategory = 'ENERGYPRODUCTION TECH3',
                maxUnits = 4,
                maxRadius = 20,
                BuildStructures = {
                    'T3EnergyProduction',
                },
            }
        }
    },

    Builder {
        BuilderName = 'SorianEdit T2 Power Engineer - init',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1500,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2'}},
            ----{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildStructures = {
                    'T2EnergyProduction',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Power Engineer - init',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1500,
        InstanceCount = 1,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
            ----{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
        },
        BuilderData = {
            Construction = {
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
                { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, 'ENERGYPRODUCTION TECH2' } },
                --{ UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'TECH3 ENGINEER' }},
                { SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH3'}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
                { EBC, 'LessThanEconTrend', { 10000.0, 0.0 }},
            },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
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
                { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, 'ENERGYPRODUCTION TECH3' } },
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.1 }},
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
        BuilderName = 'SorianEdit T2 Engineering Support UEF',
        PlatoonTemplate = 'UEFT2EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'PRODUCTSORIAN',
                BuildClose = true,
                FactionIndex = 1,
                BuildStructures = {
                    'T2EngineerSupport',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineering Support UEF',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'PRODUCTSORIAN',
                BuildClose = true,
                FactionIndex = 1,
                BuildStructures = {
                    'T2EngineerSupport',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineering Support Cybran',
        PlatoonTemplate = 'CybranT2EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'PRODUCTSORIAN',
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
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'ENGINEERSTATION' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 3, 'ENGINEER TECH2, ENGINEER TECH3' } },
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'PRODUCTSORIAN',
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
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { MIBC, 'FactionIndex', {3}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineeering Support Upgrade 2',
        PlatoonTemplate = 'T2Engineering2',
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { MIBC, 'FactionIndex', {3}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineeering Support Upgrade',
        PlatoonTemplate = 'T2Engineering',
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 10, 100}},
            { MIBC, 'FactionIndex', {1}},
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
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
