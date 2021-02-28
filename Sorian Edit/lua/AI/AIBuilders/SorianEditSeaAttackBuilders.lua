--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/AISeaAttackBuilders.lua
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
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

local SUtils = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')

	do
	LOG('--------------------- SorianEdit Sea Attack Builders loading')
	end

BuilderGroup {
    BuilderGroupName = 'SorianEditT1SeaFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Sea Frigate Constant',
        PlatoonTemplate = 'T1SeaFrigate',
        Priority = 3000,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.08, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'NAVAL TECH1 DIRECTFIRE' }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Sea Sub',
        PlatoonTemplate = 'T1SeaSub',
        Priority = 2500,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
            { SBC, 'HaveUnitRatioSorian', { 0.4, categories.NAVAL * categories.TECH1 * categories.SUBMERSIBLE, '<=', categories.NAVAL * categories.TECH1 * categories.FRIGATE}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Sea Frigate',
        PlatoonTemplate = 'T1SeaFrigate',
        Priority = 700,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Sea Frigate - ratio to T2',
        PlatoonTemplate = 'T1SeaFrigate',
        Priority = 3500,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
            { SBC, 'HaveUnitRatioSorian', { 0.6, categories.NAVAL * categories.TECH1 * categories.MOBILE - categories.SUBMERSIBLE, '<=', categories.NAVAL * categories.MOBILE * categories.TECH1}},
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'NAVAL TECH1 DIRECTFIRE' }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Naval Anti-Air',
        PlatoonTemplate = 'T1SeaAntiAir',
        Priority = 700,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Air' } },
        },
        BuilderType = 'Sea',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2SeaFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer Landattack',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 1300,
        BuilderType = 'Sea',
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 3}}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 1400,
        BuilderType = 'Sea',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
            { SBC, 'HaveUnitRatioSorian', { 0.45, categories.NAVAL * categories.TECH2 * categories.MOBILE * categories.CRUISER, '<=', categories.NAVAL * categories.MOBILE * categories.DIRECTFIRE * categories.DESTROYER - categories.CRUISER}},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T2SubKiller',
        PlatoonTemplate = 'T2SubKiller',
        Priority = 1200,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', { 2, 3 }}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads 
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2ShieldBoat',
        PlatoonTemplate = 'T2ShieldBoat',
        Priority = 1300,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {1}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
			{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.NAVAL * categories.SHIELD } },
            { SBC, 'HaveUnitRatioSorian', { 0.25, categories.NAVAL * categories.TECH2 * categories.MOBILE * categories.SHIELD, '<=', categories.NAVAL * categories.MOBILE * categories.DIRECTFIRE - categories.TECH1 - categories.SHIELD}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2CounterIntelBoat',
        PlatoonTemplate = 'T2CounterIntelBoat',
        Priority = 1200,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {3}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'COUNTERINTELLIGENCE NAVAL MOBILE' } },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2SeaStrikeForceBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer - SF',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 1300,
        BuilderType = 'Sea',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser - SF',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 0.95 }},
            { SBC, 'HaveUnitRatioSorian', { 0.45, categories.NAVAL * categories.TECH2 * categories.MOBILE * categories.CRUISER, '<=', categories.NAVAL * categories.MOBILE * categories.DIRECTFIRE - categories.TECH1 - categories.CRUISER}},
        },
        BuilderType = 'Sea',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3SeaFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer - T3',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 2300,
        BuilderType = 'Sea',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
			-- { UCBC, 'CanPathNavalBaseToNavalTargets', { 'LocationType', categories.ALLUNITS }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser - T3',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 2300,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
            { SBC, 'HaveUnitRatioSorian', { 0.45, categories.NAVAL * categories.TECH2 * categories.MOBILE * categories.CRUISER, '<=', categories.NAVAL * categories.MOBILE * categories.DIRECTFIRE - categories.TECH1 - categories.CRUISER}},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Battleship',
        PlatoonTemplate = 'T3SeaBattleship',
        Priority = 4500,
        BuilderType = 'Sea',
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
            { SBC, 'HaveUnitRatioSorian', { 0.35, categories.NAVAL * categories.MOBILE * categories.TECH3 * categories.BATTLESHIP, '<=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Nuke Sub',
        PlatoonTemplate = 'T3SeaNukeSub',
        Priority = 3250, --700,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.NAVAL * categories.MOBILE * categories.SILO * categories.NUKE, '<=', categories.NAVAL * categories.MOBILE * categories.TECH3 - (categories.MOBILE * categories.SILO)}},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T3MissileBoat',
        PlatoonTemplate = 'T3MissileBoat',
        Priority = 3250,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
            { SBC, 'HaveUnitRatioSorian', { 0.3, categories.NAVAL * categories.MOBILE * categories.TECH3 * categories.INDIRECTFIRE, '>=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3Battlecruiser',
        PlatoonTemplate = 'T3Battlecruiser',
        Priority = 4400,
        BuilderType = 'Sea',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {1}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.8 }},
            { SBC, 'HaveUnitRatioSorian', { 0.35, categories.NAVAL * categories.MOBILE * categories.TECH3 * categories.BATTLESHIP, '<=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
        },
    },
}


BuilderGroup {
    BuilderGroupName = 'SorianEditSeaHunterFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit LandAttack T2 Destroyers',
        PlatoonTemplate = 'SeaAttackLandSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 3}}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads 
            { UCBC, 'GreaterThanGameTimeSeconds', { 360 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 4, 'MOBILE TECH2 NAVAL' } },
            },
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Sea Hunters T1',
        PlatoonTemplate = 'SeaHuntSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 2, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Sea Hunters T2',
        PlatoonTemplate = 'SeaHuntSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, 'MOBILE TECH2 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Sea Hunters T3',
        PlatoonTemplate = 'SeaHuntSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, 'MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Sea StrikeForce T2',
        PlatoonTemplate = 'SeaStrikeSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 100,
        InstanceCount = 7,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, 'MOBILE TECH2 NAVAL' } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.STRUCTURE * categories.DEFENSE * categories.ANTINAVY, 'Enemy'}},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentSeaAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Sea Attack T1',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 7,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Sea Attack T2',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 6,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Sea Attack T3',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 8,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditBigSeaAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Big Sea Attack T1',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 8,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Big Sea Attack T2',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 8,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH3 NAVAL' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Big Sea Attack T3',
        PlatoonTemplate = 'SeaAttackSorianEdit',
        --PlatoonAddPlans = {'DistressResponseAISorian', 'PlatoonCallForHelpAISorian'},
        PlatoonAddPlans = {'AirLandToggleSorian'},
        Priority = 10,
        InstanceCount = 8,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 20000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120,
            IgnorePathing = false,
            TargetSearchCategory = categories.ALLUNITS - categories.SCOUT,
            MoveToCategories = {
                categories.MOBILE * categories.NAVAL,
                categories.COMMAND,
                categories.STRUCTURE,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
        BuilderConditions = {
            -- { SeaAttackCondition, { 'LocationType', 360 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterSeaFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
}
	do
	LOG('--------------------- SorianEdit Sea Attack Builders loaded')
	end
