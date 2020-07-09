do
function AIPlatoonSquadAttackVector( aiBrain, platoon )

    --Engine handles whether or not we can occupy our vector now, so this should always be a valid, occupiable spot.
    local attackPos = GetBestThreatTarget(aiBrain, platoon)
    
    local bNeedTransports = false
    # if no pathable attack spot found
    if not attackPos then
        # try skipping pathability
        attackPos = GetBestThreatTarget(aiBrain, platoon, true)
        bNeedTransports = true
        if not attackPos then
            platoon:StopAttack()
            return {}
        end
    end


    # avoid mountains by slowly moving away from higher areas
    GetMostRestrictiveLayer(platoon)
    if platoon.MovementLayer == 'Land' then
        local bestPos = attackPos
        local attackPosHeight = GetTerrainHeight(attackPos[1], attackPos[3])
        # if we're land
        if attackPosHeight > GetSurfaceHeight(attackPos[1], attackPos[3]) then
            local lookAroundTable = {1,0,-2,-1,2}
            local squareRadius = (ScenarioInfo.size[1] / 16) / table.getn(lookAroundTable)
            for ix, offsetX in lookAroundTable do
                for iz, offsetZ in lookAroundTable do
                    local surf = GetSurfaceHeight( bestPos[1]+offsetX, bestPos[3]+offsetZ )
                    local terr = GetTerrainHeight( bestPos[1]+offsetX, bestPos[3]+offsetZ )
                    # is it lower land... make it our new position to continue searching around
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
    
    # if we don't have an old path or our old destination and new destination are different
    if oldPathSize == 0 or attackPos[1] != platoon.LastAttackDestination[oldPathSize][1] or
    attackPos[3] != platoon.LastAttackDestination[oldPathSize][3] then
        
        GetMostRestrictiveLayer(platoon)
        # check if we can path to here safely... give a large threat weight to sort by threat first
        local path, reason = PlatoonGenerateSafePathTo(aiBrain, platoon.MovementLayer, platoon:GetPlatoonPosition(), attackPos, platoon.PlatoonData.NodeWeight or 10 )
    
        # clear command queue
        platoon:Stop()    
   
        local usedTransports = false
        local position = platoon:GetPlatoonPosition()
        if (not path and reason == 'NoPath') then
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, true)
        # Require transports over 500 away
        elseif VDist2Sq( position[1], position[3], attackPos[1], attackPos[3] ) > 1200*1200 then
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, true)
        # use if possible at 250
        else
            usedTransports = SendPlatoonWithTransports(aiBrain, platoon, attackPos, false)
        end
        
        if not usedTransports then
            if not path then
                if reason == 'NoStartNode' or reason == 'NoEndNode' then
                    --Couldn't find a valid pathing node. Just use shortest path.
                    platoon:AggressiveMoveToLocation(attackPos)
                end
                # force reevaluation
                platoon.LastAttackDestination = {attackPos}
            else
                local pathSize = table.getn(path)
                # store path
                platoon.LastAttackDestination = path
                # move to new location
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
    
    # return current command queue 
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