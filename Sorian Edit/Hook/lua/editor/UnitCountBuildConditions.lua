
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

local MAPBASEPOSTITIONS = {}
local mapSizeX, mapSizeZ = GetMapSize()

--{ UCBC, 'CanBuildCategory', { categories.RADAR * categories.TECH1 } },
local FactionIndexToCategory = {[1] = categories.UEF, [2] = categories.AEON, [3] = categories.CYBRAN, [4] = categories.SERAPHIM, [5] = categories.NOMADS, [6] = categories.ARM, [7] = categories.CORE }
function CanBuildCategory(aiBrain,category)
    -- convert text categories like 'MOBILE AIR' to 'categories.MOBILE * categories.AIR'
    local FactionCat = FactionIndexToCategory[aiBrain:GetFactionIndex()] or categories.ALLUNITS
    local numBuildableUnits = table.getn(EntityCategoryGetUnitList(category * FactionCat)) or -1
    --AILog('* CanBuildCategory: FactionIndex: ('..repr(aiBrain:GetFactionIndex())..') numBuildableUnits:'..numBuildableUnits..' - '..repr( EntityCategoryGetUnitList(category * FactionCat) ))
    return numBuildableUnits > 0
end

--            { UCBC, 'HaveLessThanUnitsInCategoryBeingUpgrade', { 1, categories.RADAR * categories.TECH1 }},
function HaveUnitsInCategoryBeingUpgrade(aiBrain, numunits, category, compareType)
    -- get all units matching 'category'
    local unitsBuilding = aiBrain:GetListOfUnits(category, false)
    local numBuilding = 0
    -- own armyIndex
    local armyIndex = aiBrain:GetArmyIndex()
    -- loop over all units and search for upgrading units
    for unitNum, unit in unitsBuilding do
        if not unit.Dead and not unit:BeenDestroyed() and unit:IsUnitState('Upgrading') and unit:GetAIBrain():GetArmyIndex() == armyIndex then
            numBuilding = numBuilding + 1
        end
    end
    --AILog(aiBrain:GetArmyIndex()..' HaveUnitsInCategoryBeingUpgrade ( '..numBuilding..' '..compareType..' '..numunits..' ) --  return '..repr(CompareBody(numBuilding, numunits, compareType))..' ')
    return CompareBody(numBuilding, numunits, compareType)
end
function HaveLessThanUnitsInCategoryBeingUpgrade(aiBrain, numunits, category)
    return HaveUnitsInCategoryBeingUpgrade(aiBrain, numunits, category, '<')
end
function HaveGreaterThanUnitsInCategoryBeingUpgrade(aiBrain, numunits, category)
    return HaveUnitsInCategoryBeingUpgrade(aiBrain, numunits, category, '>')
end

-- function GreaterThanGameTime(aiBrain, num) is multiplying the time by 0.5, if we have an cheat AI. But i need the real time here.
--            { UCBC, 'GreaterThanGameTimeSeconds', { 180 } },
function GreaterThanGameTimeSeconds(aiBrain, num)
    if num < GetGameTimeSeconds() then
        return true
    end
    return false
end
--            { UCBC, 'LessThanGameTimeSeconds', { 180 } },
function LessThanGameTimeSeconds(aiBrain, num)
    if num > GetGameTimeSeconds() then
        return true
    end
    return false
end

--            { UCBC, 'HaveUnitRatioVersusCap', { 0.024, '<=', categories.STRUCTURE * categories.FACTORY * categories.LAND } }, -- Maximal 3 factories at 125 unitcap, 12 factories at 500 unitcap...
function HaveUnitRatioVersusCap(aiBrain, ratio, compareType, categoryOwn)
    local numOwnUnits = aiBrain:GetCurrentUnits(categoryOwn)
    local cap = GetArmyUnitCap(aiBrain:GetArmyIndex())
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} ( '..numOwnUnits..' '..compareType..' '..cap..' ) -- ['..ratio..'] -- '..repr(DEBUG)..' :: '..(numOwnUnits / cap)..' '..compareType..' '..cap..' return '..repr(CompareBody(numOwnUnits / cap, ratio, compareType)))
    return CompareBody(numOwnUnits / cap, ratio, compareType)
end

function HaveUnitRatioVersusEnemy(aiBrain, ratio, categoryOwn, compareType, categoryEnemy)
    if ScenarioInfo.Options.OmniCheat == "off" and aiBrain:GetCurrentUnits(categories.STRUCTURE * categories.OMNI) == 0 then
        return true
    end
    local numOwnUnits = aiBrain:GetCurrentUnits(categoryOwn)
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ , 'Enemy')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} ( '..numOwnUnits..' '..compareType..' '..numEnemyUnits..' ) -- ['..ratio..'] -- return '..repr(CompareBody(numOwnUnits / numEnemyUnits, ratio, compareType)))
    return CompareBody(numOwnUnits / numEnemyUnits, ratio, compareType)
end

-- 0.8 = 4:5
--{ UCBC, 'HaveUnitRatioAtLocationRadiusVersusEnemy', { 1.50, 'LocationType', 90, 'STRUCTURE DEFENSE ANTIMISSILE TECH3', '<','SILO NUKE TECH3' } },
function HaveUnitRatioAtLocationRadiusVersusEnemy(aiBrain, ratio, locType, radius, categoryOwn, compareType, categoryEnemy)
    local AIName = ArmyBrains[aiBrain:GetArmyIndex()].Nickname
    local baseposition, radius
    if MAPBASEPOSTITIONS[AIName][locType] then
        baseposition = MAPBASEPOSTITIONS[AIName][locType].Pos
        radius = MAPBASEPOSTITIONS[AIName][locType].Rad
    elseif aiBrain.BuilderManagers[locType] then
        baseposition = aiBrain.BuilderManagers[locType].FactoryManager.Location
        radius = aiBrain.BuilderManagers[locType].FactoryManager:GetLocationRadius()
        MAPBASEPOSTITIONS[AIName] = MAPBASEPOSTITIONS[AIName] or {} 
        MAPBASEPOSTITIONS[AIName][locType] = {Pos=baseposition, Rad=radius}
    elseif aiBrain:PBMHasPlatoonList() then
        for k,v in aiBrain.PBM.Locations do
            if v.LocationType == locType then
                baseposition = v.Location
                radius = v.Radius
                MAPBASEPOSTITIONS[AIName] = MAPBASEPOSTITIONS[AIName] or {} 
                MAPBASEPOSTITIONS[AIName][locType] = {baseposition, radius}
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

function HaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, compareType)
    if not aiBrain.BuilderManagers[locationType] then
        AIWarn('*AI WARNING: HaveEnemyUnitAtLocation - Invalid location - ' .. locationType)
        return false
    elseif not aiBrain.BuilderManagers[locationType].Position then
        AIWarn('*AI WARNING: HaveEnemyUnitAtLocation - Invalid position - ' .. locationType)
        return false
    end
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, aiBrain.BuilderManagers[locationType].Position, radius , 'Enemy')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} radius:['..radius..'] '..repr(DEBUG)..' ['..numEnemyUnits..'] '..compareType..' ['..unitCount..'] return '..repr(CompareBody(numEnemyUnits, unitCount, compareType)))
    return CompareBody(numEnemyUnits, unitCount, compareType)
end
--            { UCBC, 'EnemyUnitsGreaterAtLocationRadius', {  BasePanicZone, 'LocationType', 0, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function EnemyUnitsGreaterAtLocationRadius(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return HaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, '>')
end
--            { UCBC, 'EnemyUnitsLessAtLocationRadius', {  BasePanicZone, 'LocationType', 1, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function EnemyUnitsLessAtLocationRadius(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return HaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, '<')
end

--            { UCBC, 'UnitsLessAtEnemy', { 1 , 'MOBILE EXPERIMENTAL' } },
--            { UCBC, 'UnitsGreaterAtEnemy', { 1 , 'MOBILE EXPERIMENTAL' } },
function GetEnemyUnits(aiBrain, unitCount, categoryEnemy, compareType)
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, Vector(mapSizeX/2,0,mapSizeZ/2), mapSizeX+mapSizeZ , 'Enemy')
    --AILog(aiBrain:GetArmyIndex()..' CompareBody {World} '..categoryEnemy..' ['..numEnemyUnits..'] '..compareType..' ['..unitCount..'] return '..repr(CompareBody(numEnemyUnits, unitCount, compareType)))
    return CompareBody(numEnemyUnits, unitCount, compareType)
end
function UnitsLessAtEnemy(aiBrain, unitCount, categoryEnemy)
    return GetEnemyUnits(aiBrain, unitCount, categoryEnemy, '<')
end
function UnitsGreaterAtEnemy(aiBrain, unitCount, categoryEnemy)
    return GetEnemyUnits(aiBrain, unitCount, categoryEnemy, '>')
end

--            { UCBC, 'EngineerManagerUnitsAtLocation', { 'MAIN', '<=', 100,  'ENGINEER TECH3' } },
function EngineerManagerUnitsAtLocation(aiBrain, LocationType, compareType, numUnits, category)
    local numEngineers = aiBrain.BuilderManagers[LocationType].EngineerManager:GetNumCategoryUnits('Engineers', category)
    --AILog('* EngineerManagerUnitsAtLocation: '..LocationType..' ( engineers: '..numEngineers..' '..compareType..' '..numUnits..' ) -- '..category..' return '..repr(CompareBody( numEngineers, numUnits, compareType )) )
    return CompareBody( numEngineers, numUnits, compareType )
end

function HaveGreaterThanUnitsInCategoryBeingBuiltAtLocation(aiBrain, locationType, numReq, category, constructionCat)
    local numUnits
    if constructionCat then
        numUnits = table.getn( GetUnitsBeingBuiltLocation(aiBrain, locationType, category, category + (categories.ENGINEER * categories.MOBILE - categories.STATIONASSISTPOD - categories.POD) + constructionCat) or {} )
    else
        numUnits = table.getn( GetUnitsBeingBuiltLocation(aiBrain,locationType, category, category + (categories.ENGINEER * categories.MOBILE - categories.STATIONASSISTPOD - categories.POD) ) or {} )
    end
    if numUnits > numReq then
        return true
    end
    return false
end

function GetUnitsBeingBuiltLocation(aiBrain, locType, buildingCategory, builderCategory)
    local AIName = ArmyBrains[aiBrain:GetArmyIndex()].Nickname
    local baseposition, radius
    if MAPBASEPOSTITIONS[AIName][locType] then
        baseposition = MAPBASEPOSTITIONS[AIName][locType].Pos
        radius = MAPBASEPOSTITIONS[AIName][locType].Rad
    elseif aiBrain.BuilderManagers[locType] then
        baseposition = aiBrain.BuilderManagers[locType].FactoryManager.Location
        radius = aiBrain.BuilderManagers[locType].FactoryManager:GetLocationRadius()
        MAPBASEPOSTITIONS[AIName] = MAPBASEPOSTITIONS[AIName] or {} 
        MAPBASEPOSTITIONS[AIName][locType] = {Pos=baseposition, Rad=radius}
    elseif aiBrain:PBMHasPlatoonList() then
        for k,v in aiBrain.PBM.Locations do
            if v.LocationType == locType then
                baseposition = v.Location
                radius = v.Radius
                MAPBASEPOSTITIONS[AIName] = MAPBASEPOSTITIONS[AIName] or {} 
                MAPBASEPOSTITIONS[AIName][locType] = {baseposition, radius}
                break
            end
        end
    end
    if not baseposition then
        return false
    end
    local filterUnits = GetOwnUnitsAroundLocation(aiBrain, builderCategory, baseposition, radius)
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

function GetOwnUnitsAroundLocation(aiBrain, category, location, radius)
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
