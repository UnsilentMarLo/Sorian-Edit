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

BuilderGroup {
    BuilderGroupName = 'SorianEditTime Exempt Extractor Upgrades Expansion',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Single Expansion',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH2' } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Single Expansion',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple Expansion',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'UnitsGreaterAtLocation', { 'MAIN', 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditTime Exempt Extractor Upgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Storage Based',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 950,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageCurrent', { 600, 0 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH1' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH3' } },

        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Bleed Off',
        PlatoonTemplate = 'T1MassExtractorUpgrade', 
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH1' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH3' } },

        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Single',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 22, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH3' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH1' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Two',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 12, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH1, MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless LOTS',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 3,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 15, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH1, MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
	
	
	
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Storage Based',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 0, --20,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Bleed Off',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome', { 13, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.90, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
	
	

    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 20, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.90, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless - Later',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome', { 13, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple - Later',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 3,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 20, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditTime Exempt Extractor Upgrades - Rush',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Storage Based - Rush',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 960,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageCurrent', { 600, 0 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },

        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T1 Mass Extractor Upgrade Bleed Off - Rush',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 1.0, 0 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2' }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },

        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Single - Rush',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 22, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless Two - Rush',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 2,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 12, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T1 Mass Extractor Upgrade Timeless LOTS - Rush',
        PlatoonTemplate = 'T1MassExtractorUpgrade',
        InstanceCount = 2,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconIncome',  { 15, 0.10}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH2', 'MASSEXTRACTION TECH2' } },
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY TECH2' }},
            --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
	
	
	
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Storage Based - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 0, --20,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Mass Extractor Upgrade Bleed Off - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        InstanceCount = 1,
        Priority = 970,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconStorageRatio', { 1.0, 0 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH2' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome', { 13, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.90, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },

    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 20, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.90, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless - Later - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 4, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome', { 13, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple - Later - Rush',
        PlatoonTemplate = 'T2MassExtractorUpgrade',
        Priority = 970,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2, ENERGYPRODUCTION TECH3' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'MASSEXTRACTION TECH3', 'MASSEXTRACTION TECH2' } },
            { EBC, 'GreaterThanEconIncome',  { 20, 0.50 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1, 1.2 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, 'MASSEXTRACTION TECH3' }},
        },
        FormRadius = 10000,
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
        Priority = 1400,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
				{ EBC, 'GreaterThanEconIncome',  { 10, 50 } },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'MOBILE TECH2, FACTORY TECH2', 'Enemy'}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Emergency T2 Factory Upgrade',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 1600,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.RESEARCH * categories.TECH2 } },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, 'MOBILE TECH3, FACTORY TECH3', 'Enemy'}},
				{ EBC, 'GreaterThanEconIncome',  { 20, 50 } },
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
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 14, 30}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit RushT1AirFactoryUpgradeInitial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 10, 35}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Rush T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY LAND TECH2, FACTORY LAND TECH3'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 10, 35}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit RushT1AirFactoryUpgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR TECH2, FACTORY AIR TECH3'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 15, 35}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Rush T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH, FACTORY NAVAL TECH3 RESEARCH'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 15, 35}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
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
        Priority = 1300,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 34, 50}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgradeInitial',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 120,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 3, 'FACTORY TECH2, FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 35, 75}},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 1300,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY LAND TECH2, FACTORY LAND TECH3'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 40, 75}},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 120,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR TECH2, FACTORY AIR TECH3'}},
                ----{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 35, 75}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 120,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH, FACTORY NAVAL TECH3 RESEARCH'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 15, 25}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2BalancedUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Land Factory Upgrade - T3',
        PlatoonTemplate = 'T1LandFactoryUpgrade',
        Priority = 1000,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH3'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade - T3',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 1000,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'MASSEXTRACTION TECH3'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - initial',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
                --{ SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - initial',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { IBC, 'BrainNotLowPowerMode', {} },
                --{ SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - Large Map',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                --{ SIBC, 'FactoryRatioLessOrEqual', { 'LocationType', 1.0, 'FACTORY LAND TECH3', 'FACTORY AIR TECH3', 'FACTORY AIR TECH2'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                --{ SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - Large Map',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                --{ SBC, 'AIType', {'sorianrush', false }},
                ----CanBuildFirebase { 1000, 1000 }},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Land Factory Upgrade - Rush',
        PlatoonTemplate = 'T2LandFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'FACTORY TECH3, FACTORY TECH2'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                --{ SBC, 'AIType', {'sorianrush', true }},
                ----CanBuildFirebase { 1000, 1000 }},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade - Small Map',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 140,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                --{ SBC, 'AIType', {'sorianrush', true }},
                ----CanBuildFirebase { 1000, 1000 }},
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Sea Factory Upgrade',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 1400,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 14, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
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
        Priority = 1400,
        InstanceCount = 3,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH'}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { EBC, 'GreaterThanEconIncome',  { 0.5, 7.5}},
            },
        BuilderType = 'Any',
    },
    -- ================================= --
    --     FACTORY UPGRADES AFTER INITIAL
    -- ================================= --
    Builder {
        BuilderName = 'SorianEdit Naval T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 1200,
        InstanceCount = 3,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL' } },
                { EBC, 'GreaterThanEconIncome',  { 0.8, 7.5}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 400 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2} },
            },
        BuilderType = 'Any',
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2NavalUpgradeBuilders',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit Naval T2 Sea Factory Upgrade init',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 1520,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH3 RESEARCH'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'} },
                { EBC, 'GreaterThanEconIncome',  { 20, 10}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Naval T2 Sea Factory Upgrade',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 1520,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH3 RESEARCH'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'} },
                { EBC, 'GreaterThanEconIncome',  { 20, 10}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Naval T1 Sea Factory Upgrade',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 3,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH'}},
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'MASSEXTRACTION TECH3'} },
                { EBC, 'GreaterThanEconIncome',  { 20, 10}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { IBC, 'BrainNotLowPowerMode', {} },
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
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                --{ UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2} },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit FastT1AirFactoryUpgrade Expansion',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T1 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH, FACTORY NAVAL TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                { EBC, 'GreaterThanEconIncome',  { 12, 6.0}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.2} },
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
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T2 Air Factory Upgrade Expansion',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Fast T2 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH3 RESEARCH'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 20}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2 }},
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
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH2 RESEARCH, FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH1 } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                --{ UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                --{ UCBC, 'FactoryGreaterAtLocation', { 'MAIN', 2, 'FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
                { IBC, 'BrainNotLowPowerMode', {} },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit BalancedT1AirFactoryUpgrade Expansion',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        FormDebugFunction = nil,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH2 RESEARCH, FACTORY AIR TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH1 } },
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, 'MASSEXTRACTION TECH2'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH3'}},
                --{ UCBC, 'FactoryLessAtLocation', { 'MAIN', 1, 'FACTORY TECH1' } },
                --{ UCBC, 'FactoryGreaterAtLocation', { 'MAIN', 2, 'FACTORY TECH3' } },
                { EBC, 'GreaterThanEconIncome',  { 12, 5.0}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T1 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T1SeaFactoryUpgrade',
        Priority = 1100,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH2 RESEARCH, FACTORY NAVAL TECH3 RESEARCH'}},
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH1 } },
                --{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, 'NAVAL FACTORY' } },
                { EBC, 'GreaterThanEconIncome',  { 12, 6.0}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 300 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 } },
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
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.LAND * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY LAND TECH3 RESEARCH'}},
                { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 7, 'MOBILE LAND'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Air Factory Upgrade Expansion',
        PlatoonTemplate = 'T2AirFactoryUpgrade',
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.FACTORY * categories.AIR * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY AIR TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 1.80}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
            },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit Balanced T2 Sea Factory Upgrade Expansion',
        PlatoonTemplate = 'T2SeaFactoryUpgrade',
        Priority = 1201,
        InstanceCount = 2,
        BuilderConditions = {
                { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.FACTORY * categories.NAVAL * categories.TECH2 * categories.RESEARCH } },
                { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'FACTORY NAVAL TECH3 RESEARCH'}},
                --{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'MASSEXTRACTION TECH3'}},
                { EBC, 'GreaterThanEconIncome',  { 11, 2.50}},
                { IBC, 'BrainNotLowPowerMode', {} },
				{ UCBC, 'GreaterThanGameTimeSeconds', { 800 } },
                { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.25 }},
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
        Priority = 750,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9501', 'zab9501', 'zrb9501', 'zsb9501', 'znb9501' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH1 }},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 1',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade1',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            -- Have we the eco to build it ?
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 2',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade2',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 3',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade3',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 4',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade4',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.SUPPORTFACTORY * categories.LAND * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Land Support Factory Upgrade 5',
        PlatoonTemplate = 'T2LandSupFactoryUpgrade5',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9601', 'zab9601', 'zrb9601', 'zsb9601', 'znb9601' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.LAND * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.LAND - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    -- AIR Support Factories
    Builder {
        BuilderName = 'SorianEdit T1 Air Support Factory Upgrade',
        PlatoonTemplate = 'T1AirFactoryUpgrade',
        Priority = 750,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9502', 'zab9502', 'zrb9502', 'zsb9502', 'znb9502' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.AIR * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH1 }},
        },
        BuilderType = 'Any',
    },
    -- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 1',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade1',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 2',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade2',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 3',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade3',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 4',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade4',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.AIR * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Air Support Factory Upgrade 5',
        PlatoonTemplate = 'T2AirSupFactoryUpgrade5',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9602', 'zab9602', 'zrb9602', 'zsb9602', 'znb9602' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.65 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.AIR * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.AIR - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
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
        Priority = 950,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9503', 'zab9503', 'zrb9503', 'zsb9503', 'znb9503' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.NAVAL * ( categories.TECH2 + categories.TECH3 ) - categories.SUPPORTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 4, categories.STRUCTURE * categories.FACTORY * categories.TECH1 }},
        },
        BuilderType = 'Any',
    },
-- Builder for 5 factions
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 1',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade1',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.UEF * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 3, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 2',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade2',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.AEON * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 3',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade3',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.CYBRAN * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 4',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade4',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SERAPHIM * categories.NAVAL * categories.SUPPORTFACTORY * categories.TECH2 }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SorianEdit T2 Navy Support Factory Upgrade 5',
        PlatoonTemplate = 'T2SeaSupFactoryUpgrade5',
        Priority = 900,
        InstanceCount = 4,
        BuilderData = {
            OverideUpgradeBlueprint = { 'zeb9603', 'zab9603', 'zrb9603', 'zsb9603', 'znb9603' }, -- overides Upgrade blueprint for all 5 factions. Used for support factories
        },
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.20, 0.50 } },
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.SUPPORTFACTORY - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.SUPPORTFACTORY * categories.TECH2 * categories.NAVAL - categories.SERAPHIM - categories.CYBRAN - categories.AEON - categories.UEF }},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 2, categories.STRUCTURE * categories.FACTORY * categories.TECH2 }},
        },
        BuilderType = 'Any',
    },
}