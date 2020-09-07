--***************************************************************************
--*
--**  File     :  /mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditNavalExpansionSmall.lua
--**  Author(s): Michael Robbins aka SorianEdit
--**
--**  Summary  : Manage engineers for a location
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditNavalExpansionLarge',
    Builders = {
        -- ==== ECONOMY ==== --
        -- Factory upgrades
        'SorianEditT1NavalUpgradeBuilders',
        'SorianEditT2NavalUpgradeBuilders',
        'SorianEditT1BalancedUpgradeBuilders',
        'SorianEditT2BalancedUpgradeBuilders',
        --'SorianEditT1FastUpgradeBuildersExpansion',
        --'SorianEditT2FastUpgradeBuildersExpansion',
        --'SorianEditT1RushUpgradeBuilders',
        'SorianEditEmergencyUpgradeBuilders',
        --'SorianEditTime Exempt Extractor Upgrades - Rush',
        'SorianEditSupportFactoryUpgrades',
        'SorianEditSupportFactoryUpgrades - Emergency',
        'SorianEditSupportFactoryUpgradesNAVY',

        -- Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstruction Balance',
		'SorianEditEngineerFactoryConstructionLandHigherPriority',
        'SorianEditEngineerFactoryConstruction',

        -- SCU Upgrades
        'SorianEditSCUUpgrades',
		
        -- Scouts
        'SorianEditAirScoutFactoryBuilders',
        'SorianEditAirScoutFormBuilders',

        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersMain',

        'SorianEditCounterIntelBuilders',

        -- Build Mass high pri at this base
        'Sorianedit Mass Builders', 

        -- Extractors
        'SorianEditTime Exempt Extractor Upgrades',

        -- 'SorianEditT1ACUDefenses',
        'SorianEditT2ACUDefenses',
        'SorianEditT2ACUShields',
        'SorianEditT3ACUShields',
        -- 'SorianEditT3ACUNukeDefenses',
        'SorianEditT3NukeDefensesFormer',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersFulldrop',
        'SorianEditEngineerFirebaseBuilders',

        -- ==== DEFENSES ==== --
        -- 'SorianEditT1BaseDefenses',
        'SorianEditT2BaseDefenses',
        'SorianEditT3BaseDefenses',
        'SorianEditT2BaseDefenses - Emerg',
        'SorianEditT3BaseDefenses - Emerg',
		
        'SorianEditT2PerimeterDefenses',
        'SorianEditT3PerimeterDefenses',

        -- 'SorianEditT1DefensivePoints Turtle',
        'SorianEditT2DefensivePoints Turtle',
        'SorianEditT3DefensivePoints Turtle',
		-- 'SorianEditT1LightDefenses',
		'SorianEditT2LightDefenses',
		'SorianEditT3LightDefenses',
		
		'SorianEditAirStagingExpansion',

        'SorianEditT2ArtilleryFormBuilders',
        'SorianEditT3ArtilleryFormBuilders',
        'SorianEditT4ArtilleryFormBuilders',
        'SorianEditT2MissileDefenses',
        'SorianEditT3NukeDefenses',
        'SorianEditT3NukeDefenseBehaviors',
        'SorianEditMiscDefensesEngineerBuilders',

        'SorianEditMassAdjacencyDefenses',

        -- ==== NAVAL EXPANSION ==== --
        'SorianEditNavalExpansionBuilders',
        'SorianEditNavalExpansionBuildersFast',

        -- ==== LAND UNIT BUILDERS ==== --											 
        'SorianEditT1LandFactoryBuilders',
        'SorianEditT1Land - water map',
        'SorianEditT2LandFactoryBuilders',
        'SorianEditT2LandFactoryBuilders - water map',
        'SorianEditT3LandFactoryBuilders',

        'SorianEditFrequentLandAttackFormBuilders',
        'SorianEditMassHunterLandFormBuilders',
        'SorianEditMiscLandFormBuilders',
        'SorianEditUnitCapLandAttackFormBuilders',

        'SorianEditT1LandAA',
        'SorianEditT2LandAA',
        'SorianEditT3LandAA',

        'SorianEditT1ReactionDF',
        'SorianEditT2ReactionDF',
        'SorianEditT3ReactionDF',

        'SorianEditT2Shields',
        'SorianEditT2ShieldsExpansion',
        'SorianEditShieldUpgrades',
        'SorianEditT3Shields',
        'SorianEditT3ShieldsExpansion',
        'SorianEditEngineeringUpgrades',

        -- ==== AIR UNIT BUILDERS ==== --
        'SorianEditT1AirFactoryBuilders',
        'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditUnitCapAirAttackFormBuilders',
        'SorianEditACUHunterAirFormBuilders',

        'SorianEditTransportFactoryBuilders',
        'SorianEditTransportFactoryBuilders - Rush',
		
        'SorianEditExpResponseFormBuilders',

        'SorianEditT1AntiAirBuilders',
        'SorianEditT2AntiAirBuilders',
        'SorianEditT3AntiAirBuilders',
        'SorianEditBaseGuardAirFormBuilders',

        -- ==== EXPERIMENTALS ==== --
        'SorianEditMobileLandExperimentalEngineers',
        'SorianEditMobileLandExperimentalForm',

        'SorianEditMobileAirExperimentalEngineers',
        'SorianEditMobileAirExperimentalForm',

        'SorianEditMobileNavalExperimentalEngineers',
        'SorianEditMobileNavalExperimentalForm',

        'SorianEditEconomicExperimentalEngineers',
        'SorianEditMobileExperimentalEngineersGroup',
		
        -- ==== DEFENSES ==== --
        'SorianEditT1NavalDefenses',
        'SorianEditT2NavalDefenses',
        'SorianEditT3NavalDefenses',

        -- ==== ATTACKS ==== --
        'SorianEditT1SeaFactoryBuilders',
        'SorianEditT2SeaFactoryBuilders',
        'SorianEditT3SeaFactoryBuilders',

        'SorianEditT2SeaStrikeForceBuilders',

        'SorianEditSeaHunterFormBuilders',
        'SorianEditBigSeaAttackFormBuilders',
        'SorianEditMassHunterSeaFormBuilders',

        -- == STRATEGY PLATOONS == --

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        -- ==== NAVAL EXPANSION ==== --
        'SorianEditNavalExpansionBuildersFast',
        'SorianEditNavalExpansionBuilders',

        -- ==== EXPERIMENTALS ==== --
        'SorianEditMobileNavalExperimentalEngineers',
        'SorianEditMobileNavalExperimentalForm',
		
        -- ==== Intel ==== --
        'SorianEditSonarEngineerBuilders',
        'SorianEditSonarUpgradeBuilders',
    },
    NonCheatBuilders = {},
    BaseSettings = {
        EngineerCount = {
            Tech1 = 13,
            Tech2 = 7,
            Tech3 = 5,
            SCU = 1,
        },
        FactoryCount = {
            Land = 0,
            Air = 0,
            Sea = 4,
            Gate = 0,
        },
        MassToFactoryValues = {
            T1Value = 4, --6
            T2Value = 10, --15
            T3Value = 20, --22.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)

        if markerType ~= 'Naval Area' then
            return -1
        end
		
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if personality == 'sorianeditadaptive' or personality == 'sorianeditadaptivecheat'  then
            return 400, 'sorianeditadaptive'
        end
        return 0
    end,
}
