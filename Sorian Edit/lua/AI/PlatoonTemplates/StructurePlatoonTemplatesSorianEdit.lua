#***************************************************************************
#*
#**  File     :  /lua/ai/StructurePlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

PlatoonTemplate {
    Name = 'AddToMassExtractorUpgradePlatoonSE',
    Plan = 'SorianPlatoonMerger',
    GlobalSquads = {
        { categories.MASSEXTRACTION * (categories.TECH1 + categories.TECH2 + categories.TECH3), 1, 300, 'support', 'none' }
    },
}

PlatoonTemplate {
    Name = 'MassFabsSorianEdit',
    Plan = 'PauseAI',
    GlobalSquads = {
        { categories.STRUCTURE * categories.MASSFABRICATION - categories.MASSEXTRACTION, 1, 1, 'support', 'none' },
    }
}

# ==== Missile systems ==== #
PlatoonTemplate {
    Name = 'T2TacticalLauncherSorianEdit',
    Plan = 'TacticalAISorian',
    GlobalSquads = {
        { categories.STRUCTURE * categories.TACTICALMISSILEPLATFORM, 1, 1, 'attack', 'none' },
    }
}

# ==== Artillery platoons ==== #
PlatoonTemplate {
    Name = 'T2ArtilleryStructureSorianEdit',
    Plan = 'ArtilleryAISorian',
    GlobalSquads = {
        { categories.ARTILLERY * categories.STRUCTURE * categories.TECH2, 1, 1, 'artillery', 'None' }
    }
}

PlatoonTemplate {
    Name = 'T3ArtilleryStructureSorianEdit',
    Plan = 'ArtilleryAISorian',
    GlobalSquads = {
        { categories.ARTILLERY * categories.STRUCTURE * categories.TECH3, 1, 1, 'artillery', 'None' }
    }
}

PlatoonTemplate {
    Name = 'T4ArtilleryStructureSorianEdit',
    Plan = 'ArtilleryAISorian',
    GlobalSquads = {
        { categories.ARTILLERY * categories.STRUCTURE * categories.EXPERIMENTAL, 1, 1, 'artillery', 'None' }
    }
}

PlatoonTemplate {
    Name = 'T3NukeSorianEdit',
    Plan = 'NukePlatoonSorianEdit',
    GlobalSquads = {
        { categories.NUKE * categories.STRUCTURE * categories.TECH3, 1, 1, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T4NukeSorianEdit',
    Plan = 'NukePlatoonSorianEdit',
    GlobalSquads = {
        { categories.NUKE * categories.STRUCTURE * categories.EXPERIMENTAL, 1, 1, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T2Engineering',
    Plan = 'UnitUpgradeAI',
    FactionSquads = {
        UEF = {
            { 'xeb0104', 0, 1, 'support', 'None' }
        },
    }
}

PlatoonTemplate {
    Name = 'T2Engineering1',
    Plan = 'UnitUpgradeAI',
    FactionSquads = {
        Cybran = {
            { 'xrb0104', 0, 1, 'support', 'None' }
        },
    }
}

PlatoonTemplate {
    Name = 'T2Engineering2',
    Plan = 'UnitUpgradeAI',
    FactionSquads = {
        Cybran = {
            { 'xrb0204', 0, 1, 'support', 'None' }
        },
    }
}

PlatoonTemplate {
    Name = 'T4SatelliteExperimentalSorianEdit',
    Plan = 'SatelliteAISorian',
    GlobalSquads = {
        { categories.SATELLITE, 1, 1, 'attack', 'none' },
    }
}
