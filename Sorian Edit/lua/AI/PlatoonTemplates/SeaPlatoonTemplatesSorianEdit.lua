#***************************************************************************
#*
#**  File     :  /lua/ai/SeaPlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

# ==== Global Form platoons ==== #
PlatoonTemplate {
    Name = 'SeaAttackSorianEdit',
    Plan = 'NavalForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.NAVAL - categories.EXPERIMENTAL - categories.CARRIER, 1, 100, 'Attack', 'GrowthFormation' }
    },
}

PlatoonTemplate {
    Name = 'SeaHuntSorianEdit',
    Plan = 'NavalHuntAI',
    GlobalSquads = {
        { categories.MOBILE * categories.NAVAL - categories.EXPERIMENTAL - categories.CARRIER, 1, 100, 'Attack', 'GrowthFormation' }
    },
}

PlatoonTemplate {
    Name = 'SeaStrikeSorianEdit',
    Plan = 'StrikeForceAISorian',
    GlobalSquads = {
        { categories.MOBILE * categories.NAVAL * categories.TECH2 - categories.EXPERIMENTAL - categories.CARRIER - categories.SUBMERSIBLE, 1, 100, 'Attack', 'GrowthFormation' }
    },
}

PlatoonTemplate {
    Name = 'T4ExperimentalSeaSorianEdit',
    Plan = 'ExperimentalAIHubSorian',
    GlobalSquads = {
        { categories.NAVAL * categories.EXPERIMENTAL * categories.MOBILE, 1, 1, 'attack', 'none' },
    },
}
