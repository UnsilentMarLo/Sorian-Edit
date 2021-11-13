--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditNavalBuilders.lua
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
	LOG('--------------------- SorianEdit Naval Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditNavalExpansionBuildersFast',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Naval Builder Fast - initial',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 12000,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.NAVAL } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
					'T1SeaFactory',
					'T1SeaFactory',
					'T1NavalDefense',
					'T1AADefense',
					'T1Sonar',
					'T1SeaFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Naval Builder Fast',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY NAVAL'}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
					'T1SeaFactory',
					'T1SeaFactory',
					'T1SeaFactory',
					'T1SeaFactory',
					'T1NavalDefense',
					'T1NavalDefense',
					'T1NavalDefense',
					'T1AADefense',
					'T1Sonar',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Builder Fast',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL - categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2AADefense',
					'T2Sonar',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Builder Fast',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL - categories.TECH1 } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2NavalDefense',
					'T3AADefense',
					'T2Sonar',
                }
            }
        }
    },
}

-- For everything but Naval Rush
BuilderGroup {
    BuilderGroupName = 'SorianEditNavalExpansionBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Naval Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
					'T1NavalDefense',
					'T1NavalDefense',
					'T1NavalDefense',
					'T1AADefense',
					'T1Sonar',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Builder',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2AADefense',
					'T2Sonar',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Builder',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 1200, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 4300, --1200,
                ThreatRings = 0,
                ThreatType = 'AntiSurface',
                BuildClose = false,
                BaseTemplate = ExBaseTmpl,
                ExpansionBase = true,
                ExpansionRadius = 50,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
					'T2NavalDefense',
					'T2NavalDefense',
					'T2NavalDefense',
					'T3AADefense',
					'T3AADefense',
					'T3AADefense',
					'T2Sonar',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEngineerNavalFactoryBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Naval Factory Builder',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 905,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER - categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 5, categories.NAVAL } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
					'T1NavalDefense',
					'T1AADefense',
                },
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Factory Builder',
        PlatoonTemplate = 'T2EngineerBuilderSorianEdit',
        Priority = 905,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, categories.ENGINEER * categories.TECH3 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 5, categories.NAVAL } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
					'T2NavalDefense',
					'T2AADefense',
                },
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Factory Builder',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 4.0, 25.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }}, -- { 1.0, 1.0 }},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 5, categories.NAVAL } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
					'T2NavalDefense',
					'T3AADefense',
                },
            },
        },
    },
}
	do
	LOG('--------------------- SorianEdit Naval Builders loaded')
	end
