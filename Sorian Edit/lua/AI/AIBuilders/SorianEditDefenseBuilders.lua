--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditDefenseBuilders.lua
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
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua').GetDangerZoneRadii()

local AIAddBuilderTable = import('/lua/AI/AIAddBuilderTable.lua')

	do
	LOG('--------------------- SorianEdit Defense Builders loading')
	end


BuilderGroup {
    BuilderGroupName = 'SorianEditMassAdjacencyDefenses',
    BuildersType = 'EngineerBuilder',
    -- Builder {
        -- BuilderName = 'SorianEdit T1 Mass Adjacency Defense Engineer',
        -- PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        -- Priority = 825,
        -- BuilderConditions = {
            -- { MABC, 'MarkerLessThanDistance',  { 'Mass', 600, -1, 0, 0}},
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
            -- { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			-- { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			-- { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            -- { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION', 600, 'ueb2101' } },
        -- },
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- NeedGuard = false,
            -- Construction = {
                -- AdjacencyCategory = 'MASSEXTRACTION',
                -- AdjacencyDistance = 600,
                -- BuildClose = false,
                -- -- ThreatMin = -1,
                -- -- ThreatMax = 1200,
                -- -- ThreatRings = 0,
                -- MinRadius = 250,
                -- BuildStructures = {
                    -- 'T1GroundDefense',
                    -- 'T1AADefense',
                -- }
            -- }
        -- }
    -- },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Adjacency Defense Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1225,
        InstanceCount = 2,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) }},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 200, -1, 0, 0}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 600,
                BuildClose = false,
                -- ThreatMin = -1,
                -- ThreatMax = 1200,
                -- ThreatRings = 0,
                MinRadius = 250,
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mass Adjacency Defense Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1225,
        InstanceCount = 4,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.2, 0.8 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.STRUCTURE * categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) }},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 300, -1, 0, 0}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 600,
                BuildClose = false,
                ThreatMin = -1,
                ThreatMax = 1200,
                ThreatRings = 0,
                MinRadius = 250,
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                }
            }
        }
    },
}

-- Inside the base location defenses
BuilderGroup {
    BuilderGroupName = 'SorianEditT1BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1200,
        InstanceCount = 4,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1AADefense',
                    'T1GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D AA Engineer - Response',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        InstanceCount = 4,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D PD Engineer - Response',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        InstanceCount = 4,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Base D Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 2020,
        InstanceCount = 1,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.DEFENSE * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Engineer PD - Response',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Anti-TML Engineer - Response',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D AA Engineer - Response',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Artillery',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 2,
        BuilderType = 'Any',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.DEFENSE * categories.TECH2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildStructures = {
                    'T2Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2TMLEngineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2ArtilleryFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 TML Silo',
        PlatoonTemplate = 'T2TacticalLauncherSorianEdit',
        Priority = 1,
        InstanceCount = 1000,
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Artillery',
        PlatoonTemplate = 'T2ArtilleryStructureSorianEdit',
        Priority = 1,
        InstanceCount = 1000,
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer AA',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 945,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                    'T3AADefense',
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer AA - Response',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 948,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer AA - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2TMLEngineer - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer PD - Exp Response',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer PD',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 1245,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BaseDefenses - Emerg',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Base D AA Engineer - Response R',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Engineer PD - Response R',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2'}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3BaseDefenses - Emerg',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Base D AA Engineer - Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer AA - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2TMLEngineer - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer PD - Exp Response R',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 1300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- Defenses surrounding the base in patrol points
BuilderGroup {
    BuilderGroupName = 'SorianEditT1PerimeterDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Perimeter',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 910,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                -- NearBasePatrolPoints = true,
                NearInterestList = true,
                BuildStructures = {
                    'T1AADefense',
                    'T1GroundDefense',
                    'T1AADefense',
                    'T1GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2PerimeterDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Base D Engineer - Perimeter',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        DelayEqualBuildPlatoons = {'DefenseBuildings', 4},
        Priority = 3300,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.2, 0.5 }},
            -- { UCBC, 'CheckBuildPlatoonDelay', { 'DefenseBuildings' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                -- NearBasePatrolPoints = true,
                NearInterestList = true,
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
                    'T2GroundDefense',
                    'T2AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 D Engineer - PD Creep',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        DelayEqualBuildPlatoons = {'DefenseBuildings2', 4},
        Priority = 3430,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.8 }},
            { UCBC, 'CheckBuildPlatoonDelay', { 'DefenseBuildings2' }},
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                PdCreep = true,
                BuildStructures = {
                    'T1Radar',
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit D Engineer - Heavy PD Creep',
        PlatoonTemplate = 'T2T3EngineerBuilderSorianEdit',
        DelayEqualBuildPlatoons = {'DefenseBuildings2', 4},
        Priority = 7430,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.7, 0.9 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.8 }},
            { UCBC, 'CheckBuildPlatoonDelay', { 'DefenseBuildings2' }},
			{ SBC, 'CanPathToCurrentEnemy', { true, 'LocationType' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 3,
            Construction = {
                BuildClose = false,
                PdCreep = true,
                BuildStructures = {
                    'T1Radar',
                    'T2GroundDefense',
                    'T2ShieldDefense',
                    'T2AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3PerimeterDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer - Perimeter',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 12000, --945,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.7 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }}, -- { 0.2, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                -- NearBasePatrolPoints = true,
                NearInterestList = true,
                BuildStructures = {
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
                    'T2ShieldDefense',
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2Artillery',
                    'T2Artillery',
                    'T2Artillery',
                    'T3AADefense',
                    'T3AADefense',
                    'T3AADefense',
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- Defenses at defensive point markers
BuilderGroup {
    BuilderGroupName = 'SorianEditT1DefensivePoints',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Defensive Point Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900, --850,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
    -- Builder {
        -- BuilderName = 'SorianEdit T1 Defensive Point Fac spam',
        -- PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        -- Priority = 1200,
        -- InstanceCount = 1,
        -- BuilderConditions = {
            -- { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			-- { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			-- { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            -- { UCBC, 'UnitCapCheckLess', { .75 } },
        -- },
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- NeedGuard = false,
            -- NumAssistees = 1,
            -- Construction = {
                -- BuildClose = false,
                -- BaseTemplate = ExBaseTmpl,
                -- ExpansionBase = true,
                -- ExpansionRadius = 200,
                -- NearMarkerType = 'Defensive Point',
                -- MarkerRadius = 20,
                -- LocationRadius = 350,
                -- LocationType = 'LocationType',
                -- ThreatMin = -10000,
                -- ThreatMax = 2500,
                -- ThreatRings = 1,
                -- ThreatType = 'AntiSurface',
                -- MarkerUnitCount = 9,
                -- MarkerUnitCategory = 'STRUCTURE',
                -- BuildStructures = {
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- 'T1LandFactory',
                -- },
            -- },
        -- },
    -- },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2DefensivePoints',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Defensive Point Engineer UEF',
        PlatoonTemplate = 'UEFT2EngineerBuilderSorianEdit',
        Priority = 900, --875,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT2EngineerBuilderSorianEdit',
        Priority = 900, --875,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Defensive Point Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 900, --875,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
                    'T2ShieldDefense',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3DefensivePoints',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Defensive Point Engineer UEF',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Defensive Point Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2ShieldDefense',
                }
            }
        }
    },
}

-- Defenses at defensive point markers
BuilderGroup {
    BuilderGroupName = 'SorianEditT1DefensivePoints Turtle',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Turtle Defensive Point Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 950,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
    BuilderGroupName = 'SorianEditT2DefensivePoints Turtle',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Turtle Defensive Point Engineer UEF',
        PlatoonTemplate = 'UEFT2EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
        BuilderName = 'SorianEdit T2 Turtle Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT2EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
        BuilderName = 'SorianEdit T2 Turtle Defensive Point Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
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
    BuilderGroupName = 'SorianEditT3DefensivePoints Turtle',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Turtle Defensive Point Engineer UEF',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Turtle Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Turtle Defensive Point Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
}

-- Defenses at naval markers where a naval factory would be built
BuilderGroup {
    BuilderGroupName = 'SorianEditT1NavalDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Naval D Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 3,
                MarkerUnitCategory = 'DEFENSE TECH1 ANTINAVY',
                BuildStructures = {
                    'T1NavalDefense',
                    'T1GroundDefense',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D Naval AA Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 900,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH1 ANTIAIR',
                BuildStructures = {
                    'T1AADefense',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2NavalDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Naval D Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 3,
                MarkerUnitCategory = 'DEFENSE TECH2 ANTINAVY',
                BuildStructures = {
                    'T2NavalDefense',
                    'T2Artillery',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Naval AA Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH2 ANTIAIR',
                BuildStructures = {
                    'T2AADefense',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3NavalDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Naval D Engineer',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorianEdit',
        Priority = 945,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 3,
                MarkerUnitCategory = 'DEFENSE TECH3 ANTINAVY',
                BuildStructures = {
                    'T3NavalDefense',
                    'T2Artillery',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Naval AA Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 945,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.6, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                -- ThreatMax = 1200,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 ANTIAIR',
                BuildStructures = {
                    'T3AADefense',
                },
            }
        }
    },
}

-- Shields
BuilderGroup {
    BuilderGroupName = 'SorianEditT2Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Energy Production',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1200,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.5, 0.9 } },
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH2, 2, categories.STRUCTURE * categories.SHIELD * categories.TECH2}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'SHIELD STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 2,
                maxRadius = 20,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Energy Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 2230,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.16, 0.7 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.6, 0.9 } },
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH2, 1, categories.STRUCTURE * categories.SHIELD * categories.TECH2}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 20,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
	
	-- Near Mass Defences --
	
	-- 'T2AADefense',
	-- 'T2GroundDefense',
	-- 'T2MissileDefense',
	-- 'T2Artillery',
	
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 2930,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.16, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.0 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 1, 'LocationType', 20, 1, categories.SHIELD * categories.TECH2 * categories.STRUCTURE, false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 20,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 TMD D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.2 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 10, 'LocationType', 100, 2, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - (categories.ANTIAIR + categories.DIRECTFIRE), false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'ANTIMISSILE STRUCTURE TECH2',
                maxUnits = 4,
                maxRadius = 10,
                BuildClose = false,
                BuildStructures = {
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 PD D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.2 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 10, 'LocationType', 100, 4, categories.DIRECTFIRE * categories.TECH2 * categories.STRUCTURE, false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'DIRECTFIRE STRUCTURE TECH2',
                maxUnits = 4,
                maxRadius = 10,
                BuildClose = false,
                BuildStructures = {
                    'T2GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Artillery D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.2 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 10, 'LocationType', 100, 2, categories.INDIRECTFIRE * categories.TECH2 * categories.STRUCTURE - categories.SILO, false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'ARTILLERY STRUCTURE',
                maxUnits = 4,
                maxRadius = 10,
                BuildClose = false,
                BuildStructures = {
                    'T2Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 TML D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.2 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 10, 'LocationType', 100, 2, categories.TACTICALMISSILEPLATFORM * categories.TECH2 * categories.STRUCTURE, false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'TACTICALMISSILEPLATFORM STRUCTURE TECH2',
                maxUnits = 4,
                maxRadius = 10,
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 AA D Engineer Near Mass Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        InstanceCount = 4,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.7, 1.2 } },
            { UCBC, 'HaveLessThanUnitsAroundMarkerCategory', { 'Mass', 10, 'LocationType', 100, 2, categories.ANTIAIR * categories.TECH2 * categories.STRUCTURE, false, false, false }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 200,
                AvoidCategory = 'ANTIAIR STRUCTURE TECH2',
                maxUnits = 4,
                maxRadius = 10,
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2ShieldsExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Factory Expansion',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.SHIELD * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'SHIELD STRUCTURE TECH2' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 2,
                maxRadius = 20,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditShieldUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Shield Cybran 1',
        PlatoonTemplate = 'T2Shield1',
        Priority = 5,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield Cybran 2',
        PlatoonTemplate = 'T2Shield2',
        Priority = 5,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield Cybran 3',
        PlatoonTemplate = 'T2Shield3',
        Priority = 5,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 0.5, 30.0}},
            { MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield Cybran 4',
        PlatoonTemplate = 'T2Shield4',
        Priority = 5,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield',
        PlatoonTemplate = 'T2Shield',
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Power Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH3, 2, categories.STRUCTURE * categories.SHIELD}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH3',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 30,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Para Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 3,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.MASSPRODUCTION * categories.EXPERIMENTAL } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION MASSPRODUCTION EXPERIMENTAL',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Mass Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
			{ UCBC, 'HaveForEach', { categories.MASSEXTRACTION * categories.TECH3, 1, categories.STRUCTURE * categories.SHIELD}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION TECH3',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 30,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Factory Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH3, 2, categories.STRUCTURE * categories.SHIELD}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 30,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3ShieldsExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Near Factory Expansion',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 940,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.8 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH3, 2, categories.STRUCTURE * categories.SHIELD}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 30,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Near Factory Expansion Cybran',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 940,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.3, 0.9 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.8 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
			{ UCBC, 'HaveForEach', { categories.ENERGYPRODUCTION * categories.TECH3, 2, categories.STRUCTURE * categories.SHIELD}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'FACTORY, ENERGYPRODUCTION EXPERIMENTAL, ENERGYPRODUCTION TECH3, ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 1,
                maxRadius = 30,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- Anti nuke defenses
BuilderGroup {
    BuilderGroupName = 'SorianEditT3NukeDefensesExp',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near Factory Expansion',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 935,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                AvoidCategory = 'SHIELD STRUCTURE',
                maxUnits = 4,
                maxRadius = 10,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- Anti nuke defenses
BuilderGroup {
    BuilderGroupName = 'SorianEditT3NukeDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near Factory - First',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 125600,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.TECH3 * categories.ANTIMISSILE}},
            { SBC, 'EnemyHasLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.NUKE * categories.SILO, true}},
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                AvoidCategory = 'ANTIMISSILE STRUCTURE',
                maxUnits = 2,
                maxRadius = 60,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near Factory',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 4200, --945,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.05, 0.6 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { SBC, 'EnemyHasLessThanUnitsWithCategory', { 1, categories.STRUCTURE * categories.NUKE * categories.SILO, false}},
            { UCBC, 'HaveUnitRatioAtLocationSERadiusVersusEnemy', { 1.20, 'LocationType', 90, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3, '<=', categories.SILO * categories.NUKE * (categories.TECH3 + categories.EXPERIMENTAL) } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                AvoidCategory = 'ANTIMISSILE STRUCTURE',
                maxUnits = 1,
                maxRadius = 120,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer - Emerg',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 3301,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
            -- { UCBC, 'HaveUnitRatioAtLocationSERadiusVersusEnemy', { 1.20, 'LocationType', 90, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3, '<=', categories.SILO * categories.NUKE * (categories.TECH3 + categories.EXPERIMENTAL) } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 8,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer - Emerg 2',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 3301,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
            -- { UCBC, 'HaveUnitRatioAtLocationSERadiusVersusEnemy', { 1.20, 'LocationType', 90, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3, '<=', categories.SILO * categories.NUKE * (categories.TECH3 + categories.EXPERIMENTAL) } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 0, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { SBC, 'HaveComparativeUnitsWithCategoryAndAllianceAtLocation', { 'LocationType', true, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, categories.STRUCTURE * categories.NUKE * categories.TECH3, 'Enemy'}},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 8,
            Construction = {
                BuildClose = false,
                AdjacencyCategory = 'FACTORY -NAVAL',
                AdjacencyDistance = 100,
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist DP',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 2302,
        InstanceCount = 6,
        BuilderConditions = {
			{ UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.STRUCTURE * categories.SIZE4 - categories.TECH1}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 450,
                BeingBuiltCategories = { 'STRUCTURE SIZE4 TECH2', 'STRUCTURE SIZE4 TECH3', },
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist DP',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 3302,
        InstanceCount = 3,
        BuilderConditions = {
			{ UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.STRUCTURE * categories.SIZE4 - categories.TECH1}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = { 'STRUCTURE SIZE4 TECH2', 'STRUCTURE SIZE4 TECH3', },
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Anti-Nuke Emerg',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 3302000000000,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 0, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = {'ANTIMISSILE TECH3 STRUCTURE'},
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3NukeDefenseBehaviors',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Anti Nuke Silo',
        PlatoonTemplate = 'T3AntiNuke',
        Priority = 5,
        InstanceCount = 20,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.TECH3 * categories.ANTIMISSILE}},
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1LightDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Light',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1GroundDefense',
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Light - Emerg AA',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1001,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Light - Emerg PD',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 1001,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2MissileDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2MissileDefenseEng',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0, --925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Base D Anti-TML Engineer - Emerg Response',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { SBC, 'GreaterThanEnemyUnitsAroundBase', { 'LocationType', 0, 'TACTICALMISSILEPLATFORM TECH2 STRUCTURE', 256 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2LightDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Base D Engineer - Light',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2GroundDefense',
                    'T2AADefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Light T2 Artillery',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        BuilderType = 'Any',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'CheckUnitRange', { 'LocationType', 'T2Artillery', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildStructures = {
                    'T2Artillery',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit Light T2TML',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'CheckUnitRange', { 'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3LightDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer AA - Light',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer PD - Light',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 875,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditAirStagingExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Air Staging Engineer Expansion',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 0,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, categories.AIRSTAGINGPLATFORM}},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.AIRSTAGINGPLATFORM}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 15, categories.AIR * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AirStagingPlatform',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Wall Builder Expansion',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 0,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'HaveAreaWithUnitsFewWalls', { 'LocationType', 200, 5, 'DEFENSE', false, false, false } },
        },
        BuilderData = {
            NumAssistees = 0,
            Construction = {
                BuildStructures = { 'Wall' },
                LocationType = 'LocationType',
                Wall = true,
                MarkerRadius = 200,
                MarkerUnitCount = 5,
                MarkerUnitCategory = 'DEFENSE',
            },
        },
    },
}

-- Misc Defenses
BuilderGroup {
    BuilderGroupName = 'SorianEditMiscDefensesEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Wall Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 0,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'HaveAreaWithUnitsFewWalls', { 'LocationType', 200, 5, 'DEFENSE', false, false, false } },
        },
        BuilderData = {
            NumAssistees = 0,
            Construction = {
                BuildStructures = { 'Wall' },
                LocationType = 'LocationType',
                Wall = true,
                MarkerRadius = 200,
                MarkerUnitCount = 5,
                MarkerUnitCategory = 'DEFENSE',
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Staging Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 0,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.AIRSTAGINGPLATFORM * categories.STRUCTURE}},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 5, categories.AIRSTAGINGPLATFORM}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 15, categories.AIR * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AirStagingPlatform',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Reclaim Enemy Walls',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        PlatoonAIPlan = 'ReclaimUnitsAI',
        Priority = 975,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH1}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 10, categories.WALL, 'Enemy'}},
            },
        BuilderType = 'Any',
        BuilderData = {
            Radius = 1000,
            Categories = {'WALL'},
            ThreatMin = -10,
            ThreatMax = 10000,
            ThreatRings = 1,
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1ACUDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 ACU D Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 890,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.5, 0.7 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32000,
                BuildClose = false,
                BuildStructures = {
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2ACUDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 ACU D Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1390,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32,
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2ACUShields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near ACU',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 1390,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.ENGINEER * categories.TECH2}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}


BuilderGroup {
    BuilderGroupName = 'SorianEditT3ACUShields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Near ACU',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1390,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } }, -- { 0.16, 0.16 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 0.6, 0.8 }},
			{ MIBC, 'FactionIndex', { 1, 2, 4, 5 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32000,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- BuilderGroup {
    -- BuilderGroupName = 'SorianEditT3ACUNukeDefenses',
    -- BuildersType = 'EngineerBuilder',
    -- Builder {
        -- BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near ACU',
        -- PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        -- Priority = 2500,
        -- BuilderConditions = {
            -- { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'NUKE SILO STRUCTURE', 'Enemy'}},
            -- -- { UCBC, 'HaveUnitRatioAtLocationSERadiusVersusEnemy', { 1.20, 'LocationType', 90, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3, '<=', categories.SILO * categories.NUKE * (categories.TECH3 + categories.EXPERIMENTAL) } },
            -- -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE } },
            --  { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.0 }},
        -- },
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- NumAssistees = 1,
            -- Construction = {
                -- NearUnitCategory = 'COMMAND',
                -- NearUnitRadius = 32000,
                -- BuildClose = false,
                -- BuildStructures = {
                    -- 'T3StrategicMissileDefense',
                -- },
                -- Location = 'LocationType',
            -- }
        -- }
    -- },
-- }

BuilderGroup {
    BuilderGroupName = 'SorianEditT3NukeDefensesFormer',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEditT3NukeDefensePlatoon',
        PlatoonTemplate = 'AddToAntiNukePlatoonSorianEdit',
        Priority = 4000,
        FormRadius = 10000,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3 } },
        },
        BuilderData = {
            AIPlan = 'SorianEditT3AntiNukeAI',
        },
        BuilderType = 'Any',
    },
}

	do
	LOG('--------------------- SorianEdit Defense Builders loaded')
	end