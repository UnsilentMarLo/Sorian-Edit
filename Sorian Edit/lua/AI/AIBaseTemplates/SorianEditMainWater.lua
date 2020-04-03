--***************************************************************************
--*
--**  File     :  /mods/Sorian edit/lua/ai/AIBaseTemplates/SorianEditMainWater.lua
--**  Author(s): Michael Robbins aka SorianEdit
--**
--**  Summary  : Manage engineers for a location
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

BaseBuilderTemplate {
    BaseTemplateName = 'SorianEditMainWater',
    Builders = {
        -- ==== ECONOMY ==== --
        -- Factory upgrades
        'SorianEditT1NavalUpgradeBuilders',
        'SorianEditT2NavalUpgradeBuilders',
        'SorianEditEmergencyUpgradeBuilders',


        -- Engineer Builders
        'SorianEditEngineerFactoryBuilders',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstruction Air',
        'SorianEditEngineerFactoryConstruction',

        -- SCU Upgrades
        'SorianEditSCUUpgrades',

        -- Engineer Support buildings
        'SorianEditEngineeringSupportBuilder',

        -- Build energy at this base
        'SorianEditEngineerEnergyBuilders',

        -- Build Mass high pri at this base
        'SorianEditEngineerMassBuilders - Naval',

        -- Extractors
        'SorianEditTime Exempt Extractor Upgrades',

        -- ACU Builders
        'SorianEdit Naval Initial ACU Builders',
        'SorianEditACUBuilders',
        'SorianEditACUUpgrades',

        -- ACU Defense
        'SorianEditT1ACUDefenses',
        'SorianEditT2ACUDefenses',
        'SorianEditT2ACUShields',
        'SorianEditT3ACUShields',
        'SorianEditT3ACUNukeDefenses',

        'SorianEditMassAdjacencyDefenses',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull - Naval',
        'SorianEditEngineerFirebaseBuilders',

        -- ==== DEFENSES ==== --
        'SorianEditT1BaseDefenses',
        'SorianEditT2BaseDefenses',
        'SorianEditT3BaseDefenses',

        'SorianEditT1NavalDefenses',
        'SorianEditT2NavalDefenses',
        'SorianEditT3NavalDefenses',

        'SorianEditT2PerimeterDefenses',
        'SorianEditT3PerimeterDefenses',

        --'SorianEditT1DefensivePoints',
        --'SorianEditT2DefensivePoints',
        --'SorianEditT3DefensivePoints',

        'SorianEditT2ArtilleryFormBuilders',
        'SorianEditT3ArtilleryFormBuilders',
        'SorianEditT4ArtilleryFormBuilders',
        'SorianEditT2MissileDefenses',
        'SorianEditT3NukeDefenses',
        'SorianEditT3NukeDefenseBehaviors',
        'SorianEditMiscDefensesEngineerBuilders',

        -- ==== NAVAL EXPANSION ==== --
        'SorianEditNavalExpansionBuildersFast',

        -- ==== LAND UNIT BUILDERS ==== --
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

        -- ==== AIR UNIT BUILDERS ==== --
        --'SorianEditT1AirFactoryBuilders',
        --'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditUnitCapAirAttackFormBuilders',
        'SorianEditACUHunterAirFormBuilders',

        'SorianEditAntiNavyAirFormBuilders',

        'SorianEditTransportFactoryBuilders - Air',

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

        --'SorianEditMobileNavalExperimentalEngineers',
        --'SorianEditMobileNavalExperimentalForm',

        'SorianEditEconomicExperimentalEngineers',
        'SorianEditMobileExperimentalEngineersGroup',

        -- ==== ARTILLERY BUILDERS ==== --
        'SorianEditT3ArtilleryGroup',

        'SorianEditExperimentalArtillery',

        'SorianEditNukeBuildersEngineerBuilders',
        'SorianEditNukeFormBuilders',

        'SorianEditSatelliteExperimentalEngineers',
        'SorianEditSatelliteExperimentalForm',

 --[[   -- ======== Strategies ======== --
        'SorianEditHeavyAirStrategy',
        'SorianEditBigAirGroup',
        'SorianEditJesterRush',
        'SorianEditNukeRush',
        'SorianEditT3ArtyRush',
        'SorianEditT2ACUSnipe',
        'SorianEditT3FBRush',
        'SorianEditParagonStrategy',
        'SorianEdit Tele SCU Strategy',
        'SorianEditWaterMapLowLand',
        'SorianEdit PD Creep Strategy',
        'SorianEditStopNukes',
        'SorianEditEnemyTurtle - In Range',
        'SorianEditEnemyTurtle - Out of Range',
        'SorianEdit Excess Mass Strategy', ]]--

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
        'SorianEditExcessMassBuilders',
    },
    NonCheatBuilders = {
        'SorianEditAirScoutFactoryBuilders',
        'SorianEditAirScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersMain',

        'SorianEditCounterIntelBuilders',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 15,
            Tech2 = 10,
            Tech3 = 45, --30,
            SCU = 8,
        },
        FactoryCount = {
            Land = 1,
            Air = 4,
            Sea = 0,
            Gate = 1,
        },
        MassToFactoryValues = {
            T1Value = 8, --6
            T2Value = 20, --15
            T3Value = 40, --22.5
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
            return 1, 'sorianwater'
        end

        if per != 'sorianwater' and per != 'sorianadaptive' and per != '' then
            return 1, 'sorianwater'
        end

        local mapSizeX, mapSizeZ = GetMapSize()

        local startX, startZ = aiBrain:GetArmyStartPos()
        local isIsland = import('/lua/editor/SorianEditBuildConditions.lua').IsIslandMap(aiBrain)

        if per == 'sorianwater' then
            return 1000, 'sorianwater'
        end

        --If we're playing on an island map, do not use this plan often
        if mapSizeX < 1024 and mapSizeZ < 1024 and isIsland then
            return Random(65, 80), 'sorianwater'
        elseif mapSizeX >= 1024 and mapSizeZ >= 1024 and isIsland then
            return Random(98, 100), 'sorianwater'
        else
            return 1, 'sorianwater'
        end
    end,
}