
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
    local Cat1Num = aiBrain:GetCurrentUnits(category)
    local Cat2Num = aiBrain:GetCurrentUnits(category2)
	-- LOG('*AI DEBUG: HaveForEach ' .. Cat2Num .. ' numunits is ' .. numunits 'This many' ..Cat1Num )
	if Cat1Num > 0 and Cat2Num / Cat1Num < numunits then
		return true
	end
		
    return false
end

function HaveLessThanUnitsAroundMarkerCategory(aiBrain, markerType, markerRadius, locationType, locationRadius,
    unitCount, unitCategory, threatMin, threatMax, threatRings, threatType)
    local pos = aiBrain:PBMGetLocationCoords(locationType)
    if not pos then
        return false
    end
    if type(unitCategory) == 'string' then
        unitCategory = ParseEntityCategory(unitCategory)
    end
    local positions = AIUtils.AIGetMarkersAroundLocation(aiBrain, markerType, pos, locationType, threatMin, threatMax, threatRings, threatType)
    for k,v in positions do
        local unitTotal = table.getn(AIUtils.GetOwnUnitsAroundPoint(aiBrain, unitCategory, v.Position, markerRadius, threatMin,
            threatMax, threatRings, threatType))
        if unitTotal < unitCount then
            return true
        end
    end
    return false
end