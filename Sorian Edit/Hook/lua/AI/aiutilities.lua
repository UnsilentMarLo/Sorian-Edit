
-- Hook For AI-SorianEdit.
function EngineerMoveWithSafePathSE(aiBrain, unit, destination)
    -- Only use this with AI-SorianEdit
    if not destination then
        return false
    end
    local pos = unit:GetPosition()
    -- don't check a path if we are in build range
    if VDist2(pos[1], pos[3], destination[1], destination[3]) <= 12 then
        return true
    end

    -- first try to find a path with markers.
    local result, bestPos
    local path, reason = AIAttackUtils.EngineerGenerateSafePathTo(aiBrain, 'Amphibious', pos, destination)
    -- only use CanPathTo for distance closer then 200 and if we can't path with markers
    if reason ~= 'PathOK' then
        -- we will crash the game if we use CanPathTo() on all engineer movments on a map without markers. So we don't path at all.
        if reason == 'NoGraph' then
            result = true
        -- if we have a Graph (AI markers) but not a path, then there is no path. We need a transporter.
        elseif reason == 'NoPath' then
            --AILog('* AI-SorianEdit: EngineerMoveWithSafePath(): No path found ('..math.floor(pos[1])..'/'..math.floor(pos[3])..') to ('..math.floor(destination[1])..'/'..math.floor(destination[3])..')')
        elseif VDist2(pos[1], pos[3], destination[1], destination[3]) < 200 then
            AIDebug('* AI-SorianEdit: EngineerMoveWithSafePath(): EngineerGenerateSafePathTo returned: ('..repr(reason)..') -> executing c-engine function CanPathTo().', true, SorianEditOffsetAiutilitiesLUA)
            -- be really sure we don't try a pathing with a destroyed c-object
            if unit.Dead or unit:BeenDestroyed() or IsDestroyed(unit) then
                AIDebug('* AI-SorianEdit: Unit is death before calling CanPathTo()', true, SorianEditOffsetAiutilitiesLUA)
                return false
            end
            result, bestPos = unit:CanPathTo(destination)
        end
    end
    local bUsedTransports = false
    -- Increase check to 300 for transports
    if ((not result and reason ~= 'PathOK') or VDist2Sq(pos[1], pos[3], destination[1], destination[3]) > 40000) -- 200*200=40000
    and unit.PlatoonHandle and not EntityCategoryContains(categories.COMMAND, unit) then
        -- If we can't path to our destination, we need, rather than want, transports
        local needTransports = not result and reason ~= 'PathOK'
        if VDist2Sq(pos[1], pos[3], destination[1], destination[3]) > 40000 then -- 200*200=40000
            needTransports = true
        end

        bUsedTransports = AIAttackUtils.SendPlatoonWithTransportsNoCheckSE(aiBrain, unit.PlatoonHandle, destination, needTransports, true, false)

        if bUsedTransports then
            return true
        elseif VDist2Sq(pos[1], pos[3], destination[1], destination[3]) > 262144 then -- 515*515=262144
            -- If over 512 and no transports dont try and walk!
            return false
        end
    end

    -- If we're here, we haven't used transports and we can path to the destination
    if result or reason == 'PathOK' then
        if reason ~= 'PathOK' then
            path, reason = AIAttackUtils.EngineerGenerateSafePathTo(aiBrain, 'Amphibious', pos, destination)
        end
        if path then
            local pathSize = table.getn(path)
            -- Move to way points (but not to destination... leave that for the final command)
            for widx, waypointPath in path do
                IssueMove({unit}, waypointPath)
            end
            --IssueMove({unit}, destination)
        else
            IssueMove({unit}, destination)
        end
        return true
    end
    return false
end

---------------------------------------------
-- Utility Function
-- Get and load transports with platoon units
---------------------------------------------
function UseTransportsSE(units, transports, location, transportPlatoon)
    local aiBrain
    for k, v in units do
        if not v.Dead then
            aiBrain = v:GetAIBrain()
            break
        end
    end

    if not aiBrain then
        return false
    end

    -- Load transports
    local transportTable = {}
    local transSlotTable = {}
    if not transports then
        return false
    end

    IssueClearCommands(transports)

    for num, unit in transports do
        local id = unit.UnitId
        if not transSlotTable[id] then
            transSlotTable[id] = GetNumTransportSlots(unit)
        end
        table.insert(transportTable,
            {
                Transport = unit,
                LargeSlots = transSlotTable[id].Large,
                MediumSlots = transSlotTable[id].Medium,
                SmallSlots = transSlotTable[id].Small,
                Units = {}
            }
        )
    end

    local shields = {}
    local remainingSize3 = {}
    local remainingSize2 = {}
    local remainingSize1 = {}
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    for num, unit in units do
        if not unit.Dead then
            if unit:IsUnitState('Attached') then
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
            elseif EntityCategoryContains(categories.url0306 + categories.DEFENSE, unit) then
                table.insert(shields, unit)
            elseif unit:GetBlueprint().Transport.TransportClass == 3 then
                table.insert(remainingSize3, unit)
            elseif unit:GetBlueprint().Transport.TransportClass == 2 then
                table.insert(remainingSize2, unit)
            elseif unit:GetBlueprint().Transport.TransportClass == 1 then
                table.insert(remainingSize1, unit)
            else
                table.insert(remainingSize1, unit)
            end
        end
    end

    local needed = GetNumTransports(units)
    local largeHave = 0
    for num, data in transportTable do
        largeHave = largeHave + data.LargeSlots
    end

    local leftoverUnits = {}
    local currLeftovers = {}
    local leftoverShields = {}
    transportTable, leftoverShields = SortUnitsOnTransports(transportTable, shields, largeHave - needed.Large)

    transportTable, leftoverUnits = SortUnitsOnTransports(transportTable, remainingSize3, -1)

    transportTable, currLeftovers = SortUnitsOnTransports(transportTable, leftoverShields, -1)

    for _, v in currLeftovers do table.insert(leftoverUnits, v) end
    transportTable, currLeftovers = SortUnitsOnTransports(transportTable, remainingSize2, -1)

    for _, v in currLeftovers do table.insert(leftoverUnits, v) end
    transportTable, currLeftovers = SortUnitsOnTransports(transportTable, remainingSize1, -1)

    for _, v in currLeftovers do table.insert(leftoverUnits, v) end
    transportTable, currLeftovers = SortUnitsOnTransports(transportTable, currLeftovers, -1)

    aiBrain:AssignUnitsToPlatoon(pool, currLeftovers, 'Unassigned', 'None')
    if transportPlatoon then
        transportPlatoon.UsingTransport = true
    end

    local monitorUnits = {}
    for num, data in transportTable do
        if not table.empty(data.Units) then
            IssueClearCommands(data.Units)
            IssueTransportLoad(data.Units, data.Transport)
            for k, v in data.Units do table.insert(monitorUnits, v) end
        end
    end

    local attached = true
    repeat
        coroutine.yield(20)
        local allDead = true
        local transDead = true
        for k, v in units do
            if not v.Dead then
                allDead = false
                break
            end
        end
        for k, v in transports do
            if not v.Dead then
                transDead = false
                break
            end
        end
        if allDead or transDead then return false end
        attached = true
        for k, v in monitorUnits do
            if not v.Dead and not v:IsIdleState() then
                attached = false
                break
            end
        end
    until attached

    -- Any units that aren't transports and aren't attached send back to pool
    for k, unit in units do
        if not unit.Dead and not EntityCategoryContains(categories.TRANSPORTATION, unit) then
            if not unit:IsUnitState('Attached') then
                aiBrain:AssignUnitsToPlatoon(pool, {unit}, 'Unassigned', 'None')
            end
        elseif not unit.Dead and EntityCategoryContains(categories.TRANSPORTATION, unit) and table.empty(unit:GetCargo()) then
            ReturnTransportsToPoolSE({unit}, true)
            table.remove(transports, k)
        end
    end

    -- If some transports have no units return to pool
    for k, t in transports do
        if not t.Dead and table.empty(t:GetCargo()) then
            aiBrain:AssignUnitsToPlatoon('ArmyPool', {t}, 'Scout', 'None')
            table.remove(transports, k)
        end
    end

    if not table.empty(transports) then
        -- If no location then we have loaded transports then return true
        if location then
            -- Adding Surface Height, so the transporter get not confused, because the target is under the map (reduces unload time)
            location = {location[1], GetSurfaceHeight(location[1],location[3]), location[3]}
							-- #AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, platoon.MovementLayer, transports[1]:GetPosition(), location, 10, 200 ) New function
            -- local safePath = AIAttackUtils.PlatoonGenerateSafePathTo(aiBrain, 'Air', transports[1]:GetPosition(), location, 200)
            local safePath = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, transportPlatoon, transportPlatoon.MovementLayer, transports[1]:GetPosition(), location, 10, 200 )
            if safePath then
                for _, p in safePath do
                    IssueMove(transports, p)
                end
                IssueMove(transports, location)
                IssueTransportUnload(transports, location)
            else
                IssueMove(transports, location)
                IssueTransportUnload(transports, location)
            end
        else
            return true
        end
    else
        -- If no transports return false
        return false
    end

    local attached = true
    while attached do
        coroutine.yield(20)
        local allDead = true
        for _, v in transports do
            if not v.Dead then
                allDead = false
                break
            end
        end

        if allDead then
            return false
        end

        attached = false
        for num, unit in units do
            if not unit.Dead and unit:IsUnitState('Attached') then
                attached = true
                break
            end
        end
    end

    if transportPlatoon then
        transportPlatoon.UsingTransport = false
    end
    ReturnTransportsToPoolSE(transports, true)

    return true
end

--------------------------------------------------------------------
-- Utility Function
-- Function that gets the correct number of transports for a platoon
--------------------------------------------------------------------
function GetTransportsSE(platoon, units)
    if not units then
        units = platoon:GetPlatoonUnits()
    end

    -- Check for empty platoon
    if table.empty(units) then
        return 0
    end

    local neededTable = GetNumTransports(units)
    local transportsNeeded = false
    if neededTable.Small > 0 or neededTable.Medium > 0 or neededTable.Large > 0 then
        transportsNeeded = true
    end


    local aiBrain = platoon:GetBrain()
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')

    -- Make sure more are needed
    local tempNeeded = {}
    tempNeeded.Small = neededTable.Small
    tempNeeded.Medium = neededTable.Medium
    tempNeeded.Large = neededTable.Large

    local location = platoon:GetPlatoonPosition()
    if not location then
        -- We can assume we have at least one unit here
        location = units[1]:GetPosition()
    end

    if not location then
        return 0
    end

    -- Determine distance of transports from platoon
    local transports = {}
    for _, unit in pool:GetPlatoonUnits() do
        if not unit.Dead and EntityCategoryContains(categories.TRANSPORTATION - categories.uea0203, unit) and not unit:IsUnitState('Busy') and not unit:IsUnitState('TransportLoading') and table.empty(unit:GetCargo()) and unit:GetFractionComplete() == 1 then
            local unitPos = unit:GetPosition()
            local curr = {Unit = unit, Distance = VDist2(unitPos[1], unitPos[3], location[1], location[3]),
                           Id = unit.UnitId}
            table.insert(transports, curr)
        end
    end

    local numTransports = 0
    local transSlotTable = {}
    if not table.empty(transports) then
        local sortedList = {}
        -- Sort distances
        for k = 1, table.getn(transports) do
            local lowest = -1
            local key, value
            for j, u in transports do
                if lowest == -1 or u.Distance < lowest then
                    lowest = u.Distance
                    value = u
                    key = j
                end
            end
            sortedList[k] = value
            -- Remove from unsorted table
            table.remove(transports, key)
        end

        -- Take transports as needed
        for i = 1, table.getn(sortedList) do
            if transportsNeeded and table.empty(sortedList[i].Unit:GetCargo()) and not sortedList[i].Unit:IsUnitState('TransportLoading') then
                local id = sortedList[i].Id
                aiBrain:AssignUnitsToPlatoon(platoon, {sortedList[i].Unit}, 'Scout', 'GrowthFormation')
                numTransports = numTransports + 1
                if not transSlotTable[id] then
                    transSlotTable[id] = GetNumTransportSlots(sortedList[i].Unit)
                end
                local tempSlots = {}
                tempSlots.Small = transSlotTable[id].Small
                tempSlots.Medium = transSlotTable[id].Medium
                tempSlots.Large = transSlotTable[id].Large
                -- Update number of slots needed
                while tempNeeded.Large > 0 and tempSlots.Large > 0 do
                    tempNeeded.Large = tempNeeded.Large - 1
                    tempSlots.Large = tempSlots.Large - 1
                    tempSlots.Medium = tempSlots.Medium - 2
                    tempSlots.Small = tempSlots.Small - 4
                end
                while tempNeeded.Medium > 0 and tempSlots.Medium > 0 do
                    tempNeeded.Medium = tempNeeded.Medium - 1
                    tempSlots.Medium = tempSlots.Medium - 1
                    tempSlots.Small = tempSlots.Small - 2
                end
                while tempNeeded.Small > 0 and tempSlots.Small > 0 do
                    tempNeeded.Small = tempNeeded.Small - 1
                    tempSlots.Small = tempSlots.Small - 1
                end
                if tempNeeded.Small <= 0 and tempNeeded.Medium <= 0 and tempNeeded.Large <= 0 then
                    transportsNeeded = false
                end
            end
        end
    end

    if transportsNeeded then
        ReturnTransportsToPoolSE(platoon:GetSquadUnits('Scout'), false)
        return false, tempNeeded.Small, tempNeeded.Medium, tempNeeded.Large
    else
        platoon.UsingTransport = true
        return numTransports, 0, 0, 0
    end
end

---------------------------------------------------------------------------------------
-- Utility Function
-- Takes transports in platoon, returns them to pool, flys them back to return location
---------------------------------------------------------------------------------------
function ReturnTransportsToPoolSE(units, move)
    -- Put transports back in TPool
    local unit
    if not units then
        return false
    end

    for k, v in units do
        if not v.Dead then
            unit = v
            break
        end
    end

    if not unit then
        return false
    end

    local aiBrain = unit:GetAIBrain()
    local x, z = aiBrain:GetArmyStartPos()
    local position = RandomLocation(x, z)
    -- local safePath, reason = AIAttackUtils.PlatoonGenerateSafePathTo(aiBrain, 'Air', unit:GetPosition(), position, 200)
    local safePath = false
    for k, unit in units do
        if not unit.Dead and EntityCategoryContains(categories.TRANSPORTATION, unit) then
            aiBrain:AssignUnitsToPlatoon('ArmyPool', {unit}, 'Scout', 'None')
            if move then
                if safePath then
                    for _, p in safePath do
                        IssueMove({unit}, p)
                    end
                else
                    IssueMove({unit}, position)
                end
            end
        end
    end
end



-- AI-SorianEdit: Helper function for targeting
function ValidateLayerSorianEdit(UnitPos,MovementLayer)
    -- Air can go everywhere
    if MovementLayer == 'Air' then
        return true
    end
    local TerrainHeight = GetTerrainHeight( UnitPos[1], UnitPos[3] ) -- terran high
    local SurfaceHeight = GetSurfaceHeight( UnitPos[1], UnitPos[3] ) -- water high
    -- Terrain > Surface = Target is on land
    if TerrainHeight >= SurfaceHeight and ( MovementLayer == 'Land' or MovementLayer == 'Amphibious' ) then
        --LOG('AttackLayer '..MovementLayer..' - TerrainHeight > SurfaceHeight. = Target is on land ')
        return true
    end
    -- Terrain < Surface = Target is underwater
    if TerrainHeight < SurfaceHeight and ( MovementLayer == 'Water' or MovementLayer == 'Amphibious' ) then
        --LOG('AttackLayer '..MovementLayer..' - TerrainHeight < SurfaceHeight. = Target is on water ')
        return true
    end

    return false
end

-- AI-SorianEdit: Target function
function AIFindNearestCategoryTargetInRangeSorianEdit(aiBrain, platoon, squad, position, maxRange, MoveToCategories, TargetSearchCategory, enemyBrain)
    if not maxRange then
        LOG('* AI-SorianEdit: AIFindNearestCategoryTargetInRangeSorianEdit: function called with empty "maxRange"' )
        return false, false, false, 'NoRange'
    end
    if not TargetSearchCategory then
        LOG('* AI-SorianEdit: AIFindNearestCategoryTargetInRangeSorianEdit: function called with empty "TargetSearchCategory"' )
        return false, false, false, 'NoCat'
    end
    if not position then
        LOG('* AI-SorianEdit: AIFindNearestCategoryTargetInRangeSorianEdit: function called with empty "position"' )
        return false, false, false, 'NoPos'
    end
    if not platoon then
        LOG('* AI-SorianEdit: AIFindNearestCategoryTargetInRangeSorianEdit: function called with no "platoon"' )
        return false, false, false, 'NoPos'
    end
    local AttackEnemyStrength = platoon.PlatoonData.AttackEnemyStrength or 300
    local platoonUnits = platoon:GetPlatoonUnits()
    local PlatoonStrength = table.getn(platoonUnits)

    if type(TargetSearchCategory) == 'string' then
        TargetSearchCategory = ParseEntityCategory(TargetSearchCategory)
    end
    local enemyIndex = false
    local MyArmyIndex = aiBrain:GetArmyIndex()
    if enemyBrain then
        enemyIndex = enemyBrain:GetArmyIndex()
    end

    local RangeList = { [1] = maxRange }
    if maxRange > 512 then
        RangeList = {
            [1] = 30,
            [1] = 64,
            [2] = 128,
            [2] = 192,
            [3] = 256,
            [3] = 384,
            [4] = 512,
            [5] = maxRange,
        }
    elseif maxRange > 256 then
        RangeList = {
            [1] = 30,
            [1] = 64,
            [2] = 128,
            [2] = 192,
            [3] = 256,
            [4] = maxRange,
        }
    elseif maxRange > 64 then
        RangeList = {
            [1] = 30,
            [2] = maxRange,
        }
    end
    local path = false
    local reason = false
    local UnitWithPath = false
    local UnitNoPath = false
    local count = 0
    local TargetsInRange, EnemyStrength, TargetPosition, category, distance, targetRange, success, bestGoalPos, canAttack, TTime
    for _, range in RangeList do
        TargetsInRange = aiBrain:GetUnitsAroundPoint(TargetSearchCategory, position, range, 'Enemy')
        -- DrawCircle(position, range, '0000FF')
		TTime = GetGameTick()
        for _, v in MoveToCategories do
            category = v
            if type(category) == 'string' then
                category = ParseEntityCategory(category)
            end
            distance = maxRange * maxRange
            -- LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: numTargets '..table.getn(TargetsInRange)..'  ')
            for num, Target in TargetsInRange do
                if Target.Dead or Target:BeenDestroyed() then
                    continue
                end
                TargetPosition = Target:GetPosition()
                EnemyStrength = 0
                -- check if the target is on the same layer then the attacker
                if not ValidateLayerSorianEdit(TargetPosition, platoon.MovementLayer) then continue end
                -- check if we have a special player as enemy
                if enemyBrain and enemyIndex and enemyBrain ~= enemyIndex then continue end
                -- check if the Target is still alive, matches our target priority and can be attacked from our platoon
                canAttack = platoon:CanAttackTarget(squad, Target) or false
                --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: canAttack '..repr(canAttack))
                if not Target.Dead and EntityCategoryContains(category, Target) and canAttack then
                    -- yes... we need to check if we got friendly units with GetUnitsAroundPoint(_, _, _, 'Enemy')
                    if not IsEnemy( MyArmyIndex, Target:GetAIBrain():GetArmyIndex() ) then continue end
                    if Target.ReclaimInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: ReclaimInProgress !!! Ignoring the target.')
                        continue
                    end
                    if Target.CaptureInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: CaptureInProgress !!! Ignoring the target.')
                        continue
                    end
                    targetRange = VDist2Sq(position[1],position[3],TargetPosition[1],TargetPosition[3])
                    --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: targetRange '..repr(targetRange))
                    if targetRange < distance then
                        if not aiBrain:PlatoonExists(platoon) then
                            return false, false, false, 'NoPlatoonExists'
                        end
                        if platoon.MovementLayer == 'Land' then
                            EnemyStrength = aiBrain:GetNumUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) * (categories.DIRECTFIRE + categories.INDIRECTFIRE + categories.GROUNDATTACK) , TargetPosition, 50, 'Enemy' )
                        elseif platoon.MovementLayer == 'Air' then
                            EnemyStrength = aiBrain:GetNumUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) * categories.ANTIAIR , TargetPosition, 60, 'Enemy' )
                        elseif platoon.MovementLayer == 'Water' then
                            EnemyStrength = aiBrain:GetNumUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) * (categories.DIRECTFIRE + categories.INDIRECTFIRE + categories.GROUNDATTACK + categories.ANTINAVY) , TargetPosition, 50, 'Enemy' )
                        elseif platoon.MovementLayer == 'Amphibious' then
                            EnemyStrength = aiBrain:GetNumUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) * (categories.DIRECTFIRE + categories.INDIRECTFIRE + categories.GROUNDATTACK + categories.ANTINAVY) , TargetPosition, 50, 'Enemy' )
                        end
                        --LOG('PlatoonStrength / 100 * AttackEnemyStrength <= '..(PlatoonStrength / 100 * AttackEnemyStrength)..' || EnemyStrength = '..EnemyStrength)
                        -- Only attack if we have a chance to win
                        if PlatoonStrength / 100 * AttackEnemyStrength < EnemyStrength then continue end
                        --coroutine.yield(1)
                        -- LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: PlatoonGenerateSafePathTo ')
                        path, reason = AIAttackUtils.PlatoonGenerateSafePathToSorianEdit(aiBrain, platoon.MovementLayer, position, TargetPosition, platoon.PlatoonData.NodeWeight or 10 )
                        -- Check if we found a path with markers
                        if path then
                            UnitWithPath = Target
                            distance = targetRange
                            --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: Possible target with path. distance '..distance..'  ')
                        -- We don't find a path with markers
                        else
                            -- NoPath happens if we have markers, but can't find a way to the destination. (We need transport)
                            if reason == 'NoPath' then
                                UnitNoPath = Target
                                distance = targetRange
                                --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: Possible target no path. distance '..distance..'  ')
                            -- NoGraph means we have no Map markers. Lets try to path with c-engine command CanPathTo()
                            elseif reason == 'NoGraph' then
                                --coroutine.yield(1)
                                local success, bestGoalPos = AIAttackUtils.CheckPlatoonPathingEx(platoon, TargetPosition)
                                -- check if we found a path with c-engine command.
                                if success then
                                    UnitWithPath = Target
                                    distance = targetRange
                                    --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: Possible target with CanPathTo(). distance '..distance..'  ')
                                    -- break out of the loop, so we don't use CanPathTo too often.
                                    break
                                -- There is no path to the target.
                                else
                                    UnitNoPath = Target
                                    distance = targetRange
                                    --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: Possible target failed CanPathTo(). distance '..distance..'  ')
                                end
                            end
                        end
                    end
                end
                count = count + 1
                if count > 300 then -- 300 
                    coroutine.yield(1)
                    count = 0
                end
                -- DEBUG; use the first target if we can path to it.
                --if UnitWithPath then
                --    return UnitWithPath, UnitNoPath, path, reason
                --end
                -- DEBUG; use the first target if we can path to it.
            end
			TTime = (GetGameTick() - TTime)
            if UnitWithPath then
				-- LOG('*------------------------ AIFindNearestCategoryTargetInRangeSorianEdit: finding nearest Target found Target and path, took: '..TTime..' GameTicks, at: '..maxRange..' range ')
                return UnitWithPath, UnitNoPath, path, reason
            end
        end
    end
	TTime = (GetGameTick() - TTime)
    if UnitNoPath then
		-- LOG('*------------------------ AIFindNearestCategoryTargetInRangeSorianEdit: finding nearest Target found Target but no path, took: '..TTime..' GameTicks, at: '..maxRange..' range ')
        return UnitWithPath, UnitNoPath, path, reason
    end
	-- LOG('*------------------------ AIFindNearestCategoryTargetInRangeSorianEdit: finding nearest Target failed, took: '..TTime..' GameTicks, at: '..maxRange..' range ')
    return false, false, false, 'NoUnitFound'
end

function AIFindNearestCategoryTargetInRangeSorianEditCDRSorianEdit(aiBrain, position, maxRange, MoveToCategories, TargetSearchCategory, enemyBrain)
    if type(TargetSearchCategory) == 'string' then
        TargetSearchCategory = ParseEntityCategory(TargetSearchCategory)
    end
    local enemyIndex = false
    local MyArmyIndex = aiBrain:GetArmyIndex()
    if enemyBrain then
        enemyIndex = enemyBrain:GetArmyIndex()
    end
    local RangeList = { [1] = maxRange }
    if maxRange > 512 then
        RangeList = {
            [1] = 30,
            [1] = 64,
            [2] = 128,
            [2] = 192,
            [3] = 256,
            [3] = 384,
            [4] = 512,
            [5] = maxRange,
        }
    elseif maxRange > 256 then
        RangeList = {
            [1] = 30,
            [1] = 64,
            [2] = 128,
            [2] = 192,
            [3] = 256,
            [4] = maxRange,
        }
    elseif maxRange > 64 then
        RangeList = {
            [1] = 30,
            [2] = maxRange,
        }
    end
    local TargetUnit = false
    local basePostition = aiBrain.BuilderManagers['MAIN'].Position
    local TargetsInRange, EnemyStrength, TargetPosition, category, distance, targetRange, baseTargetRange, canAttack
    for _, range in RangeList do
        TargetsInRange = aiBrain:GetUnitsAroundPoint(TargetSearchCategory, position, range, 'Enemy')
        --DrawCircle(position, range, '0000FF')
        for _, v in MoveToCategories do
            category = v
            if type(category) == 'string' then
                category = ParseEntityCategory(category)
            end
            distance = maxRange
            --LOG('* AIFindNearestCategoryTargetInRangeSorianEdit: numTargets '..table.getn(TargetsInRange)..'  ')
            for num, Target in TargetsInRange do
                if Target.Dead or Target:BeenDestroyed() then
                    continue
                end
                TargetPosition = Target:GetPosition()
                EnemyStrength = 0
                -- check if we have a special player as enemy
                if enemyBrain and enemyIndex and enemyBrain ~= enemyIndex then continue end
                -- check if the Target is still alive, matches our target priority and can be attacked from our platoon
                if not Target.Dead and EntityCategoryContains(category, Target) then
                    -- yes... we need to check if we got friendly units with GetUnitsAroundPoint(_, _, _, 'Enemy')
                    if not IsEnemy( MyArmyIndex, Target:GetAIBrain():GetArmyIndex() ) then continue end
                    if Target.ReclaimInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: ReclaimInProgress !!! Ignoring the target.')
                        continue
                    end
                    if Target.CaptureInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: CaptureInProgress !!! Ignoring the target.')
                        continue
                    end
                    targetRange = VDist2(position[1],position[3],TargetPosition[1],TargetPosition[3])
                    baseTargetRange = VDist2(basePostition[1],basePostition[3],TargetPosition[1],TargetPosition[3])
                    -- check if the target is in range of the ACU and in range of the base
                    -- if targetRange < distance and baseTargetRange < maxRange then
                    if targetRange < distance then
                        TargetUnit = Target
                        distance = targetRange
                    end
                end
            end
            if TargetUnit then
                return TargetUnit
            end
           coroutine.yield(10)
        end
        coroutine.yield(1)
    end
    return TargetUnit
end

function AIFindNearestCategoryTeleportLocationSorianEdit(aiBrain, position, maxRange, MoveToCategories, TargetSearchCategory, enemyBrain)
    if type(TargetSearchCategory) == 'string' then
        TargetSearchCategory = ParseEntityCategory(TargetSearchCategory)
    end
    local enemyIndex = false
    if enemyBrain then
        enemyIndex = enemyBrain:GetArmyIndex()
    end
    local TargetUnit = false
    local TargetsInRange, TargetPosition, category, distance, targetRange, AntiteleportUnits

    TargetsInRange = aiBrain:GetUnitsAroundPoint(TargetSearchCategory, position, maxRange, 'Enemy')
    --LOG('* AIFindNearestCategoryTeleportLocationSorianEdit: numTargets '..table.getn(TargetsInRange)..'  ')
    --DrawCircle(position, range, '0000FF')
    for _, v in MoveToCategories do
        category = v
        if type(category) == 'string' then
            category = ParseEntityCategory(category)
        end
        distance = maxRange
        for num, Target in TargetsInRange do
            if Target.Dead or Target:BeenDestroyed() then
                continue
            end
            TargetPosition = Target:GetPosition()
            -- check if we have a special player as enemy
            if enemyBrain and enemyIndex and enemyBrain ~= enemyIndex then continue end
            -- check if the Target is still alive, matches our target priority and can be attacked from our platoon
            if not Target.Dead and EntityCategoryContains(category, Target) then
                -- yes... we need to check if we got friendly units with GetUnitsAroundPoint(_, _, _, 'Enemy')
                if not IsEnemy( aiBrain:GetArmyIndex(), Target:GetAIBrain():GetArmyIndex() ) then continue end
                targetRange = VDist2(position[1],position[3],TargetPosition[1],TargetPosition[3])
                -- check if the target is in range of the ACU and in range of the base
                if targetRange < distance then
                    -- Check if the target is protected by antiteleporter
                    if categories.ANTITELEPORT then 
                        AntiteleportUnits = aiBrain:GetUnitsAroundPoint(categories.ANTITELEPORT, TargetPosition, 60, 'Enemy')
                        --LOG('* AIFindNearestCategoryTeleportLocationSorianEdit: numAntiteleportUnits '..table.getn(AntiteleportUnits)..'  ')
                        local scrambled = false
                        for i, unit in AntiteleportUnits do
                            -- If it's an ally, then we skip.
                            if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                            local NoTeleDistance = unit:GetBlueprint().Defense.NoTeleDistance
                            if NoTeleDistance then
                                local AntiTeleportTowerPosition = unit:GetPosition()
                                local dist = VDist2(TargetPosition[1], TargetPosition[3], AntiTeleportTowerPosition[1], AntiTeleportTowerPosition[3])
                                if dist and NoTeleDistance >= dist then
                                    --LOG('* AIFindNearestCategoryTeleportLocationSorianEdit: Teleport Destination Scrambled 1 '..repr(TargetPosition)..' - '..repr(AntiTeleportTowerPosition))
                                    scrambled = true
                                    break
                                end
                            end
                        end
                        if scrambled then
                            continue
                        end
                    end
                    --LOG('* AIFindNearestCategoryTeleportLocationSorianEdit: Found a target that is not Teleport Scrambled')
                    TargetUnit = Target
                    distance = targetRange
                end
            end
        end
        if TargetUnit then
            return TargetUnit
        end
       coroutine.yield(10)
    end
    return TargetUnit
end

function AIFindNearestCategoryTargetInCloseRangeSorianEdit(aiBrain, position, maxRange, MoveToCategories, TargetSearchCategory, enemyBrain)
    if type(TargetSearchCategory) == 'string' then
        TargetSearchCategory = ParseEntityCategory(TargetSearchCategory)
    end
    local enemyIndex = false
    local MyArmyIndex = aiBrain:GetArmyIndex()
    if enemyBrain then
        enemyIndex = enemyBrain:GetArmyIndex()
    end
    local RangeList = {
        [1] = 10,
        [2] = maxRange,
        [3] = maxRange + 80,
    }
    local TargetUnit = false
    local TargetsInRange, EnemyStrength, TargetPosition, category, distance, targetRange, baseTargetRange, canAttack
    for _, range in RangeList do
        if not position then
            --WARN('* AI-SorianEdit: AIFindNearestCategoryTargetInCloseRange: position is empty')
            return false
        end
        if not range then
            --WARN('* AI-SorianEdit: AIFindNearestCategoryTargetInCloseRange: range is empty')
            return false
        end
        if not TargetSearchCategory then
            --WARN('* AI-SorianEdit: AIFindNearestCategoryTargetInCloseRange: TargetSearchCategory is empty')
            return false
        end
        TargetsInRange = aiBrain:GetUnitsAroundPoint(TargetSearchCategory, position, range, 'Enemy')
        --DrawCircle(position, range, '0000FF')
        for _, v in MoveToCategories do
            category = v
            if type(category) == 'string' then
                category = ParseEntityCategory(category)
            end
            distance = maxRange
            --LOG('* AIFindNearestCategoryTargetInRange: numTargets '..table.getn(TargetsInRange)..'  ')
            for num, Target in TargetsInRange do
                if Target.Dead or Target:BeenDestroyed() then
                    continue
                end
                TargetPosition = Target:GetPosition()
                EnemyStrength = 0
                -- check if the target is inside a nuke blast radius
                if IsNukeBlastArea(aiBrain, TargetPosition) then continue end
                -- check if we have a special player as enemy
                if enemyBrain and enemyIndex and enemyBrain ~= enemyIndex then continue end
                -- check if the Target is still alive, matches our target priority and can be attacked from our platoon
                if not Target.Dead and EntityCategoryContains(category, Target) then
                    -- yes... we need to check if we got friendly units with GetUnitsAroundPoint(_, _, _, 'Enemy')
                    if not IsEnemy( MyArmyIndex, Target:GetAIBrain():GetArmyIndex() ) then continue end
                    if Target.ReclaimInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: ReclaimInProgress !!! Ignoring the target.')
                        continue
                    end
                    if Target.CaptureInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRangeSorianEdit: CaptureInProgress !!! Ignoring the target.')
                        continue
                    end
                    targetRange = VDist2(position[1],position[3],TargetPosition[1],TargetPosition[3])
                    -- check if the target is in range of the unit and in range of the base
                    if targetRange < distance then
                        TargetUnit = Target
                        distance = targetRange
                    end
                end
            end
            if TargetUnit then
                return TargetUnit
            end
           coroutine.yield(10)
        end
        coroutine.yield(1)
    end
    return TargetUnit
end

function points(original,radius,num)
    local nnn=0
    local coords = {}
    while nnn < num do
        local xxx = 0
        local yyy = 0
        xxx = original[1] + radius * math.cos (nnn/num* (2 * math.pi))
        yyy = original[3] + radius * math.sin (nnn/num* (2 * math.pi))
        table.insert(coords, {xxx, yyy})
        nnn = nnn + 1
    end
    for k, v in ipairs(coords) do
    print(v[1]..':'..v[2])
    end
end

local originalcoords = { 233.5, 25.239820480347, 464.5, type="VECTOR3" }

points(originalcoords, 20, 6)