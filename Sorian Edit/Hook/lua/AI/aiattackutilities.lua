do

function PlatoonGenerateSafePathToSorianEdit(aiBrain, platoonLayer, startPos, endPos, optThreatWeight, optMaxMarkerDist, testPathDist)
    -- Only use this with SorianEdit
    if not GetPathGraphs()[platoonLayer] then
        return false, 'NoGraph'
    end

    --Get the closest path node at the platoon's position
    optMaxMarkerDist = optMaxMarkerDist or 250
    optThreatWeight = optThreatWeight or 1
    local startNode
    startNode = GetClosestPathNodeInRadiusByLayer(startPos, optMaxMarkerDist, platoonLayer)
    if not startNode then return false, 'NoStartNode' end

    --Get the matching path node at the destiantion
    local endNode = GetClosestPathNodeInRadiusByGraph(endPos, optMaxMarkerDist, startNode.graphName)
    if not endNode then return false, 'NoEndNode' end

    --Generate the safest path between the start and destination
    local path = GeneratePathSorianEdit(aiBrain, startNode, endNode, ThreatTable[platoonLayer], optThreatWeight, endPos, startPos)
    if not path then return false, 'NoPath' end

    -- Insert the path nodes (minus the start node and end nodes, which are close enough to our start and destination) into our command queue.
    -- delete the first and last node only if they are very near (under 30 map units) to the start or end destination.
    local finalPath = {}
    local NodeCount = table.getn(path.path)
    for i,node in path.path do
        -- IF this is the first AND not the only waypoint AND its nearer 30 THEN continue and don't add it to the finalpath
        if i == 1 and NodeCount > 1 and VDist2(startPos[1], startPos[3], node.position[1], node.position[3]) < 30 then  
            continue
        end
        -- IF this is the last AND not the only waypoint AND its nearer 20 THEN continue and don't add it to the finalpath
        if i == NodeCount and NodeCount > 1 and VDist2(endPos[1], endPos[3], node.position[1], node.position[3]) < 20 then  
            continue
        end
        table.insert(finalPath, node.position)
    end
    -- in case we have a path with only 2 waypoints and skipped both:
    if not finalPath[1] then
        table.insert(finalPath, table.copy(endPos))
    end
    -- return the path
    return finalPath, 'PathOK'
end

-- function GeneratePathSorianEdit(aiBrain, startNode, endNode, threatType, threatWeight, destination, location)
    -- if not aiBrain.PathCache then
        -- aiBrain.PathCache = {}
    -- end
    -- -- create a new path
    -- aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    -- aiBrain.PathCache[startNode.name][endNode.name].settime = aiBrain.PathCache[startNode.name][endNode.name].settime or GetGameTimeSeconds()

    -- if aiBrain.PathCache[startNode.name][endNode.name].path and aiBrain.PathCache[startNode.name][endNode.name].path != 'bad'
    -- and aiBrain.PathCache[startNode.name][endNode.name].settime + 60 > GetGameTimeSeconds() then
        -- return aiBrain.PathCache[startNode.name][endNode.name].path
    -- end

    -- -- Uveso - Clean path cache. Loop over all paths's and remove old ones
    -- if aiBrain.PathCache then
        -- local GameTime = GetGameTimeSeconds()
        -- for StartNode, EndNodeCache in aiBrain.PathCache do
            -- for EndNode, Path in EndNodeCache do
                -- if Path.settime and Path.settime + 60 < GameTime then
                    -- aiBrain.PathCache[StartNode][EndNode] = nil
                -- end
            -- end
        -- end
    -- end
    -- threatWeight = threatWeight or 1

    -- local graph = GetPathGraphs()[startNode.layer][startNode.graphName]
    -- local closed = {}
    -- local queue = { path = {startNode, }, }

    -- if VDist2Sq(location[1], location[3], startNode.position[1], startNode.position[3]) > 10000 and
    -- SUtils.DestinationBetweenPoints(destination, location, startNode.position) then
        -- local newPath = {
                -- path = {newNode = {position = destination}, },
        -- }
        -- return newPath
    -- end

    -- local lastNode = startNode

    -- repeat
        -- if closed[lastNode] then
            -- --aiBrain.PathCache[startNode.name][endNode.name] = { settime = 36000 , path = 'bad' }
            -- return false
        -- end

        -- closed[lastNode] = true
        -- local mapSizeX = ScenarioInfo.size[1]
        -- local mapSizeZ = ScenarioInfo.size[2]
        -- local lowCost = false
        -- local bestNode = false

        -- for i, adjacentNode in lastNode.adjacent do
            -- local newNode = graph[adjacentNode]
            -- if not newNode or closed[newNode] then
                -- continue
            -- end
            -- if SUtils.DestinationBetweenPoints(destination, lastNode.position, newNode.position) then
                -- aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }
                -- return queue
            -- end
            -- local dist = VDist2Sq(newNode.position[1], newNode.position[3], endNode.position[1], endNode.position[3])
            -- dist = 100 * dist / (mapSizeX + mapSizeZ)

            -- --get threat from current node to adjacent node
            -- local threat = aiBrain:GetThreatBetweenPositions(newNode.position, lastNode.position, nil, threatType)
            -- --update path stuff
            -- local cost = dist + threat*threatWeight
            -- if lowCost and cost >= lowCost then
                -- continue
            -- end
            -- bestNode = newNode
            -- lowCost = cost
        -- end
        -- if bestNode then
            -- table.insert(queue.path,bestNode)
            -- lastNode = bestNode
        -- end
    -- until lastNode == endNode
    -- aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }
    -- return queue
-- end

-- new function for pathing
function GeneratePathSorianEdit(aiBrain, startNode, endNode, threatType, threatWeight, endPos, startPos)
    threatWeight = threatWeight or 1
	
    if not aiBrain.PathCache then
        aiBrain.PathCache = {}
    end
    -- create a new path
    aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name].settime = aiBrain.PathCache[startNode.name][endNode.name].settime or GetGameTimeSeconds()
	
    -- Check if we have this path already cached.
    if aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path then
        -- Path is not older then 30 seconds. Is it a bad path? (the path is too dangerous)
        if aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path == 'bad' then
            -- We can't move this way at the moment. Too dangerous.
            return false
        else
            -- The cached path is newer then 30 seconds and not bad. Sounds good :) use it.
            return aiBrain.PathCache[startNode.name][endNode.name][threatWeight].path
        end
    end
    -- loop over all path's and remove any path from the cache table that is older then 30 seconds
    if aiBrain.PathCache then
        local GameTime = GetGameTimeSeconds()
        -- loop over all cached paths
        for StartNodeName, CachedPaths in aiBrain.PathCache do
            -- loop over all paths starting from StartNode
            for EndNodeName, ThreatWeightedPaths in CachedPaths do
                -- loop over every path from StartNode to EndNode stored by ThreatWeight
                for ThreatWeight, PathNodes in ThreatWeightedPaths do
                    -- check if the path is older then 30 seconds.
                    if GameTime - 30 > PathNodes.settime then
                        --AILog('* AI-SorianEdit: GeneratePathSorianEdit() Found old path: storetime: '..PathNodes.settime..' store+60sec: '..(PathNodes.settime + 30)..' actual time: '..GameTime..' timediff= '..(PathNodes.settime + 30 - GameTime) )
                        -- delete the old path from the cache.
                        aiBrain.PathCache[StartNodeName][EndNodeName][ThreatWeight] = nil
                    end
                end
            end
        end
    end
    -- We don't have a path that is newer then 30 seconds. Let's generate a new one.
    --Create path cache table. Paths are stored in this table and saved for 30 seconds, so
    --any other platoons needing to travel the same route can get the path without any extra work.
    aiBrain.PathCache = aiBrain.PathCache or {}
    aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = {}
    local fork = {}
    -- Is the Start and End node the same OR is the distance to the first node longer then to the destination ?
    if startNode.name == endNode.name
    or VDist2(startPos[1], startPos[3], startNode.position[1], startNode.position[3]) > VDist2(startPos[1], startPos[3], endPos[1], endPos[3])
    or VDist2(startPos[1], startPos[3], endPos[1], endPos[3]) < 50 then
        -- store as path only our current destination.
        fork.path = { { position = endPos } }
        aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = fork }
        -- return the destination position as path
        return fork
    end
    -- Set up local variables for our path search
    local AlreadyChecked = {}
    local curPath = {}
    local lastNode = {}
    local newNode = {}
    local dist = 0
    local threat = 0
    local lowestpathkey = 1
    local lowestcost
    local tableindex = 0
    local armyIndex = aiBrain:GetArmyIndex()
    local enemyIndex = aiBrain:GetCurrentEnemy()
    -- Get all the waypoints that are from the same movementlayer than the start point.
    local graph = GetPathGraphs()[startNode.layer][startNode.graphName]
    -- For the beginning we store the startNode here as first path node.
    local queue = {
        {
        cost = 0,
        path = {startNode},
        }
    }
    local table = table
    local unpack = unpack
    local GetThreatFromHeatMap = import('/mods/AI-Uveso/lua/AI/AITargetManager.lua').GetThreatFromHeatMap
    -- Now loop over all path's that are stored in queue. If we start, only the startNode is inside the queue
    -- (We are using here the "A*(Star) search algorithm". An extension of "Edsger Dijkstra's" pathfinding algorithm used by "Shakey the Robot" in 1959)
    while aiBrain.Result ~= "defeat" do
        -- remove the table (shortest path) from the queue table and store the removed table in curPath
        -- (We remove the path from the queue here because if we don't find a adjacent marker and we
        --  have not reached the destination, then we no longer need this path. It's a dead end.)
        curPath = table.remove(queue,lowestpathkey)
        if not curPath then break end
        -- get the last node from the path, so we can check adjacent waypoints
        lastNode = curPath.path[table.getn(curPath.path)]
        -- Have we already checked this node for adjacenties ? then continue to the next node.
        if not AlreadyChecked[lastNode] then
            -- Check every node (marker) inside lastNode.adjacent
            for i, adjacentNode in lastNode.adjacent do
                -- get the node data from the graph table
                newNode = graph[adjacentNode]
                -- check, if we have found a node.
                if newNode then
                    -- copy the path from the startNode to the lastNode inside fork,
                    -- so we can add a new marker at the end and make a new path with it
                    fork = {
                        cost = curPath.cost,            -- cost from the startNode to the lastNode
                        path = {unpack(curPath.path)},  -- copy full path from starnode to the lastNode
                    }
                    -- get distance from new node to destination node
                    dist = VDist2(newNode.position[1], newNode.position[3], endNode.position[1], endNode.position[3])
                    -- get threat from current node to adjacent node
					
					--##### aiBrain:GetThreatAtPosition({x,0,z}, 1, true, 'AntiAir', enemy:GetArmyIndex()) -- Other options
					--##### local enemyThreat = SUtils.GetThreatAtPosition(aiBrain, {StartX, 0, StartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex) -- Other options
					
                    --##### threat = GetThreatFromHeatMap(armyIndex, newNode.position, startNode.layer) -- Uveso
					
					threat = aiBrain:GetThreatBetweenPositions(newNode.position, lastNode.position, nil, threatType) -- Vanilla/Sorian
					
                    -- add as cost for the path the distance and threat to the overall cost from the whole path
                    fork.cost = fork.cost + dist + (threat * 1) * threatWeight
                    -- add the newNode at the end of the path
                    table.insert(fork.path, newNode)
                    -- check if we have reached our destination
                    if newNode.name == endNode.name then
                        -- store the path inside the path cache
                        aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = fork }
                        -- return the path
                        return fork
                    end
                    -- add the path to the queue, so we can check the adjacent nodes on the last added newNode
                    table.insert(queue,fork)
                end
            end
            -- Mark this node as checked
            AlreadyChecked[lastNode] = true
        end
        -- Search for the shortest / safest path and store the table key in lowestpathkey
        lowestcost = 100000000
        lowestpathkey = 1
        tableindex = 1
        while queue[tableindex].cost do
            if lowestcost > queue[tableindex].cost then
                lowestcost = queue[tableindex].cost
                lowestpathkey = tableindex
            end
            tableindex = tableindex + 1
        end
    end
    -- At this point we have not found any path to the destination.
    -- The path is to dangerous at the moment (or there is no path at all). We will check this again in 30 seconds.
    aiBrain.PathCache[startNode.name][endNode.name][threatWeight] = { settime = GetGameTimeSeconds(), path = 'bad' }
    return false
end

function EngineerGenerateSafePathToSorianEdit(aiBrain, platoonLayer, startPos, endPos, optThreatWeight, optMaxMarkerDist)
    if not GetPathGraphs()[platoonLayer] then
        return false, 'NoGraph'
    end

    --Get the closest path node at the platoon's position
    optMaxMarkerDist = optMaxMarkerDist or 250
    optThreatWeight = optThreatWeight or 1
    local startNode
    startNode = GetClosestPathNodeInRadiusByLayer(startPos, optMaxMarkerDist, platoonLayer)
    if not startNode then return false, 'NoStartNode' end

    --Get the matching path node at the destiantion
    local endNode = GetClosestPathNodeInRadiusByGraph(endPos, optMaxMarkerDist, startNode.graphName)
    if not endNode then return false, 'NoEndNode' end

    --Generate the safest path between the start and destination
    local path = EngineerGeneratePathUveso(aiBrain, startNode, endNode, ThreatTable[platoonLayer], optThreatWeight, endPos, startPos)
    if not path then return false, 'NoPath' end

    -- Insert the path nodes (minus the start node and end nodes, which are close enough to our start and destination) into our command queue.
    -- delete the first and last node only if they are very near (under 30 map units) to the start or end destination.
    local finalPath = {}
    local NodeCount = table.getn(path.path)
    for i,node in path.path do
        -- IF this is the first AND not the only waypoint AND its nearer 30 THEN continue and don't add it to the finalpath
        if i == 1 and NodeCount > 1 and VDist2(startPos[1], startPos[3], node.position[1], node.position[3]) < 30 then  
            continue
        end
        -- IF this is the last AND not the only waypoint AND its nearer 20 THEN continue and don't add it to the finalpath
        if i == NodeCount and NodeCount > 1 and VDist2(endPos[1], endPos[3], node.position[1], node.position[3]) < 20 then  
            continue
        end
        table.insert(finalPath, node.position)
    end

    -- return the path
    return finalPath, 'PathOK'
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