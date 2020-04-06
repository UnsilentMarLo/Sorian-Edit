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

        -- Pass engineers to main as needed
        --'Engineer Transfers',

        -- Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerNavalFactoryBuilder',

        -- Mass
        'SorianEditEngineerMassBuildersLowerPri',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',

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

        -- ===== STRATEGIES ====== --



        -- == STRATEGY PLATOONS == --

        'SorianEditBalancedUpgradeBuildersExpansionStrategy',

        -- ==== NAVAL EXPANSION ==== --
        'SorianEditNavalExpansionBuildersFast',
        'SorianEditNavalExpansionBuilders',

        -- ==== EXPERIMENTALS ==== --
        --'SorianEditMobileNavalExperimentalEngineers',
        --'SorianEditMobileNavalExperimentalForm',
    },
    NonCheatBuilders = {
        'SorianEditSonarEngineerBuilders',
        'SorianEditSonarUpgradeBuilders',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 15,
            Tech2 = 9,
            Tech3 = 6,
            SCU = 0,
        },
        FactoryCount = {
            Land = 0,
            Air = 0,
            Sea = 3,
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
            return 200, 'sorianeditadaptive'
        end
        return 0
    end,
}
