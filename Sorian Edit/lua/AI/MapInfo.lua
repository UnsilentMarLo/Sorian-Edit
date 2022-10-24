local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua') -- located in the lua.nx2 part of the FAF gamedata
local Utilities = import('/mods/Sorian Edit/lua/AI/sorianeditutilities.lua')
local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')
local NavUtils = import('/lua/sim/NavUtils.lua')

MassPoints = {} -- Stores position of each mass point (as a position value, i.e. a table with 3 values, x, y, z
HydroPoints = {} -- Stores position values i.e. a table with 3 values, x, y, z

PlayerStartPoints = {} -- Stores position values i.e. a table with 3 values, x, y, z; item 1 = ARMY_1 etc.
EnemyTable = {} -- Stores position values i.e. a table with 3 values, x, y, z; item 1 = ARMY_1 etc.
AllyTable = {} -- Stores position values i.e. a table with 3 values, x, y, z; item 1 = ARMY_1 etc.

MassNearStart = {} -- Stores location of mass extractors that are near to start locations; 1st value is the army number, 2nd value the mex number, 3rd value the position array (which itself is made up of 3 values)
AllFoundPoints = {} -- Stores position of each Valid Naval Area (as a position value, i.e. a table with 3 values, x, y, z
NavalAreaCount = 0 -- Stores count of all Valid Naval Area

MassCount = 0 -- used as a way of checking if have the core markers needed
HydroCount = 0

function RecordPlayerStartLocations(self)
	-- Updates PlayerStartPoints to Record all the possible player start points
	for i = 1, 16 do
		local tempPos = ScenarioUtils.GetMarker('ARMY_'..i).position
		if tempPos ~= nil then
			PlayerStartPoints[i] = tempPos
			-- LOG('* SorianEdit: Recording Player start point, ARMY_'..i..' x=' ..PlayerStartPoints[i][1]..';y='..PlayerStartPoints[i][2]..';z='..PlayerStartPoints[i][3])
		end
	end
	
	local selfIndex = self:GetArmyIndex()
	for _, v in ArmyBrains do
		local iArmy = tonumber(string.sub(v.Name, 6 ))
		local tempPos = ScenarioUtils.GetMarker('ARMY_'..iArmy).position
		
		if IsEnemy(selfIndex, v:GetArmyIndex()) then
			EnemyTable[iArmy] = tempPos
		elseif IsAlly(selfIndex, v:GetArmyIndex()) then
			AllyTable[iArmy] = tempPos
		end
	end
end

function RecordResourceLocations()
    if MassPoints[1] == 0 then
		MassCount = 0
		HydroCount = 0

		for _, v in ScenarioUtils.GetMarkers() do
			if v.type == "Mass" then
				MassCount = MassCount + 1
				MassPoints[MassCount] = v.position
				-- LOG('* SorianEdit: Recording masspoints: co-ordinates = ' ..MassPoints[MassCount][1].. ' - ' ..MassPoints[MassCount][2].. ' - ' ..MassPoints[MassCount][3])
			end -- Mass
			if v.type == "Hydrocarbon" then
				HydroCount = HydroCount + 1
				HydroPoints[HydroCount] = v.position
				-- LOG('* SorianEdit: Recording hydrocarbon points: co-ordinates = ' ..HydroPoints[HydroCount][1].. ' - ' ..HydroPoints[HydroCount][2].. ' - ' ..HydroPoints[HydroCount][3])
			end -- Hydrocarbon
		end -- GetMarkers() loop
		-- MapMexCount = MassCount
	end
end

function RecordMexNearStartPosition(iArmy, iMaxDistance, bCountOnly)
    -- iArmy is the army number, e.g. 1 for ARMY_1; iMaxDistance is the max distance for a mex to be returned
    -- Returns a table containing positions of any mex meeting the criteria, unless bCountOnly is true in which case returns the no. of such mexes
    if bCountOnly == nil then bCountOnly = false end
    local iDistance = 0
    local pStartPos =  PlayerStartPoints[iArmy]
    local NearbyMexPos = {}
    local iMexCount = 0
	-- LOG('-------------------------------RecordMexNearStartPosition for IArmy == '..repr(iArmy))
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
            ---- LOG('* SorianEdit: MapInfo.lua: Nearby mex found, iArmy='..iArmy..'; iMexCount=' ..iMexCount..'pMexPos[1-2-3]='..pMexPos[1]..'-'..pMexPos[2]..'-'..pMexPos[3])
        end
    end
    if bCountOnly == false then return NearbyMexPos
        else return iMexCount
    end

end

AttackVectors = {}
ArmyVectorPoints = {}

function RecordAttackVectorsStartPosition(aiBrain)
    -- create a table of ArmyPositions then populate it with pathable positions for possible attack vectors on each spawn
    -- use this to create possible backdoors into the enemy Base
    local mapSizeX, mapSizeZ = GetMapSize()
    local radius = 50
	
	local selfIndex = tonumber(string.sub(aiBrain.Name, 6 ))
    
    if mapSizeX > 512 and mapSizeZ > 512 then
        radius = 50 * (((mapSizeX+mapSizeZ)/2)/512)
    end
	
    -- LOG('*------------------------------- AI-sorianedit RecordAttackVectorsStartPosition: X:'..repr(mapSizeX)..' Z: '..repr(mapSizeZ))
    -- LOG('*------------------------------- AI-sorianedit RecordAttackVectorsStartPosition:'..repr(radius))
	
    for kp, vp in PlayerStartPoints do
		ArmyVectorPoints[kp] = {}
        local x = vp[1]
        local y = vp[3]
        local z = vp[2]
		local maxdist = VDist2Sq(x, y, PlayerStartPoints[selfIndex][1], PlayerStartPoints[selfIndex][3])
        for i = 1, 12 do
            local angle = i * math.pi / 6
            local ptx, pty = x + radius * math.cos( angle ), y + radius * math.sin( angle )
			-- LOG('*------------------------------- AI-sorianedit RecordAttackVectorsStartPosition: Vector at angle:'..repr(angle)..' Position: '..repr({ptx, z, pty}))
			if NavUtils.CanPathTo('Land', {ptx, z, pty}, vp) then
				if kp == selfIndex then
					ArmyVectorPoints[kp][i] = {ptx, z, pty}
					continue
				end
				-- LOG('*------------------------------- AI-sorianedit RecordAttackVectorsStartPosition: Vector:'..repr(VDist2Sq(ptx, pty, PlayerStartPoints[selfIndex][1], PlayerStartPoints[selfIndex][3]))..' vs Base: '..repr(maxdist))
				if VDist2Sq(ptx, pty, PlayerStartPoints[selfIndex][1], PlayerStartPoints[selfIndex][3]) <= maxdist then
					ArmyVectorPoints[kp][i] = {ptx, z, pty}
				end
			end
        end
    end
end

function EvaluateNavalAreas(iArmy)
    -- local pStartPos =  PlayerStartPoints[iArmy]
    -- AllFoundPoints[NavalAreaCount] = {}
	-- -- LOG('*------------------------------- AI-sorianedit:'..repr(AIAttackUtils.GetPathGraphs()))
	-- local NavalgraphTable = AIAttackUtils.GetPathGraphs()['Water']
	-- local NavalgraphTablePosition = 0
	
	-- -- Count the amount of ponds with NavalAreas inside, the goal is to only have 1 active Naval Area per pond - also check if this NavalArea is relevant, ie able to send units to the enemy
	-- -- single Naval Area per pond
	-- -- make a list of all Naval Areas in 5km range of the Base - 256*256
	
	-- for k, v in ScenarioUtils.GetMarkers() do
		-- if v.type == "Naval Area" then
			-- LOG('*------------------------------- AI-sorianedit: EvaluateNavalAreas: Found Naval Area')
			-- local pMarkerPos = v.position
			-- local Distance = Utilities.GetDistanceBetweenPositions(pStartPos, pMarkerPos)
			-- if Distance <= 256 then
				-- LOG('*------------------------------- AI-sorianedit: EvaluateNavalAreas: Found Naval Area Near Spawn')
				-- local AreaNode = AIAttackUtils.GetClosestPathNodeInRadiusByLayer(pMarkerPos, 30, 'Water')
				-- -- Loop through Graphs, see if the graph contains our Naval Area then remove the graph from our search table, locking any other Area in said graph from being found
				-- if NavalgraphTable then
					-- for name, graph in NavalgraphTable do
						-- for mn, markerInfo in graph do
							-- -- local dist = VDist2Sq(AreaNode.markerInfo[1], AreaNode.markerInfo[3], markerInfo.position[1], markerInfo.position[3])
							-- if AreaNode == markerInfo then
								-- table.remove(NavalgraphTable,NavalgraphTablePosition)
								-- LOG('*------------------------------- AI-sorianedit: EvaluateNavalAreas: Found Naval Area in Graph')
								-- break
							-- end
						-- end
						-- NavalgraphTablePosition = NavalgraphTablePosition + 1
					-- end
				-- end
				-- AllFoundPoints[NavalAreaCount] = v.position
				-- NavalAreaCount = NavalAreaCount + 1
			-- end
		-- end
	-- end
	
	-- if not PondTable[1] == nil then
		-- function CanGraphTo(unit, destPos, layer)
			-- local startNode = GetClosestPathNodeInRadiusByLayer(pStartPos, 256, 'Water')
			-- local endNode = false

			-- if startNode then
				-- endNode = GetClosestPathNodeInRadiusByGraph(destPos, 100, startNode.graphName)
			-- end

			-- if endNode then
				-- return true, endNode.Position
			-- end
		-- end
	-- end
	
	-- -- if we dont have a cached list and we have less valid NavalAreas than ponds with NavalAreas then we Populate this table
	-- if (AllFoundPoints[1] == nil) and (NavalAreaCount < PondCount) then
		-- for _2, v2 in ScenarioUtils.GetMarkers() do
			-- if v2.type == "Mass" then
				-- NavalAreaCount = NavalAreaCount + 1
				-- AllFoundPoints[NavalAreaCount] = v2.position
			-- end
		-- end
	-- end
	
	-- -- also check if these NavalAreas are relevant, ie able to send units to the enemy from there and not at our allies base
	
	-- function CanGraphTo(unit, destPos, layer)
		-- local startNode = GetClosestPathNodeInRadiusByLayer(pMarkerPos, 6, 'Water')
		-- local endNode = false

		-- if startNode then
			-- endNode = GetClosestPathNodeInRadiusByGraph(destPos, 165, startNode.graphName) -- Range of a Battleship + 15 since we are looking at the center of the enemy Base
		-- end

		-- if endNode then
			-- return true, endNode.Position
		-- end
	-- end
	
    -- if NavalAreaCount < 1 then return false
        -- else return MarkerList
    -- end

end
