--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditEconomyUpgradeBuilders.lua
--**
--**  Summary  : Default economic builders for skirmish
--**
--**  Copyright © 205 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local BBTmplFile = '/lua/basetemplates.lua'
local ExBaseTmpl = 'ExpansionBaseTemplates'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'
local Adj22Tmpl = 'Adjacency22'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

-------------------------------------
-- NEW EXTRACTOR UPGRADE FUNCTION AND THREAD --

-- The New Thread and Function are located in SorianEditUtilites.lua and Platoon.lua
-- This New Thread and Function will auto upgrade mexes depending on the economy 
-- This will elimate the need for Strategies to upgrade mexes as this will adapt to the economy itself and the situation
-- This will also fix endless issues with Sorian's Mass Stalls
-------------------------------------

	do
	LOG('--------------------- SorianEdit Eco Upgrades Builders loading')
	end
	
BuilderGroup {
    BuilderGroupName = 'SorianEditTime Exempt Extractor Upgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Extractor upgrade',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 1,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 120 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Extractor upgrade - Multiple',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 2,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 220 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },
	
    Builder {
        BuilderName = 'SorianEdit Extractor upgrade - Multiple2',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 3,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 540 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },
	
	-- Overflow --
	
    Builder {
        BuilderName = 'SorianEdit Extractor upgrade - Overflow',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 1,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 120 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.80, 0.90 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Extractor upgrade - Multiple - Overflow',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 3,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 120 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.90, 1.00 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },
	
    Builder {
        BuilderName = 'SorianEdit Extractor upgrade - Multiple2 - Overflow',
        PlatoonTemplate = 'AddToMassExtractorUpgradePlatoonSE',
        Priority = 40000,
        InstanceCount = 6,
        FormDebugFunction = function()
            LOG('* AI-SorianEdit: Extractor Upgrade Platoon formed' ) 
        end,
        FormRadius = 10000,
        BuilderConditions = {
			{ UCBC, 'GreaterThanGameTimeSeconds', { 120 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.99, 1.00 } },
        },
        BuilderData = {
            AIPlan = 'ExtractorUpgradeAISorian',
        },
        BuilderType = 'Any',
    },
}

-- ================================= --
--     EMERGENCY FACTORY UPGRADES
-- ================================= --
BuilderGroup {
    BuilderGroupName = 'SorianEditEmergencyUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Emergency T1 Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
				{ UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'MOBILE TECH2, FACTORY TECH2', 'Enemy'}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Emergency T2 Factory Upgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 1, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
            },
        BuilderType = 'Any',
    },
}

-- ================================= --
--     RUSH FACTORY UPGRADES
-- ================================= --
BuilderGroup {
    BuilderGroupName = 'SorianEditT1RushUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Rush T1 Land Factory Upgrade Initial',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 14, 30}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit RushT1AirFactoryUpgrade Initial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 10, 35}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Rush T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY LAND TECH2, FACTORY LAND TECH3'}},
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 10, 35}},
                -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit RushT1AirFactoryUpgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        FormDebugFunction = nil,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 6,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR TECH2, FACTORY AIR TECH3'}},
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 15, 35}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
}

-- ================================= --
--     BALANCED FACTORY UPGRADES
-- ================================= --
BuilderGroup {
    BuilderGroupName = 'SorianEditT1BalancedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade Initial',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 150000,
        InstanceCount = 1,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
            },
        BuilderType = 'Any',
    },
   
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade Initial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 105000,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                --{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 3, 'FACTORY TECH2, FACTORY TECH3' } },
                -- { EBC, 'GreaterThanEconIncome',  { 3, 25}},
            },
        BuilderType = 'Any',
    },

    --[[ Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY LAND TECH2, FACTORY LAND TECH3'}},
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 40, 75}},
                -- { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 120,
        InstanceCount = 4,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR TECH2, FACTORY AIR TECH3'}},
                ---- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { EBC, 'GreaterThanEconIncome',  { 35, 75}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    }, ]]--
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BalancedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',

    --[[ Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade - T3',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH3'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade - T3',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH3'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    }, ]]--

    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - initial',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1,  categories.MASSEXTRACTION * categories.TECH3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH * categories.TECH3 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - initial',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1,  categories.MASSEXTRACTION * categories.TECH3 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1,  categories.ENERGYPRODUCTION * categories.TECH3 } },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
            },
        BuilderType = 'Any',
    },

    --[[ Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - Large Map',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 140,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                -- --{ SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY LAND TECH3', 'FACTORY AIR TECH3', 'FACTORY AIR TECH2'}},
                -- { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - Large Map',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 140,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - Rush',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 140,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                -- { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { SBC, 'AIType', {'sorianrush', true }},
                ----CanBuildFirebase { 1000, 1000 }},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - Small Map',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 140,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
                -- { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                -- { SBC, 'AIType', {'sorianrush', true }},
                ----CanBuildFirebase { 1000, 1000 }},
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    }, ]]--
}

-- ================================= --
--     NAVAL FACTORY UPGRADES
-- ================================= --
BuilderGroup {
    BuilderGroupName = 'SorianEditT1NavalUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    -- ================================= --
    --     INITIAL FACTORY UPGRADES
    -- ================================= --
    Builder {
        BuilderName = 'SorianEdit Naval T1 Naval Factory Upgrade Initial',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.NAVAL * categories.RESEARCH - categories.TECH1 } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 6,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 200 } },
            },
        BuilderType = 'Any',
    },
   --[[ -- ================================= --
    --     FACTORY UPGRADES AFTER INITIAL
    -- ================================= --
     Builder {
        BuilderName = 'SorianEdit Naval T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY NAVAL TECH2 RESEARCH'}},
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL' } },
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2} },
            },
        BuilderType = 'Any',
    },]]--
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2NavalUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Naval T2 Sea Factory Upgrade init',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 1,
        BuilderConditions = {
				{ UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
				{ UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.NAVAL * categories.TECH3 * categories.RESEARCH } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
				{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Naval T2 Sea Factory Upgrade',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
				{ EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
				{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
				{ UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2} },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.FACTORY * categories.NAVAL * categories.TECH2} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Naval T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 3,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH'}},
				{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
                -- { EBC, 'GreaterThanEconIncome',  { 20, 10}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT1FastUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Fast T1 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                -- { UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit FastT1AirFactoryUpgrade Expansion',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T1 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.NAVAL * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2FastUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Fast T2 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 900 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T2 Air Factory Upgrade Expansion',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
                -- { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 900 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T2 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.NAVAL * categories.TECH3 * categories.RESEARCH } },
                -- { EBC, 'GreaterThanEconIncome',  { 11, 20}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 500 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
}

-- ============================================ --
--     BALANCED FACTORY UPGRADES EXPANSIONS
-- ============================================ --
BuilderGroup {
    BuilderGroupName = 'SorianEditT1BalancedUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 7,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                -- { UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                -- { UCBC, 'FactoryGreaterAtLocation', { 'MAIN', 2, 'FACTORY TECH3' } },
                -- { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
                -- { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade Expansion',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        FormDebugFunction = nil,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 7,  categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.RESEARCH - categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH1 } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                -- { UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                -- { UCBC, 'FactoryGreaterAtLocation', { 'MAIN', 2, 'FACTORY TECH3' } },
                -- { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BalancedUpgradeBuildersExpansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade Expansion',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.LAND * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                -- { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 900 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade Expansion',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 1,  categories.FACTORY * categories.AIR * categories.TECH3 * categories.RESEARCH } },
                -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                -- { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                -- { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 900 } },
                { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.85, 0.95 }},
            },
        BuilderType = 'Any',
    },
}

 -- Emergency Factory Upgraders, ignore economy if the enemy has higher TECH -- 

BuilderGroup {
    BuilderGroupName = 'SorianEditSupportFactoryUpgrades - Emergency',
    BuildersType = 'PlatoonFormBuilder',
    -- LAND Support Factories
    Builder {
        BuilderName = 'SorianEdit T1 Land Support Factory Upgrade - Emergency',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9501', 'zab9501', 'zrb9501', 'zsb9501', 'znb9501' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH2, FACTORY TECH2', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 1 - Emergency',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade1',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 2 - Emergency',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade2',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 3 - Emergency',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade3',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 4 - Emergency',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade4',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 5 - Emergency',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade5',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    -- AIR Support Factoriesa
    Builder {
        BuilderName = 'SorianEdit T1 Air Support Factory Upgrade - Emergency',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9502', 'zab9502', 'zrb9502', 'zsb9502', 'znb9502' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH2, FACTORY TECH2', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 1 - Emergency',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade1',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 2 - Emergency',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade2',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 3 - Emergency',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade3',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 4 - Emergency',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade4',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 5 - Emergency',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade5',
        Priority = 15000,
        InstanceCount = 2,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3'}},
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 20, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSupportFactoryUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    -- LAND Support Factories
    Builder {
        BuilderName = 'SorianEdit T1 Land Support Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9501', 'zab9501', 'zrb9501', 'zsb9501', 'znb9501' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH1 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 1',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade1',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 2',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade2',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 3',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade3',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 4',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade4',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 5',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade5',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.LAND - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.LAND }},
        },
        BuilderType = 'Any',
    },
    -- AIR Support Factoriesa
    Builder {
        BuilderName = 'SorianEdit T1 Air Support Factory Upgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9502', 'zab9502', 'zrb9502', 'zsb9502', 'znb9502' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.AIR * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH1 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 1',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade1',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 2',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade2',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 3',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade3',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 4',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade4',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 5',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade5',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.AIR - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.AIR }},
        },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSupportFactoryUpgradesNAVY',
    BuildersType = 'PlatoonFormBuilder',
    -- NAVAL Support Factories
    Builder {
        BuilderName = 'SorianEdit T1 Navy Support Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9503', 'zab9503', 'zrb9503', 'zsb9503', 'znb9503' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.NAVAL * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH1 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9503', 'zab9503', 'zrb9503', 'zsb9503', 'znb9503' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * (categories.TECH2 + categories.TECH3) } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
-- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 1',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade1',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 3, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 2',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade2',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 3',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade3',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 4',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade4',
        Priority = 15000,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 5',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade5',
        Priority = 15000,
        InstanceCount = 3,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.22, 0.21 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.MASSEXTRACTION * categories.TECH3 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.NAVAL - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', {1, categories.STRUCTURE * categories.FACTORY * categories.TECH2 * categories.NAVAL }},
        },
        BuilderType = 'Any',
    },
}
	do
	LOG('--------------------- SorianEdit Eco Upgrades Builders loaded')
	end