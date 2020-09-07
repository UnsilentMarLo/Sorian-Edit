
-- Cheat Utilities
function SetupCheat(aiBrain, cheatBool)
	if cheatBool then
		aiBrain.CheatEnabled = true

		local buffDef = Buffs['CheatBuildRate']
		local buffAffects = buffDef.Affects
		buffAffects.BuildRate.Mult = tonumber(ScenarioInfo.Options.BuildMult)

		buffDef = Buffs['CheatIncome']
		buffAffects = buffDef.Affects
		buffAffects.EnergyProduction.Mult = tonumber(ScenarioInfo.Options.CheatMult) * 1.1
		buffAffects.MassProduction.Mult = tonumber(ScenarioInfo.Options.CheatMult) * 1.1

		local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
		for _, v in pool:GetPlatoonUnits() do
			-- Apply build rate and income buffs
			ApplyCheatBuffs(v)
		end

	end
end
