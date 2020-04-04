--***************************************************************************
--*
--**  File     :  /mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditExpansionBalancedSmall.lua
--**  Author(s): Michael Robbins aka SorianEdit
--**
--**  Summary  : Manage engineers for a location
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditExpansionBalancedSmall',
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
        'SorianEditLandInitialFactoryConstruction',

        -- SCU Upgrades
        'SorianEditSCUUpgrades',

        -- Extractor building
        'SorianEditEngineerMassBuildersLowerPri - Rush',

        -- Build some power, but not much
        'SorianEditEngineerEnergyBuildersExpansions',

        -- ==== DEFENSES ==== --
        'SorianEditT1LightDefenses',
        'SorianEditT2LightDefenses',
        'SorianEditT3LightDefenses',

        'SorianEditT2ArtilleryFormBuilders',
        --'SorianEditT3ArtilleryFormBuilders',
        --'SorianEditT4ArtilleryFormBuilders',
        'SorianEditAirStagingExpansion',
        'SorianEditT2MissileDefenses',

        'SorianEditMassAdjacencyDefenses',

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

        if markerType ~= 'Start Location' then
            return -1
        end

        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if personality == 'sorianeditadaptive' or personality == 'sorianeditadaptivecheat'  then
            return 250, 'sorianedit'
        end

        return 0
    end,
}
