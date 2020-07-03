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
        'SorianEditSupportFactoryUpgradesNAVY',

        -- Pass engineers to main as needed
        --'Engineer Transfers',

        -- Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerNavalFactoryBuilder',

        -- Mass
        'Sorian Mass Builders', 

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersFulldrop',

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
