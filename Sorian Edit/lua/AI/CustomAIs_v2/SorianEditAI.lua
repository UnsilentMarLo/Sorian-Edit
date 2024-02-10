#****************************************************************************
#**
#**  File     :  
#**  Author(s): 
#**
#**  Summary  : Utility File to insert custom AI into the game.
#**
#****************************************************************************

AI = {
    Name = "Sorian Edit AI",
    Version = "0.0.1",
    AIList = {
        {
            key = 'sorianeditadaptive',
            name = "AI: Sorian Edit AI Adaptive",
			
            rating = 400,
            ratingCheatMultiplier = 0.0,
            ratingBuildMultiplier = 0.0,
            ratingOmniBonus = 0.0,
            ratingMapMultiplier = {
                [256] = 0.8,   -- 5x5
                [512] = 1.0,   -- 10x10
                [1024] = 1.25,  -- 20x20
                [2048] = 1.75, -- 40x40
                [4096] = 2.5,  -- 80x80
            }
        },
    },
    CheatAIList = {
        {
            key = 'sorianeditadaptivecheat',
            name = "AIx: Sorian Edit AI Adaptive",
			
            rating = 600,
            ratingCheatMultiplier = 150.0,
            ratingBuildMultiplier = 150.0,
            ratingOmniBonus = 200,
            ratingNegativeThreshold = -50,
            ratingMapMultiplier = {
                [256] = 0.8,   -- 5x5
                [512] = 1.0,   -- 10x10
                [1024] = 1.25,  -- 20x20
                [2048] = 1.75, -- 40x40
                [4096] = 2.5,  -- 80x80
            }
        },
    },
}