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
        'SorianEditT1BalancedUpgradeBuilders',
        'SorianEditT2BalancedUpgradeBuilders',
        --'SorianEditT1FastUpgradeBuildersExpansion',
        --'SorianEditT2FastUpgradeBuildersExpansion',
        --'SorianEditT1RushUpgradeBuilders',
        --'SorianEditEmergencyUpgradeBuilders',
        'SorianEditSupportFactoryUpgrades',
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

        -- Engineer Support buildings
        -- 'SorianEditEngineeringSupportBuilder',

        -- Build energy at this base
        'SorianEditEngineerEnergyBuilders',

        -- Build Mass high pri at this base
        'Sorian Mass Builders', 

        -- Extractors
        'SorianEditTime Exempt Extractor Upgrades',
        -- ACU Builders
        'SorianEdit Initial ACU Builders',
        'SorianEditACUBuilders',
        'SorianEditACUUpgrades',

        -- ACU Defense
        'SorianEditT1ACUDefenses',
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
        'SorianEditT1BaseDefenses',
        'SorianEditT2BaseDefenses',
        'SorianEditT3BaseDefenses',
        'SorianEditT2BaseDefenses - Emerg',
        'SorianEditT3BaseDefenses - Emerg',
		
        'SorianEditT2PerimeterDefenses',
        'SorianEditT3PerimeterDefenses',

        'SorianEditT1DefensivePoints Turtle',
        'SorianEditT2DefensivePoints Turtle',
        'SorianEditT3DefensivePoints Turtle',

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
        'SorianEditShieldUpgrades',
        'SorianEditT3Shields',
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

        -- ==== ARTILLERY BUILDERS ==== --
        'SorianEditT3ArtilleryGroup',

        'SorianEditExperimentalArtillery',

        'SorianEditNukeBuildersEngineerBuilders',
        'SorianEditNukeFormBuilders',

        'SorianEditSatelliteExperimentalEngineers',
        'SorianEditSatelliteExperimentalForm',

   -- ======== Strategies ======== --
        'SorianEditHeavyAirStrategy',
        'SorianEditBigAirGroup',
        'SorianEditJesterRush',
        'SorianEditNukeRush',
        'SorianEditT3FBRush',
        'SorianEditT2ACUSnipe',
        -- 'SorianEditParagonStrategy',
        -- 'SorianEditParagonStrategyExp',
        'SorianEdit Tele SCU Strategy',
        -- 'SorianEditWaterMapLowLand',
        'SorianEdit PD Creep Strategy',
        'SorianEditStopNukes',
        'SorianEditEnemyTurtle - In Range',
        'SorianEditEnemyTurtle - Out of Range',
        'SorianEdit Excess Mass Strategy', 

        -- ===== Strategy Platoons ===== --
        'SorianEditT1BomberHighPrio',
        'SorianEditT2BomberHighPrio',
        'SorianEditT3BomberHighPrio',
        'SorianEditT3BomberSpecialHighPrio',
        'SorianEditT1GunshipHighPrio',
        'SorianEditT1DefensivePoints - High Prio',
        'SorianEditT2DefensivePoints - High Prio',

        'SorianEditBomberLarge',
        'SorianEditBomberBig',
        'SorianEditGunShipLarge',
        'SorianEditNukeBuildersHighPrio',
        'SorianEditT3ArtyBuildersHighPrio',
        'SorianEditT2FirebaseBuildersHighPrio',
        'SorianEditT3FBBuildersHighPrio',
        'SorianEdit Extractor Upgrades Strategy',
        'SorianEditBalancedUpgradeBuildersExpansionStrategy',
        'SorianEditEngineerExpansionBuildersStrategy',
        'SorianEditACUUpgrades - Rush',
        'SorianEditExcessMassBuilders',
    },
    NonCheatBuilders = {
        'SorianEditAirScoutFactoryBuilders',
        'SorianEditAirScoutFormBuilders',

        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersMain',

        'SorianEditCounterIntelBuilders',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 10,
            Tech2 = 20,
            Tech3 = 35, --30,
            SCU = 8,
        },
        FactoryCount = {
            Land = 8,
            Air = 6,
            Sea = 0,
            Gate = 2,
        },
        MassToFactoryValues = {
            T1Value = 6, --8
            T2Value = 15, --20
            T3Value = 22.5, --27.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if markerType == ('Large Expansion Area' or 'Blank Marker' or 'Start Location')
        and personality == 'sorianeditadaptive' or personality == 'sorianeditadaptivecheat'  then
            LOG('--------------------- M-ExpansionFunction High Priority '..personality)
            return 800, 'sorianeditadaptive'
        else
        LOG('--------------------- M-ExpansionFunction low Priority '..personality)
		return 2
		end
	end,
}
