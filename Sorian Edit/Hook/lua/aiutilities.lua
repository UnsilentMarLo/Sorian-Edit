local BuildingTemplates = import('/lua/BuildingTemplates.lua').BuildingTemplates
local UnitTemplates = import('/lua/unittemplates.lua').UnitTemplates
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utils = import('/lua/utilities.lua')
local AIAttackUtils = import('/lua/AI/aiattackutilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local SUtils = import('/lua/AI/sorianutilities.lua')
local AIBehaviors = import('/lua/ai/AIBehaviors.lua')

-- Cheat Utilities
function SetupCheat(aiBrain, cheatBool)
    if cheatBool then
        aiBrain.CheatEnabled = true

        local buffDef = Buffs['CheatBuildRate']
        local buffAffects = buffDef.Affects
        buffAffects.BuildRate.Mult = tonumber(ScenarioInfo.Options.BuildMult)

        buffDef = Buffs['CheatIncome']
        buffAffects = buffDef.Affects
        buffAffects.EnergyProduction.Mult = tonumber(ScenarioInfo.Options.CheatMult) * 2.5
        buffAffects.MassProduction.Mult = tonumber(ScenarioInfo.Options.CheatMult) * 1.5

        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
        for _, v in pool:GetPlatoonUnits() do
            -- Apply build rate and income buffs
            ApplyCheatBuffs(v)
        end

    end
end
