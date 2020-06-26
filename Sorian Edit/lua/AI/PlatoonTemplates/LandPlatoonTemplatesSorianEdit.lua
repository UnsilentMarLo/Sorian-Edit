PlatoonTemplate {
    Name = 'LandAttackSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 30, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackMediumSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 20, 50, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 35, 80, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'HuntAttackSmallSorianEdit',
    Plan = 'HuntAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 15, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'HuntAttackMediumSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 25, 'Attack', 'none' }
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
    Plan = 'StrikeForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 30, 'Attack', 'AttackFormation' }
    },
}

PlatoonTemplate {
    Name = 'StartLocationAttackSorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 20, 50, 'Attack', 'none' },
        { categories.ENGINEER - categories.COMMAND, 1, 1, 'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'StartLocationAttack2SorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 30, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'T1LandScoutFormSorianEdit',
    Plan = 'ScoutingAISorian',
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
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 10, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'MassHuntersCategorySorianEditLarge',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 25, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandSorianEdit',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE - categories.url0401, 1, 10, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalScathisSorianEdit',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.url0401, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandLate',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE - categories.url0401, 2, 5, 'attack', 'GrowthFormation' }
    },
}

PlatoonTemplate {
    Name = 'T3ArmoredAssaultSorianEdit',
    FactionSquads = {
        UEF = {
            { 'xel0305', 1, 1, 'attack', 'none' }, --DUNCAN - fixed typo
        },
        Aeon = {
            { 'ual0303', 1, 1, 'attack', 'none' },
        },
        Cybran = {
            { 'xrl0305', 1, 1, 'attack', 'none' },
        },
        Seraphim = {
            { 'xsl0303', 1, 1, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2AttackTankSorianEdit',
    FactionSquads = {
        UEF = {
            { 'del0204', 1, 1, 'attack', 'None' },
        },
        Aeon = {
            { 'xal0203', 1, 1, 'attack', 'None' },
        },
        Cybran = {
            { 'drl0204', 1, 1, 'attack', 'None' },
        },
    },
}