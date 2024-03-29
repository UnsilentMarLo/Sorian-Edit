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
        { categories.SUBCOMMANDER - categories.ENGINEERPRESET - categories.RASPRESET - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
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
    Name = 'EngineerAssistSorianEditALL',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.ENGINEER - categories.SUBCOMMANDER - categories.COMMAND, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerFactoryAssistSorianEditALL',
    Plan = 'FactoryAssistSorianEdit',
    GlobalSquads = {
        { categories.ENGINEER - categories.COMMAND - categories.SUBCOMMANDER - categories.TECH3, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerAssistSorianEdit',
    Plan = 'SorianManagerEngineerAssistAI',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CommanderBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
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
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { (categories.ENGINEER - categories.ENGINEERSTATION) + categories.SUBCOMMANDER - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH1',
    Plan = 'EngineerBuildAIEdit',
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
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T2T3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER - categories.TECH1 - categories.COMMAND - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'UEFT2EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.UEF * categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CybranT2EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.CYBRAN * categories.ENGINEER * categories.TECH2 - categories.ENGINEERSTATION, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerBuilderOnlySorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 - categories.SUBCOMMANDER - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'T3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'AeonT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.AEON * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'UEFT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.UEF * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'CybranT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.CYBRAN * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'SeraphimT3EngineerBuilderSorianEdit',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.SERAPHIM * categories.ENGINEER * (categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET), 1, 1, 'support', 'None' }
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
        { categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER - categories.RAMBOPRESET, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditALLTECH',
    Plan = 'ReclaimSorianEdit',
    GlobalSquads = {
        { categories.ENGINEER * (categories.TECH1 + categories.TECH2 + categories.TECH3), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH1REC',
    Plan = 'ReclaimSorianEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 2, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH12REC',
    Plan = 'ReclaimSorianEdit',
    GlobalSquads = {
        { categories.ENGINEER * (categories.TECH1 + categories.TECH2), 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH1',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH1, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH2',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH2, 1, 1, 'support', 'None' }
    },
}

PlatoonTemplate {
    Name = 'EngineerBuilderSorianEditTECH3',
    Plan = 'EngineerBuildAIEdit',
    GlobalSquads = {
        { categories.ENGINEER * categories.TECH3, 1, 1, 'support', 'None' }
    },
}
