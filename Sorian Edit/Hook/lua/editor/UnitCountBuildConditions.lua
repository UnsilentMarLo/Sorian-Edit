
local MAPBASEPOSTITIONSSE = {}
local mapSizeX, mapSizeZ = GetMapSize()
local NavUtils = import("/lua/sim/navutils.lua")

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

--{ UCBC, 'CanBuildCategorySE', { categories.RADAR * categories.TECH1 } },
local FactionIndexToCategory = {[1] = categories.UEF, [2] = categories.AEON, [3] = categories.CYBRAN, [4] = categories.SERAPHIM, [5] = categories.NOMADS, [6] = categories.ARM, [7] = categories.CORE }
function CanBuildCategorySE(aiBrain,category)
    -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
    local FactionCat = FactionIndexToCategory[aiBrain:GetFactionIndex()] or categories.ALLUNITS
    local numBuildableUnits = table.getn(EntityCategoryGetUnitList(category * FactionCat)) or -1
    --AILog('* CanBuildCategorySE: FactionIndex: ('..repr(aiBrain:GetFactionIndex())..') numBuildableUnits:'..numBuildableUnits..' - '..repr( EntityCategoryGetUnitList(category * FactionCat) ))
    return numBuildableUnits > 0
end

--            { UCBC, 'HaveUnitRatioVersusCapSE', { 0.024, '<=', categories.STRUCTURE * categories.FACTORY * categories.LAND } }, -- Maximal 3 factories at 125 unitcap, 12 factories at 500 unitcap...
function HaveUnitRatioVersusCapSE(aiBrain, ratio, compareType, categoryOwn)
    local numOwnUnits = aiBrain:GetCurrentUnits(categoryOwn)
    local cap = GetArmyUnitCap(aiBrain:GetArmyIndex())
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} ( '..numOwnUnits..' '..compareType..' '..cap..' ) -- ['..ratio..'] -- '..repr(DEBUG)..' :: '..(numOwnUnits / cap)..' '..compareType..' '..cap..' return '..repr(CompareBody(numOwnUnits / cap, ratio, compareType)))
    return CompareBody(numOwnUnits / cap, ratio, compareType)
end

function GreaterThanGameTimeSecondsSE(aiBrain, num)
    if num < GetGameTimeSeconds() then
        return true
    end
    return false
end
--            { UCBC, 'LessThanGameTimeSeconds', { 180 } },
function LessThanGameTimeSecondsSE(aiBrain, num)
    if num > GetGameTimeSeconds() then
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


function HaveUnitRatioAtLocationSE(aiBrain, locType, ratio, categoryNeed, compareType, categoryHave)
    local AIName = ArmyBrains[aiBrain:GetArmyIndex()].Nickname
    local baseposition, radius
    if MAPBASEPOSTITIONSSE[AIName][locType] then
        baseposition = MAPBASEPOSTITIONSSE[AIName][locType].Pos
        radius = MAPBASEPOSTITIONSSE[AIName][locType].Rad
    elseif aiBrain.BuilderManagers[locType] then
        baseposition = aiBrain.BuilderManagers[locType].FactoryManager.Location
        radius = aiBrain.BuilderManagers[locType].FactoryManager:GetLocationRadius()
        MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
        MAPBASEPOSTITIONSSE[AIName][locType] = {Pos=baseposition, Rad=radius}
    elseif aiBrain:PBMHasPlatoonList() then
        for k,v in aiBrain.PBM.Locations do
            if v.LocationType == locType then
                baseposition = v.Location
                radius = v.Radius
                MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
                MAPBASEPOSTITIONSSE[AIName][locType] = {baseposition, radius}
                break
            end
        end
    end
    if not baseposition then
        return false
    end
    local numNeedUnits = aiBrain:GetNumUnitsAroundPoint(categoryNeed, baseposition, radius , 'Ally')
    local numHaveUnits = aiBrain:GetNumUnitsAroundPoint(categoryHave, baseposition, radius , 'Ally')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {'..locType..'} ( '..numNeedUnits..' '..compareType..' '..numHaveUnits..' ) -- ['..ratio..'] -- '..categoryNeed..' '..compareType..' '..categoryHave..' return '..repr(CompareBody(numNeedUnits / numHaveUnits, ratio, compareType)))
    return CompareBody(numNeedUnits / numHaveUnits, ratio, compareType)
end

-- 0.8 = 4:5
--{ UCBC, 'HaveUnitRatioAtLocationSERadiusVersusEnemy', { 1.50, 'LocationType', 90, 'STRUCTURE DEFENSE ANTIMISSILE TECH3', '<','SILO NUKE TECH3' } },
function HaveUnitRatioAtLocationSERadiusVersusEnemy(aiBrain, ratio, locType, radius, categoryOwn, compareType, categoryEnemy)
    local AIName = ArmyBrains[aiBrain:GetArmyIndex()].Nickname
    local baseposition, radius
    if MAPBASEPOSTITIONSSE[AIName][locType] then
        baseposition = MAPBASEPOSTITIONSSE[AIName][locType].Pos
        radius = MAPBASEPOSTITIONSSE[AIName][locType].Rad
    elseif aiBrain.BuilderManagers[locType] then
        baseposition = aiBrain.BuilderManagers[locType].FactoryManager.Location
        radius = aiBrain.BuilderManagers[locType].FactoryManager:GetLocationRadius()
        MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
        MAPBASEPOSTITIONSSE[AIName][locType] = {Pos=baseposition, Rad=radius}
    elseif aiBrain:PBMHasPlatoonList() then
        for k,v in aiBrain.PBM.Locations do
            if v.LocationType == locType then
                baseposition = v.Location
                radius = v.Radius
                MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
                MAPBASEPOSTITIONSSE[AIName][locType] = {baseposition, radius}
                break
            end
        end
    end
    if not baseposition then
        return false
    end
    local numNeedUnits = aiBrain:GetNumUnitsAroundPoint(categoryOwn, baseposition, radius , 'Ally')
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ , 'Enemy')
    return CompareBody(numNeedUnits / numEnemyUnits, ratio, compareType)
end

function HaveEnemyUnitAtLocationSE(aiBrain, radius, locationType, unitCount, categoryEnemy, compareType)
    if not aiBrain.BuilderManagers[locationType] then
        AIWarn('*AI WARNING: HaveEnemyUnitAtLocationSE - Invalid location - ' .. locationType)
        return false
    elseif not aiBrain.BuilderManagers[locationType].Position then
        AIWarn('*AI WARNING: HaveEnemyUnitAtLocationSE - Invalid position - ' .. locationType)
        return false
    end
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, aiBrain.BuilderManagers[locationType].Position, radius , 'Enemy')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} radius:['..radius..'] '..repr(DEBUG)..' ['..numEnemyUnits..'] '..compareType..' ['..unitCount..'] return '..repr(CompareBody(numEnemyUnits, unitCount, compareType)))
    return CompareBody(numEnemyUnits, unitCount, compareType)
end
--            { UCBC, 'EnemyUnitsGreaterAtLocationRadiusSE', {  BasePanicZone, 'LocationType', 0, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function EnemyUnitsGreaterAtLocationRadiusSE(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return HaveEnemyUnitAtLocationSE(aiBrain, radius, locationType, unitCount, categoryEnemy, '>')
end
--            { UCBC, 'EnemyUnitsLessAtLocationRadiusSE', {  BasePanicZone, 'LocationType', 1, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function EnemyUnitsLessAtLocationRadiusSE(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return HaveEnemyUnitAtLocationSE(aiBrain, radius, locationType, unitCount, categoryEnemy, '<')
end

--            { UCBC, 'UnitsLessAtEnemySE', { 1 , 'MOBILE EXPERIMENTAL' } },
--            { UCBC, 'UnitsGreaterAtEnemySE', { 1 , 'MOBILE EXPERIMENTAL' } },
function GetEnemyUnitsSE(aiBrain, unitCount, categoryEnemy, compareType)
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ , 'Enemy')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} '..categoryEnemy..' ['..numEnemyUnits..'] '..compareType..' ['..unitCount..'] return '..repr(CompareBody(numEnemyUnits, unitCount, compareType)))
    return CompareBody(numEnemyUnits, unitCount, compareType)
end
function UnitsLessAtEnemySE(aiBrain, unitCount, categoryEnemy)
    return GetEnemyUnitsSE(aiBrain, unitCount, categoryEnemy, '<')
end
function UnitsGreaterAtEnemySE(aiBrain, unitCount, categoryEnemy)
    return GetEnemyUnitsSE(aiBrain, unitCount, categoryEnemy, '>')
end

function HaveGreaterThanUnitsInCategoryBeingBuiltAtLocationSE(aiBrain, locationType, numReq, category, constructionCat)
    local numUnits
    if constructionCat then
        numUnits = table.getn( GetUnitsBeingBuiltLocationSE(aiBrain, locationType, category, category + (categories.ENGINEER * categories.MOBILE - categories.STATIONASSISTPOD - categories.POD) + constructionCat) or {} )
    else
        numUnits = table.getn( GetUnitsBeingBuiltLocationSE(aiBrain,locationType, category, category + (categories.ENGINEER * categories.MOBILE - categories.STATIONASSISTPOD - categories.POD) ) or {} )
    end
    if numUnits > numReq then
        return true
    end
    return false
end

function GetUnitsBeingBuiltLocationSE(aiBrain, locType, buildingCategory, builderCategory)
    local AIName = ArmyBrains[aiBrain:GetArmyIndex()].Nickname
    local baseposition, radius
    if MAPBASEPOSTITIONSSE[AIName][locType] then
        baseposition = MAPBASEPOSTITIONSSE[AIName][locType].Pos
        radius = MAPBASEPOSTITIONSSE[AIName][locType].Rad
    elseif aiBrain.BuilderManagers[locType] then
        baseposition = aiBrain.BuilderManagers[locType].FactoryManager.Location
        radius = aiBrain.BuilderManagers[locType].FactoryManager:GetLocationRadius()
        MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
        MAPBASEPOSTITIONSSE[AIName][locType] = {Pos=baseposition, Rad=radius}
    elseif aiBrain:PBMHasPlatoonList() then
        for k,v in aiBrain.PBM.Locations do
            if v.LocationType == locType then
                baseposition = v.Location
                radius = v.Radius
                MAPBASEPOSTITIONSSE[AIName] = MAPBASEPOSTITIONSSE[AIName] or {} 
                MAPBASEPOSTITIONSSE[AIName][locType] = {baseposition, radius}
                break
            end
        end
    end
    if not baseposition then
        return false
    end
    local filterUnits = GetOwnUnitsAroundLocationSE(aiBrain, builderCategory, baseposition, radius)
    local retUnits = {}
    for k,v in filterUnits do
        -- Only assist if allowed
        if v.DesiresAssist == false then
            continue
        end
        -- Engineer doesn't want any more assistance
        if v.NumAssistees and table.getn(v:GetGuards()) >= v.NumAssistees then
            continue
        end
        -- skip the unit, if it's not building or upgrading.
        if not v:IsUnitState('Building') and not v:IsUnitState('Upgrading') then
            continue
        end
        if not v.UnitBeingBuilt or not EntityCategoryContains(buildingCategory, v.UnitBeingBuilt) then
            continue
        end
        table.insert(retUnits, v)
    end
    return retUnits
end

function GetOwnUnitsAroundLocationSE(aiBrain, category, location, radius)
    local units = aiBrain:GetUnitsAroundPoint(category, location, radius, 'Ally')
    local index = aiBrain:GetArmyIndex()
    local retUnits = {}
    for _, v in units do
        if not v.Dead and v:GetAIBrain():GetArmyIndex() == index then
            table.insert(retUnits, v)
        end
    end
    return retUnits
end

--            { UCBC, 'CanPathNavalBaseToNavalTargetsSE', {  'LocationType', categories.STRUCTURE * categories.FACTORY * categories.NAVAL }}, -- LocationType, categoryUnits
function CanPathNavalBaseToNavalTargetsSE(aiBrain, locationType, unitCategory)
    local baseposition = aiBrain.BuilderManagers[locationType].FactoryManager.Location
    local Factories = aiBrain.BuilderManagers[locationType].FactoryManager:GetFactories(categories.NAVAL)
    if Factories[1] then
        baseposition = Factories[1]:GetPosition()
    end
    --AILog('Searching water path from base ['..locationType..'] position '..repr(baseposition))
    local EnemyNavalUnits = aiBrain:GetUnitsAroundPoint(unitCategory, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ, 'Enemy')
    for _, EnemyUnit in EnemyNavalUnits do
        if not EnemyUnit.Dead then
            --AILog('checking enemy factories '..repr(EnemyUnit:GetPosition()))
            -- if CanGraphAreaTo(baseposition, EnemyUnit:GetPosition(), 'Water') then
            if NavUtils.CanPathTo('Water', baseposition, EnemyUnit:GetPosition()) then
                --AILog('Found a water path from base ['..locationType..'] to enemy position '..repr(EnemyUnit:GetPosition()))
                return true
            end
        end
    end
    --AILog('Found no path to any target from naval base ['..locationType..']')
    return false
end