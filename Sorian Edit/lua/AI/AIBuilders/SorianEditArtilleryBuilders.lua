--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/AIArtilleryBuilders.lua
--**
--**  Summary  : Default artillery/nuke/etc builders for skirmish
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
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Artillery Builders loading')
	end
	
-- T3 Artillery/Rapid Fire Artillery
BuilderGroup {
    BuilderGroupName = 'SorianEditT3ArtilleryGroup',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Artillery Engineer - In range',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 951,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.6 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Artillery Engineer - Overflow',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 3000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 5,
            Construction = {
				RepeatBuild = true,
                BuildClose = true,
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Artillery Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 949,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.6 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.TECH3 * categories.ARTILLERY}},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Artillery Engineer - 5x5+',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 949,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.6 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.TECH3 * categories.ARTILLERY}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.EXPERIMENTAL}},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Rapid T3 Artillery Engineer',
        PlatoonTemplate = 'AeonT3EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.45, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE * categories.EXPERIMENTAL, 'LocationType', }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                --T4 = true,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3RapidArtillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Rapid T3 Artillery Engineer - Overflow',
        PlatoonTemplate = 'AeonT3EngineerBuilderSorianEdit',
        Priority = 3000,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.7, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 5,
            Construction = {
				RepeatBuild = true,
                BuildClose = true,
                --T4 = true,
                BuildStructures = {
                    'T3RapidArtillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3EngineerAssistBuildHLRA',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 850,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.ARTILLERY * categories.TECH3 * categories.STRUCTURE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 150,
                BeingBuiltCategories = {'ARTILLERY TECH3 STRUCTURE'},
                Time = 120,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3ArtilleryGroupExp',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Artillery Engineer Expansion - In range',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 951,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE, 'LocationType', }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- T3 Artillery/Rapid Fire Artillery
BuilderGroup {
    BuilderGroupName = 'SorianEditExperimentalArtillery',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Artillery Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        --PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 949,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.3, 0.3 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.1, 1.1 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.TECH3 * categories.ANTIMISSILE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.TECH3 * categories.ARTILLERY * categories.STRUCTURE}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, categories.EXPERIMENTAL * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.EXPERIMENTAL}},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                --T4 = true,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T4Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T4 Artillery Engineer - Overflow',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        --PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.EXPERIMENTAL}},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 5,
            Construction = {
				RepeatBuild = true,
                BuildClose = true,
                --T4 = true,
                BuildStructures = {
                    'T4Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T4 Artillery Engineer - Cybran',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        --PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 949,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.2, 1.25 }},
            { MIBC, 'FactionIndex', {3} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.TECH3 * categories.ANTIMISSILE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.EXPERIMENTAL}},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false, --false
                --T4 = true,
                BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T4LandExperimental2',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T4 Artillery Engineer - Cybran Overflow',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        --PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 2000,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = true,
                BaseTemplate = ExBaseTmpl,
                BuildStructures = {
                    'T4LandExperimental2',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T4EngineerAssistBuildHLRA',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 850,
        InstanceCount = 8,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.ARTILLERY * categories.TECH3 * categories.STRUCTURE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssisteeType = 'Engineer',
                AssistRange = 150,
                AssistLocation = 'LocationType',
                BeingBuiltCategories = {'EXPERIMENTAL STRUCTURE'},
                Time = 120,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3ArtilleryFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Artillery',
        PlatoonTemplate = 'T3ArtilleryStructureSorianEdit',
        Priority = 1,
        InstanceCount = 1000,
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT4ArtilleryFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Artillery',
        PlatoonTemplate = 'T4ArtilleryStructureSorianEdit',
        --PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 1,
        InstanceCount = 1000,
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

-- Nukes
BuilderGroup {
    BuilderGroupName = 'SorianEditNukeBuildersEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit Seraphim Exp Nuke Engineer',
        PlatoonTemplate = 'SeraphimT3EngineerBuilderSorianEdit',
        Priority = 949,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.2, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.NUKE * categories.STRUCTURE * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                --T4 = true,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T4Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Seraphim Exp Nuke Engineer - Overflow',
        PlatoonTemplate = 'SeraphimT3EngineerBuilderSorianEdit',
        Priority = 3000,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                RepeatBuild = true,
                BuildClose = true,
                --T4 = true,
                BuildStructures = {
                    'T4Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Nuke Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Nuke Engineer - Overflow',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 3000,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.5, 0.5 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.25, 1.25 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = true,
                RepeatBuild = true,
                BuildStructures = {
                    'T3StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Nuke Engineer - 10x10',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.25 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.EXPERIMENTAL}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.NUKE * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            MinNumAssistees = 2,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T3StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Build Nuke',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 850,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.25 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.STRUCTURE * categories.NUKE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 150,
                BeingBuiltCategories = {'STRUCTURE NUKE'},
                Time = 120,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Build Nuke Missile',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 850,
        InstanceCount = 3,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.25 }},
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, 'NUKE STRUCTURE'}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 150,
                AssisteeCategory = 'STRUCTURE NUKE',
                Time = 120,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditNukeFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Nuke Silo',
        PlatoonTemplate = 'T3NukeSorianEdit',
        Priority = 4000,
        InstanceCount = 10,
        FormRadius = 10000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 0, categories.STRUCTURE * categories.NUKE * (categories.TECH2 + categories.TECH3 - categories.EXPERIMENTAL) } },
        },
        BuilderData = {
            AIPlan = 'NukePlatoonSorianEdit',
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T4 Nuke Silo',
        PlatoonTemplate = 'T4NukeSorianEdit',
        Priority = 4000,
        InstanceCount = 10,
        FormRadius = 10000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 0, categories.STRUCTURE * categories.NUKE * categories.EXPERIMENTAL } },
        },
        BuilderData = {
            AIPlan = 'NukePlatoonSorianEdit',
        },
        BuilderType = 'Any',
    },
}
	do
	LOG('--------------------- SorianEdit Artillery Builders loaded')
	end
