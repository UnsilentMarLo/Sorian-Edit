do
local OldPlatoonClass = Platoon
Platoon = Class(OldPlatoonClass) {

    AttackForceAISorian = function(self)
        self:Stop()
        local aiBrain = self:GetBrain()

        -- get units together
        if not self:GatherUnitsSorian() then
            self:PlatoonDisband()
        end

        -- Setup the formation based on platoon functionality

        local enemy = aiBrain:GetCurrentEnemy()

        local platoonUnits = self:GetPlatoonUnits()
        local numberOfUnitsInPlatoon = table.getn(platoonUnits)
        local oldNumberOfUnitsInPlatoon = numberOfUnitsInPlatoon
        local platoonTechLevel = SUtils.GetPlatoonTechLevel(platoonUnits)
        local platoonThreatTable = {4,28,80}
        local stuckCount = 0

        self.PlatoonAttackForce = true
        -- formations have penalty for taking time to form up... not worth it here
        -- maybe worth it if we micro
        --self:SetPlatoonFormationOverride('GrowthFormation')
        local bAggro = self.PlatoonData.AggressiveMove or false
        local PlatoonFormation = self.PlatoonData.UseFormation or 'No Formation'
        self:SetPlatoonFormationOverride(PlatoonFormation)
        local maxRange, selectedWeaponArc, turretPitch = AIAttackUtils.GetLandPlatoonMaxRangeSorian(aiBrain, self)
        --local quickReset = false

        while aiBrain:PlatoonExists(self) do
            local pos = self:GetPlatoonPosition() -- update positions; prev position done at end of loop so not done first time

            -- if we can't get a position, then we must be dead
            if not pos then
                self:PlatoonDisband()
            end


            -- if we're using a transport, wait for a while
            if self.UsingTransport then
                WaitSeconds(10)
                continue
            end

            -- pick out the enemy
            if aiBrain:GetCurrentEnemy() and aiBrain:GetCurrentEnemy().Result == "defeat" then
                aiBrain:PickEnemyLogicSorian()
            end

            -- merge with nearby platoons
            if aiBrain:PlatoonExists(self) then
                self:MergeWithNearbyPlatoonsSorian('AttackForceAISorian', 10)
            end

            -- rebuild formation
            platoonUnits = self:GetPlatoonUnits()
            numberOfUnitsInPlatoon = table.getn(platoonUnits)
            -- if we have a different number of units in our platoon, regather
            local threatatLocation = aiBrain:GetThreatAtPosition(pos, 1, true, 'AntiSurface')
            if (oldNumberOfUnitsInPlatoon != numberOfUnitsInPlatoon) and threatatLocation < 1 then
                self:StopAttack()
                self:SetPlatoonFormationOverride(PlatoonFormation)
                oldNumberOfUnitsInPlatoon = numberOfUnitsInPlatoon
            end

            -- deal with lost-puppy transports
            local strayTransports = {}
            for k,v in platoonUnits do
                if EntityCategoryContains(categories.TRANSPORTATION, v) then
                    table.insert(strayTransports, v)
                end
            end
            if table.getn(strayTransports) > 0 then
                local dropPoint = pos
                dropPoint[1] = dropPoint[1] + Random(-3, 3)
                dropPoint[3] = dropPoint[3] + Random(-3, 3)
                IssueTransportUnload(strayTransports, dropPoint)
                WaitSeconds(10)
                local strayTransports = {}
                for k,v in platoonUnits do
                    local parent = v:GetParent()
                    if parent and EntityCategoryContains(categories.TRANSPORTATION, parent) then
                        table.insert(strayTransports, parent)
                        break
                    end
                end
                if table.getn(strayTransports) > 0 then
                    local MAIN = aiBrain.BuilderManagers.MAIN
                    if MAIN then
                        dropPoint = MAIN.Position
                        IssueTransportUnload(strayTransports, dropPoint)
                        WaitSeconds(30)
                    end
                end
                self.UsingTransport = false
                AIUtils.ReturnTransportsToPool(strayTransports, true)
                platoonUnits = self:GetPlatoonUnits()
            end


            --Disband platoon if it's all air units, so they can be picked up by another platoon
            local mySurfaceThreat = AIAttackUtils.GetSurfaceThreatOfUnits(self)
            if mySurfaceThreat == 0 and AIAttackUtils.GetAirThreatOfUnits(self) > 0 then
                self:PlatoonDisband()
                return
            end

            local cmdQ = {}
            -- fill cmdQ with current command queue for each unit
            for k,v in platoonUnits do
                if not v.Dead then
                    local unitCmdQ = v:GetCommandQueue()
                    for cmdIdx,cmdVal in unitCmdQ do
                        table.insert(cmdQ, cmdVal)
                        break
                    end
                end
            end

            if (oldNumberOfUnitsInPlatoon != numberOfUnitsInPlatoon) then
                maxRange, selectedWeaponArc, turretPitch = AIAttackUtils.GetLandPlatoonMaxRangeSorian(aiBrain, self)
            end

            if not maxRange then maxRange = 50 end

            -- if we're on our final push through to the destination, and we find a unit close to our destination
            --local closestTarget = self:FindClosestUnit('attack', 'enemy', true, categories.ALLUNITS)
            local closestTarget = SUtils.FindClosestUnitPosToAttack(aiBrain, self, 'attack', maxRange + 20, categories.ALLUNITS - categories.AIR - categories.NAVAL - categories.SCOUT, selectedWeaponArc, turretPitch)
            local nearDest = false
            local oldPathSize = table.getn(self.LastAttackDestination)
            if self.LastAttackDestination then
                nearDest = oldPathSize == 0 or VDist3(self.LastAttackDestination[oldPathSize], pos) < 20
            end

            local inWater = AIAttackUtils.InWaterCheck(self)

        -- if we're near our destination and we have a unit closeby to kill, kill it
            if table.getn(cmdQ) <= 1 and closestTarget and nearDest then
                self:StopAttack() 
                if not inWater then
                    self:MoveToLocation(closestTarget:GetPosition(), false)
                else
                    self:AggressiveMoveToLocation(closestTarget:GetPosition())
                end
                cmdQ = {1}
                stuckCount = 0
--              quickReset = true
            -- if we have a target and can attack it, attack!
            elseif closestTarget then
                self:StopAttack()
                self:MoveToLocation(closestTarget:GetPosition(), false)
                cmdQ = {1}
                stuckCount = 0
--              quickReset = true
            -- if we have nothing to do, but still have a path (because of one of the above)
            elseif table.getn(cmdQ) == 0 and oldPathSize > 0 then
                self.LastAttackDestination = {}
                self:StopAttack()
                cmdQ = AIAttackUtils.AIPlatoonSquadAttackVectorSorian(aiBrain, self, bAggro)
                stuckCount = 0
            -- if we have nothing to do, try finding something to do
            elseif table.getn(cmdQ) == 0 then
                self:StopAttack()
                cmdQ = AIAttackUtils.AIPlatoonSquadAttackVectorSorian(aiBrain, self, bAggro)
                stuckCount = 0
            -- if we've been stuck and unable to reach next marker? Ignore nearby stuff and pick another target
            elseif self.LastPosition and VDist2Sq(self.LastPosition[1], self.LastPosition[3], pos[1], pos[3]) < (self.PlatoonData.StuckDistance or 8) then
                stuckCount = stuckCount + 1
                if stuckCount >= 1 then
                    self:StopAttack()
                    self.LastAttackDestination = {}
                    cmdQ = AIAttackUtils.AIPlatoonSquadAttackVectorSorian(aiBrain, self, bAggro)
                    stuckCount = 0
                end
            else
                stuckCount = 0
            end

            self.LastPosition = pos

--[[            if table.getn(cmdQ) == 0 then --and mySurfaceThreat < 4 then
                -- if we have a low threat value, then go and defend an engineer or a base
                if mySurfaceThreat < platoonThreatTable[platoonTechLevel]
                    and mySurfaceThreat > 0 and not self.PlatoonData.NeverGuard
                    and not (self.PlatoonData.NeverGuardEngineers and self.PlatoonData.NeverGuardBases) then
                    --LOG('*DEBUG: Trying to guard')
                    --if platoonTechLevel > 1 then
                    --  return self:GuardExperimentalSorian(self.AttackForceAISorian)
                    --else
                        return self:GuardEngineer(self.AttackForceAISorian)
                    --end
                end

                -- we have nothing to do, so find the nearest base and disband
                if not self.PlatoonData.NeverMerge then
                    return self:ReturnToBaseAISorian()
                end
                WaitSeconds(5)
            else
                -- wait a little longer if we're stuck so that we have a better chance to move
                if quickReset then
                    quickReset = false
                    WaitSeconds(6)
                else ]]--
                WaitSeconds(Random(5,11) + 2 * stuckCount)
                self:PlatoonDisband()
--              end
--            end
        end
    end,

}
end