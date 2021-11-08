--***************************************************************************
--*
--**  File     :  /mods/Sorian Edit/lua/ai/SorianEditExperimentalBuilders.lua
--**
--**  Summary  : Default experimental builders for skirmish
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
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local PlatoonFile = '/lua/platoon.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'

local SUtils = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')

local AIAddBuilderTable = import('/lua/ai/AIAddBuilderTable.lua')
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Experimental Builders loading')
	end
	
function T4LandAttackCondition(aiBrain, locationType, targetNumber)
    local UC = import('/lua/editor/UnitCountBuildConditions.lua')
    local SInBC = import('/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua')
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        return true
    end
    if aiBrain:GetCurrentEnemy() then
        local estartX, estartZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
        local enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
        --local enemyTML = aiBrain:GetNumUnitsAroundPoint(categories.TECH2 * categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE, {estartX, 0, estartZ}, 100, 'Enemy')
        local enemyT3PD = aiBrain:GetNumUnitsAroundPoint(categories.TECH3 * categories.DEFENSE * categories.DIRECTFIRE, {estartX, 0, estartZ}, 100, 'Enemy')
        --targetNumber = aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'AntiSurface')
        targetNumber = SUtils.GetThreatAtPosition(aiBrain, {estartX, 0, estartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex)
        targetNumber = targetNumber + (enemyT3PD * 54)-- + (enemyTML * 54)
    end

    local position = engineerManager:GetLocationCoords()
    local radius = engineerManager.Radius

    --local surThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.LAND * categories.EXPERIMENTAL, position, radius * 2.5)
    local surThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.LAND * categories.EXPERIMENTAL)
    if surThreat >= targetNumber * .6 then
        return true
    --elseif UC.UnitCapCheckGreater(aiBrain, .99) then
    --	return true
    elseif SUtils.ThreatBugcheck(aiBrain) then -- added to combat buggy inflated threat
        return true
    elseif SInBC.PoolGreaterAtLocationExp(aiBrain, locationType, 4, categories.MOBILE * categories.LAND * categories.EXPERIMENTAL) then
        return true
    end
    return false
end

function T4AirAttackCondition(aiBrain, locationType, targetNumber)
    local UC = import('/lua/editor/UnitCountBuildConditions.lua')
    local SInBC = import('/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua')
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        return true
    end
    if aiBrain:GetCurrentEnemy() then
        local estartX, estartZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
        local enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
        targetNumber = SUtils.GetThreatAtPosition(aiBrain, {estartX, 0, estartZ}, 1, 'AntiAir', {'Air'}, enemyIndex)
        --targetNumber = aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'AntiAir')
    end

    local position = engineerManager:GetLocationCoords()
    local radius = engineerManager.Radius

    local surThreat = pool:GetPlatoonThreat('AntiSurface', categories.MOBILE * categories.AIR * categories.EXPERIMENTAL, position, radius * 2.5)
    if surThreat > targetNumber * .6 then
        return true
    --elseif UC.UnitCapCheckGreater(aiBrain, .99) then
    --	return true
    elseif SUtils.ThreatBugcheck(aiBrain) then -- added to combat buggy inflated threat
        return true
    elseif SInBC.PoolGreaterAtLocationExp(aiBrain, locationType, 4, categories.MOBILE * categories.AIR * categories.EXPERIMENTAL) then
        return true
    end
    return false
end

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileExperimentalEngineersGroup',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer 1 Group',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 3200,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRATEGIC * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1 Group',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRATEGIC * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
	
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer 1 Group2',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2500,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1 Group2',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileLandExperimentalEngineers',
    BuildersType = 'EngineerBuilder',
    --Land T4 builders for 20x20 and larger maps
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp1 Engineer 1 - Large Map',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2200,
        InstanceCount = 3,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRATEGIC * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE LAND EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp2 Engineer 1 - Large Map',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        InstanceCount = 3,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRATEGIC * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE LAND EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental2',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Land Exp3 Engineer 1 - Large Map',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        InstanceCount = 3,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRATEGIC * categories.TECH3 * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE LAND EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --BaseTemplate = ExBaseTmpl,
                --NearMarkerType = 'Rally Point',
                BuildStructures = {
                    'T4LandExperimental3',
                },
                Location = 'LocationType',
            }
        }
    },
	
	
	
	
	
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Experimental Mobile Land',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 45,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.LAND * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE LAND'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Mobile Land',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 951,
        InstanceCount = 30,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.LAND * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE LAND'},
                Time = 60,
            },
        }
    },
}




BuilderGroup {
    BuilderGroupName = 'SorianEditMobileLandExperimentalForm',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Exp Land',
        PlatoonAddPlans = {'NameUnitsSorian'},
        PlatoonTemplate = 'T4ExperimentalLandSorianEdit',
        Priority = 10000,
        FormRadius = 750,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderConditions = {
            -- { SIBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'EXPERIMENTAL MOBILE LAND, EXPERIMENTAL MOBILE AIR'}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2000, 'FACTORY TECH1, FACTORY TECH2' } },
            -- { T4LandAttackCondition, { 'LocationType', 250 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.TECH1 - categories.NAVAL - categories.HOVER - categories.AMPHIBIOUS - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.MOBILE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.MOBILE * categories.LAND * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
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
        BuilderName = 'SorianEdit T4 Exp Land Bot',
        PlatoonAddPlans = {'NameUnitsSorian'},
        PlatoonTemplate = 'T4ExperimentalLandSorianEditBot',
        Priority = 10000,
        FormRadius = 750,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderConditions = {
            -- { SIBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'EXPERIMENTAL MOBILE LAND, EXPERIMENTAL MOBILE AIR'}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2000, 'FACTORY TECH1, FACTORY TECH2' } },
            -- { T4LandAttackCondition, { 'LocationType', 250 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = false,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.TECH1 - categories.NAVAL - categories.HOVER - categories.AMPHIBIOUS - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.MOBILE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.MOBILE * categories.LAND * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
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
        BuilderName = 'SorianEdit T4 Exp Land - Scathis',
        PlatoonAddPlans = {'NameUnitsSorian'},
        PlatoonTemplate = 'T4ExperimentalScathisSorian',
        Priority = 10000,
        FormRadius = 45000,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderConditions = {
            -- { SIBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'EXPERIMENTAL MOBILE LAND, EXPERIMENTAL MOBILE AIR'}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2000, 'FACTORY TECH1, FACTORY TECH2' } },
            ---- { T4LandAttackCondition, { 'LocationType', 250 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.TECH1 - categories.NAVAL - categories.HOVER - categories.AMPHIBIOUS - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.MOBILE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.MOBILE * categories.LAND * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.TECH3,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T4 Exp Land Unit Cap',
        PlatoonAddPlans = {'NameUnitsSorian'},
        PlatoonTemplate = 'T4ExperimentalLandSorianEdit',
        Priority = 10000,
        FormRadius = 45000,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderConditions = {
            -- { SIBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 3, 'EXPERIMENTAL MOBILE LAND, EXPERIMENTAL MOBILE AIR'}},
            -- { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2000, 'FACTORY TECH1, FACTORY TECH2' } },
            -- { UCBC, 'UnitCapCheckGreater', { .95 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.COMMAND, -- categories.MOBILE * categories.LAND - categories.TECH1 - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.MOBILE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.MOBILE * categories.LAND * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.COMMAND,
                categories.EXPERIMENTAL,
                categories.DEFENSE,
                categories.TECH3,
                categories.INDIRECTFIRE,
                categories.ECONOMIC,
                categories.DIRECTFIRE,
                categories.MOBILE,
                categories.ANTIAIR,
            },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileAirExperimentalEngineers',
    BuildersType = 'EngineerBuilder',
    --Air T4 builders for 20x20 and larger maps
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    --Air T4 builders for 10x10 and smaller maps
    Builder {
        BuilderName = 'SorianEdit T3 Air Exp1 Engineer 1 - Small Map',
        PlatoonTemplate = 'T3EngineerBuilderSorianEdit',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --NearMarkerType = 'Protected Experimental Construction',
                BuildStructures = {
                    'T4AirExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Experimental Mobile Air',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 25,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.AIR * categories.MOBILE}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE AIR'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Mobile Air',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 951,
        InstanceCount = 35,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.AIR * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistUntilFinished = true,
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE AIR'},
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileAirExperimentalForm',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Exp Air',
        PlatoonTemplate = 'T4ExperimentalAirSorianEdit',
        PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 800,
        InstanceCount = 10,
        BuilderType = 'Any',
        FormRadius = 10000,
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.TECH1 - categories.NAVAL - categories.HOVER - categories.AMPHIBIOUS - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL,
                categories.NUKE,
                categories.COMMAND,
                categories.ECONOMIC,
                categories.FACTORY,
                categories.TECH3 * categories.LAND,
                categories.TECH3,
                categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
        },
    },
    Builder {
        BuilderName = 'SorianEdit T4 Exp Air Unit Cap',
        PlatoonTemplate = 'T4ExperimentalAirSorianEdit',
        PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 800,
        InstanceCount = 3,
        BuilderType = 'Any',
        FormRadius = 10000,
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * categories.LAND - categories.TECH1 - categories.NAVAL - categories.HOVER - categories.AMPHIBIOUS - categories.ANTIAIR - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
            WeaponTargetCategories = {
                categories.EXPERIMENTAL,
                categories.NUKE,
                categories.COMMAND,
                categories.ECONOMIC,
                categories.FACTORY,
                categories.TECH3 * categories.LAND,
                categories.TECH3,
                categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
            },
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileNavalExperimentalEngineers',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Sea Exp1 Engineer',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 2,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                --NearMarkerType = 'Naval Area',
                BuildStructures = {
                    'T4SeaExperimental1',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Experimental Mobile Naval',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 799,
        InstanceCount = 15,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.NAVAL * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE NAVAL'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Mobile Naval',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 849,
        InstanceCount = 15,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.NAVAL * categories.MOBILE}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL MOBILE NAVAL'},
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditMobileNavalExperimentalForm',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Exp Sea',
        PlatoonTemplate = 'T4ExperimentalSeaSorianEdit',
        --PlatoonAddBehaviors = { 'TempestBehaviorSorianEdit' },
        PlatoonAddPlans = {'NameUnitsSorian'},
        --PlatoonAIPlan = 'AttackForceAI',
        Priority = 2100,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        FormRadius = 45000,
        InstanceCount = 10,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 100000,
            GetTargetsFromBase = false,
            RequireTransport = false,
            AggressiveMove = true,
            AttackEnemyStrength = 120000,
            IgnorePathing = true,
            TargetSearchCategory = categories.MOBILE * (categories.NAVAL + categories.NAVAL) - categories.TECH1 - categories.SCOUT,
            MoveToCategories = {
                categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC,
                categories.STRUCTURE * categories.NAVAL,
                categories.MOBILE * categories.EXPERIMENTAL,
                categories.STRUCTURE * categories.NUKE,
                categories.COMMAND,
                categories.STRUCTURE * categories.FACTORY * categories.TECH3,
                categories.MOBILE * categories.NAVAL * categories.TECH3,
                categories.STRUCTURE * categories.ENERGYPRODUCTION * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
                categories.STRUCTURE * categories.DEFENSE * categories.TECH2,
                categories.STRUCTURE * categories.DEFENSE,
                categories.STRUCTURE,
                categories.ALLUNITS,
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
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSatelliteExperimentalEngineers',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 Satellite Exp Engineer',
        PlatoonTemplate = 'UEFT3EngineerBuilderSorianEdit',
        Priority = 2100,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.EXPERIMENTAL}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T4SatelliteExperimental',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Experimental Satellite',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 5,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.ORBITALSYSTEM }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'EXPERIMENTAL ORBITALSYSTEM'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Satellite',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 951,
        InstanceCount = 5,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.ORBITALSYSTEM }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'EXPERIMENTAL ORBITALSYSTEM'},
                Time = 60,
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSatelliteExperimentalForm',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SorianEdit T4 Exp Satellite',
        PlatoonTemplate = 'T4SatelliteExperimentalSorianEdit',
        PlatoonAddPlans = {'NameUnitsSorian'},
        Priority = 800,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 0 }},
        },
        FormRadius = 45000,
        InstanceCount = 3,
        BuilderType = 'Any',
        BuilderData = {
            SearchRadius = 100000,
            PrioritizedCategories = { 'STRUCTURE STRATEGIC EXPERIMENTAL', 'EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE', 'STRUCTURE STRATEGIC TECH3', 'STRUCTURE NUKE TECH3', 'EXPERIMENTAL ORBITALSYSTEM', 'EXPERIMENTAL ENERGYPRODUCTION STRUCTURE', 'STRUCTURE ANTIMISSILE TECH3', 'TECH3 MASSFABRICATION', 'TECH3 ENERGYPRODUCTION', 'STRUCTURE STRATEGIC', 'STRUCTURE DEFENSE TECH3 ANTIAIR', 'COMMAND', 'STRUCTURE DEFENSE TECH3 DIRECTFIRE', 'STRUCTURE DEFENSE TECH3 SHIELD', 'STRUCTURE DEFENSE TECH2', 'STRUCTURE' }, -- list in order
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEconomicExperimentalEngineers',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SorianEdit Econ Exper Engineer',
        PlatoonTemplate = 'AeonT3EngineerBuilder',
        Priority = 2100,
        InstanceCount = 1,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'SEExperimental' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'MOBILE EXPERIMENTAL' }},
        },
        BuilderType = 'Any',
        BuilderData = {
            --MinNumAssistees = 3,
			NumAssistees = 25,
            Construction = {
                DesiresAssist = true,
                BuildClose = true,
                --T4 = true,
                AdjacencyCategory = 'SHIELD STRUCTURE',
                BuildStructures = {
                    'T4EconExperimental',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Engineer Assist Experimental Economic',
        PlatoonTemplate = 'T2EngineerAssistSorianEdit',
        Priority = 800,
        InstanceCount = 25,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.ECONOMIC}},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL ECONOMIC'},
                Time = 60,
            },
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Engineer Assist Experimental Economic',
        PlatoonTemplate = 'T3EngineerAssistSorianEdit',
        Priority = 951,
        InstanceCount = 25,
        DelayEqualBuildPlatoons = {'SEExperimental', 10},
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.4, 0.8 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 0.8 }},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.EXPERIMENTAL * categories.ECONOMIC }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 250,
                BeingBuiltCategories = {'EXPERIMENTAL ECONOMIC'},
                Time = 60,
            },
        }
    },
}
	do
	LOG('--------------------- SorianEdit Experimental Builders loaded')
	end
