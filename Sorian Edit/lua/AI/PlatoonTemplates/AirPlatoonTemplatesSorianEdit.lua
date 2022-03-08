PlatoonTemplate {
    Name = 'AirAttackSorianSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTATION - categories.EXPERIMENTAL, 2, 10, 'Attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 5, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEditSnipeT2',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER * categories.TECH2 - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 50, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEditSnipeT3',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER * categories.TECH3 - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 50, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEditT3',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T2FighterBomberSE',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.BOMBER * categories.TECH2 - categories.TRANSPORTATION - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}

-- Constant attackers

PlatoonTemplate {
    Name = 'T1LAirDF1SorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.TECH1 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'T2LAirDF1SorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.TECH2 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}
PlatoonTemplate {
    Name = 'T3LAirDF1SorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR  * categories.TECH3 - categories.EXPERIMENTAL, 3, 10, 'Attack', 'none' },
    }
}

-- Constant attackers end

PlatoonTemplate {
    Name = 'T1AirFighterSE',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.ANTIAIR * categories.TECH1 - categories.BOMBER - categories.TRANSPORTATION - categories.EXPERIMENTAL, 1, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'ThreatAirAttackSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * (categories.BOMBER + categories.GROUNDATTACK) - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'BomberAttackSorianEditBig',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * (categories.BOMBER + categories.GROUNDATTACK) - categories.EXPERIMENTAL - categories.ANTINAVY, 1, 30, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'TorpedoBomberAttackSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.ANTINAVY - categories.EXPERIMENTAL, 2, 20, 'Attack', 'none' },
        -- { categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.EXPERIMENTAL - categories.BOMBER - categories.TRANSPORTATION, 2, 5, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirBaseGuardSorianEdit',
    Plan = 'GuardBaseSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTATION - categories.EXPERIMENTAL, 1, 30, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipAttackSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTATION, 1, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipSFSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTATION, 1, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipSFSorianEditNoHero',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTATION, 1, 10, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GunshipMassHunterSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.MOBILE * categories.AIR * categories.GROUNDATTACK - categories.EXPERIMENTAL - categories.TRANSPORTATION, 1, 5, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T1AirScoutFormSorianEdit',
    Plan = 'ScoutingSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.SCOUT * categories.TECH1, 1, 1, 'scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirHuntSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit', --'FighterHuntAI',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTATION - categories.EXPERIMENTAL, 1, 5, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'AntiAirT4GuardSorianEdit',
    Plan = 'GuardExperimentalSorian',
    GlobalSquads = {
        { categories.AIR * categories.MOBILE * categories.ANTIAIR * (categories.TECH1 + categories.TECH2 + categories.TECH3) - categories.BOMBER - categories.TRANSPORTATION - categories.EXPERIMENTAL, 1, 5, 'attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'T3AirScoutFormSorianEdit',
    Plan = 'ScoutingSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.INTELLIGENCE * categories.TECH3, 1, 1, 'scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'T4ExperimentalAirSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.EXPERIMENTAL * categories.MOBILE - categories.SATELLITE, 1, 1, 'attack', 'none' },
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalAirLateSorianEdit',
    Plan = 'InterceptorBomberGunshipSorianEdit',
    GlobalSquads = {
        { categories.AIR * categories.EXPERIMENTAL * categories.MOBILE - categories.SATELLITE, 1, 1, 'attack', 'none' },
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