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
        'SorianEditSupportFactoryUpgrades',
		'SorianEditSupportFactoryUpgrades - Emergency',
        'SorianEditSupportFactoryUpgradesNAVY',

        -- Engineer Builders
        'SorianEditEngineerNavalFactoryBuilders',
        'SorianEditEngineerFactoryBuildersExpansion rush',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerNavalFactoryBuilder',

        -- -- Build Mass high pri at this base
        -- 'Sorianedit Mass Builders', 

        -- -- Extractors
        -- 'SorianEditTime Exempt Extractor Upgrades',

        -- 'SorianEditT3ACUNukeDefenses',
        'SorianEditT3NukeDefensesFormer',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersFulldrop',
        'SorianEditEngineerFirebaseBuilders',

        -- ==== EXPERIMENTALS ==== --
		
        'SorianEditMobileAirExperimentalEngineers',
        'SorianEditMobileAirExperimentalForm',

        'SorianEditMobileNavalExperimentalEngineers',
        'SorianEditMobileNavalExperimentalForm',
		
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
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if markerType == 'Naval Area' or 'Large Naval Area' and personality == 'sorianeditadaptivecheat' or personality == 'sorianeditadaptive' or personality == 'sorianedit' then
            LOG('--------------------- M-ExpansionFunction Naval Base '..personality)
            return 15000, 'sorianedit'
        else
            return -1
        end
    end,
}
