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
        Priority = 1200,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3'}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
                'T1SeaFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Naval Builder Fast',
        PlatoonTemplate = 'EngineerBuilderSorianEdit',
        Priority = 922,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY NAVAL'}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'FACTORY NAVAL TECH2, FACTORY NAVAL TECH3' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 600, -1000, 10, 1, 'AntiSurface' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                NearMarkerType = 'Naval Area',
                LocationRadius = 600,
                LocationType = 'LocationType',
                ThreatMin = -1000,
                ThreatMax = 1200,
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH2, ENGINEER TECH3' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                'T1NavalDefense',
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
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 1, 'ENGINEER TECH3' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                'T1NavalDefense',
                'T1NavalDefense',
                'T1AADefense',
                },
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Factory Builder',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 905,
        BuilderConditions = {
            { UCBC, 'NavalBaseCheck', { } }, -- related to ScenarioInfo.Options.NavalExpansionsAllowed
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.85 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                Location = 'LocationType',
                NearMarkerType = 'Naval Area',
                BuildClose = true,
                BuildStructures = {
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                    'T1SeaFactory',
                'T1NavalDefense',
                'T1NavalDefense',
                'T1AADefense',
                },
            },
        },
    },
}
	do
	LOG('--------------------- SorianEdit Naval Builders loaded')
	end
