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
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Strategy Platoons Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditExcessMassBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer - Excess Mass',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 981,
        ActivePriority = 980,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL LAND', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = true,
                --T4 = true,
                -- BaseTemplate = ExBaseTmpl,
                -- NearMarkerType = 'Rally Point',
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
        Priority = 981,
        ActivePriority = 979,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL LAND', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 6,
            Construction = {
                BuildClose = true,
                --T4 = true,
                -- BaseTemplate = ExBaseTmpl,
                -- NearMarkerType = 'Rally Point',
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
        Priority = 981,
        ActivePriority = 981,
        InstanceCount = 15,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.LAND * categories.MOBILE}},
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
        Priority = -1,
        ActivePriority = 980,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL AIR', 'LocationType', }},
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
        Priority = -1,
        ActivePriority = 979,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, 'EXPERIMENTAL AIR', 'LocationType', }},
            { SBC, 'MapLessThan', { 1000, 1000 }},
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
        Priority = -1,
        Priority = 981,
        InstanceCount = 15,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.AIR * categories.MOBILE}},
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
        Priority = -1,
        ActivePriority = 700,
        BuilderType = 'Air',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1Transport - GG',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Air Transport - GG',
        PlatoonTemplate = 'T1AirTransport',
        Priority = -1,
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
        Priority = -1,
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
        Priority = -1,
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
        Priority = -1,
        ActivePriority = 1500,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'AIR FACTORY' } },
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
        Priority = -1,
        ActivePriority = 1500,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 5, categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL} },
        },
        BuilderData = {
            ThreatSupport = 250,
            PrioritizedCategories = {
                'ENERGYPRODUCTION DRAGBUILD',
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
        Priority = -1,
        ActivePriority = 900,
        BuilderType = 'Air',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BomberHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Air Bomber - High Prio',
        PlatoonTemplate = 'T3AirBomber',
        Priority = -1,
        ActivePriority = 1200,
        BuilderType = 'Air',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BomberSpecialHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Air Bomber Special - High Prio',
        PlatoonTemplate = 'T3AirBomberSpecialSorianEdit',
        Priority = -1,
        ActivePriority = 1200,
        BuilderType = 'Air',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1GunshipHighPrio',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1Gunship - High Prio',
        PlatoonTemplate = 'T1Gunship',
        Priority = -1,
        ActivePriority = 700,
        BuilderType = 'Air',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3' }},
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
        Priority = -1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'ENERGYPRODUCTION DRAGBUILD',
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
        },
    },
    Builder {
        BuilderName = 'SorianEdit Bomber Attack - Large T1',
        PlatoonTemplate = 'BomberAttackSorianEdit',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        --PlatoonAddPlans = { 'AirIntelToggle' },
        Priority = -1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'ENERGYPRODUCTION DRAGBUILD',
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
        Priority = -1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'COMMAND',
                'ENERGYPRODUCTION DRAGBUILD',
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
        Priority = -1,
        ActivePriority = 1300,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'ENERGYPRODUCTION DRAGBUILD',
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
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3ArtyBuildersHighPrio',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Arty Engineer - High Prio',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1300,
        ActivePriority = 1300,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 1300,
        ActivePriority = 1300,
        InstanceCount = 2,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'STRUCTURE TECH3 ARTILLERY', 'LocationType', }},
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 980,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 1280,
        ActivePriority = 1280,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.06, 0.02 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
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
        Priority = 981,
        ActivePriority = 981,
        InstanceCount = 3,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 981,
        ActivePriority = 981,
        InstanceCount = 3,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
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
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        InstanceCount = 5,
        Priority = 20000,
        ActivePriority = 200,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.4, 0.4 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Strategy',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 20000,
        ActivePriority = 200,
        InstanceCount = 5,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.4, 0.4 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = -1,
        ActivePriority = 200,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade Expansion Strategy',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = -1,
        ActivePriority = 200,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Sea Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = -1,
        ActivePriority = 200,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3, FACTORY TECH2' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = -1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = -1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Sea Factory Upgrade Expansion Strategy',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = -1,
        ActivePriority = 300,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'FACTORY TECH3' } },
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
        Priority = 900,
        ActivePriority = 985,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 5, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 900,
        ActivePriority = 932,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'StartLocationNeedsEngineer', { 'LocationType', 1000, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
        Priority = 900,
        ActivePriority = 922,
        InstanceCount = 2,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            { UCBC, 'ExpansionAreaNeedsEngineer', { 'LocationType', 350, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'StartLocationsFull', { 'LocationType', 350, -1000, 100, 0, 'StructuresNotMex' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
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
        Priority = 900,
        ActivePriority = 980,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 350, 'DEFENSE TECH1 STRUCTURE', 20,4,-10000,1,1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
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
        Priority = 900,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
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
        Priority = 900,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
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
        Priority = 900,
        ActivePriority = 980,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { MIBC, 'FactionIndex', {2, 4}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 } },
            { SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, -10000, 1, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.9 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6, 'MASSEXTRACTION' }},
                { SBC, 'CmdrHasUpgrade', { 'HeavyAntiMatterCannon', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                { SBC, 'CmdrHasUpgrade', { 'HeavyAntiMatterCannon', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {1}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.9 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6, 'MASSEXTRACTION' }},
                { SBC, 'CmdrHasUpgrade', { 'CrysalisBeam', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                { SBC, 'CmdrHasUpgrade', { 'CrysalisBeam', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'Shield', false }},
                { MIBC, 'FactionIndex', {2}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.9 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6, 'MASSEXTRACTION' }},
                { SBC, 'CmdrHasUpgrade', { 'CoolingUpgrade', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                { SBC, 'CmdrHasUpgrade', { 'CoolingUpgrade', true }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'MicrowaveLaserGenerator', false }},
                { MIBC, 'FactionIndex', {3}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.9 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6, 'MASSEXTRACTION' }},
                { SBC, 'CmdrHasUpgrade', { 'RateOfFire', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering ', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3' }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 900,
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
                { EBC, 'GreaterThanEconStorageRatio', { 0.13, 0.11 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH2, FACTORY TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3}},
                { SBC, 'CmdrHasUpgrade', { 'T3Engineering', true }},
                { SBC, 'CmdrHasUpgrade', { 'AdvancedRegenAura', false }},
                { MIBC, 'FactionIndex', {4}},
            },
        Priority = 900,
        ActivePriority = 900,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Enhancement = { 'AdvancedRegenAura' },
        },
    },
}
	do
	LOG('--------------------- SorianEdit Strategy Platoons Builders loaded')
	end
