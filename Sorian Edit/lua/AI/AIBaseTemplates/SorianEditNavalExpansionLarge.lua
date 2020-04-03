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
    BaseTemplateName = 'SorianEditNavalExpansionLarge',
    Builders = {
        # ==== ECONOMY ==== #
        # Factory upgrades
        'SorianEditT1NavalUpgradeBuilders',
        'SorianEditT2NavalUpgradeBuilders',

        # Pass engineers to main as needed
        #'Engineer Transfers',

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
        'SorianEditBigSeaAttackFormBuilders',
        'SorianEditMassHunterSeaFormBuilders',

        # ===== STRATEGIES ====== #

        'SorianEditParagonStrategyExp',

        # == STRATEGY PLATOONS == #

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        # ==== NAVAL EXPANSION ==== #
        'SorianEditNavalExpansionBuildersFast',

        # ==== EXPERIMENTALS ==== #
        #'SorianEditMobileNavalExperimentalEngineers',
        #'SorianEditMobileNavalExperimentalForm',
    },
    NonCheatBuilders = {
        'SorianEditSonarEngineerBuilders',
        'SorianEditSonarUpgradeBuilders',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 3,
            Tech2 = 3,
            Tech3 = 3,
            SCU = 0,
        },
        FactoryCount = {
            Land = 0,
            Air = 0,
            Sea = 2,
            Gate = 0,
        },
        MassToFactoryValues = {
            T1Value = 8, #6
            T2Value = 20, #15
            T3Value = 30, #22.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)
        if not aiBrain.SorianEdit then
            return -1
        end
        if markerType != 'Naval Area' then
            return 0
        end

        local isIsland = false
        local startX, startZ = aiBrain:GetArmyStartPos()
        local islandMarker = import('/lua/AI/AIUtilities.lua').AIGetClosestMarkerLocation(aiBrain, 'Island', startX, startZ)
        if islandMarker then
            isIsland = true
        end

        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        local base = ScenarioInfo.ArmySetup[aiBrain.Name].AIBase

        if personality == 'sorianadaptive' and base == 'SorianEditMainWater' then
            return 250
        end

        if personality == 'sorianwater' then
            return 200
        end

        return 0
    end,
}
