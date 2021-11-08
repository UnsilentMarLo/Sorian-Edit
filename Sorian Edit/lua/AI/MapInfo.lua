local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua') -- located in the lua.nx2 part of the FAF gamedata
local Utilities = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')

MassPoints = {} -- Stores position of each mass point (as a position value, i.e. a table with 3 values, x, y, z
HydroPoints = {} -- Stores position values i.e. a table with 3 values, x, y, z

PlayerStartPoints = {} -- Stores position values i.e. a table with 3 values, x, y, z; item 1 = ARMY_1 etc.
MassNearStart = {} -- Stores location of mass extractors that are near to start locations; 1st value is the army number, 2nd value the mex number, 3rd value the position array (which itself is made up of 3 values)

MassCount = 0 -- used as a way of checking if have the core markers needed
HydroCount = 0

function RecordPlayerStartLocations()
    -- Updates PlayerStartPoints to Record all the possible player start points
    for i = 1, 16 do
        local tempPos = ScenarioUtils.GetMarker('ARMY_'..i).position
        if tempPos ~= nil then
            PlayerStartPoints[i] = tempPos
            -- LOG('* Micro27AI: Recording Player start point, ARMY_'..i..' x=' ..PlayerStartPoints[i][1]..';y='..PlayerStartPoints[i][2]..';z='..PlayerStartPoints[i][3])
        end
    end
end

function RecordResourceLocations()
    MassCount = 0
    HydroCount = 0

    for _, v in ScenarioUtils.GetMarkers() do
        if v.type == "Mass" then
            MassCount = MassCount + 1
            MassPoints[MassCount] = v.position
            -- LOG('* Micro27AI: Recording masspoints: co-ordinates = ' ..MassPoints[MassCount][1].. ' - ' ..MassPoints[MassCount][2].. ' - ' ..MassPoints[MassCount][3])
        end -- Mass
        if v.type == "Hydrocarbon" then
            HydroCount = HydroCount + 1
            HydroPoints[HydroCount] = v.position
            -- LOG('* Micro27AI: Recording hydrocarbon points: co-ordinates = ' ..HydroPoints[HydroCount][1].. ' - ' ..HydroPoints[HydroCount][2].. ' - ' ..HydroPoints[HydroCount][3])
        end -- Hydrocarbon
    end -- GetMarkers() loop
    -- MapMexCount = MassCount
end

function RecordMexNearStartPosition(iArmy, iMaxDistance, bCountOnly)
    -- iArmy is the army number, e.g. 1 for ARMY_1; iMaxDistance is the max distance for a mex to be returned
    -- Returns a table containing positions of any mex meeting the criteria, unless bCountOnly is true in which case returns the no. of such mexes
    if bCountOnly == nil then bCountOnly = false end
    local iDistance = 0
    local pStartPos =  PlayerStartPoints[iArmy]
    local NearbyMexPos = {}
    local iMexCount = 0
    MassNearStart[iArmy] = {}
    local AllMassPoints = {}
    if MassPoints[1] == nil then
        -- LOG('RecordMexNearStartPosition is being called outside of normal approach')
        local iAllMexCount = 0
        --This is likely being run before main initialisation code
        if ScenarioUtils.GetMarkers() == nil then
            -- LOG('ERROR: RecordMexNearStartPosition: ScenarioUtils.GetMarkers Is Nil')
        end

        for _2, v2 in ScenarioUtils.GetMarkers() do
            if v2.type == "Mass" then
                iAllMexCount = iAllMexCount + 1
                AllMassPoints[iAllMexCount] = v2.position
            end
        end
    else
        AllMassPoints = MassPoints
    end
    for key,pMexPos in AllMassPoints do
        iDistance = Utilities.GetDistanceBetweenPositions(pStartPos, pMexPos)
        if iDistance <= iMaxDistance then
            iMexCount = iMexCount + 1
            MassNearStart[iArmy][iMexCount] = pMexPos
            -- NearbyMexPos[iMexCount] = pMexPos
            ---- LOG('* Micro27AI: MapInfo.lua: Nearby mex found, iArmy='..iArmy..'; iMexCount=' ..iMexCount..'pMexPos[1-2-3]='..pMexPos[1]..'-'..pMexPos[2]..'-'..pMexPos[3])
        end
    end
    if bCountOnly == false then return NearbyMexPos
        else return iMexCount
    end

end
