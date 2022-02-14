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
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 12000,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 10.0, 45.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.35, 0.6 } },
            -- { SIBC, 'LessThanNavalBases', {} },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 256, -1000, 20000, 1, 'AntiSurface' } },
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
					'T1Sonar',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T1 Naval Builder Fast',
        PlatoonTemplate = 'EngineerBuilderSorianEditTECH1',
        Priority = 922,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 10.0, 45.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.35, 0.6 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { SIBC, 'LessThanNavalBases', {} },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 256, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY NAVAL'}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.NAVAL } },
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
					'T1NavalDefense',
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
            { EBC, 'GreaterThanEconIncome',  { 10.0, 45.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.35, 0.6 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { SIBC, 'LessThanNavalBases', {} },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 256, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL - categories.TECH1 - categories.COMMAND } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.NAVAL - categories.TECH1 - categories.COMMAND } },
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
            { EBC, 'GreaterThanEconIncome',  { 10.0, 45.0}},
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconStorageRatio', { 0.35, 0.6 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0 }},
            -- { SIBC, 'LessThanNavalBases', {} },
            { UCBC, 'NavalAreaNeedsEngineer', { 'LocationType', 256, -1000, 20000, 1, 'AntiSurface' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.COMMAND } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.NAVAL * categories.TECH3 - categories.COMMAND } },
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
					'T2NavalDefense',
					'T3AADefense',
					'T2Sonar',
                }
            }
        }
    },
}

	do
	LOG('--------------------- SorianEdit Naval Builders loaded')
	end
