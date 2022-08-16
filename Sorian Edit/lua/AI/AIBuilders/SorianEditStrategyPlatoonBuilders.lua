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
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/AITargetManager.lua').GetDangerZoneRadii()

	do
	LOG('--------------------- SorianEdit Strategy Platoons Builders loading')
	end

BuilderGroup {
    BuilderGroupName = 'SorianEditStrategyPlatoons',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SorianEditT2FighterBomber Snipe',
        PlatoonTemplate = 'T2FighterBomber',
        Priority = 0,
        ActivePriority = 50000,
        BuilderType = 'Air',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.05, 0.4 } },
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
    },
    Builder {
        BuilderName = 'SorianEditT3 Air Bomber Snipe',
        PlatoonTemplate = 'T3AirBomber',
        Priority = 0,
        ActivePriority = 50000,
        BuilderType = 'Air',
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.05, 0.4 } },
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditStrategyPlatoonFormers',
    BuildersType = 'PlatoonFormBuilder',
    -- Builder {
        -- BuilderName = 'SorianEdit Bomber Attack - Big',
        -- PlatoonTemplate = 'BomberAttackSorianEditBig',
        -- PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        -- --PlatoonAddPlans = { 'AirIntelToggle' },
        -- Priority = 0,
        -- ActivePriority = 1300,
        -- InstanceCount = 20,
        -- BuilderType = 'Any',
        -- BuilderData = {
            -- SearchRadius = 6000,
            -- PrioritizedCategories = {
                -- 'COMMAND',
                -- 'ENERGYPRODUCTION DRAGBUILD',
                -- 'MASSFABRICATION',
                -- 'MASSEXTRACTION',
                -- 'SHIELD',
                -- 'ANTIAIR STRUCTURE',
                -- 'DEFENSE STRUCTURE',
                -- 'STRUCTURE',
                -- 'MOBILE ANTIAIR',
                -- 'ALLUNITS',
            -- },
        -- },
        -- BuilderConditions = {
            -- { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 19, 'AIR MOBILE BOMBER' } },
        -- },
    -- },
    Builder {
        BuilderName = 'SorianEditBomberAttack Snipe T2',
        PlatoonTemplate = 'BomberAttackSorianEditSnipeT2',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        Priority = 0,
        ActivePriority = 50000,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 2500,
            IgnorePathing = true,
            AvoidBases = true,
            AvoidBasesRadius = 300,
            TargetSearchCategory = categories.COMMAND,
            PrioritizedCategories = {
                categories.COMMAND,
                categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3),
                categories.MASSEXTRACTION,
                categories.ENGINEER * categories.TECH2,
                categories.ENGINEER * categories.TECH3,
                categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3),
                categories.ENGINEER * categories.TECH1,
                categories.ENERGYPRODUCTION,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.MOBILE * categories.LAND,
                categories.NAVAL * categories.CRUISER,
                categories.NAVAL - (categories.T1SUBMARINE + categories.T2SUBMARINE),
            },
            MoveToCategories = {
                categories.COMMAND,
                categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH2,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH2,
                categories.STRUCTURE * categories.MASSEXTRACTION,
                categories.STRUCTURE * categories.ENERGYPRODUCTION,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.ANTIAIR,
                categories.MASSEXTRACTION,
                categories.ENERGYPRODUCTION,
                categories.STRUCTURE,
                categories.MOBILE,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 15, 'AIR MOBILE BOMBER TECH2' } },
        },
    },
    Builder {
        BuilderName = 'SorianEditBomberAttack Snipe',
        PlatoonTemplate = 'BomberAttackSorianEditSnipeT3',
        PlatoonAddBehaviors = { 'AirUnitRefitSorian' },
        Priority = 0,
        ActivePriority = 50000,
        InstanceCount = 20,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 3000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 2500,
            IgnorePathing = true,
            AvoidBases = true,
            AvoidBasesRadius = 300,
            TargetSearchCategory = categories.COMMAND,
            PrioritizedCategories = {
                categories.COMMAND,
                categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3),
                categories.MASSEXTRACTION,
                categories.ENGINEER * categories.TECH2,
                categories.ENGINEER * categories.TECH3,
                categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3),
                categories.ENGINEER * categories.TECH1,
                categories.ENERGYPRODUCTION,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.MOBILE * categories.LAND,
                categories.NAVAL * categories.CRUISER,
                categories.NAVAL - (categories.T1SUBMARINE + categories.T2SUBMARINE),
            },
            MoveToCategories = {
                categories.COMMAND,
                categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH2,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH2,
                categories.STRUCTURE * categories.MASSEXTRACTION,
                categories.STRUCTURE * categories.ENERGYPRODUCTION,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.ANTIAIR,
                categories.MASSEXTRACTION,
                categories.ENERGYPRODUCTION,
                categories.STRUCTURE,
                categories.MOBILE,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 6, 'AIR MOBILE BOMBER TECH3' } },
        },
    },
}
	do
	LOG('--------------------- SorianEdit Strategy Platoons Builders loaded')
	end
