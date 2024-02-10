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
        'SorianEditSupportFactoryUpgrades',
        -- 'SorianEditSupportFactoryUpgrades - Emergency',

        -- Engineer Builders
        'SorianEditEngineerFactoryBuildersExpansion rush',
        'SorianEditT1EngineerBuilders',
        'SorianEditT2EngineerBuilders',
        'SorianEditT3EngineerBuilders',
        'SorianEditEngineerFactoryConstruction Balance',
        'SorianEditLandInitialFactoryConstruction',
		'SorianEditEngineerFactoryConstructionLandHigherPriority',
        'SorianEditEngineerFactoryConstruction',
        'SorianEdit T3 Sub Commander',

        -- SCU Upgrades
        'SorianEditSCUUpgrades',
        -- Scouts
        'SorianEditAirScoutFactoryBuilders',
        'SorianEditAirScoutFormBuilders',

        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',
        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersMain',

        -- Engineer Support buildings
        -- 'SorianEditEngineeringSupportBuilder',

        -- Build energy at this base
        'SorianEditEngineerEnergyBuilders',
        'SorianEditEngineerEnergyBuildersExpansions',

        -- Build Mass high pri at this base
        'Sorianedit Mass Builders',
        'Sorianedit Mass Builders Tech 2',
        -- 'Sorianedit Mass Builders Tech 3',
        'Sorianedit MassFab Builders',

        -- Extractors
        'SorianEditTime Exempt Extractor Upgrades',

        'SorianEditT3NukeDefensesFormer',

        -- ==== EXPANSION ==== --
        'SorianEditEngineerExpansionBuildersFull',
        'SorianEditEngineerExpansionBuildersFulldrop',
        'SorianEditEngineerFirebaseBuilders',

        -- ==== DEFENSES ==== --
        -- 'SorianEditT1BaseDefenses',
        'SorianEditT2BaseDefenses',
        'SorianEditT3BaseDefenses',
        'SorianEditT2BaseDefenses - Emerg',
        'SorianEditT3BaseDefenses - Emerg',
		
        'SorianEditT2PerimeterDefenses',
        'SorianEditT3PerimeterDefenses',

        'SorianEditT1DefensivePoints',
        'SorianEditT2DefensivePoints',
        'SorianEditT3DefensivePoints',
        -- 'SorianEditT1DefensivePoints Turtle',
        'SorianEditT2DefensivePoints Turtle',
        'SorianEditT3DefensivePoints Turtle',
		-- 'SorianEditT1LightDefenses',
		'SorianEditT2LightDefenses',
		'SorianEditT3LightDefenses',
		
		'SorianEditAirStagingExpansion',

        'SorianEditT2ArtilleryFormBuilders',
        'SorianEditT3ArtilleryFormBuilders',
        'SorianEditT4ArtilleryFormBuilders',
        'SorianEditT2MissileDefenses',
        'SorianEditT3NukeDefenses',
        'SorianEditT3NukeDefenseBehaviors',
        'SorianEditMiscDefensesEngineerBuilders',

        -- 'SorianEditMassAdjacencyDefenses',

        -- ==== LAND UNIT BUILDERS ==== --											 
        'SorianEditT1LandFactoryBuilders',
        'SorianEditT1Land - water map',
        'SorianEditT2LandFactoryBuilders',
        'SorianEditT2LandFactoryBuilders - water map',
        'SorianEditT3LandFactoryBuilders',

        'SorianEditFrequentLandAttackFormBuilders',
        'SorianEditMassHunterLandFormBuilders',

        'SorianEditT1LandAA',
        'SorianEditT2LandAA',
        'SorianEditT3LandAA',

        'SorianEditT2ReactionDF',
        'SorianEditT3ReactionDF',

        'SorianEditT2Shields',
        'SorianEditT2ShieldsExpansion',
        'SorianEditShieldUpgrades',
        'SorianEditT3Shields',
        'SorianEditT3ShieldsExpansion',
        'SorianEditEngineeringUpgrades',

        -- ==== AIR UNIT BUILDERS ==== --
        'SorianEditT1AirFactoryBuilders',
        'SorianEditT2AirFactoryBuilders',
        'SorianEditT3AirFactoryBuilders',
        'SorianEditFrequentAirAttackFormBuilders',
        'SorianEditMassHunterAirFormBuilders',

        'SorianEditACUHunterAirFormBuilders',

        'SorianEditTransportFactoryBuilders',
		
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
        -- 'SorianEditHeavyAirStrategy',
        -- 'SorianEditBigAirGroup',
        -- 'SorianEditJesterRush',
        -- 'SorianEditNukeRush',
        -- 'SorianEditT3FBRush',
        -- 'SorianEditT2ACUSnipe',
        -- 'SorianEditT3ACUSnipe',
        -- -- 'SorianEditParagonStrategy',
        -- -- 'SorianEditParagonStrategyExp',
        -- 'SorianEdit Tele SCU Strategy',
        -- -- 'SorianEditWaterMapLowLand',
        -- 'SorianEdit PD Creep Strategy',
        -- 'SorianEditStopNukes',
        -- 'SorianEdit Excess Mass Strategy', 

        -- ===== Strategy Platoons ===== --
        -- 'SorianEditStrategyPlatoons',
        -- 'SorianEditStrategyPlatoonFormers',
    },
    NonCheatBuilders = {
		
        'SorianEditAirScoutFactoryBuilders',
        'SorianEditAirScoutFormBuilders',

        'SorianEditLandScoutFactoryBuilders',
        'SorianEditLandScoutFormBuilders',

        'SorianEditRadarEngineerBuilders',
        'SorianEditRadarUpgradeBuildersExpansion',

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
            Land = 6,
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
        if markerType == ('Large Expansion Area' or 'Blank Marker' or 'Expansion Area' or 'Start Location')
        and personality == 'sorianeditadaptive' or personality == 'sorianeditadaptivecheat' or personality == 'sorianedit'  then
            -- LOG('--------------------- M-ExpansionFunction Expansion High Priority '..personality)
            return 15000, 'sorianedit'
        else
        -- LOG('--------------------- M-ExpansionFunction Expansion Balanced low Priority '..personality)
		return -1
		end
	end,
    FirstBaseFunction = function(aiBrain)
       return -15000, 'sorianedit'
    end,
}
