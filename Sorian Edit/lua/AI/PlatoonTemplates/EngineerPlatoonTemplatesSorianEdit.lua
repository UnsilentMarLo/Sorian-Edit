#***************************************************************************
#*
#**  File     :  /lua/ai/EngineerPlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

### Engineer platoons to be formed

PlatoonTemplate {
    Name = 'CommanderAssistSorianEdit',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' },
    },
}

PlatoonTemplate {
    Name = 'SCUEnhance',
    Plan = 'EnhanceAISorian',
    GlobalSquads = {
        { categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CommanderEnhanceSorianEdit',
    Plan = 'EnhanceAISorian',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerAssistSorianEdit',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerAssistSorianEdit',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CommanderBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CommanderAttackSorianEdit',
    Plan = 'CDRHuntAISorianEdit',
    GlobalSquads = {
        { categories.COMMAND, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'AnyEngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { (categories.ENGINEER - categories.ENGINEERSTATION) + categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T2EngineerAssistSorianEdit',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T2EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'UEFT2EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.UEF * categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CybranT2EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.CYBRAN * categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerBuilderOnlySorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'AeonT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.AEON * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'UEFT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.UEF * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CybranT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.CYBRAN * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'SeraphimT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAISorian',
    GlobalSquads = {
        { categories.SERAPHIM * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerRepairSorianEdit',
    Plan = 'RepairAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T2EngineerRepairSorianEdit',
    Plan = 'RepairAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerRepairSorianEdit',
    Plan = 'RepairAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER, 1, 1, 'support', 'None' }
    },
}
