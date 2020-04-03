#***************************************************************************
#*
#**  File     :  /lua/ai/AIBaseTemplates/SorianEditExpansionBalancedSmall.lua
#**  Author(s): Michael Robbins aka SorianEdit
#**
#**  Summary  : Manage engineers for a location
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditExpansionBalancedSmall',
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
        'SorianEditLandInitialFactoryConstruction',

        # SCU Upgrades
        'SorianEditSCUUpgrades',

        # Extractor building
        'SorianEditEngineerMassBuildersLowerPri - Rush',

        # Build some power, but not much
        'SorianEditEngineerEnergyBuildersExpansions',

        # ==== DEFENSES ==== #
        'SorianEditT1LightDefenses',
        'SorianEditT2LightDefenses',
        'SorianEditT3LightDefenses',

        'SorianEditT2ArtilleryFormBuilders',
        #'SorianEditT3ArtilleryFormBuilders',
        #'SorianEditT4ArtilleryFormBuilders',
        'SorianEditAirStagingExpansion',
        'SorianEditT2MissileDefenses',

        'SorianEditMassAdjacencyDefenses',

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
    },
    NonCheatBuilders = {
        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersExpansion',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 15,
            Tech2 = 10,
            Tech3 = 10,
            SCU = 1,
        },

        FactoryCount = {
            Land = 4,
            Air = 1,
            Sea = 0,
            Gate = 0,
        },

        MassToFactoryValues = {
            T1Value = 6,
            T2Value = 15,
            T3Value = 22.5,
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
        if not (personality == 'sorianrush' or personality == 'sorianadaptive') then
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
