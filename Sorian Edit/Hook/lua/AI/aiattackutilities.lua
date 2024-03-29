do
WARN('[Sorian Edit Ai Attack Utilities - aiattackutilities.lua ------------------------ '..debug.getinfo(1).currentline..'] ----------------------------- File Offset, subtract 2.')

local NavUtils = import("/lua/sim/navutils.lua")

function PlatoonGenerateSafePathToSorianEdit(aiBrain, platoonLayer, startPos, endPos, optThreatWeight, optMaxMarkerDist, testPathDist)
    -- Only use this with SorianEdit
    -- if not GetPathGraphs()[platoonLayer] then
        -- return false, 'NoGraph'
    -- end

    --Get the closest path node at the platoon's position
    -- optMaxMarkerDist = optMaxMarkerDist or 250
    optThreatWeight = optThreatWeight or 100
	if optThreatWeight < 100 then optThreatWeight = 100 end
	
    -- local startNode
    -- startNode = GetClosestPathNodeInRadiusByLayer(startPos, optMaxMarkerDist, platoonLayer)
    -- if not startNode then return false, 'NoStartNode' end

    -- --Get the matching path node at the destiantion
    -- local endNode = GetClosestPathNodeInRadiusByGraph(endPos, optMaxMarkerDist, startNode.graphName)
    -- if not endNode then return false, 'NoEndNode' end

	local platoonThreatLayer = 'AntiSurface'
	
	if platoonLayer == ('DefaultLand' or 'Land') then
		platoonThreatLayer = 'AntiSurface'
		platoonLayer = 'Land'
	elseif platoonLayer == ('DefaultAir' or 'Air') then
		platoonThreatLayer = 'AntiAir'
		platoonLayer = 'Air'
	elseif platoonLayer == ('DefaultWater' or 'Naval') then
		platoonThreatLayer = 'AntiSurface'
		platoonLayer = 'Naval'
	end
	
    --Generate the safest path between the start and destination
    -- local path = GeneratePathSorianEdit(aiBrain, startNode, endNode, ThreatTable[platoonLayer], optThreatWeight, endPos, startPos)
	-- function PathToWithThreatThreshold(layer, origin, destination, aibrain, threatFunc, threatThreshold, threatRadius)
	
	local path, reason = NavUtils.PathToWithThreatThreshold(platoonLayer, startPos, endPos, aiBrain, NavUtils.ThreatFunctions[platoonThreatLayer], optThreatWeight, aiBrain.IMAPConfig.Rings)
    if not path then return false, reason end

    -- -- Insert the path nodes (minus the start node and end nodes, which are close enough to our start and destination) into our command queue.
    -- -- delete the first and last node only if they are very near (under 30 map units) to the start or end destination.
    -- local finalPath = {}
    -- local NodeCount = table.getn(path.path)
    -- for i,node in path.path do
        -- -- IF this is the first AND not the only waypoint AND its nearer 30 THEN continue and don't add it to the finalpath
        -- if i == 1 and NodeCount > 1 and VDist2(startPos[1], startPos[3], node.position[1], node.position[3]) < 30 then  
            -- continue
        -- end
        -- -- IF this is the last AND not the only waypoint AND its nearer 20 THEN continue and don't add it to the finalpath
        -- if i == NodeCount and NodeCount > 1 and VDist2(endPos[1], endPos[3], node.position[1], node.position[3]) < 20 then  
            -- continue
        -- end
        -- table.insert(finalPath, node.position)
    -- end
    -- in case we have a path with only 2 waypoints and skipped both:
    -- if not finalPath[1] then
        -- table.insert(finalPath, table.copy(endPos))
    -- end
    -- return the path
    return path, 'PathOK'
end

-- local PathIterations = 0

-- -- new function for pathing
-- function GeneratePathSorianEdit(aiBrain, startNode, endNode, threatType, threatWeight, endPos, startPos)
    -- threatWeight = threatWeight or 1
    
    -- -- PathIterations = PathIterations + 1
    
    -- -- local GameTime = GetGameTimeSeconds()
    -- -- LOG('* --------------------------------------- AI-SorianEdit: GeneratePathSorianEdit() called: Gametime = '..GameTime..' Iteration = '..PathIterations)
    
    -- if not aiBrain.PathCache then
        -- aiBrain.PathCache = {}
    -- end
    -- -- create a new path
    -- aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name].settime = aiBrain.PathCache[startNode.name][endNode.name].settime or GetGameTimeSeconds()
	
    -- -- Check if we have this path already cached.
    -- if aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path then
        -- -- Path is not older then 30 seconds. Is it a bad path? (the path is too dangerous)
        -- if aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path == 'bad' then
            -- -- We can't move this way at the moment. Too dangerous.
            -- return false
        -- else
            -- -- The cached path is newer then 30 seconds and not bad. Sounds good :) use it.
            -- return aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path
        -- end
    -- end
    -- -- loop over all path's and remove any path from the cache table that is older then 30 seconds
    -- if aiBrain.PathCache then
        -- local GameTime = GetGameTimeSeconds()
        -- -- loop over all cached paths
        -- for StartNodeName, CachedPaths in aiBrain.PathCache do
            -- -- loop over all paths starting from StartNode
            -- for EndNodeName, ThreatWeightedPaths in CachedPaths do
                -- -- loop over every path from StartNode to EndNode stored by ThreatWeight
                -- for ThreatWeight, PathNodes in ThreatWeightedPaths do
                    -- -- check if the path is older then 30 seconds.
                    -- if GameTime - 30 > PathNodes.settime then
                        -- --AILog('* AI-SorianEdit: GeneratePathSorianEdit() Found old path: storetime: '..PathNodes.settime..' store+60sec: '..(PathNodes.settime + 30)..' actual time: '..GameTime..' timediff= '..(PathNodes.settime + 30 - GameTime) )
                        -- -- delete the old path from the cache.
                        -- aiBrain.PathCache[StartNodeName][EndNodeName][ThreatWeight] = nil
                    -- end
                -- end
            -- end
        -- end
    -- end
    -- -- We don't have a path that is newer then 30 seconds. Let's generate a new one.
    -- --Create path cache table. Paths are stored in this table and saved for 30 seconds, so
    -- --any other platoons needing to travel the same route can get the path without any extra work.
    -- aiBrain.PathCache = aiBrain.PathCache or {}
    -- aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = {}
    -- local fork = {}
    -- -- Is the Start and End node the same OR is the distance to the first node longer then to the destination ?
    -- if startNode.name == endNode.name
    -- or VDist2(startPos[1], startPos[3], startNode.position[1], startNode.position[3]) > VDist2(startPos[1], startPos[3], endPos[1], endPos[3])
    -- or VDist2(startPos[1], startPos[3], endPos[1], endPos[3]) < 50 then
        -- -- store as path only our current destination.
        -- fork.path = { { position = endPos } }
        -- aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = fork }
        -- -- return the destination position as path
        -- return fork
    -- end
    -- -- Set up local variables for our path search
    -- local AlreadyChecked = {}
    -- local curPath = {}
    -- local lastNode = {}
    -- local newNode = {}
    -- local dist = 0
    -- local threat = 0
    -- local lowestpathkey = 1
    -- local lowestcost
    -- local tableindex = 0
    -- local armyIndex = aiBrain:GetArmyIndex()
    -- local enemyIndex = aiBrain:GetCurrentEnemy()
    -- -- Get all the waypoints that are from the same movementlayer than the start point.
    -- local graph = GetPathGraphs()[startNode.layer][startNode.graphName]
    -- -- For the beginning we store the startNode here as first path node.
    -- local queue = {
        -- {
        -- cost = 0,
        -- path = {startNode},
        -- }
    -- }
    -- local table = table
    -- local unpack = unpack
    -- -- local GetThreatFromHeatMap = import('/mods/AI-Uveso/lua/AI/AITargetManager.lua').GetThreatFromHeatMap
    -- -- Now loop over all path's that are stored in queue. If we start, only the startNode is inside the queue
    -- -- (We are using here the "A*(Star) search algorithm". An extension of "Edsger Dijkstra's" pathfinding algorithm used by "Shakey the Robot" in 1959)
    -- while aiBrain.Result ~= "defeat" do
        -- -- remove the table (shortest path) from the queue table and store the removed table in curPath
        -- -- (We remove the path from the queue here because if we don't find a adjacent marker and we
        -- --  have not reached the destination, then we no longer need this path. It's a dead end.)
        -- curPath = table.remove(queue,lowestpathkey)
        -- if not curPath then break end
        -- -- get the last node from the path, so we can check adjacent waypoints
        -- lastNode = curPath.path[table.getn(curPath.path)]
        -- -- Have we already checked this node for adjacenties ? then continue to the next node.
        -- if not AlreadyChecked[lastNode] then
            -- -- Check every node (marker) inside lastNode.adjacent
            -- for i, adjacentNode in lastNode.adjacent do
                -- -- get the node data from the graph table
                -- newNode = graph[adjacentNode]
                -- -- check, if we have found a node.
                -- if newNode then
                    -- -- copy the path from the startNode to the lastNode inside fork,
                    -- -- so we can add a new marker at the end and make a new path with it
                    -- fork = {
                        -- cost = curPath.cost,            -- cost from the startNode to the lastNode
                        -- path = {unpack(curPath.path)},  -- copy full path from starnode to the lastNode
                    -- }
                    -- -- get distance from new node to destination node
                    -- dist = VDist2(newNode.position[1], newNode.position[3], endNode.position[1], endNode.position[3])
                    -- -- get threat from current node to adjacent node
					
					-- --##### aiBrain:GetThreatAtPosition({x,0,z}, 1, true, 'AntiAir', enemy:GetArmyIndex()) -- Other options
					-- --##### local enemyThreat = SUtils.GetThreatAtPosition(aiBrain, {StartX, 0, StartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex) -- Other options
					
                    -- --##### threat = GetThreatFromHeatMap(armyIndex, newNode.position, startNode.layer) -- Uveso
					
					-- threat = aiBrain:GetThreatBetweenPositions(newNode.position, lastNode.position, nil, threatType) -- Vanilla/Sorian
					
                    -- -- add as cost for the path the distance and threat to the overall cost from the whole path
                    -- fork.cost = fork.cost + dist + (threat * 1) * threatWeight
                    -- -- add the newNode at the end of the path
                    -- table.insert(fork.path, newNode)
                    -- -- check if we have reached our destination
                    -- if newNode.name == endNode.name then
                        -- -- store the path inside the path cache
                        -- aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = fork }
                        -- -- return the path
                        -- return fork
                    -- end
                    -- -- add the path to the queue, so we can check the adjacent nodes on the last added newNode
                    -- table.insert(queue,fork)
                -- end
            -- end
            -- -- Mark this node as checked
            -- AlreadyChecked[lastNode] = true
        -- end
        -- -- Search for the shortest / safest path and store the table key in lowestpathkey
        -- lowestcost = 100000000
        -- lowestpathkey = 1
        -- tableindex = 1
        -- while queue[tableindex].cost do
            -- if lowestcost > queue[tableindex].cost then
                -- lowestcost = queue[tableindex].cost
                -- lowestpathkey = tableindex
            -- end
            -- tableindex = tableindex + 1
        -- end
    -- end
    -- -- At this point we have not found any path to the destination.
    -- -- The path is to dangerous at the moment (or there is no path at all). We will check this again in 30 seconds.
    -- aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = 'bad' }
    -- return false
-- end

-- new function for pathing
function GeneratePathSimpleSorianEdit(aiBrain, layer, startPos, endPos)
	local path, reason = NavUtils.PathTo(layer, startPos, endPos)
	return path, reason
end

---@param thresholdLeafSize number      # Minimum size of a leaf to consider it pathable. Size is in ogrids. Defaults to 4
---@param multiplierLeafSize number     # Multiplier to prefer larger leaves. Defaults to 1. Smaller values reduces the preference. A value of 0 removes the preference all together
-- new function for pathing
function GeneratePathDetailedSorianEdit(aiBrain, layer, startPos, endPos, thresholdLeafSize, multiplierLeafSize)
	local path, reason = NavUtils.DetailedPathTo(layer, startPos, endPos, thresholdLeafSize, multiplierLeafSize)
	return path, reason
end

-- edited for new NavMesh
function CheckPlatoonPathingExSE(platoon, destPos)
    local unit = GetMostRestrictiveLayer(platoon)

    --reject invalid spaces
    if destPos[1] < 0 or destPos[3] < 0 or destPos[1] > ScenarioInfo.size[1] or destPos[3] > ScenarioInfo.size[2] then
        return false, destPos
    end

    --only try to path to places on the same layer
    if not unit or unit.Dead then
        return false, destPos
    elseif NavUtils.CanPathTo(platoon.MovementLayer, unit:GetPosition(), destPos) then
		return true, destPos
    else
        if unit:CanPathTo(destPos) then
            return true, destPos
        end
    end

    return false, destPos
end

function EngineerGenerateSafePathToSorianEdit(aiBrain, platoonLayer, startPos, endPos, optThreatWeight, optMaxMarkerDist)
    -- if not GetPathGraphs()[platoonLayer] then
        -- return false, 'NoGraph'
    -- end

    -- --Get the closest path node at the platoon's position
    -- optMaxMarkerDist = optMaxMarkerDist or 250
    -- optThreatWeight = optThreatWeight or 1
    -- local startNode
    -- startNode = GetClosestPathNodeInRadiusByLayer(startPos, optMaxMarkerDist, platoonLayer)
    -- if not startNode then return false, 'NoStartNode' end
	
    optThreatWeight = optThreatWeight or 100
	if optThreatWeight < 100 then optThreatWeight = 100 end

	local platoonThreatLayer = 'AntiSurface'
	
	if platoonLayer == ('DefaultLand' or 'Land') then
		platoonThreatLayer = 'AntiSurface'
		platoonLayer = 'Land'
	elseif platoonLayer == ('DefaultAir' or 'Air') then
		platoonThreatLayer = 'AntiAir'
		platoonLayer = 'Air'
	elseif platoonLayer == ('DefaultWater' or 'Naval') then
		platoonThreatLayer = 'AntiSurface'
		platoonLayer = 'Naval'
	end
	
    -- --Get the matching path node at the destiantion
    -- local endNode = GetClosestPathNodeInRadiusByGraph(endPos, optMaxMarkerDist, startNode.graphName)
    -- if not endNode then return false, 'NoEndNode' end

    --check graph
    -- if not CanGraphAreaTo({startNode.position[1], 0, startNode.position[3]}, {endNode.position[1], 0, endNode.position[3]}, platoonLayer) then
	if not NavUtils.CanPathTo(platoonLayer, startPos, endPos) then
        return false, 'NoPath'
    end

    --Generate the safest path between the start and destination
    -- local path = GeneratePathSorianEdit(aiBrain, startNode, endNode, ThreatTable[platoonLayer], optThreatWeight, endPos, startPos) -- was Uveso
    -- if not path then return false, 'NoPath' end
	local path, reason = NavUtils.PathToWithThreatThreshold(platoonLayer, startPos, endPos, aiBrain, NavUtils.ThreatFunctions[platoonThreatLayer], optThreatWeight, aiBrain.IMAPConfig.Rings)
    if not path then return false, reason end

    -- Insert the path nodes (minus the start node and end nodes, which are close enough to our start and destination) into our command queue.
    -- delete the first and last node only if they are very near (under 30 map units) to the start or end destination.
    -- local finalPath = {}
    -- local NodeCount = table.getn(path.path)
    -- for i,node in path.path do
        -- -- IF this is the first AND not the only waypoint AND its nearer 30 THEN continue and don't add it to the finalpath
        -- if i == 1 and NodeCount > 1 and VDist2(startPos[1], startPos[3], node.position[1], node.position[3]) < 30 then  
            -- continue
        -- end
        -- -- IF this is the last AND not the only waypoint AND its nearer 20 THEN continue and don't add it to the finalpath
        -- if i == NodeCount and NodeCount > 1 and VDist2(endPos[1], endPos[3], node.position[1], node.position[3]) < 20 then  
            -- continue
        -- end
        -- table.insert(finalPath, node.position)
    -- end

    -- return the path
    return path, 'PathOK'
end

function SendPlatoonWithTransportsNoCheckSE(aiBrain, platoon, destination, bRequired, bSkipLastMove)

    GetMostRestrictiveLayer(platoon)

    local units = platoon:GetPlatoonUnits()


    -- only get transports for land (or partial land) movement
    if platoon.MovementLayer == 'Land' or platoon.MovementLayer == 'Amphibious' then

        -- DUNCAN - commented out, why check it?
        -- UVESO - If we reach this point, then we have either a platoon with Land or Amphibious MovementLayer.
        --         Both are valid if we have a Land destination point. But if we have a Amphibious destination
        --         point then we don't want to transport landunits.
        --         (This only happens on maps without AI path markers. Path graphing would prevent this.)
        if platoon.MovementLayer == 'Land' then
            local terrain = GetTerrainHeight(destination[1], destination[2])
            local surface = GetSurfaceHeight(destination[1], destination[2])
            if terrain < surface then
                return false
            end
        end

        -- if we don't *need* transports, then just call GetTransports...
        if not bRequired then
            --  if it doesn't work, tell the aiBrain we want transports and bail
            if AIUtils.GetTransportsSE(platoon) == false then
                aiBrain.WantTransports = true
                return false
            end
        else
            -- we were told that transports are the only way to get where we want to go...
            -- ask for a transport every 10 seconds
            local counter = 0
            local transportsNeeded = AIUtils.GetNumTransports(units)
            local numTransportsNeeded = math.ceil((transportsNeeded.Small + (transportsNeeded.Medium * 2) + (transportsNeeded.Large * 4)) / 10)
            if not aiBrain.NeedTransports then
                aiBrain.NeedTransports = 0
            end
            aiBrain.NeedTransports = aiBrain.NeedTransports + numTransportsNeeded
            if aiBrain.NeedTransports > 10 then
                aiBrain.NeedTransports = 10
            end
            local bUsedTransports, overflowSm, overflowMd, overflowLg = AIUtils.GetTransportsSE(platoon)
            while not bUsedTransports and counter < 9 do --DUNCAN - was 6
                -- if we have overflow, dump the overflow and just send what we can
                if not bUsedTransports and overflowSm+overflowMd+overflowLg > 0 then
                    local goodunits, overflow = AIUtils.SplitTransportOverflow(units, overflowSm, overflowMd, overflowLg)
                    local numOverflow = table.getn(overflow)
                    if table.getn(goodunits) > numOverflow and numOverflow > 0 then
                        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                        for _,v in overflow do
                            if not v.Dead then
                                aiBrain:AssignUnitsToPlatoon(pool, {v}, 'Unassigned', 'None')
                            end
                        end
                        units = goodunits
                    end
                end
                bUsedTransports, overflowSm, overflowMd, overflowLg = AIUtils.GetTransportsSE(platoon)
                if bUsedTransports then
                    break
                end
                counter = counter + 1
                WaitSeconds(10)
                if not aiBrain:PlatoonExists(platoon) then
                    aiBrain.NeedTransports = aiBrain.NeedTransports - numTransportsNeeded
                    if aiBrain.NeedTransports < 0 then
                        aiBrain.NeedTransports = 0
                    end
                    return false
                end

                local survivors = {}
                for _,v in units do
                    if not v.Dead then
                        table.insert(survivors, v)
                    end
                end
                units = survivors

            end

            aiBrain.NeedTransports = aiBrain.NeedTransports - numTransportsNeeded
            if aiBrain.NeedTransports < 0 then
                aiBrain.NeedTransports = 0
            end

            -- couldn't use transports...
            if bUsedTransports == false then
                return false
            end
        end

        -- presumably, if we're here, we've gotten transports
        local transportLocation = false

        --DUNCAN - try the destination directly? Only do for engineers (eg skip last move is true)
        if bSkipLastMove then
            transportLocation = destination
        end

        -- --DUNCAN - try the land path nodefirst , not the transport marker as this will get units closer(thanks to Sorian).
        -- if not transportLocation then
            -- transportLocation = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Land Path Node', destination[1], destination[3])
        -- end
        -- find an appropriate transport marker if it's on the map
        if not transportLocation then
            transportLocation = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Transport Marker', destination[1], destination[3])
        end

        local useGraph = 'Land'
        if not transportLocation then
            -- go directly to destination, do not pass go.  This move might kill you, fyi.
            transportLocation = AIUtils.RandomLocation(destination[1],destination[3]) --Duncan - was platoon:GetPlatoonPosition()
            useGraph = 'Air'
        end

        if transportLocation then
            local minThreat = aiBrain:GetThreatAtPosition(transportLocation, 0, true)
            if minThreat > 0 then
                local threatTable = aiBrain:GetThreatsAroundPosition(transportLocation, 1, true, 'Overall')
                for threatIdx,threatEntry in threatTable do
                    if threatEntry[3] < minThreat then
                        -- if it's land...
                        local terrain = GetTerrainHeight(threatEntry[1], threatEntry[2])
                        local surface = GetSurfaceHeight(threatEntry[1], threatEntry[2])
                        if terrain >= surface  then
                           minThreat = threatEntry[3]
                           transportLocation = {threatEntry[1], 0, threatEntry[2]}
                       end
                    end
                end
            end
        end

        -- path from transport drop off to end location
		-- #PlatoonGenerateSafePathToSorianEdit( aiBrain, platoon, useGraph, transportLocation, destination, 200, 10000) -- using this instead
        -- local path, reason = PlatoonGenerateSafePathTo(aiBrain, useGraph, transportLocation, destination, 200)
        local path, reason = PlatoonGenerateSafePathToSorianEdit( aiBrain, useGraph, transportLocation, destination, 200, 10000)
        -- use the transport!
        AIUtils.UseTransportsSE(units, platoon:GetSquadUnits('Scout'), transportLocation, platoon)

        -- just in case we're still landing...
        for _,v in units do
            if not v.Dead then
                if v:IsUnitState('Attached') then
                   WaitSeconds(2)
                end
            end
        end

        -- check to see we're still around
        if not platoon or not aiBrain:PlatoonExists(platoon) then
            return false
        end

        -- then go to attack location
        if not path then
            -- directly
            if not bSkipLastMove then
                platoon:AggressiveMoveToLocation(destination)
                platoon.LastAttackDestination = {destination}
            end
        else
            -- or indirectly
            -- store path for future comparison
            platoon.LastAttackDestination = path

            local pathSize = table.getn(path)
            --move to destination afterwards
            for wpidx,waypointPath in path do
                if wpidx == pathSize then
                    if not bSkipLastMove then
                        platoon:AggressiveMoveToLocation(waypointPath)
                    end
                else
                    platoon:MoveToLocation(waypointPath, false)
                end
            end
        end
    else
        return false
    end

    return true
end

function AIPlatoonSquadAttackVector( aiBrain, platoon )

    --Engine handles whether or not we can occupy our vector now, so this should always be a valid, occupiable spot.
    local attackPos = GetBestThreatTarget(aiBrain, platoon)
    
    local bNeedTransports = false
    -- if no pathable attack spot found
    if not attackPos then
        -- try skipping pathability
        attackPos = GetBestThreatTarget(aiBrain, platoon, true)
        bNeedTransports = true
        if not attackPos then
            platoon:StopAttack()
            return {}
        end
    end


    -- avoid mountains by slowly moving away from higher areas
    GetMostRestrictiveLayer(platoon)
    if platoon.MovementLayer == 'Land' then
        local bestPos = attackPos
        local attackPosHeight = GetTerrainHeight(attackPos[1], attackPos[3])
        -- if we're land
        if attackPosHeight > GetSurfaceHeight(attackPos[1], attackPos[3]) then
            local lookAroundTable = {1,0,-2,-1,2}
            local squareRadius = (ScenarioInfo.size[1] / 16) / table.getn(lookAroundTable)
            for ix, offsetX in lookAroundTable do
                for iz, offsetZ in lookAroundTable do
                    local surf = GetSurfaceHeight( bestPos[1]+offsetX, bestPos[3]+offsetZ )
                    local terr = GetTerrainHeight( bestPos[1]+offsetX, bestPos[3]+offsetZ )
                    -- is it lower land... make it our new position to continue searching around
                    if terr >= surf and terr < attackPosHeight then
                        bestPos[1] = bestPos[1] + offsetX
                        bestPos[3] = bestPos[3] + offsetZ
                        attackPosHeight = terr
                    end
                end
            end
        end
        attackPos = bestPos
    end
        
    local oldPathSize = table.getn(platoon.LastAttackDestination)
    
    -- if we don't have an old path or our old destination and new destination are different
    if oldPathSize == 0 or attackPos[1] != platoon.LastAttackDestination[oldPathSize][1] or
    attackPos[3] != platoon.LastAttackDestination[oldPathSize][3] then
        
        GetMostRestrictiveLayer(platoon)
        -- check if we can path to here safely... give a large threat weight to sort by threat first
        local path, reason = PlatoonGenerateSafePathToSorianEdit(aiBrain, platoon.MovementLayer, platoon:GetPlatoonPosition(), attackPos, platoon.PlatoonData.NodeWeight or 10, 10000 )
    
        -- clear command queue
        platoon:Stop()    
   
        local usedTransports = false
        local position = platoon:GetPlatoonPosition()
        if (not path and reason == 'NoPath') then
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, true)
        -- Require transports over 500 away
        elseif VDist2Sq( position[1], position[3], attackPos[1], attackPos[3] ) > 1200*1200 then
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, true)
        -- use if possible at 250
        else
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, false)
        end
        
        if not usedTransports then
            if not path then
                if reason == 'NoStartNode' or reason == 'NoEndNode' then
                    --Couldn't find a valid pathing node. Just use shortest path.
                    platoon:AggressiveMoveToLocation(attackPos)
                end
                -- force reevaluation
                platoon.LastAttackDestination = {attackPos}
            else
                local pathSize = table.getn(path)
                -- store path
                platoon.LastAttackDestination = path
                -- move to new location
                for wpidx,waypointPath in path do
                    if wpidx == pathSize then
                        platoon:AggressiveMoveToLocation(waypointPath)
                    else
                        platoon:MoveToLocation(waypointPath, false)
                    end
                end   
            end
        end
    end 
    
    -- return current command queue 
    local cmd = {}
    for k,v in platoon:GetPlatoonUnits() do
        if not v:IsDead() then
            local unitCmdQ = v:GetCommandQueue()
            for cmdIdx,cmdVal in unitCmdQ do
                table.insert(cmd, cmdVal)
                break
            end
        end
    end
    return cmd
end

end