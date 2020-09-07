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
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Land attack Builders loading')
	end
	
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
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 440 } },
        },
        BuilderType = 'Land',
    },
    -- Priority of tanks at tech 2
    -- Won't build if economy is hurting
    Builder {
        BuilderName = 'SorianEdit T1 Light Tank - Tech 2',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 500,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { SBC, 'IsIslandMap', { false } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 440 } },
        },
        BuilderType = 'Land',
    },
    -- Priority of tanks at tech 3
    -- Won't build if economy is hurting
    Builder {
        BuilderName = 'SorianEdit T1 Light Tank - Tech 3',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 400,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'UnitCapCheckLess', { .5 } },
            { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 440 } },
        },
        BuilderType = 'Land',
    },
    -- T1 Artillery, built in a ratio to tanks before tech 3
    Builder {
        BuilderName = 'SorianEdit T1 Mortar',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 830,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'HaveUnitRatioUveso', { 0.5, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            -- { SBC, 'IsIslandMap', { false } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			-- { UCBC, 'LessThanGameTimeSeconds', { 440 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - Not T1',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 500, --600,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            ---- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'INDIRECTFIRE LAND MOBILE' } },
            { UCBC, 'HaveUnitRatioUveso', { 0.5, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { SBC, 'IsIslandMap', { false } },
            { UCBC, 'UnitCapCheckLess', { .6 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mortar - tough def',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 835,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            ---- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'INDIRECTFIRE LAND MOBILE' } },
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
            { UCBC, 'HaveUnitRatioUveso', { 0.5, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { SBC, 'IsIslandMap', { false } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
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
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'HaveUnitRatioUveso', { 0.25, categories.LAND * categories.ANTIAIR * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'LAND ANTIAIR MOBILE' } },
            -- { UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'ANTIAIR' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mobile AA - Response',
        PlatoonTemplate = 'T1LandAA',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 900,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'LAND ANTIAIR MOBILE' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			{ UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
}

------------------------------------------
-- T1 Amphibious 
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT1Land - water map',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mobile - water map',
        PlatoonTemplate = 'T1LandDFTank',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { SBC, 'IsWaterMap', { true } },
			{ MIBC, 'FactionIndex', {2}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 30, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mobile - water map',
        PlatoonTemplate = 'T1LandArtillery',
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 500,
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { SBC, 'IsWaterMap', { true } },
			{ MIBC, 'FactionIndex', {4}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.6 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 30, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
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
        BuilderConditions = {
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH1 } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH2, FACTORY TECH3 LAND' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3 LAND' }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 440 } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH1 } },
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
        Priority = 100,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'LAND TECH2 MOBILE' } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    -- MML's, built in a ratio to directfire units
    Builder {
        BuilderName = 'SorianEdit T2 MML',
        PlatoonTemplate = 'T2LandArtillery',
        Priority = 100,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { UCBC, 'HaveUnitRatioUveso', { 0.45, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1100,
        BuilderType = 'Land',
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3',
        PlatoonTemplate = 'T2LandDFTank',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'LAND TECH2 MOBILE' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2MobileShields',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 3, 'LAND TECH2 MOBILE' } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { UCBC, 'HaveUnitRatioUveso', { 0.15, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - T3 Factories',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY - categories.TECH1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 3, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 4, 'LAND TECH2 MOBILE' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { UCBC, 'HaveUnitRatioUveso', { 0.15, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    },
}

------------------------------------------
-- T2 Factories - Naval Map
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT2LandFactoryBuilders - water map',
    BuildersType = 'FactoryBuilder',
    -- Tech 2 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2 Tank Aeon - Tech 2 - water map',
        PlatoonTemplate = 'T2AttackTank',
        Priority = 1300,
        BuilderType = 'Land',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileShields - Tech 2 - water map',
        PlatoonTemplate = 'T2MobileShields',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            { UCBC, 'HaveUnitRatioUveso', { 0.3, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T2MobileAA - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAA',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
			{ MIBC, 'FactionIndex', {2}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    -- Tech 3 Priority
    Builder {
        BuilderName = 'SorianEdit T2 Tank 2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    -- Tech 2 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank - Tech 2 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1000,
        BuilderType = 'Land',
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
        },
    },
    -- Tech 3 priority
    Builder {
        BuilderName = 'SorianEdit T2AttackTank2 - Tech 3 - water map',
        PlatoonTemplate = 'T2LandAmphibious',
        Priority = 1050,
        BuilderType = 'Land',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
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
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            -- { SBC, 'IsIslandMap', { false } },
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE - categories.TECH1 } },
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
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatioUveso', { 0.3, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 2, 'FACTORY TECH3 LAND' }},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mobile Flak Response',
        PlatoonTemplate = 'T2LandAA',
        Priority = 1000,
        BuilderConditions = {
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 4, 'FACTORY TECH3 LAND' }},
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            -- { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 10, 'Air' } },
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3 LAND' }},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
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
        Priority = 1450,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            -- { UCBC, 'HaveUnitRatioUveso', { 0.25, categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3 * categories.PRODUCTFA}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3ArmoredAssault',
        PlatoonTemplate = 'T3ArmoredAssault',
        Priority = 1450,
        BuilderType = 'Land',
        BuilderConditions = {
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    -- T3 Artilery
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            -- { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveUnitRatioUveso', { 0.3, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Heavy Artillery - tough def',
        PlatoonTemplate = 'T3LandArtillery',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            -- { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
            { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiSurface', 53}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { UCBC, 'HaveUnitRatioUveso', { 0.4, categories.LAND * categories.ARTILLERY * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile Flak',
        PlatoonTemplate = 'T3LandAA',
        Priority = 1250,
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { UCBC, 'HaveUnitRatioUveso', { 0.4, categories.LAND * categories.ANTIAIR * categories.MOBILE * categories.TECH3, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE * categories.TECH3}},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            -- { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3SniperBots',
        PlatoonTemplate = 'T3SniperBots',
        Priority = 1350,
        BuilderType = 'Land',
        BuilderConditions = {
            -- { SBC, 'IsIslandMap', { false } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileMissile',
        PlatoonTemplate = 'T3MobileMissile',
        Priority = 1250,
        BuilderType = 'Land',
        BuilderConditions = {
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { UCBC, 'HaveUnitRatioUveso', { 0.3, categories.LAND * categories.INDIRECTFIRE * categories.MOBILE * categories.SILO, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE}},
            -- { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 5, 'AntiSurface' } },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T3MobileShields',
        PlatoonTemplate = 'T3MobileShields',
        Priority = 1250,
        BuilderType = 'Land',
        BuilderConditions = {
            -- { SBC, 'IsIslandMap', { false } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            { UCBC, 'HaveUnitRatioUveso', { 0.4, categories.LAND * categories.MOBILE * (categories.COUNTERINTELLIGENCE + (categories.SHIELD * categories.DEFENSE)) - categories.DIRECTFIRE, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1}},
        },
    },
}

------------------------------------------
-- T3 AA
------------------------------------------
BuilderGroup {
    BuilderGroupName = 'SorianEditT3LandAA',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA',
        PlatoonTemplate = 'T3LandAA',
        Priority = 1200,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatioUveso', { 0.3, categories.LAND * categories.ANTIAIR * categories.MOBILE - categories.TECH1 - categories.TECH2, '<=', categories.LAND * categories.DIRECTFIRE * categories.MOBILE - categories.TECH1 - categories.TECH2}},
            { MIBC, 'CanPathToCurrentEnemy', { true } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
			-- { UCBC, 'LessThanGameTimeSeconds', { 730 } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 Mobile AA Response',
        PlatoonTemplate = 'T3LandAA',
        Priority = 1200,
        BuilderConditions = {
            { TBC, 'HaveLessThreatThanNearby', { 'LocationType', 'AntiAir', 'Air' } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH2 } },
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'LAND ANTIAIR MOBILE' } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.60, 0.8 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
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
        PlatoonTemplate = 'T3ArmoredAssault',
        Priority = 945,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            -- { SBC, 'IsIslandMap', { false } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH3 } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SorianEdit T3 SiegeBot Enemy Nearby',
        PlatoonTemplate = 'T3LandBot',
        Priority = 935,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Land', 1 } },
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, categories.LAND * categories.FACTORY * categories.TECH3 } },
            -- { SBC, 'IsIslandMap', { false } },
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 60, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.03, 0.01 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.65, 0.75 }},
            -- { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, categories.DIRECTFIRE * categories.LAND * categories.MOBILE * categories.TECH3 } },
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
    --[[ Builder {
        BuilderName = 'SorianEdit Unit Cap Default Land Attack',
        PlatoonTemplate = 'LandAttackSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'UnitCapCheckGreater', { .95 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T1',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
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
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T2',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 25, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1220 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit De-clutter Land Attack T3',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 800,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.SCOUT - categories.ENGINEER } },
            { UCBC, 'GreaterThanGameTimeSeconds', { 1720 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            ThreatSupport = 500,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = false,
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
            --SecondaryTargetThreatType = 'StructuresNotMex',
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
    }, ]]--
}


-----------------------------------------

--DOCUMENTATION OF ATTACKFORCEAI FOR SORIANEDIT--

-- The AttackForceAI at full use now. We are using all features of the threatweights.
-- which includes very detailed information of what we are looking to attack and what we are not looking to attack.
-- This will increase the effectiveness of AttackForceAI as most of this was on default settings before which were horrible
-- The Intending effect of AttackForceAI was to be fully customizable but was never put into effect???
-- Look at The File "AIAttackUtils.lua" in FAFDevelop for more information. 

-- I will begin to look into {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'}, soon, but this will take time.
-- I will also note that the AirLandToggleSorian is something We need to look into too. 
-- Note That we can also include specific squads in these platoons as a future improvement.
-- Also Drops will be much more specific in Targetting now. As they will listen to the Threatweights also.
-- Notice Distress Range and Threat Support are both from {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},.
-- These two guide these functions, DistressRange should allow this to work properly but This is up to Marlo to test.
-- Threatsupport is when a DistressResponse is put out when a platoon feels that the threat is simply to high for them to engage according to their Threatweights.

-- ALSO GROWTHFORMATION ALLOWS MOVEMENT AND FORMATION OF THE PLATOON AT THE SAME TIME, SO WE CAN KEEP FORMATION AND MOVE AT THE SAME TIME. 
-- AttackFormation waited till the formation was completely formed to move at all, which was terrible.

-----------------------------------------
 -- Update:
 -- The next version is going to take advantage of Uvesos new Micro AI,
 -- since this requires a comparative, target search category based Builder data
 -- we are forced to ditch the fairly effective threat weight system.
 
-----------------------------------------

-- SorianEdit Documentation by Marlo and Azraeel.


BuilderGroup {
    BuilderGroupName = 'SorianEditFrequentLandAttackFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack Default',
        PlatoonTemplate = 'LandAttackSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 100,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND,
            MoveToCategories = {
                categories.MOBILE * categories.LAND,
                categories.COMMAND,
                categories.Structure,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                categories.INDIRECTFIRE * categories.LAND,
                categories.DIRECTFIRE * categories.LAND,
                categories.ANTIAIR * categories.LAND,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND - categories.ENGINEER } },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Artillery Attack Default',
        PlatoonTemplate = 'LandAttackSorianEditArty',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 100,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 100,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND,
            MoveToCategories = {
                categories.MOBILE * categories.LAND,
                categories.COMMAND,
                categories.Structure,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                categories.INDIRECTFIRE * categories.LAND,
                categories.DIRECTFIRE * categories.LAND,
                categories.ANTIAIR * categories.LAND,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND - categories.ENGINEER } },
        },
    },
	
Builder {
        BuilderName = 'SorianEdit Amphibious Water Attack - Default',
        PlatoonTemplate = 'LandAttackLargeSorianEdit - amphib',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1200,
        InstanceCount = 30,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 100,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND,
            MoveToCategories = {
                categories.MOBILE * categories.LAND,
                categories.COMMAND,
                categories.Structure,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                categories.INDIRECTFIRE * categories.LAND,
                categories.DIRECTFIRE * categories.LAND,
                categories.ANTIAIR * categories.LAND,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
	
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Medium',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 100,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND,
            MoveToCategories = {
                categories.MOBILE * categories.LAND,
                categories.COMMAND,
                categories.Structure,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                categories.INDIRECTFIRE * categories.LAND,
                categories.DIRECTFIRE * categories.LAND,
                categories.ANTIAIR * categories.LAND,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 20, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
    Builder {
        BuilderName = 'SorianEdit Frequent Land Attack - Large',
        PlatoonTemplate = 'LandAttackLargeSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        InstanceCount = 50,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 100,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND,
            MoveToCategories = {
                categories.MOBILE * categories.LAND,
                categories.COMMAND,
                categories.Structure,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL * categories.LAND,
                categories.COMMAND,
                categories.INDIRECTFIRE * categories.LAND * categories.TECH3,
                categories.DIRECTFIRE * categories.LAND * categories.TECH3,
                categories.INDIRECTFIRE * categories.LAND,
                categories.DIRECTFIRE * categories.LAND,
                categories.ANTIAIR * categories.LAND,
                categories.MOBILE * categories.LAND,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 35, categories.MOBILE * categories.LAND - categories.ENGINEER} },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMassHunterLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',

    -- Hunts for mass locations with Economic threat value of no more than 2 mass extractors
    Builder {
        BuilderName = 'SorianEdit Mass Hunter Early Game',
        PlatoonTemplate = 'MassHuntersCategorySorianEditSmall',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
				{ UCBC, 'LessThanGameTimeSeconds', { 350 } },
                -- { UCBC, 'LessThanGameTimeSeconds', { 420 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 750,
            LocationType = 'LocationType',
            MarkerType = 'Mass',
            MoveFirst = 'Threat',
            MoveNext = 'Threat',
            ThreatType = 'Economy', 		    -- Type of threat to use for gauging attacks
            FindHighestThreat = false, 		-- Don't find high threat targets
            MaxThreatThreshold = 4000, 		-- If threat is higher than this, do not attack
            MinThreatThreshold = 1000, 		-- If threat is lower than this, do not attack
            AvoidBases = true,
            AvoidBasesRadius = 200,
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
        PlatoonTemplate = 'MassHuntersCategorySorianEditLarge',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 990,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 600 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 15, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 750,
            MarkerType = 'Mass',
            LocationType = 'LocationType',
            MoveFirst = 'Threat',
            MoveNext = 'Threat',
            ThreatType = 'Economy', 		    -- Type of threat to use for gauging attacks
            FindHighestThreat = false, 		-- Don't find high threat targets
            MaxThreatThreshold = 20000, 	-- If threat is higher than this, do not attack
            MinThreatThreshold = 1000, 		-- If threat is lower than this, do not attack
            AvoidBases = true,
            AvoidBasesRadius = 200,
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
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                -- { UCBC, 'LessThanGameTimeSeconds', { 720 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
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
            AvoidBasesRadius = 200,
            AggressiveMove = false,
            AvoidClosestRadius = 50,
            GuardTimer = 50,
            UseFormation = 'GrowthFormation',
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Small',
        PlatoonTemplate = 'LandAttackSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 250,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Early Attacks Medium',
        PlatoonTemplate = 'LandAttackSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1000,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 20, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
            },
        BuilderData = {
            ThreatSupport = 250,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
            },
        },
        InstanceCount = 3,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T2/T3 Land Weak Enemy Response',
        --PlatoonTemplate = 'StrikeForceMediumSorianEdit',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND * (categories.TECH2 + categories.TECH3) - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 1000}},
            { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 13, categories.MOBILE * categories.LAND * (categories.TECH2 + categories.TECH3)  - categories.ENGINEER } },
        },
        BuilderData = {
            ThreatSupport = 250,
            SearchRadius = 513,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
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
        BuilderName = 'SorianEdit Land Weak Enemy Response - T1',
        PlatoonTemplate = 'LandAttackMediumSorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 1400,
        BuilderConditions = {
            { SBC, 'PoolThreatGreaterThanEnemyBase', {'LocationType', categories.MOBILE * categories.LAND * categories.TECH1 - categories.SCOUT - categories.ENGINEER, 'AntiSurface', 'AntiSurface', 350}},
            { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 13, categories.MOBILE * categories.LAND * categories.TECH1  - categories.ENGINEER } },
        },
        BuilderData = {
            ThreatSupport = 250,
            SearchRadius = 513,
            NeverGuardBases = true,
            LocationType = 'LocationType',
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            AggressiveMove = false,
        ThreatWeights = {
                IgnoreStrongerTargetsRatio = 500.0,
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


    Builder {
        BuilderName = 'SorianEdit Expansion Area Patrol - Small Map',
        PlatoonTemplate = 'StartLocationAttack2SorianEdit',
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'},
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 850,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 420 } },
                { SBC, 'MapLessThan', {1000, 1000}},
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
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
        --PlatoonAddPlans = {'PlatoonCallForHelpAISorian', 'DistressResponseAISorian'}, 
        PlatoonAddBehaviors = { 'AirLandToggleSorian' },
        Priority = 825,
        BuilderConditions = {
                { UCBC, 'GreaterThanGameTimeSeconds', { 840 } },
                { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 10, categories.MOBILE * categories.LAND  - categories.ENGINEER } },
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
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMiscLandFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    --[[ Builder {
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
            ---- { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 } },
            --CanBuildFirebase { 500, 500 }},
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    },
    Builder {
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
            -- { UCBC, 'PoolLessAtLocation', { 'LocationType', 1, categories.MOBILE * categories.LAND - categories.ENGINEER - categories.TECH1 - categories.TECH2} },
            { UCBC, 'EngineersNeedGuard', { 'LocationType' } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
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
            -- { SBC, 'NoRushTimeCheck', { 0 }},
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
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderType = 'Any',
    }, ]]--
}
	do
	LOG('--------------------- SorianEdit Land attack Builders loaded')
	end
