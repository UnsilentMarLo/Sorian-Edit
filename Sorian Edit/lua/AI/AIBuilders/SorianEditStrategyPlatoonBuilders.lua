--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditStrategyPlatoonBuilders.lua
--**
--**  Summary  : Default Naval structure builders for skirmish
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
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SorianEditExcessMassBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer - Excess Mass',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'EXPERIMENTAL', 'NUKE STRUCTURE', 'TECH3 ARTILLERY STRUCTURE'} }},
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL LAND', 'LocationType', }},
            { IBC, 'BrainNotLowPowerMode', {} },
            { SBC, 'MapLessThan', { 2000, 2000 }},
            { SBC, 'MarkerLessThan', { 'LocationType', {'Amphibious Path Node', 'Land Path Node'}, 100, true } },
            --{ SIBC, 'T4BuildingCheck', {} },
            { SBC, 'EnemyThreatLessThanValueAtBase', { 'LocationType', 1, 'Air', 2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = false,
                --T4 = true,
                BaseTemplate = ExBaseTmpl,
                NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer - Large Map - Excess Mass',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 979,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'EXPERIMENTAL', 'NUKE STRUCTURE', 'TECH3 ARTILLERY STRUCTURE'} }},
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL LAND', 'LocationType', }},
            { IBC, 'BrainNotLowPowerMode', {} },
            --CanBuildFirebase { 2000, 2000 }},
            { SBC, 'MarkerLessThan', { 'LocationType', {'Amphibious Path Node', 'Land Path Node'}, 100, true } },
            --{ SIBC, 'T4BuildingCheck', {} },
            { SBC, 'EnemyThreatLessThanValueAtBase', { 'LocationType', 1, 'Air', 2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = false,
                --T4 = true,
                BaseTemplate = ExBaseTmpl,
                NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Mobile Land - Excess Mass',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 0.1,
        ActivePriority = 981,
        InstanceCount = 15,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.LAND * categories.MOBILE}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE LAND'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1 - Excess Mass',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'EXPERIMENTAL', 'NUKE STRUCTURE', 'TECH3 ARTILLERY STRUCTURE'} }},
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL AIR', 'LocationType', }},
            { IBC, 'BrainNotLowPowerMode', {} },
            --CanBuildFirebase { 1000, 1000 }},
            --{ SIBC, 'T4BuildingCheck', {} },
            { SBC, 'EnemyThreatLessThanValueAtBase', { 'LocationType', 1, 'Air', 2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = false,
                --T4 = true,
                NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1 - Small Map - Excess Mass',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 979,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'EXPERIMENTAL', 'NUKE STRUCTURE', 'TECH3 ARTILLERY STRUCTURE'} }},
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL AIR', 'LocationType', }},
            { IBC, 'BrainNotLowPowerMode', {} },
            { SBC, 'MapLessThan', { 1000, 1000 }},
            --{ SIBC, 'T4BuildingCheck', {} },
            { SBC, 'EnemyThreatLessThanValueAtBase', { 'LocationType', 1, 'Air', 2 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = false,
                --T4 = true,
                NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Mobile Air - Excess Mass',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 0.1,
        Priority = 981,
        InstanceCount = 15,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.AIR * categories.MOBILE}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE AIR'},
                Time = 60,
            },
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'SorianEditT1BomberHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Bomber - High Prio',
        PlatoonTemplate = 'T1AirBomber',
        Priority = 0.1,
        ActivePriority = 700,
        BuilderType = 'Air',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.AIR * categories.TECH1 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.05 }},
            ----{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
            --{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY AIR TECH2, FACTORY AIR TECH3' }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1Transport - GG',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Transport - GG',
        PlatoonTemplate = 'T1AirTransport',
        Priority = 0.1,
        ActivePriority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'TRANSPORTFOCUS' } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'TRANSPORTFOCUS' } },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Bot - GG',
        PlatoonTemplate = 'T1LandDFBot',
        Priority = 0.1,
        ActivePriority = 825,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL } },
        },
        BuilderType = 'Land',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditAirFactoryHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Factory Builder - High Prio',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 1500,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'AIR FACTORY' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
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
    Builder {
        BuilderName = 'SorianEdit CDR T1 Air Factory Builder - High Prio',
        PlatoonTemplate = 'CommanderBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 1500,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'AIR FACTORY' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'AIR FACTORY', 'LocationType', }},
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
    BuilderGroupName = 'SorianEditGGFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit GG Force',
        PlatoonTemplate = 'T1GhettoSquad',
        Priority = 0.1,
        ActivePriority = 1500,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 5, categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL} },
        },
        BuilderData = {
            ThreatSupport = 250,
            PrioritizedCategories = {
                'PRODUCTSORIAN DRAGBUILD',
                'HYDROCARBON',
                'COMMAND',
                'ENGINEER',
                'MASSEXTRACTION',
                'MOBILE LAND',
                'MASSFABRICATION',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'COMMAND',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BomberHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Air Bomber - High Prio',
        PlatoonTemplate = 'T2BomberSorianEdit',
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Air',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.AIR * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.05 }},
            ----{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
            --{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY AIR TECH3' }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BomberHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Air Bomber - High Prio',
        PlatoonTemplate = 'T3AirBomber',
        Priority = 0.1,
        ActivePriority = 1200,
        BuilderType = 'Air',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.AIR * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.05 }},
            ----{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BomberSpecialHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Air Bomber Special - High Prio',
        PlatoonTemplate = 'T3AirBomberSpecialSorianEdit',
        Priority = 0.1,
        ActivePriority = 1200,
        BuilderType = 'Air',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.AIR * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.05 }},
            ----{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1GunshipHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1Gunship - High Prio',
        PlatoonTemplate = 'T1Gunship',
        Priority = 0.1,
        ActivePriority = 700,
        BuilderType = 'Air',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.AIR * categories.TECH1 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 1.05 }},
            ----{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
            --{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY AIR TECH2, FACTORY AIR TECH3' }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditBomberLarge',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Bomber Attack - Large',
        PlatoonTemplate = 'BomberAttackSorianEdit',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        Priority = 0.1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'PRODUCTSORIAN DRAGBUILD',
                'MASSEXTRACTION',
                'MASSFABRICATION',
                'COMMAND',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 5, 'AIR MOBILE BOMBER' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit Bomber Attack - Large T1',
        PlatoonTemplate = 'BomberAttackSorianEdit',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        Priority = 0.1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'PRODUCTSORIAN DRAGBUILD',
                'MASSEXTRACTION',
                'MASSFABRICATION',
                'COMMAND',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 3, 'AIR MOBILE BOMBER' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditBomberBig',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Bomber Attack - Big',
        PlatoonTemplate = 'BomberAttackSorianEditBig',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        Priority = 0.1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'COMMAND',
                'PRODUCTSORIAN DRAGBUILD',
                'MASSFABRICATION',
                'MASSEXTRACTION',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 19, 'AIR MOBILE BOMBER' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditGunShipLarge',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit GunShip Attack - Large',
        PlatoonTemplate = 'GunshipSFSorianEdit',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        Priority = 0.1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'PRODUCTSORIAN DRAGBUILD',
                'HYDROCARBON',
                'COMMAND',
                'ENGINEER',
                'MASSEXTRACTION',
                'MOBILE LAND',
                'MASSFABRICATION',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'COMMAND',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 9, 'AIR MOBILE GROUNDATTACK' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3ArtyBuildersHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Arty Engineer - High Prio',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 1300,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
            --{ SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'ARTILLERY STRUCTURE TECH3' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Build Arty - High Prio',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 0.1,
        ActivePriority = 1300,
        InstanceCount = 2,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 150,
                BeingBuiltCategories = {'STRUCTURE ARTILLERY TECH3'},
                Time = 120,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3FBBuildersHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - HP',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 700, 'Expansion Area', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 700,
                NearMarkerType = 'Expansion Area',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2EngineerSupport',
                    'T2ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - HP',
        PlatoonTemplate = 'AeonT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 900, 'Expansion Area', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 900,
                NearMarkerType = 'Expansion Area',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - UEF - HP',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 750, 'Expansion Area', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 750,
                NearMarkerType = 'Expansion Area',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T2EngineerSupport',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - HP',
        PlatoonTemplate = 'SeraphimT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 825, 'Expansion Area', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 825,
                NearMarkerType = 'Expansion Area',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - DP - HP',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 700, 'Defensive Point', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 700,
                NearMarkerType = 'Defensive Point',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - DP - HP',
        PlatoonTemplate = 'AeonT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 900, 'Defensive Point', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 900,
                NearMarkerType = 'Defensive Point',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - UEF - DP - HP',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 750, 'Defensive Point', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 750,
                NearMarkerType = 'Defensive Point',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - DP - HP',
        PlatoonTemplate = 'SeraphimT3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ MABC, 'CanBuildFirebase', { 'LocationType', 825, 'Defensive Point', -10000, 5, 1, 'AntiSurface', 1, 'STRUCTURE ARTILLERY TECH3', 20} },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 825,
                NearMarkerType = 'Defensive Point',
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRUCTURE ARTILLERY TECH3',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2RadarJammer',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T3ShieldDefense',
                    'T3ShieldDefense',
                    'T3Artillery',
                    'T2Artillery',
                    'T2StrategicMissile',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2FirebaseBuildersHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Firebase Engineer - High Prio',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                FireBase = true,
                FireBaseRange = 256,
                NearMarkerType = 'Expansion Area',
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 700,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
                MarkerUnitCategory = 'STRATEGIC',
                MarkerRadius = 20,
                BuildStructures = {
                    'T2StrategicMissile',
                    'T2AADefense',
                    'T2GroundDefense',
                    'T2Radar',
                    'T2Artillery',
                    'T2MissileDefense',
                    'T2AADefense',
                    'T2GroundDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2ShieldDefense',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditNukeBuildersHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Nuke Engineer - High Prio',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.NUKE * categories.STRUCTURE}},
            --{ SIBC, 'HaveLessThanUnitsWithCategory', { 1, 'NUKE SILO STRUCTURE TECH3' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Build Nuke - High Prio',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 0.1,
        ActivePriority = 981,
        InstanceCount = 3,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 150,
                BeingBuiltCategories = {'STRUCTURE NUKE'},
                Time = 120,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Build Nuke Missile - High Prio',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 0.1,
        ActivePriority = 981,
        InstanceCount = 3,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'NonUnitBuildingStructure',
                AssistUntilFinished = true,
                AssistRange = 150,
                AssisteeCategory = 'STRUCTURE NUKE',
                Time = 120,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Extractor Upgrades Strategy',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Strategy',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 5,
        Priority = 0.1,
        ActivePriority = 200,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Strategy',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 0.1,
        ActivePriority = 200,
        InstanceCount = 5,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditBalancedUpgradeBuildersExpansionStrategy',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 200,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY LAND TECH2', 'FACTORY AIR TECH2', 'FACTORY AIR TECH1'}},
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade Expansion Strategy',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 200,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
                { SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY AIR TECH2', 'FACTORY LAND TECH2', 'FACTORY LAND TECH1'}},
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Sea Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 200,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY LAND TECH3', 'FACTORY AIR TECH3', 'FACTORY AIR TECH2'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY AIR TECH3', 'FACTORY LAND TECH3', 'FACTORY LAND TECH2'}},
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Sea Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 0.1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerExpansionBuildersStrategy',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1VacantStartingAreaEngineer - HP Strategy',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 985,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 5, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'LessThanExpansionBases', { } },
            --{ UCBC, 'HaveUnitRatio', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 6.5, '>=', 'FACTORY TECH1 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            --{ EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Start Location',
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 700,
                ThreatRings = 0,
                ThreatType = 'StructuresNotMex',
                BuildStructures = {
                    'T1GroundDefense',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1AADefense',
                    'T1Radar',
                }
            },
            NeedGuard = true,
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1VacantStartingAreaEngineer Strategy',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 932,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'LessThanExpansionBases', { } },
            --{ UCBC, 'HaveUnitRatio', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 6.5, '>=', 'FACTORY TECH1 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 14, '>=', 'FACTORY TECH2 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 19, '>=', 'FACTORY TECH3 STRUCTURE' } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Start Location',
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 700,
                ThreatRings = 0,
                ThreatType = 'StructuresNotMex',
                BuildStructures = {
                    'T1GroundDefense',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1AADefense',
                    'T1Radar',
                }
            },
            NeedGuard = true,
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Vacant Expansion Area Engineer(Full Base) - Strategy',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 922,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'ExpansionAreaNeedsEngineer', { 'LocationType', 350, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'StartLocationsFull', { 'LocationType', 350, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'LessThanExpansionBases', { } },
            --{ EBC, 'MassIncomeToUnitRatio', { 10, '>=', 'FACTORY TECH1 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 20, '>=', 'FACTORY TECH2 STRUCTURE' } },
            --{ EBC, 'MassIncomeToUnitRatio', { 30, '>=', 'FACTORY TECH3 STRUCTURE' } },
            --{ UCBC, 'HaveUnitRatio', { ExtractorToFactoryRatio, 'MASSEXTRACTION', '>=','FACTORY' } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            RequireTransport = true,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                NearMarkerType = 'Expansion Area',
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 700,
                ThreatRings = 2,
                ThreatType = 'StructuresNotMex',
                BuildStructures = {
                    'T1GroundDefense',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1LandFactory',
                    'T1AADefense',
                    'T1Radar',
                }
            },
            NeedGuard = true,
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1DefensivePoints - High Prio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 - High Prio Defensive Point Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        BuilderConditions = {
            -- Most paramaters freaking ever Build Condition -- All the threat ones are optional
            --------                                   MarkerType   LocRadius       category      markerRad unitMax tMin tMax Rings tType
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 350, 'DEFENSE TECH1 STRUCTURE', 20,        4,     -10000,   1,   1, 'AntiSurface' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            --{ UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 4,
                MarkerUnitCategory = 'DEFENSE TECH1 STRUCTURE',
                BuildStructures = {
                'T1GroundDefense',
                'T1AADefense',
                'T1GroundDefense',
                'T1AADefense',
                },
            },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2DefensivePoints - High Prio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 - High Prio Defensive Point Engineer UEF',
        PlatoonTemplate = 'UEFT2EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 4,
                MarkerUnitCategory = 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 - High Prio Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT2EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 4,
                MarkerUnitCategory = 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 - High Prio Defensive Point Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0.1,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.PRODUCTSORIAN * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            { MIBC, 'FactionIndex', {2, 4}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 700,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 4,
                MarkerUnitCategory = 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditACUUpgrades - Rush',
    BuildersType = 'EngineerBuilder', --'PlatoonFormBuilder',
    -- UEF
    Builder {
        BuilderName = 'SorianEdit UEF CDR Upgrade - Rush - Gun',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION' }},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'HeavyAntiMatterCannon', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'HeavyAntiMatterCannon' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit UEF CDR Upgrade - Rush - Eng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'HeavyAntiMatterCannon', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit UEF CDR Upgrade - Rush - Shield',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'PRODUCTSORIAN TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'Shield' },
        },
    },

    -- Aeon
    Builder {
        BuilderName = 'SorianEdit Aeon CDR Upgrade - Rush - Gun',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION' }},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'CrysalisBeam', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'CrysalisBeam' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Aeon CDR Upgrade - Rush - Eng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'CrysalisBeam', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'CrysalisBeamRemove', 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Aeon CDR Upgrade T3 - Rush - Shield',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'PRODUCTSORIAN TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'Shield' },
        },
    },

    -- Cybran
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade - Rush - Gun',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION' }},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'CoolingUpgrade', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'CoolingUpgrade' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade - Rush - Eng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'CoolingUpgrade', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'CoolingUpgradeRemove', 'StealthGenerator', 'AdvancedEngineering', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Cybran CDR Upgrade - Rush - Laser',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'PRODUCTSORIAN TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
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
        BuilderName = 'SorianEdit Seraphim CDR Upgrade - Rush - Gun',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION' }},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'RateOfFire', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'RateOfFire' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Seraphim CDR Upgrade - Rush - Eng',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'PRODUCTSORIAN TECH2, PRODUCTSORIAN TECH3' }},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.25}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'RateOfFireRemove', 'AdvancedEngineering', 'RegenAura', 'T3Engineering' },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Seraphim CDR Upgrade - Rush - Regen',
        PlatoonTemplate = 'CommanderEnhanceSorianEdit',
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'PRODUCTSORIAN TECH3'}},
                --{ EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 0.1,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedRegenAura' },
        },
    },
}
