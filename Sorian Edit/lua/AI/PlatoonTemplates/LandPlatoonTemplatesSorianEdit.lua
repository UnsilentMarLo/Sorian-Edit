PlatoonTemplate {
    Name = 'LandAttackSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 100, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackMediumSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 100, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit',
    Plan = 'AttackForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 20, 100, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'HuntAttackSmallSorianEdit',
    Plan = 'HuntAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 100, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'HuntAttackMediumSorianEdit',
    Plan = 'HuntAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 100, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'BaseGuardSmallSorianEdit',
    Plan = 'GuardBaseSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 5, 15, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'BaseGuardMediumSorianEdit',
    Plan = 'GuardBaseSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 25, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'StrikeForceMediumSorianEdit',
    Plan = 'StrikeForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 100, 'Attack', 'AttackFormation' }
    },
}
PlatoonTemplate {
    Name = 'StartLocationAttackSorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 100, 'Attack', 'none' },
        { categories.ENGINEER - categories.COMMAND, 1, 1, 'Attack', 'none' },
    },
}
PlatoonTemplate {
    Name = 'StartLocationAttack2SorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 10, 100, 'Attack', 'none' }
    },
}
PlatoonTemplate {
    Name = 'T1LandScoutFormSorianEdit',
    Plan = 'ScoutingAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.SCOUT * categories.TECH1, 1, 1, 'scout', 'none' }
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
        { categories.LAND * categories.MOBILE - categories.TECH1 - categories.ANTIAIR - categories.SCOUT - categories.ENGINEER - categories.ual0303 - categories.xsl0402, 1, 10, 'guard', 'None' }
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
    Name = 'T1MassHuntersCategorySorianEdit',
    #Plan = 'AttackForceAI',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 3, 100, 'attack', 'none' },
        #{ categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 3, 15, 'attack', 'none' },
        { categories.LAND * categories.SCOUT, 0, 1, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T2MassHuntersCategorySorianEdit',
    #Plan = 'AttackForceAI',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        #{ categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 10, 100, 'attack', 'none' },
        { categories.LAND * categories.MOBILE * categories.DIRECTFIRE * categories.BOT - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 10, 100, 'attack', 'none' },
        #{ categories.TECH1 * categories.LAND * categories.MOBILE * categories.DIRECTFIRE - categories.SCOUT - categories.ENGINEER - categories.EXPERIMENTAL, 10, 25, 'attack', 'none' },
        { categories.LAND * categories.SCOUT, 0, 1, 'attack', 'none' },
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

PlatoonTemplate {
    Name = 'T3ArmoredAssaultSorianEdit',
    FactionSquads = {
        UEF = {
            { 'xel0305', 1, 1, 'attack', 'none' },
        },
        Cybran = {
            { 'xrl0305', 1, 1, 'attack', 'none' },
        },
    }
}