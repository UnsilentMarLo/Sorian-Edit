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

local AIAddBuilderTable = import('/lua/AI/AIAddBuilderTable.lua')

BuilderGroup {
    BuilderGroupName = 'SorianEditMassAdjacencyDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mass Adjacency Defense Engineer',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 825,
        BuilderConditions = {
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 600, -1, 0, 0}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION', 600, 'ueb2101' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 600,
                BuildClose = false,
                ThreatMin = -1,
                ThreatMax = 1200,
                ThreatRings = 0,
                MinRadius = 250,
                BuildStructures = {
                    'T1GroundDefense',
                    'T1AADefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Adjacency Defense Engineer',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 825,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 600, -1, 0, 0}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION', 600, 'ueb2101' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            Construction = {
                AdjacencyCategory = 'MASSEXTRACTION',
                AdjacencyDistance = 600,
                BuildClose = false,
                ThreatMin = -1,
                ThreatMax = 1200,
                ThreatRings = 0,
                MinRadius = 250,
                BuildStructures = {
                    'T1GroundDefense',
                    'T1AADefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mass Adjacency Defense Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 825,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2, MASSEXTRACTION TECH3'}},
            { MABC, 'MarkerLessThanDistance',  { 'Mass', 600, -1, 0, 0}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'AdjacencyCheck', { 'LocationType', 'MASSEXTRACTION', 600, 'ueb2301' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
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
                    'T2AADefense',
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 5, 'DEFENSE STRUCTURE'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH1 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'DEFENSE ANTIAIR STRUCTURE'}},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 5, categories.DEFENSE * categories.TECH1 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 7, 'DEFENSE DIRECTFIRE STRUCTURE'}},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Land' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH1 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        Priority = 920,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 40, 'DEFENSE TECH2 STRUCTURE' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 10, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 20, 'DEFENSE TECH2 DIRECTFIRE STRUCTURE' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 4, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2GroundDefense',
                    'T2GroundDefense',
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, 'ANTIMISSILE TECH2 STRUCTURE' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 7, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 5, 'DEFENSE TECH2 ANTIAIR STRUCTURE' }},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.DEFENSE * categories.TECH2 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 8, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ UCBC, 'CheckUnitRange', { 'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            --{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'EXPERIMENTAL AIR', 'Enemy'}},
            { SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'EXPERIMENTAL LAND', 'Enemy'}},
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            --{ UCBC, 'CheckUnitRange', { 'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
		InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE}},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
            --{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'EXPERIMENTAL AIR', 'Enemy'}},
            { SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 8, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'EXPERIMENTAL LAND', 'Enemy'}},
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            --{ UCBC, 'CheckUnitRange', { 'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
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
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 910,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 20, categories.DEFENSE * categories.TECH1 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH2'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearBasePatrolPoints = true,
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
        DelayEqualBuildPlattons = {'DefenseBuildings', 4},
        Priority = 930,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 30, categories.DEFENSE * categories.TECH2 * categories.STRUCTURE}},
            ---- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ENGINEER TECH3'}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'CheckBuildPlattonDelay', { 'DefenseBuildings' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearBasePatrolPoints = true,
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
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3PerimeterDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Base D Engineer - Perimeter',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 948, --945,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 30, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearBasePatrolPoints = true,
                BuildStructures = {
                    'T3AADefense',
                    'T2GroundDefense',
                    'T2MissileDefense',
                    'T2Artillery',
                    'T2StrategicMissile',
                    'T2ShieldDefense',
                    'T3AADefense',
                    'T2GroundDefense',
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900, --850,
        BuilderConditions = {
            -- Most paramaters freaking ever Build Condition -- All the threat ones are optional
            --------                                   MarkerType   LocRadius       category      markerRad unitMax tMin tMax Rings tType
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 350, 'DEFENSE TECH1 STRUCTURE', 20,        4,     0,   1,   1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
    Builder {
        BuilderName = 'SorianEdit T1 Defensive Point Fac spam',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1200,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.1 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 200,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 2500,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 9,
                MarkerUnitCategory = 'STRUCTURE',
                BuildStructures = {
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                'T1LandFactory',
                },
            },
        },
    },
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ MIBC, 'FactionIndex', {2, 4}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ MIBC, 'FactionIndex', {2, 4}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
            -- Most paramaters freaking ever Build Condition -- All the threat ones are optional
            --------                                   MarkerType   LocRadius       category      markerRad unitMax tMin tMax Rings tType
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 350, 'DEFENSE TECH1 STRUCTURE', 20,        4,     0,   1,   1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 350,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 1000, 'DEFENSE TECH2 STRUCTURE, DEFENSE TECH3 STRUCTURE', 20, 4, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ MIBC, 'FactionIndex', {2, 4}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 1000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            --{ SIBC, 'DefensivePointNeedsStructure', { 'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 2, 'DEFENSE STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
            --{ MIBC, 'FactionIndex', {2, 4}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH1 ANTINAVY', 20, 3, 0, 1, 1, 'AntiSurface' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH1 ANTIAIR', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH2 ANTINAVY', 20, 3, 0, 1, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH2 ANTIAIR', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH3 ANTINAVY', 20, 3, 0, 1, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .75 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
            { UCBC, 'NavalDefensivePointNeedsStructure', { 'LocationType', 300, 'DEFENSE TECH3 ANTIAIR', 20, 2, 0, 1, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 1, 'Air' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE } },
            { UCBC, 'UnitCapCheckLess', { .7 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Naval Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 300,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 1200,
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
        Priority = 930,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, categories.SHIELD * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Factory Production Base',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 930,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, categories.SHIELD * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
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
    BuilderGroupName = 'SorianEditT2ShieldsExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Shield D Engineer Near Factory Expansion',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.SHIELD * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE TECH2' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
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
            { EBC, 'GreaterThanEconIncome',  { 0.5, 15.0}},
            --{ MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            { EBC, 'GreaterThanEconIncome',  { 0.5, 20.0}},
            --{ MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            --{ MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            { EBC, 'GreaterThanEconIncome',  { 0.5, 40.0}},
            --{ MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Shield UEF Seraphim',
        PlatoonTemplate = 'T2Shield',
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 0.7, 35.0}},
            --{ MIBC, 'FactionIndex', {1, 4}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, categories.SHIELD * categories.TECH3 * categories.STRUCTURE} },
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
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, categories.SHIELD * categories.TECH3 * categories.STRUCTURE} },
            --{ MIBC, 'FactionIndex', {1, 2, 4}},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE TECH3' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION TECH3',
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
        BuilderName = 'SorianEdit T3 Shield D Engineer Factory Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 950,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 16, categories.SHIELD * categories.TECH2 * categories.STRUCTURE} },
            --{ MIBC, 'FactionIndex', {3}},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE TECH2' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                AdjacencyDistance = 100,
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
    BuilderGroupName = 'SorianEditT3ShieldsExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Shield D Engineer Near Factory Expansion',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 940,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.SHIELD * categories.TECH3 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ MIBC, 'FactionIndex', {1, 2, 4}},
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE TECH2' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'FACTORY',
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
        BuilderName = 'SorianEdit T3 Shield D Engineer Near Factory Expansion Cybran',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 940,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, categories.SHIELD * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ MIBC, 'FactionIndex', {3}},
            { SIBC, 'GreaterThanEconEfficiency', { 0.9, 1.2 } },
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE TECH2' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                AdjacencyCategory = 'FACTORY, ENERGYPRODUCTION EXPERIMENTAL, ENERGYPRODUCTION TECH3, ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T2ShieldDefense',
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
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            --{ EBC, 'GreaterThanEconIncome', { 2.5, 100}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
}

-- Anti nuke defenses
BuilderGroup {
    BuilderGroupName = 'SorianEditT3NukeDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near Factory - First',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 960,
        InstanceCount = 1,
        BuilderConditions = {
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            --{ EBC, 'GreaterThanEconIncome', { 2.5, 100}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer Near Factory',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 0, --945,
        InstanceCount = 1,
        BuilderConditions = {
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            --{ EBC, 'GreaterThanEconIncome', { 2.5, 100}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
            { UCBC, 'UnitCapCheckLess', { .95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
        BuilderName = 'SorianEdit T3 Anti-Nuke Engineer - Emerg',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 1301,
        InstanceCount = 1,
        BuilderConditions = {
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            --{ EBC, 'GreaterThanEconIncome', { 2.5, 100}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'UnitCapCheckLess', { .95 } },
            -- { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'NUKE SILO STRUCTURE', 'Enemy'}},
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
        Priority = 1301,
        InstanceCount = 1,
        BuilderConditions = {
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { SBC, 'HaveComparativeUnitsWithCategoryAndAllianceAtLocation', { 'LocationType', true, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, categories.STRUCTURE * categories.NUKE * categories.TECH3, 'Enemy'}},
            --{ EBC, 'GreaterThanEconIncome', { 2.5, 100}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
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
        BuilderName = 'SorianEdit T3 Engineer Assist Anti-Nuke Emerg',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 1302,
        InstanceCount = 8,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'NUKE SILO STRUCTURE', 'Enemy'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { true, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
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
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Anti-Nuke Emerg 2',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 1302,
        InstanceCount = 8,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ANTIMISSILE TECH3 STRUCTURE' } },
            { SBC, 'HaveComparativeUnitsWithCategoryAndAllianceAtLocation', { 'LocationType', true, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, categories.STRUCTURE * categories.NUKE * categories.TECH3, 'Enemy'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { SIBC, 'EngineerNeedsAssistance', { true, 'LocationType', {'ANTIMISSILE TECH3 STRUCTURE'} }},
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 925,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 8, 'DEFENSE STRUCTURE'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
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
                    'T1GroundDefense',
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Light - Emerg AA',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1001,
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'DEFENSE ANTIAIR STRUCTURE'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
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
                    'T1AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Base D Engineer - Light - Emerg PD',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 1001,
        BuilderConditions = {
			-- { UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'DEFENSE DIRECTFIRE STRUCTURE'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'ANTIMISSILE TECH2 STRUCTURE' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'ANTIMISSILE TECH2' }},
            { SBC, 'GreaterThanEnemyUnitsAroundBase', { 'LocationType', 0, 'TACTICALMISSILEPLATFORM TECH2 STRUCTURE', 256 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            -- { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH2 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 15, 'DEFENSE TECH2 STRUCTURE' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'ARTILLERY TECH2 STRUCTURE' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Structures' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { UCBC, 'CheckUnitRange', { 'LocationType', 'T2Artillery', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3)) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderData = {
            NumAssistees = 5,
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.TACTICALMISSILEPLATFORM}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
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
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
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
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.AIRSTAGINGPLATFORM}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2AirStagingPlatform',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Wall Builder Expansion',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
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
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, categories.AIRSTAGINGPLATFORM * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2AirStagingPlatform',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Engineer Reclaim Enemy Walls',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
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
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Reclaim Enemy Walls',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ReclaimUnitsAI',
        Priority = 975,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH2}},
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
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Reclaim Enemy Walls',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        PlatoonAIPlan = 'ReclaimUnitsAI',
        Priority = 975,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH3}},
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
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 890,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, 'DEFENSE STRUCTURE'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.6, 0.8 }},
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
        Priority = 890,
        BuilderConditions = {
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 6, 'DEFENSE TECH2 STRUCTURE' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION TECH2' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32000,
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
        Priority = 890,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.ENGINEER * categories.TECH2}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
            --{ MIBC, 'FactionIndex', {2} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
            Construction = {
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32000,
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
        Priority = 890,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.SHIELD * categories.STRUCTURE} },
            --{ MIBC, 'FactionIndex', {1, 2, 4}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.9 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.08 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 5,
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
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { UCBC, 'BuildingLessAtLocation', { 'LocationType', 1, 'ANTIMISSILE TECH3 STRUCTURE' } },
            -- -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE}},
            -- { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.0 }},
        -- },
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- NumAssistees = 5,
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
        PlatoonTemplate = 'AddToAntiNukePlatoon',
        Priority = 4000,
        FormRadius = 10000,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanArmyPoolWithCategory', { 0, categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE * categories.TECH3 } },
        },
        BuilderData = {
            AIPlan = 'U3AntiNukeAI',
        },
        BuilderType = 'Any',
    },
}
