
PlatoonTemplate {
    Name = 'CDR Attack',
    Plan = 'ACUAttackSorianEdit',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackPlatoonSorianEdit',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.SCOUT - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402, 3, 10, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackMediumSorianEdit',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402 - categories.SCOUT, 5, 13, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'LandAttackLargeSorianEdit',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402 - categories.SCOUT, 12, 40, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StartLocationAttackSorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER - categories.xsl0402 - categories.SCOUT, 20, 50, 'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'T1LandScoutFormSorianEdit',
    Plan = 'ScoutingSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND * categories.SCOUT * categories.TECH1, 1, 1, 'scout', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T1LandCombatScoutFormSorianEdit',
    Plan = 'ScoutingSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.TECH3 - categories.SCOUT - categories.ENGINEER - categories.xsl0402, 1, 2, 'Attack', 'none' }
    }
}
PlatoonTemplate {
    Name = 'MassHuntersCategorySorianEditSmall',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.TECH3 - categories.SHIELD - categories.SCOUT - categories.ENGINEER - categories.xsl0402, 1, 2, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'MassHuntersCategorySorianEditLarge',
    Plan = 'StrikeForceAI',
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.TECH3 - categories.ENGINEER - categories.SHIELD - categories.xsl0402 - categories.SCOUT, 4, 8, 'Attack', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandSorianEdit',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE - categories.BOT - categories.url0401 - categories.SCOUT, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalLandSorianEditBot',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.LAND * categories.MOBILE * categories.BOT - categories.url0401 - categories.SCOUT, 1, 1, 'attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalScathisSorianEdit',
    Plan = 'HeroFightPlatoonSorianEdit',
    GlobalSquads = {
        { categories.url0401, 1, 1, 'attack', 'none' }
    },
}