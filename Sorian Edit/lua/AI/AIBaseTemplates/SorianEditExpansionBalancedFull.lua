#***************************************************************************
#*
#**  File     :  /lua/ai/AIBaseTemplates/SorianEditExpansionBalancedFull.lua
#**
#**  Summary  : Manage engineers for a location
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditExpansionBalancedFull',
    Builders = {
        # ==== ECONOMY ==== #
        # Factory upgrades
        'SorianEditT1BalancedUpgradeBuildersExpansion',
        'SorianEditT2BalancedUpgradeBuildersExpansion',

        # Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstruction',
        'SorianEditEngineerFactoryConstruction Balance',

        # SCU Upgrades
        'SorianEditSCUUpgrades',

        # Build Mass low pri at this base
        'SorianEditEngineerMassBuildersLowerPri',

        # Build some power, but not much
        'SorianEditEngineerEnergyBuildersExpansions',

        # ==== EXPANSION ==== #
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersSmall',

        # ==== DEFENSES ==== #
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

        # ==== NAVAL EXPANSION ==== #
        'SorianEditNavalExpansionBuilders',

        # ==== LAND UNIT BUILDERS ==== #
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

        # ==== AIR UNIT BUILDERS ==== #
        'SorianEditT1AirFactoryBuilders',
        'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditUnitCapAirAttackFormBuilders',
        'SorianEditACUHunterAirFormBuilders',

        #'SorianEditTransportFactoryBuilders',

        'SorianEditExpResponseFormBuilders',

        'SorianEditT1AntiAirBuilders',
        'SorianEditT2AntiAirBuilders',
        'SorianEditT3AntiAirBuilders',
        'SorianEditBaseGuardAirFormBuilders',

        # ===== STRATEGIES ====== #

        'SorianEditParagonStrategyExp',
        'SorianEditWaterMapLowLand',

        # == STRATEGY PLATOONS == #

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        # ==== EXPERIMENTALS ==== #
        'SorianEditMobileLandExperimentalEngineers',
        'SorianEditMobileLandExperimentalForm',

        'SorianEditMobileAirExperimentalEngineers',
        'SorianEditMobileAirExperimentalForm',

        # ==== ARTILLERY BUILDERS ==== #
        'SorianEditT3ArtilleryGroupExp',
    },
    NonCheatBuilders = {
        #'SorianEditAirScoutFactoryBuilders',
        #'SorianEditAirScoutFormBuilders',

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
            Gate = 0, #1,
        },
        MassToFactoryValues = {
            T1Value = 6, #8
            T2Value = 15, #20
            T3Value = 22.5, #27.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)
        if not aiBrain.SorianEdit then
            return -1
        end
        if markerType != 'Start Location' and markerType != 'Expansion Area' then
            return 0
        end

        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if not (personality == 'sorian' or personality == 'sorianadaptive') then
            return 0
        end

        local threatCutoff = 10 # value of overall threat that determines where enemy bases are
        local distance = import('/lua/ai/AIUtilities.lua').GetThreatDistance(aiBrain, location, threatCutoff)
        if not distance or distance > 1000 then
            return 500
        elseif distance > 500 then
            return 750
        elseif distance > 250 then
            return 1000
        else # within 250
            return 250
        end

        return 0
    end,
}
