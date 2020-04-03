#***************************************************************************
#*
#**  File     :  /mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditNavalExpansionSmall.lua
#**  Author(s): Michael Robbins aka SorianEdit
#**
#**  Summary  : Manage engineers for a location
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditNavalExpansionSmall',
    Builders = {
        # ==== ECONOMY ==== #
        # Factory upgrades
        'SorianEditT1BalancedUpgradeBuilders',
        'SorianEditT2BalancedUpgradeBuilders',

        # Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerNavalFactoryBuilder',

        # Mass
        'SorianEditEngineerMassBuildersLowerPri',

        # ==== EXPANSION ==== #
        'SorianEditEngineerExpansionBuildersFull',

        # ==== DEFENSES ==== #
        'SorianEditT1NavalDefenses',
        'SorianEditT2NavalDefenses',
        'SorianEditT3NavalDefenses',

        # ==== ATTACKS ==== #
        'SorianEditT1SeaFactoryBuilders',
        'SorianEditT2SeaFactoryBuilders',
        'SorianEditT3SeaFactoryBuilders',

        'SorianEditT2SeaStrikeForceBuilders',

        'SorianEditSeaHunterFormBuilders',
        'SorianEditFrequentSeaAttackFormBuilders',
        'SorianEditMassHunterSeaFormBuilders',

        # ===== STRATEGIES ====== #

        'SorianEditParagonStrategyExp',

        # == STRATEGY PLATOONS == #

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        # ==== NAVAL EXPANSION ==== #
        'SorianEditNavalExpansionBuilders',

        # ==== EXPERIMENTALS ==== #
        #'SorianEditMobileNavalExperimentalEngineers',
        #'SorianEditMobileNavalExperimentalForm',
    },
    NonCheatBuilders = {
        'SorianEditSonarEngineerBuilders',
        'SorianEditSonarUpgradeBuildersSmall',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 1,
            Tech2 = 1,
            Tech3 = 1,
            SCU = 0,
        },
        FactoryCount = {
            Land = 0,
            Air = 0,
            Sea = 2,
            Gate = 0,
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
        if markerType != 'Naval Area' then
            return 0
        end

        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if personality == 'sorian' or personality == 'sorianrush' or personality == 'sorianair' or personality == 'sorianturtle' or personality == 'sorianadaptive' then
            return 200
        end

        return 0
    end,
}
