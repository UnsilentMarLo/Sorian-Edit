#***************************************************************************
#*
#**  File     :  /mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditMainRush.lua
#**  Author(s): Michael Robbins aka SorianEdit
#**
#**  Summary  : Manage engineers for a location
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditMainRush',
    Builders = {
        # ==== ECONOMY ==== #
        # Factory upgrades
        'SorianEditT1RushUpgradeBuilders',
        'SorianEditT2BalancedUpgradeBuilders',
        'SorianEditEmergencyUpgradeBuilders',
        'SorianEditMassFabPause',

        # Engineer Builders
        'SorianEditEngineerFactoryBuilders - Rush',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstructionLandHigherPriority',
        'SorianEditEngineerFactoryConstruction',

        # SCU Upgrades
        'SorianEditSCUUpgrades',

        # Engineer Support buildings
        'SorianEditEngineeringSupportBuilder',

        # Build energy at this base
        'SorianEditEngineerEnergyBuilders',

        # Build Mass high pri at this base
        #'SorianEditEngineerMassBuilders - Rush',
        'SorianEditEngineerMassBuildersHighPri',

        # Extractors
        'SorianEditTime Exempt Extractor Upgrades - Rush',

        # ACU Builders
        'SorianEdit Rush Initial ACU Builders',
        'SorianEditACUBuilders',
        'SorianEditACUUpgrades',
        'SorianEditACUAttack',

        # ACU Defense
        'SorianEditT1ACUDefenses',
        'SorianEditT2ACUDefenses',
        'SorianEditT2ACUShields',
        'SorianEditT3ACUShields',
        'SorianEditT3ACUNukeDefenses',

        # ==== EXPANSION ==== #
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersSmall',
        'SorianEditEngineerFirebaseBuilders',

        # ==== DEFENSES ==== #
        'SorianEditT1BaseDefenses',
        'SorianEditT2BaseDefenses - Emerg',
        'SorianEditT3BaseDefenses - Emerg',

        'SorianEditT1DefensivePoints',
        'SorianEditT2DefensivePoints',
        #'SorianEditT3DefensivePoints',

        'SorianEditT2ArtilleryFormBuilders',
        'SorianEditT3ArtilleryFormBuilders',
        'SorianEditT4ArtilleryFormBuilders',
        'SorianEditT2MissileDefenses',
        'SorianEditT3NukeDefenses',
        'SorianEditT3NukeDefenseBehaviors',
        'SorianEditMiscDefensesEngineerBuilders',

        'SorianEditMassAdjacencyDefenses',

        # ==== NAVAL EXPANSION ==== #
        'SorianEditNavalExpansionBuilders',

        # ==== LAND UNIT BUILDERS ==== #
        'SorianEditT1LandFactoryBuilders - Rush',
        'SorianEditT1LandFactoryBuilders',
        'SorianEditT2LandFactoryBuilders',
        'SorianEditT3LandFactoryBuilders',

        'SorianEditFrequentLandAttackFormBuilders',
        'SorianEditMassHunterLandFormBuilders',
        'SorianEditMiscLandFormBuilders',
        'SorianEditUnitCapLandAttackFormBuilders',

        'SorianEditT1LandAA',
        'SorianEditT2LandAA',
        'SorianEditT3LandResponseBuilders',

        'SorianEditT1ReactionDF',
        'SorianEditT2ReactionDF',
        'SorianEditT3ReactionDF',

        'SorianEditT2Shields',
        'SorianEditShieldUpgrades',
        'SorianEditT3Shields',
        'SorianEditEngineeringUpgrades',

        # ==== AIR UNIT BUILDERS ==== #
        'SorianEditT1AirFactoryBuilders',
        'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditUnitCapAirAttackFormBuilders',
        'SorianEditACUHunterAirFormBuilders',

        'SorianEditTransportFactoryBuilders - Rush',

        'SorianEditExpResponseFormBuilders',

        'SorianEditT1AntiAirBuilders',
        'SorianEditT2AntiAirBuilders',
        'SorianEditT3AntiAirBuilders',
        'SorianEditBaseGuardAirFormBuilders',

        # ==== EXPERIMENTALS ==== #
        'SorianEditMobileLandExperimentalEngineers',
        'SorianEditMobileLandExperimentalForm',

        'SorianEditMobileAirExperimentalEngineers',
        'SorianEditMobileAirExperimentalForm',

        #'SorianEditMobileNavalExperimentalEngineers',
        #'SorianEditMobileNavalExperimentalForm',

        'SorianEditEconomicExperimentalEngineers',
        'SorianEditMobileExperimentalEngineersGroup',

        # ==== ARTILLERY BUILDERS ==== #
        'SorianEditT3ArtilleryGroup',

        'SorianEditExperimentalArtillery',

        'SorianEditNukeBuildersEngineerBuilders',
        'SorianEditNukeFormBuilders',

        'SorianEditSatelliteExperimentalEngineers',
        'SorianEditSatelliteExperimentalForm',

        # ======== Strategies ======== #
        'SorianEditHeavyAirStrategy',
        'SorianEditBigAirGroup',
        'SorianEditJesterRush',
        'SorianEditNukeRush',
        'SorianEditT3ArtyRush',
        'SorianEditT2ACUSnipe',
        'SorianEditT3FBRush',
        'SorianEditParagonStrategy',
        'SorianEditSmallMapRush',
        'SorianEdit Tele SCU Strategy',
        'SorianEditWaterMapLowLand',
        'SorianEdit PD Creep Strategy',
        'SorianEditStopNukes',
        'SorianEditEnemyTurtle - In Range',
        'SorianEditEnemyTurtle - Out of Range',
        'SorianEdit Excess Mass Strategy',
        'SorianEditRushGunUpgrades',

        # ===== Strategy Platoons ===== #
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
            Tech1 = 15,
            Tech2 = 10,
            Tech3 = 25, #15,
            SCU = 2,
        },
        FactoryCount = {
            Land = 7,
            Air = 3,
            Sea = 0,
            Gate = 1,
        },
        MassToFactoryValues = {
            T1Value = 6,
            T2Value = 15,
            T3Value = 22.5
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)
        return -1
    end,
    FirstBaseFunction = function(aiBrain)
        if not aiBrain.SorianEdit then
            return -1
        end
        local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if not per then
            return 1, 'sorianrush'
        end

        if per != 'sorianrush' and per != 'sorianadaptive' and per != '' then
            return 1, 'sorianrush'
        end

        local mapSizeX, mapSizeZ = GetMapSize()

        local startX, startZ = aiBrain:GetArmyStartPos()
        local isIsland = import('/lua/editor/SorianEditBuildConditions.lua').IsIslandMap(aiBrain)

        if per == 'sorianrush' then
            return 1000, 'sorianrush'
        end

        if mapSizeX < 1024 and mapSizeZ < 1024 and isIsland then
            return Random(75, 100), 'sorianrush'

        elseif mapSizeX <= 256 and mapSizeZ <= 256 and not isIsland then
            return 100, 'sorianrush'

        elseif mapSizeX >= 256 and mapSizeZ >= 256 and mapSizeX < 1024 and mapSizeZ < 1024 then
            return Random(75, 100), 'sorianrush'

        elseif mapSizeX <= 1024 and mapSizeZ <= 1024 then
            return 50, 'sorianrush'

        else
            return 20, 'sorianrush'
        end
    end,
}
