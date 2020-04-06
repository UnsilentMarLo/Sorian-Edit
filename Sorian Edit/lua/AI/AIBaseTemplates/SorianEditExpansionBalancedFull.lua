--***************************************************************************
--*
--**  File     :  /lua/ai/aiattackutilities.lua
--**
--**  Summary  : Manage engineers for a location
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditExpansionBalancedFull',
    Builders = {
        -- ==== ECONOMY ==== --
        -- Factory upgrades
        'SorianEditT1BalancedUpgradeBuildersExpansion',
        'SorianEditT2BalancedUpgradeBuildersExpansion',

        -- Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstruction',
        'SorianEditEngineerFactoryConstruction Balance',

        -- SCU Upgrades
        'SorianEditSCUUpgrades',

        -- Build Mass low pri at this base
        'SorianEditEngineerMassBuildersLowerPri',

        -- Build some power, but not much
        'SorianEditEngineerEnergyBuildersExpansions',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersSmall',

        -- ==== DEFENSES ==== --
        'SorianEditT1LightDefenses',
        'SorianEditT2LightDefenses',
        'SorianEditT3LightDefenses',

        'SorianEditT2ArtilleryFormBuilders',
        'SorianEditT3ArtilleryFormBuilders',
        'SorianEditT4ArtilleryFormBuilders',
        'SorianEditT3NukeDefensesExp',
        'SorianEditT3NukeDefenseBehaviors',
        'SorianEditT2ShieldsExpansion',
        'SorianEditShieldUpgrades',
        'SorianEditAirStagingExpansion',
        'SorianEditT3ShieldsExpansion',
        'SorianEditT2MissileDefenses',

        'SorianEditMassAdjacencyDefenses',

        -- ==== NAVAL EXPANSION ==== --
        'SorianEditNavalExpansionBuilders',

        -- ==== LAND UNIT BUILDERS ==== --
        'SorianEditT1LandFactoryBuilders',
        'SorianEditT2LandFactoryBuilders',
        'SorianEditT3LandFactoryBuilders',
        'SorianEditFrequentLandAttackFormBuilders',
        'SorianEditMassHunterLandFormBuilders',
        'SorianEditMiscLandFormBuilders',
        'SorianEditUnitCapLandAttackFormBuilders',

        'SorianEditT1ReactionDF',
        'SorianEditT2ReactionDF',
        'SorianEditT3ReactionDF',

        -- ==== AIR UNIT BUILDERS ==== --
        'SorianEditT1AirFactoryBuilders',
        'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditUnitCapAirAttackFormBuilders',
        'SorianEditACUHunterAirFormBuilders',

        --'SorianEditTransportFactoryBuilders',

        'SorianEditExpResponseFormBuilders',

        'SorianEditT1AntiAirBuilders',
        'SorianEditT2AntiAirBuilders',
        'SorianEditT3AntiAirBuilders',
        'SorianEditBaseGuardAirFormBuilders',

        -- ===== STRATEGIES ====== --



        -- == STRATEGY PLATOONS == --

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        -- ==== EXPERIMENTALS ==== --
        'SorianEditMobileLandExperimentalEngineers',
        'SorianEditMobileLandExperimentalForm',

        'SorianEditMobileAirExperimentalEngineers',
        'SorianEditMobileAirExperimentalForm',

        -- ==== ARTILLERY BUILDERS ==== --
        'SorianEditT3ArtilleryGroupExp',
    },
    NonCheatBuilders = {
        --'SorianEditAirScoutFactoryBuilders',
        --'SorianEditAirScoutFormBuilders',

        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersExpansion',

        'SorianEditCounterIntelBuilders',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 10,
            Tech2 = 15,
            Tech3 = 20,
            SCU = 2,
        },
        FactoryCount = {
            Land = 3,
            Air = 1,
            Sea = 0,
            Gate = 0, --1,
        },
        MassToFactoryValues = {
            T1Value = 6, --8
            T2Value = 15, --20
            T3Value = 22.5, --27.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)
	
        if markerType ~= 'Large Expansion Area' then
            return -1
        end

        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if personality == 'sorianeditadaptive' or personality == 'sorianeditadaptivecheat'  then
            return 250, 'sorianedit'
        end

        return 0
    end,
}
