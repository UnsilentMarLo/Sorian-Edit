PlatoonTemplate {
    Name = 'AirAttackSorianSorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 2, 10, 'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER * categories.TECH1 - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T2FighterBomberSE',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER * categories.TECH2 - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}

-- Constant attackers

PlatoonTemplate {
    Name = 'T1LAirDF1SorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.TECH1 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'T2LAirDF1SorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.TECH2 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'T3LAirDF1SorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR  * categories.TECH3 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}

-- Constant attackers end

PlatoonTemplate {
    Name = 'T1AirFighterSE',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.ANTIAIR * categories.TECH1 - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 5, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'ThreatAirAttackSorianEdit',
    Plan = 'ThreatStrikeSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * (categories.BOMBER + categories.GROUNDATTACK) - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEditBig',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * (categories.BOMBER + categories.GROUNDATTACK) - categories.EXPERIMENTAL - categories.ANTINAVY, 5, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'TorpedoBomberAttackSorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.ANTINAVY - categories.EXPERIMENTAL, 2, 20, 'Attack', 'none' },
        --{ categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.EXPERIMENTAL - categories.BOMBER - categories.TRANSPORTFOCUS, 2, 5, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirBaseGuardSorianEdit',
    Plan = 'GuardBaseSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 1, 30, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipAttackSorianEdit',
    Plan = 'GunshipHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTFOCUS, 2, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipSFSorianEdit',
    Plan = 'AirHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTFOCUS, 3, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipMassHunterSorianEdit',
    Plan = 'GuardMarkerSorian',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTFOCUS, 2, 5, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T1AirScoutFormSorianEdit',
    Plan = 'ScoutingAISorian',
    GlobalSquads = {
        { categories.AIR * categories.SCOUT * categories.TECH1, 1, 1, 'scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirHuntSorianEdit',
    Plan = 'FighterDistributionHubSorian', --'FighterHuntAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 1, 5, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirT4GuardSorianEdit',
    Plan = 'GuardExperimentalSorian',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTFOCUS - categories.EXPERIMENTAL, 1, 5, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T3AirScoutFormSorianEdit',
    Plan = 'ScoutingAISorian',
    GlobalSquads = {
        { categories.AIR * categories.INTELLIGENCE * categories.TECH3, 1, 1, 'scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'T4ExperimentalAirSorianEdit',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.AIR * categories.EXPERIMENTAL * categories.MOBILE - categories.SATELLITE, 1, 5, 'attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalAirLateSorianEdit',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.AIR * categories.EXPERIMENTAL * categories.MOBILE - categories.SATELLITE, 2, 5, 'attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'T2BomberSorianEdit',
    FactionSquads = {
        UEF = {
            { 'dea0202', 1, 1, 'attack', 'None' },
        },
        Aeon = {
            { 'uaa0203', 1, 1, 'attack', 'None' },
        },
        Cybran = {
            { 'dra0202', 1, 1, 'attack', 'None' },
        },
        Seraphim = {
            { 'xsa0202', 1, 1, 'attack', 'None' },
        },
    },
}

PlatoonTemplate {
    Name = 'T3AirBomberSpecialSorianEdit',
    FactionSquads = {
        UEF = {
            { 'uea0304', 1, 1, 'attack', 'None' },
        },
        Aeon = {
            { 'xaa0305', 1, 1, 'attack', 'None' },
        },
        Cybran = {
            { 'ura0304', 1, 1, 'attack', 'None' },
        },
        Seraphim = {
            { 'xsa0304', 1, 1, 'attack', 'None' },
        },
    },
}