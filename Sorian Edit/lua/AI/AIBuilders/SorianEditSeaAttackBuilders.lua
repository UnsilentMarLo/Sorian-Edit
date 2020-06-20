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

local SUtils = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')

function SeaAttackCondition(aiBrain, locationType, targetNumber)
    local UC = import('/lua/editor/UnitCountBuildConditions.lua')
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        return true
    end
    --if aiBrain:GetCurrentEnemy() then
    --	local estartX, estartZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
    --	targetNumber = aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'AntiSurface')
    --	targetNumber = targetNumber + aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'AntiSub')
    --end

    local position = engineerManager:GetLocationCoords()
    local radius = engineerManager.Radius

    --local surfaceThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.NAVAL, position, radius)
    --local subThreat = pool:GetPlatoonThreat('AntiSub', categories.MOBILE * categories.NAVAL, position, radius)
    local surfaceThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.NAVAL)
    local subThreat = pool:GetPlatoonThreat('AntiSub', categories.MOBILE * categories.NAVAL)
    if (surfaceThreat + subThreat) >= targetNumber then
        return true
    elseif UC.UnitCapCheckGreater(aiBrain, .95) then
        return true
    elseif SUtils.ThreatBugcheck(aiBrain) then -- added to combat buggy inflated threat
        return true
    elseif UC.PoolGreaterAtLocation(aiBrain, locationType, 0, categories.MOBILE * categories.NAVAL * categories.TECH3) and (surfaceThreat + subThreat) > 1125 then --5 Units x 225
        return true
    elseif UC.PoolGreaterAtLocation(aiBrain, locationType, 0, categories.MOBILE * categories.NAVAL * categories.TECH2)
    and UC.PoolLessAtLocation(aiBrain, locationType, 1, categories.MOBILE * categories.NAVAL * categories.TECH3) and (surfaceThreat + subThreat) > 280 then --7 Units x 40
        return true
    elseif UC.PoolLessAtLocation(aiBrain, locationType, 1, categories.MOBILE * categories.NAVAL - categories.TECH1) and (surfaceThreat + subThreat) > 42 then --7 Units x 6
        return true
    end
    return false
end

BuilderGroup {
    BuilderGroupName = 'SorianEditT1SeaFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Sea Sub',
        PlatoonTemplate = 'T1SeaSub',
        Priority = 500,
		InstanceCount = 2,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH1 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Sea Frigate',
        PlatoonTemplate = 'T1SeaFrigate',
        Priority = 600,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY NAVAL TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T1 Naval Anti-Air',
        PlatoonTemplate = 'T1SeaAntiAir',
        Priority = 500,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Air' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY NAVAL TECH2' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
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
        Priority = 600,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { MIBC, 'FactionIndex', { 3}}, -- 1: UEF, 2: Aeon, 3: Cybran, 4: Seraphim, 5: Nomads 
            { UCBC, 'GreaterThanGameTimeSeconds', { 360 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 600,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 600,
		InstanceCount = 2,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T2SubKiller',
        PlatoonTemplate = 'T2SubKiller',
        Priority = 600,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2ShieldBoat',
        PlatoonTemplate = 'T2ShieldBoat',
        Priority = 400,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'SHIELD NAVAL MOBILE' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2CounterIntelBoat',
        PlatoonTemplate = 'T2CounterIntelBoat',
        Priority = 400,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'COUNTERINTELLIGENCE NAVAL MOBILE' } },
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2SeaStrikeForceBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Naval Destroyer - SF',
        PlatoonTemplate = 'T2SeaDestroyer',
        Priority = 600,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.STRUCTURE * categories.DEFENSE * categories.ANTINAVY, 'Enemy'}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser - SF',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 600,
		InstanceCount = 2,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.STRUCTURE * categories.DEFENSE * categories.ANTINAVY, 'Enemy'}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
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
        Priority = 1000,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Naval Cruiser - T3',
        PlatoonTemplate = 'T2SeaCruiser',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
		InstanceCount = 2,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Battleship',
        PlatoonTemplate = 'T3SeaBattleship',
        Priority = 1000,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
            { UCBC, 'HaveUnitRatio', { 0.1, categories.NAVAL * categories.MOBILE * categories.TECH3, '<=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Naval Nuke Sub',
        PlatoonTemplate = 'T3SeaNukeSub',
        Priority = 0, --700,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SorianEdit T3MissileBoat',
        PlatoonTemplate = 'T3MissileBoat',
        Priority = 900,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
            { UCBC, 'HaveUnitRatio', { 0.1, categories.NAVAL * categories.MOBILE * categories.TECH3, '<=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3Battlecruiser',
        PlatoonTemplate = 'T3Battlecruiser',
        Priority = 1000,
		InstanceCount = 2,
        BuilderType = 'Sea',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.NAVAL * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.1 }},
            { UCBC, 'HaveUnitRatio', { 0.1, categories.NAVAL * categories.MOBILE * categories.TECH3, '<=', categories.NAVAL * categories.MOBILE * categories.TECH2}},
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
            },
        InstanceCount = 4,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 1200,
            MarkerType = 'Start Location',
            MoveFirst = 'Random',
            LocationType = 'LocationType',
            MoveNext = 'Random',
            AvoidBases = false,
            AvoidBasesRadius = 100,
            UseFormation = 'None',
            AggressiveMove = false,
            AvoidClosestRadius = 50,
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
        --UseFormation = 'None',
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 20 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 60 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
        },
        BuilderConditions = {
            --{ SeaAttackCondition, { 'LocationType', 180 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, 'MOBILE TECH2 NAVAL' } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, categories.STRUCTURE * categories.DEFENSE * categories.ANTINAVY, 'Enemy'}},
            --{ SeaAttackCondition, { 'LocationType', 60 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            SearchRadius = 6000,
            PrioritizedCategories = {
                'STRUCTURE DEFENSE ANTINAVY TECH2',
                'STRUCTURE DEFENSE ANTINAVY TECH1',
                'MOBILE NAVAL',
                'STRUCTURE NAVAL',
            },
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 20 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 60 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            --{ SeaAttackCondition, { 'LocationType', 180 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH2 NAVAL, MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 40 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, 'MOBILE TECH3 NAVAL' } },
            --{ SeaAttackCondition, { 'LocationType', 120 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
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
        --UseFormation = 'None',
            ThreatWeights = {
                --IgnoreStrongerTargetsRatio = 25.0,
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economic',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            --{ SeaAttackCondition, { 'LocationType', 360 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterSeaFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
}
