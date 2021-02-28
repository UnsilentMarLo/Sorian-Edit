
PlatoonTemplate {
    Name = 'CDR Attack',
    Plan = 'ACUAttackSorianEdit',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackPlatoonSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - (categories.INDIRECTFIRE - categories.TECH1) - categories.ENGINEER - categories.xsl0402, 5, 30, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackSorianEditArty',
    Plan = 'HuntAISorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.INDIRECTFIRE - categories.TECH1 - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 30, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackMediumSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 3, 13, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 40, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit amphib',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * (categories.HOVER + categories.AMPHIBIOUS) - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 8, 35, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit amphib S',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * (categories.HOVER + categories.AMPHIBIOUS) - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 4, 20, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'HuntAttackSmallSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 15, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'HuntAttackMediumSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 25, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'BaseGuardSmallSorianEdit',
    Plan = 'GuardBaseSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 8, 15, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'BaseGuardMediumSorianEdit',
    Plan = 'GuardBaseSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 15, 50, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceMediumSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 30, 'Attack', 'AttackFormation' }
    },
}

PlatoonTemplate {
    Name = 'StartLocationAttackSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 20, 50, 'Attack', 'none' },
        { categories.ENGINEER - categories.COMMAND, 1, 1, 'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'StartLocationAttack2SorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - (categories.HOVER - categories.TECH1) - categories.ENGINEER - categories.xsl0402, 5, 30, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'T1LandScoutFormSorianEdit',
    Plan = 'ScoutingSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.SCOUT * categories.TECH1, 1, 2, 'scout', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T2EngineerGuard',
    Plan = 'None',
    GlobalSquads = {
        { categories.DIRECTFIRE * categories.TECH2 * categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER, 1, 3, 'guard', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerGuard',
    Plan = 'None',
    GlobalSquads = {
        { categories.DIRECTFIRE * categories.TECH3 * categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER, 1, 3, 'guard', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3ExpGuard',
    Plan = 'GuardExperimentalSorian',
    GlobalSquads = {
        { categories.LAND * categories.MOBILE - categories.TECH1 - categories.ANTIAIR - categories.SCOUT - categories.ENGINEER - categories.ual0303 - categories.xsl0402, 1, 3, 'guard', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T1GhettoSquad',
    Plan = 'GhettoAISorian',
    GlobalSquads = {
        { categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 6, 6, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'MassHuntersCategorySorianEditSmall',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.TECH3 - categories.ENGINEER - categories.xsl0402, 2, 5, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'MassHuntersCategorySorianEditLarge',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.TECH3 - categories.ENGINEER - categories.xsl0402, 5, 25, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE - categories.BOT - categories.url0401, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandSorianEditBot',
    Plan = 'HuntAISorianEdit',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE * categories.BOT - categories.url0401, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalScathisSorianEdit',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.url0401, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandLate',
    Plan = 'LandAttackSorianEdit',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE - categories.url0401, 1, 1, 'attack', 'GrowthFormation' }
    },
}