
-- Buildcondition to check if a platoon is still delayed
function CheckBuildPlatoonDelay(aiBrain, PlatoonName)
    if aiBrain.DelayEqualBuildPlatoons[PlatoonName] and aiBrain.DelayEqualBuildPlatoons[PlatoonName] > GetGameTimeSeconds() then
        return false
    end
    return true
end

			--{ UCBC, 'HaveForEach', { categories.FACTORY, 4, categories.ENERGYPRODUCTION * categories.TECH1 }},
function HaveForEach(aiBrain, category, numunits, category2)
    -- get all units matching 'category'
    local Cat1Num = aiBrain:GetListOfUnits(category, false)
    local Cat2Num = aiBrain:GetListOfUnits(category2, false)

	if Cat1Num > 0 and Cat2Num / Cat1Num < numunits then
		return true
	end
		
    return false
end