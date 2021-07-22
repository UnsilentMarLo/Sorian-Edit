
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

function GeneratePathSorianEdit(aiBrain, startNode, endNode, threatType, threatWeight, destination, location)
    if not aiBrain.PathCache then
        aiBrain.PathCache = {}
    end
    -- create a new path
    aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name].settime = aiBrain.PathCache[startNode.name][endNode.name].settime or GetGameTimeSeconds()

    if aiBrain.PathCache[startNode.name][endNode.name].path and aiBrain.PathCache[startNode.name][endNode.name].path != 'bad'
    and aiBrain.PathCache[startNode.name][endNode.name].settime + 60 > GetGameTimeSeconds() then
        return aiBrain.PathCache[startNode.name][endNode.name].path
    end

    -- Uveso - Clean path cache. Loop over all paths's and remove old ones
    if aiBrain.PathCache then
        local GameTime = GetGameTimeSeconds()
        for StartNode, EndNodeCache in aiBrain.PathCache do
            for EndNode, Path in EndNodeCache do
                if Path.settime and Path.settime + 60 < GameTime then
                    aiBrain.PathCache[StartNode][EndNode] = nil
                end
            end
        end
    end

    threatWeight = threatWeight or 1

    local graph = GetPathGraphs()[startNode.layer][startNode.graphName]

    local closed = {}

    local queue = {
            path = {startNode, },
    }

    if VDist2Sq(location[1], location[3], startNode.position[1], startNode.position[3]) > 10000 and
    SUtils.DestinationBetweenPoints(destination, location, startNode.position) then
        local newPath = {
                path = {newNode = {position = destination}, },
        }
        return newPath
    end

    local lastNode = startNode

    repeat
        if closed[lastNode] then
            --aiBrain.PathCache[startNode.name][endNode.name] = { settime = 36000 , path = 'bad' }
            return false
        end

        closed[lastNode] = true

        local mapSizeX = ScenarioInfo.size[1]
        local mapSizeZ = ScenarioInfo.size[2]

        local lowCost = false
        local bestNode = false

        for i, adjacentNode in lastNode.adjacent do

            local newNode = graph[adjacentNode]

            if not newNode or closed[newNode] then
                continue
            end

            if SUtils.DestinationBetweenPoints(destination, lastNode.position, newNode.position) then
                aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }
                return queue
            end

            local dist = VDist2Sq(newNode.position[1], newNode.position[3], endNode.position[1], endNode.position[3])

            dist = 100 * dist / (mapSizeX + mapSizeZ)

            --get threat from current node to adjacent node
            local threat = aiBrain:GetThreatBetweenPositions(newNode.position, lastNode.position, nil, threatType)

            --update path stuff
            local cost = dist + threat*threatWeight

            if lowCost and cost >= lowCost then
                continue
            end

            bestNode = newNode
            lowCost = cost
        end
        if bestNode then
            table.insert(queue.path,bestNode)
            lastNode = bestNode
        end
    until lastNode == endNode

    aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }

    return queue
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
        local path, reason = PlatoonGenerateSafePathTo(aiBrain, platoon.MovementLayer, platoon:GetPlatoonPosition(), attackPos, platoon.PlatoonData.NodeWeight or 10 )
    
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