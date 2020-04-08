--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditLandAttackBuilders.lua
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

function LandAttackCondition(aiBrain, locationType, targetNumber)
    local UC = import('/lua/editor/UnitCountBuildConditions.lua')
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        return true
    end
    if aiBrain:GetCurrentEnemy() then
        local estartX, estartZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
        local enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
        --targetNumber = aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'AntiSurface')
        targetNumber = SUtils.GetThreatAtPosition(aiBrain, {estartX, 0, estartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex)
    end

    local position = engineerManager:GetLocationCoords()
    local radius = engineerManager.Radius

    --local surThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER, position, radius)
    local surThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER)
    local airThreat = 0 --pool:GetPlatoonThreat('AntiAir', categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER, position, radius)
    local adjustForTime = 1 + (math.floor(GetGameTimeSeconds()/60) * .01)
    --LOG("*AI DEBUG: Pool Threat: "..surThreat.." adjustment: "..adjustForTime.." Enemy Threat: "..targetNumber)
    if (surThreat + airThreat) >= targetNumber and targetNumber > 0 then
        return true
    elseif targetNumber == 0 then
        return true
    elseif UC.UnitCapCheckGreater(aiBrain, .95) then
        return true
    elseif SUtils.ThreatBugcheck(aiBrain) then -- added to combat buggy inflated threat
        return true
    elseif UC.PoolGreaterAtLocation(aiBrain, locationType, 9, categories.MOBILE * categories.LAND * categories.TECH3 - categories.ENGINEER) and surThreat > (500 * adjustForTime) then --25 Units x 20
        return true
    elseif UC.PoolGreaterAtLocation(aiBrain, locationType, 9, categories.MOBILE * categories.LAND * categories.TECH2 - categories.ENGINEER)
    and UC.PoolLessAtLocation(aiBrain, locationType, 10, categories.MOBILE * categories.LAND * categories.TECH3 - categories.ENGINEER) and surThreat > (175 * adjustForTime) then --25 Units x 7
        return true
    elseif UC.PoolLessAtLocation(aiBrain, locationType, 10, categories.MOBILE * categories.LAND - categories.TECH1 - categories.ENGINEER) and surThreat > (25 * adjustForTime) then --25 Units x 1
        return true
    end
    return false
end

BuilderGroup {
    BuilderGroupName = 'SorianEditT1LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- Priority of tanks at tech 1
    -- Won't build if economy is hurting
    Builder {
        BuilderName = 'SorianEdit T1 Light Tank - Tech 1',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 825,
        InstanceCount = 2,
        --Priority = 950,
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
    -- Priority of tanks at tech 2
    -- Won't build if economy is hurting
    Builder {
        BuilderName = 'SorianEdit T1 Light Tank - Tech 2',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 500,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
    -- Priority of tanks at tech 3
    -- Won't build if economy is hurting
    Builder {
        BuilderName = 'SorianEdit T1 Light Tank - Tech 3',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 400,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
    -- T1 Artillery, built in a ratio to tanks before tech 3
    Builder {
        BuilderName = 'SorianEdit T1 Mortar',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 830,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatio', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH2, FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - Not T1',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 500, --600,
        InstanceCount = 2,
        BuilderConditions = {
            --{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'INDIRECTFIRE LAND MOBILE' } },
            { UCBC, 'HaveUnitRatio', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - tough def',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 835,
        InstanceCount = 2,
        BuilderConditions = {
            --{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'INDIRECTFIRE LAND MOBILE' } },
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
            { UCBC, 'HaveUnitRatio', { 0.5, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T1 Mobile AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mobile AA',
        PlatoonTemplate = 'T1LandAA',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 830,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.ANTIAIR * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            --{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'ANTIAIR' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mobile AA - Response',
        PlatoonTemplate = 'T1LandAA',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 900,
        InstanceCount = 2,
        BuilderConditions = {
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T1 Response Builder
-- Used to respond to the sight of tanks nearby
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1ReactionDF',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Tank Enemy Nearby',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 900,
        InstanceCount = 3,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
			{ UCBC, 'LessThanGameTimeSeconds', { 600 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH1 } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T2 Factories
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- Tech 2 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 900,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 1200 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 550,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    -- MML's, built in a ratio to directfire units
    Builder {
        BuilderName = 'SorianEdit T2 MML',
        PlatoonTemplate = 'T2LandArtillery',
        Priority = 700,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveUnitRatio', { 0.35, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, categories.INDIRECTFIRE * categories.LAND * categories.TECH2 * categories.MOBILE } },
			{ UCBC, 'LessThanGameTimeSeconds', { 1200 } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 800,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 1200 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 550,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2MobileShields',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 800,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 1200 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - T3 Factories',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 700,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveUnitRatio', { 0.05, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
        },
    },
}

------------------------------------------
-- T2 Response Builder
-- Used to respond to the sight of tanks nearby
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2ReactionDF',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Tank Enemy Nearby',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 925,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
			{ UCBC, 'LessThanGameTimeSeconds', { 1200 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE - categories.TECH1 } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T2 AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak',
        PlatoonTemplate = 'T2LandAA',
        Priority = 600,
        BuilderConditions = {
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.ANTIAIR * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak Response',
        PlatoonTemplate = 'T2LandAA',
        Priority = 900,
        BuilderConditions = {
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Air' } },
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T3 Land
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3LandFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    -- T3 Tank
    Builder {
        BuilderName = 'SorianEdit T3 Siege Assault Bot',
        PlatoonTemplate = 'T3LandBot',
        Priority = 950,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3ArmoredAssault',
        PlatoonTemplate = 'T3ArmoredAssault',
        Priority = 950,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    -- T3 Artilery
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 870,
        BuilderType = 'Land',
        BuilderConditions = {
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveUnitRatio', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery - tough def',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 925,
        BuilderType = 'Land',
        BuilderConditions = {
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveUnitRatio', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Flak',
        PlatoonTemplate = 'T3LandAA',
        Priority = 910,
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.ANTIAIR * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            --{ TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3SniperBots',
        PlatoonTemplate = 'T3SniperBots',
        Priority = 850,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileMissile',
        PlatoonTemplate = 'T3MobileMissile',
        Priority = 800,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            --{ TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
        },
    },
    --[[ Builder {
        BuilderName = 'SorianEdit T3MobileShields',
        PlatoonTemplate = 'T3MobileShields',
        Priority = 920,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    }, ]]--
}

------------------------------------------
-- T3 AA
-----------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3LandResponseBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA Response',
        PlatoonTemplate = 'T3LandAA',
        Priority = 930,
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 1.05 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T3 Response
-----------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3ReactionDF',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Assault Enemy Nearby',
        PlatoonTemplate = 'T3ArmoredAssaultSorianEdit',
        Priority = 945,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH3 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 SiegeBot Enemy Nearby',
        PlatoonTemplate = 'T3LandBot',
        Priority = 935,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            --{ SBC, 'NoRushTimeCheck', { 600 }},
			{ UCBC, 'GreaterThanGameTimeSeconds', { 1000 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH3 } },
        },
        BuilderType = 'Land',
    },
}

-- ===================== --
--     Form Builders
-- ===================== --
BuilderGroup {
    BuilderGroupName = 'SorianEditUnitCapLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Unit Cap Default Land Attack',
        PlatoonTemplate = 'LandAttackSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'UnitCapCheckGreater', { .95 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T1',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 15, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 720 } },
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T2',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 25, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1220 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T3',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1720 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
}


BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack Default',
        PlatoonTemplate = 'LandAttackSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 7,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 1000,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'None',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            },
        },
        BuilderConditions = {
            --{ LandAttackCondition, { 'LocationType', 10 } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack T2',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 5,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 1000,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'None',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND * categories.TECH2 - categories.ENGINEER} },
            --{ LandAttackCondition, { 'LocationType', 50 } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack T3',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 5,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 1000,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'None',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 2.0,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND * categories.TECH3 - categories.ENGINEER} },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',

    -- Hunts for mass locations with Economic threat value of no more than 2 mass extractors
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Early Game',
        PlatoonTemplate = 'T1MassHuntersCategorySorianEdit',
        -- Commented out as the platoon doesn't exist in AILandAttackBuilders.lua
        --PlatoonTemplate = 'EarlyGameMassHuntersCategory',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                --{ LandAttackCondition, { 'LocationType', 10 } },
                --{ SBC, 'NoRushTimeCheck', { 0 }},
            },
        BuilderData = {
            ThreatSupport = 750,
            LocationType = 'LocationType',
            MarkerType = 'Mass',
            MoveFirst = 'Random',
            MoveNext = 'Threat',
            ThreatType = 'Economy', 		    -- Type of threat to use for gauging attacks
            FindHighestThreat = false, 		-- Don't find high threat targets
            MaxThreatThreshold = 4000, 		-- If threat is higher than this, do not attack
            MinThreatThreshold = 1000, 		-- If threat is lower than this, do not attack
            AvoidBases = true,
            AvoidBasesRadius = 100,
            UseFormation = 'None',
            AggressiveMove = false,
            AvoidClosestRadius = 50,
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    -- Mid Game Mass Hunter
    -- Used after 10, goes after mass locations of no max threat
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Mid Game',
        PlatoonTemplate = 'T2MassHuntersCategorySorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 990,
        BuilderConditions = {
                --{ UCBC, 'GreaterThanGameTimeSeconds', { 600 } },
                --{ LandAttackCondition, { 'LocationType', 50 } },
                --CanBuildFirebase { 500, 500 }},
            },
        BuilderData = {
            ThreatSupport = 750,
            MarkerType = 'Mass',
            LocationType = 'LocationType',
            MoveFirst = 'Random',
            MoveNext = 'Threat',
            ThreatType = 'Economy', 		    -- Type of threat to use for gauging attacks
            FindHighestThreat = false, 		-- Don't find high threat targets
            MaxThreatThreshold = 20000, 	-- If threat is higher than this, do not attack
            MinThreatThreshold = 1000, 		-- If threat is lower than this, do not attack
            AvoidBases = true,
            AvoidBasesRadius = 100,
            UseFormation = 'None',
            AggressiveMove = false,
            AvoidClosestRadius = 50,
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },


    -- Early Game Start Location Attack
    -- Used in the first 12 minutes to attack starting location areas
    -- The platoon then stays at that location and disbands after a certain amount of time
    -- Also the platoon carries an engineer with it
    Builder {
        BuilderName = 'SorianEdit Start Location Attack',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                --{ SBC, 'LessThanGameTime', { 720 } },
                --{ SBC, 'NoRushTimeCheck', { 0 }},
            },
        BuilderData = {
            ThreatSupport = 250,
            MarkerType = 'Start Location',
            MoveFirst = 'Closest',
            LocationType = 'LocationType',
            MoveNext = 'None',
            --ThreatType = '',
            --SelfThreat = '',
            --FindHighestThreat ='',
            --ThreatThreshold = '',
            AvoidBases = true,
            AvoidBasesRadius = 100,
            AggressiveMove = false,
            AvoidClosestRadius = 50,
            GuardTimer = 50,
            UseFormation = 'None',
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Small',
        PlatoonTemplate = 'LandAttackSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 720 } },
            },
        BuilderData = {
            ThreatSupport = 250,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            LocationType = 'LocationType',
            --UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 25.0,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Medium',
        PlatoonTemplate = 'LandAttackSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                --{ UCBC, 'ExpansionAreaNeedsEngineer', { 'LocationType', 350, -1000, 0, 2, 'StructuresNotMex' } },
                { UCBC, 'GreaterThanGameTimeSeconds', { 720 } },
                --{ LandAttackCondition, { 'LocationType', 50 } },
                --{ SBC, 'NoRushTimeCheck', { 0 }},
                --{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TECH2 * categories.MOBILE * categories.LAND - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 250,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            --UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 25.0,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Threat Response Strikeforce',
        PlatoonTemplate = 'StrikeForceMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 0, --1500,
        BuilderConditions = {
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'STRUCTURE STRATEGIC TECH3, STRUCTURE STRATEGIC EXPERIMENTAL, EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE', 'Enemy'}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 250,
            PrioritizedCategories = {
                'STRUCTURE STRATEGIC EXPERIMENTAL',
                'EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE',
                'STRUCTURE STRATEGIC TECH3',
                'COMMAND',
                'MASSEXTRACTION',
                'ENERGYPRODUCTION DRAGBUILD',
                'MASSFABRICATION',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T2/T3 Land Weak Enemy Response',
        --PlatoonTemplate = 'StrikeForceMediumSorianEdit',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 1}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY TECH2 LAND, FACTORY TECH3 LAND' }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
            --{ LandAttackCondition, { 'LocationType', 50 } },
        },
        BuilderData = {
            ThreatSupport = 250,
            SearchRadius = 6000,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            },
            PrioritizedCategories = {
                'STRUCTURE STRATEGIC EXPERIMENTAL',
                'EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE',
                'STRUCTURE STRATEGIC TECH3',
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
        InstanceCount = 1,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Land Weak Enemy Response',
        --PlatoonTemplate = 'StrikeForceMediumSorianEdit',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 1}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH2 LAND, FACTORY TECH3 LAND' }},
            { UCBC, 'GreaterThanGameTimeSeconds', { 720 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
            --{ LandAttackCondition, { 'LocationType', 10 } },
        },
        BuilderData = {
            ThreatSupport = 250,
            SearchRadius = 6000,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
            --SecondaryTargetThreatType = 'StructuresNotMex',
            },
            PrioritizedCategories = {
                'STRUCTURE STRATEGIC EXPERIMENTAL',
                'EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE',
                'STRUCTURE STRATEGIC TECH3',
                'ENERGYPRODUCTION DRAGBUILD',
                'MASSFABRICATION',
                'MASSEXTRACTION',
                'COMMAND',
                'SHIELD',
                'ANTIAIR STRUCTURE',
                'DEFENSE STRUCTURE',
                'STRUCTURE',
                'MOBILE ANTIAIR',
                'ALLUNITS',
            },
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },

    -- Small patrol that goes to expansion areas and attacks
    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Small Map',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 925,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 540 } },
                --{ SBC, 'NoRushTimeCheck', { 0 }},
                { SBC, 'MapLessThan', {1000, 1000}},
                --CanBuildFirebase {500, 500}},
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TECH2 * categories.MOBILE * categories.LAND - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 250,
            MarkerType = 'Expansion Area',
            MoveFirst = 'Random',
            MoveNext = 'Random',
            LocationType = 'LocationType',
            --ThreatType = '',
            --SelfThreat = '',
            --FindHighestThreat ='',
            --ThreatThreshold = '',
            AvoidBases = true,
            AvoidBasesRadius = 75,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
            AvoidClosestRadius = 50,
        },
        InstanceCount = 1,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 925,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 1200 } },
                --{ SBC, 'NoRushTimeCheck', { 0 }},
                --CanBuildFirebase {1000, 1000}},
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TECH2 * categories.MOBILE * categories.LAND - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 250,
            MarkerType = 'Expansion Area',
            MoveFirst = 'Random',
            MoveNext = 'Random',
            LocationType = 'LocationType',
            --ThreatType = '',
            --SelfThreat = '',
            --FindHighestThreat ='',
            --ThreatThreshold = '',
            AvoidBases = true,
            AvoidBasesRadius = 75,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
            AvoidClosestRadius = 50,
        },
        InstanceCount = 2,
        BuilderType = 'Any',
    },

    -- Seek and destroy
    Builder {
        BuilderName = 'SorianEdit T1 Hunters',
        PlatoonTemplate = 'HuntAttackSmallSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 990,
        --Priority = 0,
        InstanceCount = 6,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 250,
            LocationType = 'LocationType',
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            --UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
        BuilderConditions = {
            --{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 } },
            --{ LandAttackCondition, { 'LocationType', 10 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },

    -- Seek and destroy
    Builder {
        BuilderName = 'SorianEdit T2 Hunters',
        PlatoonTemplate = 'HuntAttackMediumSorianEdit',
        PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 990,
        --Priority = 0,
        InstanceCount = 1,
        BuilderType = 'Any',
        BuilderData = {
            ThreatSupport = 250,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            --UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
        BuilderConditions = {
            --{ UCBC, 'PoolLessAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 - categories.TECH2 } },
            { SBC, 'MapLessThan', { 1000, 1000 }},
            --{ LandAttackCondition, { 'LocationType', 50 } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMiscLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Tanks - Engineer Guard',
        PlatoonTemplate = 'T1EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 750,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            --{ UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 } },
            --CanBuildFirebase { 500, 500 }},
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    --[[ Builder {
        BuilderName = 'SorianEdit T2 Tanks - Engineer Guard',
        PlatoonTemplate = 'T2EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 0,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 - categories.TECH2} },
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Tanks - Engineer Guard',
        PlatoonTemplate = 'T3EngineerGuard',
        PlatoonAIPlan = 'GuardEngineer',
        Priority = 0,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER * categories.TECH3} },
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Tanks - T4 Guard',
        PlatoonTemplate = 'T3ExpGuard',
        PlatoonAIPlan = 'GuardExperimentalSorianEdit',
        Priority = 750,
        InstanceCount = 3,
        BuilderData = {
            NeverGuardBases = true,
            LocationType = 'LocationType',
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.LAND * categories.MOBILE - categories.TECH1 - categories.ANTIAIR - categories.SCOUT - categories.ENGINEER - categories.ual0303} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.EXPERIMENTAL * categories.LAND}},
            --{ SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    }, ]]--
}
