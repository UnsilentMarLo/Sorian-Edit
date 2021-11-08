----------------------------------------------------------------------------
--
--  File     :  /lua/AI/sorianeditutilities.lua
--  Author(s): Michael Robbins aka Sorian
--
--  Summary  : Utility functions for the Sorian AIs
--
----------------------------------------------------------------------------

local AIUtils = import('/lua/ai/aiutilities.lua')
local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utils = import('/lua/utilities.lua')
local Mods = import('/lua/mods.lua')

local AIChatText = import('/mods/Sorian edit/lua/AI/sorianeditlang.lua').AIChatText

-- Table of AI taunts orginized by faction
local AITaunts = {
    {3,4,5,6,7,8,9,10,11,12,14,15,16}, -- Aeon
    {19,21,23,24,26,27,28,29,30,31,32}, -- UEF
    {33,34,35,36,37,38,39,40,41,43,46,47,48}, -- Cybran
    {49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64}, -- Seraphim
}

function T4Timeout(aiBrain)
    WaitSeconds(30)
    aiBrain.T4Building = false
end

function split(str, delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from , delim_from-1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

-- -----------------------------------------------------
--    Function: XZDistanceTwoVectorsSq
--    Args:
--        v1            - Position 1
--        v2            - Position 2
--    Description:
--        Gets the distance squared between 2 points.
--    Returns:
--        Distance
-- -----------------------------------------------------
function XZDistanceTwoVectorsSq(v1, v2)
    if not v1 or not v2 then return false end
    return VDist2Sq(v1[1], v1[3], v2[1], v2[3])
end

function AICheckForWeakEnemyBase(aiBrain)
    if aiBrain:GetCurrentEnemy() and table.getn(aiBrain.AirAttackPoints) == 0 then
        local enemy = aiBrain:GetCurrentEnemy()
        local x,z = enemy:GetArmyStartPos()
        local enemyBaseThreat = aiBrain:GetThreatAtPosition({x,0,z}, 1, true, 'AntiAir', enemy:GetArmyIndex())
        local bomberThreat = 0
        local bombers = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.AIR * (categories.BOMBER + categories.GROUNDATTACK), {x,0,z}, 10000)
        for k, unit in bombers do
            bomberThreat = bomberThreat + unit:GetBlueprint().Defense.SurfaceThreatLevel
        end
        if bomberThreat > enemyBaseThreat then
            table.insert(aiBrain.AirAttackPoints,
                {
                Position = {x,0,z},
                }
            )
            aiBrain:ForkThread(aiBrain.AirAttackPointsTimeout, {x,0,z}, enemy)
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandleIntelData
--    Args:
--        aiBrain           - AI Brain
--    Description:
--        Lets the AI handle intel data.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandleIntelData(aiBrain)
    local numchecks = 0
    local checkspertick = 5
    for _, intel in aiBrain.InterestList.HighPriority do
        numchecks = numchecks + 1
        if intel.Type == 'StructuresNotMex' then
            AIHandleStructureIntel(aiBrain, intel)
        elseif intel.Type == 'Commander' then
            AIHandleACUIntel(aiBrain, intel)
        -- elseif intel.Type == 'Experimental' then
        --  AIHandleT4Intel(aiBrain, intel)
        elseif intel.Type == 'Artillery' then
            AIHandleArtilleryIntel(aiBrain, intel)
        elseif intel.Type == 'Land' then
            AIHandleLandIntel(aiBrain, intel)
        end
        -- Reduce load on game
        if numchecks > checkspertick then
            WaitTicks(1)
            numchecks = 0
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandleStructureIntel
--    Args:
--        aiBrain           - AI Brain
--      intel           - Table of intel data
--    Description:
--        Handles structure intel.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandleStructureIntel(aiBrain, intel)
    for subk, subv in aiBrain.BaseMonitor.AlertsTable do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for subk, subv in aiBrain.AttackPoints do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for k,v in aiBrain.BuilderManagers do
        local basePos = v.EngineerManager:GetLocationCoords()
        -- If intel is within 300 units of a base
        if VDist2Sq(intel.Position[1], intel.Position[3], basePos[1], basePos[3]) < 90000 then
            -- Bombard the location
            table.insert(aiBrain.AttackPoints,
                {
                Position = intel.Position,
                }
            )
            aiBrain:ForkThread(aiBrain.AttackPointsTimeout, intel.Position)
            -- Set an alert for the location
            table.insert(aiBrain.BaseMonitor.AlertsTable,
                {
                Position = intel.Position,
                Threat = 350,
                }
            )
            aiBrain.BaseMonitor.AlertSounded = true
            aiBrain:ForkThread(aiBrain.BaseMonitorAlertTimeout, intel.Position, 'Overall')
            aiBrain.BaseMonitor.ActiveAlerts = aiBrain.BaseMonitor.ActiveAlerts + 1
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandleACUIntel
--    Args:
--        aiBrain           - AI Brain
--      intel           - Table of intel data
--    Description:
--        Handles ACU intel.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandleACUIntel(aiBrain, intel)
    local bombard = true
    local attack = true
    for subk, subv in aiBrain.BaseMonitor.AlertsTable do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            attack = false
            break
        end
    end
    for subk, subv in aiBrain.AttackPoints do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            bombard = false
            break
        end
    end
    if bombard then
        -- Bombard the location
        table.insert(aiBrain.AttackPoints,
            {
            Position = intel.Position,
            }
        )
        aiBrain:ForkThread(aiBrain.AttackPointsTimeout, intel.Position)
    end
    if attack then
        local bomberThreat = 0
        local bombers = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.AIR * (categories.BOMBER + categories.GROUNDATTACK), intel.Position, 500)
        for k, unit in bombers do
            bomberThreat = bomberThreat + unit:GetBlueprint().Defense.SurfaceThreatLevel
        end
        -- If AntiAir threat level is less than our bomber threat around the ACU
        if aiBrain:GetThreatAtPosition(intel.Position, 1, true, 'AntiAir') < bomberThreat then
            -- Set an alert for the location
            table.insert(aiBrain.BaseMonitor.AlertsTable,
                {
                Position = intel.Position,
                Threat = 350,
                }
            )
            aiBrain.BaseMonitor.AlertSounded = true
            aiBrain:ForkThread(aiBrain.BaseMonitorAlertTimeout, intel.Position)
            aiBrain.BaseMonitor.ActiveAlerts = aiBrain.BaseMonitor.ActiveAlerts + 1
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandleArtilleryIntel
--    Args:
--        aiBrain           - AI Brain
--      intel           - Table of intel data
--    Description:
--        Handles Artillery intel.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandleArtilleryIntel(aiBrain, intel)
    for subk, subv in aiBrain.BaseMonitor.AlertsTable do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for subk, subv in aiBrain.AttackPoints do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for k,v in aiBrain.BuilderManagers do
        local basePos = v.EngineerManager:GetLocationCoords()
        -- If intel is within 950 units of a base
        if VDist2Sq(intel.Position[1], intel.Position[3], basePos[1], basePos[3]) < 902500 then
            -- Bombard the location
            table.insert(aiBrain.AttackPoints,
                {
                Position = intel.Position,
                }
            )
            aiBrain:ForkThread(aiBrain.AttackPointsTimeout, intel.Position)
            -- Set an alert for the location
            table.insert(aiBrain.BaseMonitor.AlertsTable,
                {
                Position = intel.Position,
                Threat = intel.Threat,
                }
            )
            aiBrain.BaseMonitor.AlertSounded = true
            aiBrain:ForkThread(aiBrain.BaseMonitorAlertTimeout, intel.Position, 'Economy')
            aiBrain.BaseMonitor.ActiveAlerts = aiBrain.BaseMonitor.ActiveAlerts + 1
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandleLandIntel
--    Args:
--        aiBrain           - AI Brain
--      intel           - Table of intel data
--    Description:
--        Handles land unit intel.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandleLandIntel(aiBrain, intel)
    for subk, subv in aiBrain.BaseMonitor.AlertsTable do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for subk, subv in aiBrain.TacticalBases do
        if intel.Position[1] == subv.Position[1] and intel.Position[3] == subv.Position[3] then
            return
        end
    end
    for k,v in aiBrain.BuilderManagers do
        local basePos = v.EngineerManager:GetLocationCoords()
        -- If intel is within 100 units of a base we don't want this spot
        if VDist2Sq(intel.Position[1], intel.Position[3], basePos[1], basePos[3]) < 10000 then
            return
        end
    end
    -- Mark location for a defensive point
    nextBase = (table.getn(aiBrain.TacticalBases) + 1)
    table.insert(aiBrain.TacticalBases,
        {
        Position = intel.Position,
        Name = 'IntelBase'..nextBase,
        }
)
    -- Set an alert for the location
    table.insert(aiBrain.BaseMonitor.AlertsTable,
        {
        Position = intel.Position,
        Threat = intel.Threat,
        }
)
    aiBrain.BaseMonitor.AlertSounded = true
    aiBrain:ForkThread(aiBrain.BaseMonitorAlertTimeout, intel.Position)
    aiBrain.BaseMonitor.ActiveAlerts = aiBrain.BaseMonitor.ActiveAlerts + 1
end

-- -----------------------------------------------------
--    Function: GetThreatAtPosition
--    Args:
--        aiBrain       - AI Brain
--        pos           - Position to check for threat
--      rings           - Rings to check
--      ttype           - Threat type
--      threatFilters   - Table of threats to filter
--    Description:
--        Checks for threat level at a location and allows filtering of threat types.
--    Returns:
--        Threat level
-- -----------------------------------------------------
function GetThreatAtPosition(aiBrain, pos, rings, ttype, threatFilters, enemyIndex)
    local threat
    if enemyIndex then
        threat = aiBrain:GetThreatAtPosition(pos, rings, true, ttype, enemyIndex)
    else
        threat = aiBrain:GetThreatAtPosition(pos, rings, true, ttype)
    end
    for k,v in threatFilters do
        local rthreat
        if enemyIndex then
            rthreat = aiBrain:GetThreatAtPosition(pos, rings, true, v, enemyIndex)
        else
            rthreat = aiBrain:GetThreatAtPosition(pos, rings, true, v)
        end
        threat = threat - rthreat
    end
    return threat
end

-- -----------------------------------------------------
--    Function: ThreatBugcheck
--    Args:
--        aiBrain       - AI Brain
--    Description:
--        Checks to see if the current enemy has a much higher threat. this can indicate inflated threat or
--      that the AI is close to death. This can allow the AI to send units even if the threat is bugged
--      or give the AI a last stand ability. Throttled to check every 10 seconds at most.
--    Returns:
--        true or false
-- -----------------------------------------------------
function ThreatBugcheck(aiBrain)
    if not aiBrain:GetCurrentEnemy() then return false end
    if aiBrain.LastThreatBugCheckTime and aiBrain.LastThreatBugCheckTime + 10 > GetGameTimeSeconds() then
        return aiBrain.LastThreatBugCheckResult
    end
    local myStartX, myStartZ = aiBrain:GetArmyStartPos()
    local myIndex = aiBrain:GetArmyIndex()

    local estartX, estartZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
    local enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()

    local enemyThreat = aiBrain:GetThreatAtPosition({estartX, 0, estartZ}, 1, true, 'Overall', enemyIndex)
    local myThreat = 0 --aiBrain:GetThreatAtPosition({myStartX, 0, myStartZ}, 1, true, 'Overall', myIndex)
    local unitThreat = 0
    local units = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.ALLUNITS, {myStartX, 0, myStartZ}, 200)
    for k,v in units do
        if not v.Dead then
            unitThreat = (v:GetBlueprint().Defense.SurfaceThreatLevel or 0) + (v:GetBlueprint().Defense.AirThreatLevel or 0) + (v:GetBlueprint().Defense.SubThreatLevel or 0) + (v:GetBlueprint().Defense.EconomyThreatLevel or 0)
            myThreat = myThreat + unitThreat
        end
    end
    -- LOG('*AI DEBUG: ThreatBugcheck Units: '..table.getn(units)..' Me: '..myThreat..' Enemy: '..enemyThreat)
    aiBrain.LastThreatBugCheckTime = GetGameTimeSeconds()
    aiBrain.LastThreatBugCheckResult = enemyThreat * 3 > myThreat
    if enemyThreat > myThreat * 3 then
        --LOG('*AI DEBUG: Threat is bugged!')
        return true
    end
    return false
end

-- -----------------------------------------------------
--    Function: CheckForMapMarkers
--    Args:
--        aiBrain       - AI Brain
--    Description:
--        Checks for Land Path Node map marker to verify the map has the appropriate AI markers.
--    Returns:
--        nil
-- -----------------------------------------------------
function CheckForMapMarkers(aiBrain)
    local startX, startZ = aiBrain:GetArmyStartPos()
    local LandMarker = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Land Path Node', startX, startZ)
    if not LandMarker then
        return false
    end
    return true
end

-- -----------------------------------------------------
--    Function: AddCustomUnitSupport
--    Args:
--        aiBrain       - AI Brain
--    Description:
--        Adds support for custom units.
--    Returns:
--        nil
-- -----------------------------------------------------
function AddCustomUnitSupport(aiBrain)
    aiBrain.CustomUnits = {}
    -- Loop through active mods
    for i, m in __active_mods do
        -- If mod has a CustomUnits folder
        local CustomUnitFiles = DiskFindFiles(m.location..'/lua/CustomUnits', '*.lua')
        -- Loop through files in CustomUnits folder
        for k, v in CustomUnitFiles do
            local tempfile = import(v).UnitList
            -- Add each files entry into the appropriate table
            for plat, tbl in tempfile do
                for fac, entry in tbl do
                    if aiBrain.CustomUnits[plat] and aiBrain.CustomUnits[plat][fac] then
                        table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                    elseif aiBrain.CustomUnits[plat] then
                        aiBrain.CustomUnits[plat][fac] = {}
                        table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                    else
                        aiBrain.CustomUnits[plat] = {}
                        aiBrain.CustomUnits[plat][fac] = {}
                        table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                    end
                end
            end
        end
    end
    -- FAF addition start, adds custom unit support to .scd mods
    local CustomUnitFiles = DiskFindFiles('/lua/CustomUnits', '*.lua')
    for k, v in CustomUnitFiles do
        local tempfile = import(v).UnitList
        -- Add each files entry into the appropriate table
        for plat, tbl in tempfile do
            for fac, entry in tbl do
                if aiBrain.CustomUnits[plat] and aiBrain.CustomUnits[plat][fac] then
                    table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                elseif aiBrain.CustomUnits[plat] then
                    aiBrain.CustomUnits[plat][fac] = {}
                    table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                else
                    aiBrain.CustomUnits[plat] = {}
                    aiBrain.CustomUnits[plat][fac] = {}
                    table.insert(aiBrain.CustomUnits[plat][fac], { entry[1], entry[2] })
                end
            end
        end
    end
    -- FAF addition end
end

-- Unused (used for Nomads)
function AddCustomFactionSupport(aiBrain)
    aiBrain.CustomFactions = {}
    for i, m in __active_mods do
        -- LOG('*AI DEBUG: Checking mod: '..m.name..' for custom factions')
        local CustomFacFiles = DiskFindFiles(m.location..'/lua/CustomFactions', '*.lua')
        -- LOG('*AI DEBUG: Custom faction files found: '..repr(CustomFacFiles))
        for k, v in CustomFacFiles do
            local tempfile = import(v).FactionList
            for x, z in tempfile do
                -- LOG('*AI DEBUG: Adding faction: '..z.cat)
                table.insert(aiBrain.CustomFactions, z)
            end
        end
    end
end

-- -----------------------------------------------------
--    Function: GetTemplateReplacement
--    Args:
--        aiBrain       - AI Brain
--        building      - Unit type to find a replacement for
--        faction       - AI Faction
--    Description:
--        Finds a custom engineer built unit to replace a default one.
--    Returns:
--        Custom Unit or false
-- -----------------------------------------------------
function GetTemplateReplacement(aiBrain, building, faction, buildingTmpl)
    local retTemplate = false
    local templateData = aiBrain.CustomUnits[building]
    -- check if we have an original building
    local BuildingExist = nil
    for k,v in buildingTmpl do
        if v[1] == building then
            BuildingExist = true
            break
        end
    end
    -- If there are Custom Units for this unit type and faction
    if templateData and templateData[faction] then
        local rand = Random(1,100)
        local possibles = {}
        -- Add all the possibile replacements into a table
        for k,v in templateData[faction] do
            if rand <= v[2] or not BuildingExist then
                table.insert(possibles, v[1])
            end
        end
        -- If we found a possibility
        if table.getn(possibles) > 0 then
            rand = Random(1,table.getn(possibles))
            local customUnitID = possibles[rand]
            retTemplate = { { building, customUnitID, } }
        end
    end
    return retTemplate
end

function GetEngineerFaction(engineer)
    if EntityCategoryContains(categories.UEF, engineer) then
        return 'UEF'
    elseif EntityCategoryContains(categories.AEON, engineer) then
        return 'Aeon'
    elseif EntityCategoryContains(categories.CYBRAN, engineer) then
        return 'Cybran'
    elseif EntityCategoryContains(categories.SERAPHIM, engineer) then
        return 'Seraphim'
    elseif EntityCategoryContains(categories.NOMADS, engineer) then
        return 'Nomads'
    else
        return false
    end
end

function GetPlatoonTechLevel(platoonUnits)
    local highest = false
    for k,v in platoonUnits do
        if EntityCategoryContains(categories.TECH3, v) then
            highest = 3
        elseif EntityCategoryContains(categories.TECH2, v) and highest < 3 then
            highest = 2
        elseif EntityCategoryContains(categories.TECH1, v) and highest < 2 then
            highest = 1
        end
        if highest == 3 then break end
    end
    return highest
end

-- -----------------------------------------------------
--    Function: CanRespondEffectively
--    Args:
--        aiBrain       - AI Brain
--        location          - Distress response location
--      platoon         - Platoon to check for
--    Description:
--        Checks to see if the platoon can attack units in the distress area.
--    Returns:
--        true or false
-- -----------------------------------------------------
function CanRespondEffectively(aiBrain, location, platoon)
    -- Get units in area
    local targets = aiBrain:GetUnitsAroundPoint(categories.ALLUNITS, location, 32, 'Enemy')
    -- If threat of platoon is the same as the threat in the distess area
    if AIAttackUtils.GetAirThreatOfUnits(platoon) > 0 and aiBrain:GetThreatAtPosition(location, 0, true, 'Air') > 0 then
        return true
    elseif AIAttackUtils.GetSurfaceThreatOfUnits(platoon) > 0 and (aiBrain:GetThreatAtPosition(location, 0, true, 'Land') > 0 or aiBrain:GetThreatAtPosition(location, 0, true, 'Naval') > 0) then
        return true
    end
    -- If no visible targets go anyway
    if table.getn(targets) == 0 then
        return true
    end
    return false
end

-- -----------------------------------------------------
--    Function: AISendPing
--    Args:
--        position      - Position to ping
--        pingType          - Type of ping to send
--      army            - AI army
--    Description:
--        Function to handle AI map pings.
--    Returns:
--        nil
-- -----------------------------------------------------
function AISendPing(position, pingType, army)
    local PingTypes = {
       alert = {Lifetime = 6, Mesh = 'alert_marker', Ring = '/game/marker/ring_yellow02-blur.dds', ArrowColor = 'yellow', Sound = 'UEF_Select_Radar'},
       move = {Lifetime = 6, Mesh = 'move', Ring = '/game/marker/ring_blue02-blur.dds', ArrowColor = 'blue', Sound = 'Cybran_Select_Radar'},
       attack = {Lifetime = 6, Mesh = 'attack_marker', Ring = '/game/marker/ring_red02-blur.dds', ArrowColor = 'red', Sound = 'Aeon_Select_Radar'},
       marker = {Lifetime = 5, Ring = '/game/marker/ring_yellow02-blur.dds', ArrowColor = 'yellow', Sound = 'UI_Main_IG_Click', Marker = true},
   }
    local data = {Owner = army - 1, Type = pingType, Location = position}
    data = table.merged(data, PingTypes[pingType])
    import('/lua/simping.lua').SpawnPing(data)
end

function AIDelayChat(aigroup, ainickname, aiaction, targetnickname, delaytime)
    WaitSeconds(delaytime)
    AISendChat(aigroup, ainickname, aiaction, targetnickname)
end

-- -----------------------------------------------------
--    Function: AISendChat
--    Args:
--        aigroup       - Group to send chat to
--        ainickname    - AI name
--      aiaction        - Type of AI chat
--      tagetnickname   - Target name
--    Description:
--        Function to handle AI sending chat messages.
--    Returns:
--        nil
-- -----------------------------------------------------
function AISendChat(aigroup, ainickname, aiaction, targetnickname, extrachat)
    if aigroup and not GetArmyData(ainickname):IsDefeated() and (aigroup ~='allies' or AIHasAlly(GetArmyData(ainickname))) then
        if aiaction and AIChatText[aiaction] then
            local ranchat = Random(1, table.getn(AIChatText[aiaction]))
            local chattext
            if targetnickname then
                if IsAIArmy(targetnickname) then
                    targetnickname = trim(string.gsub(targetnickname,'%b()', ''))
                end
                chattext = string.gsub(AIChatText[aiaction][ranchat],'%[target%]', targetnickname)
            elseif extrachat then
                chattext = string.gsub(AIChatText[aiaction][ranchat],'%[extra%]', extrachat)
            else
                chattext = AIChatText[aiaction][ranchat]
            end
            table.insert(Sync.AIChat, {group=aigroup, text=chattext, sender=ainickname})
        else
            table.insert(Sync.AIChat, {group=aigroup, text=aiaction, sender=ainickname})
        end
    end
end

-- -----------------------------------------------------
--    Function: AIRandomizeTaunt
--    Args:
--        aiBrain       - AI Brain
--    Description:
--        Randmonly chooses a taunt and sends it to AISendChat.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIRandomizeTaunt(aiBrain)
    local factionIndex = aiBrain:GetFactionIndex()
    tauntid = Random(1,table.getn(AITaunts[factionIndex]))
    aiBrain.LastVocTaunt = GetGameTimeSeconds()
    AISendChat('all', aiBrain.Nickname, '/'..AITaunts[factionIndex][tauntid])
end

-- -----------------------------------------------------
--    Function: FinishAIChat
--    Args:
--        data          - Chat data table
--    Description:
--        Sends a response to a human ally's chat message.
--    Returns:
--        nil
-- -----------------------------------------------------
function FinishAIChat(data)
    local aiBrain = GetArmyBrain(data.Army)
    if data.NewTarget then
        if data.NewTarget == 'at will' then
            aiBrain.targetoveride = false
            AISendChat('allies', aiBrain.Nickname, 'Targeting at will')
        else
            if IsEnemy(data.NewTarget, data.Army) then
                aiBrain:SetCurrentEnemy(ArmyBrains[data.NewTarget])
                aiBrain.targetoveride = true
                AISendChat('allies', aiBrain.Nickname, 'tcrespond', ArmyBrains[data.NewTarget].Nickname)
            elseif IsAlly(data.NewTarget, data.Army) then
                AISendChat('allies', aiBrain.Nickname, 'tcerrorally', ArmyBrains[data.NewTarget].Nickname)
            end
        end
    elseif data.NewFocus then
        aiBrain.Focus = data.NewFocus
        AISendChat('allies', aiBrain.Nickname, 'genericchat')
    elseif data.CurrentFocus then
        local focus = 'nothing'
        if aiBrain.Focus then
            focus = aiBrain.Focus
        end
        AISendChat('allies', aiBrain.Nickname, 'focuschat', nil, focus)
    elseif data.GiveEngineer and not GetArmyBrain(data.ToArmy):IsDefeated() then
        local cats = {categories.TECH3, categories.TECH2, categories.TECH1}
        local given = false
        for _, cat in cats do
            local engies = aiBrain:GetListOfUnits(categories.ENGINEER * cat - categories.COMMAND - categories.SUBCOMMANDER - categories.ENGINEERSTATION, false)
            for k,v in engies do
                if not v.Dead and v:GetParent() == v then
                    if v.PlatoonHandle and aiBrain:PlatoonExists(v.PlatoonHandle) then
                        v.PlatoonHandle:RemoveEngineerCallbacksSorian()
                        v.PlatoonHandle:Stop()
                        v.PlatoonHandle:PlatoonDisbandNoAssign()
                    end
                    if v.NotBuildingThread then
                        KillThread(v.NotBuildingThread)
                        v.NotBuildingThread = nil
                    end
                    if v.ProcessBuild then
                        KillThread(v.ProcessBuild)
                        v.ProcessBuild = nil
                    end
                    v.BuilderManagerData.EngineerManager:RemoveUnit(v)
                    IssueStop({v})
                    IssueClearCommands({v})
                    AISendPing(v:GetPosition(), 'move', data.Army)
                    AISendChat(data.ToArmy, aiBrain.Nickname, 'giveengineer')
                    ChangeUnitArmy(v,data.ToArmy)
                    given = true
                    break
                end
            end
            if given then break end
        end
    elseif data.Command then
        if data.Text == 'target' then
            AISendChat(data.ToArmy, aiBrain.Nickname, 'target <enemy>: <enemy> is the name of the enemy you want me to attack or \'at will\' if you want me to choose targets myself.')
        elseif data.Text == 'focus' then
            AISendChat(data.ToArmy, aiBrain.Nickname, 'focus <strat>: <strat> is the name of the strategy you want me to use or \'at will\' if you want me to choose strategies myself. Available strategies: rush arty, rush nuke, air.')
        else
            AISendChat(data.ToArmy, aiBrain.Nickname, 'Available Commands: focus <strat or at will>, target <enemy or at will>, current focus, give me an engineer, command <target or strat>.')
        end
    end
end

-- -----------------------------------------------------
--    Function: AIHandlePing
--    Args:
--        aiBrain       - AI Brain
--        pingData          - Ping data table
--    Description:
--        Handles the AIs reaction to a human ally's ping.
--    Returns:
--        nil
-- -----------------------------------------------------
function AIHandlePing(aiBrain, pingData)
    if pingData.Type == 'move' then
        nextping = (table.getn(aiBrain.TacticalBases) + 1)
        table.insert(aiBrain.TacticalBases,
            {
            Position = pingData.Location,
            Name = 'BasePing'..nextping,
            }
        )
        AISendChat('allies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'genericchat')
    elseif pingData.Type == 'attack' then
        table.insert(aiBrain.AttackPoints,
            {
            Position = pingData.Location,
            }
        )
        aiBrain:ForkThread(aiBrain.AttackPointsTimeout, pingData.Location)
        AISendChat('allies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'genericchat')
    elseif pingData.Type == 'alert' then
        table.insert(aiBrain.BaseMonitor.AlertsTable,
            {
            Position = pingData.Location,
            Threat = 80,
            }
        )
        aiBrain.BaseMonitor.AlertSounded = true
        aiBrain:ForkThread(aiBrain.BaseMonitorAlertTimeout, pingData.Location)
        aiBrain.BaseMonitor.ActiveAlerts = aiBrain.BaseMonitor.ActiveAlerts + 1
        AISendChat('allies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'genericchat')
    end
end

-- -----------------------------------------------------
--    Function: FindClosestUnitPosToAttack
--    Args:
--        aiBrain           - AI Brain
--        platoon               - Platoon to find a target for
--      squad               - Platoon squad
--      maxRange            - Max Range
--      atkCat              - Categories to look for
--      selectedWeaponArc   - Platoon weapon arc
--      turretPitch         - platoon turret pitch
--    Description:
--        Finds the closest unit to attack that is not obstructed by terrain.
--    Returns:
--        target or false
-- -----------------------------------------------------
function FindClosestUnitPosToAttack(aiBrain, platoon, squad, maxRange, atkCat, selectedWeaponArc, turretPitch)
    local position = platoon:GetPlatoonPosition()
    if not aiBrain or not position or not maxRange then
        return false
    end
    local targetUnits = aiBrain:GetUnitsAroundPoint(atkCat, position, maxRange, 'Enemy')
    local retUnit = false
    local distance = 999999
    for num, unit in targetUnits do
        if not unit.Dead then
            local unitPos = unit:GetPosition()
            -- If unit is close enough, can be attacked, and not obstructed
            if (not retUnit or Utils.XZDistanceTwoVectors(position, unitPos) < distance) and platoon:CanAttackTarget(squad, unit) and (not turretPitch or not CheckBlockingTerrain(position, unitPos, selectedWeaponArc, turretPitch)) then
                retUnit = unit -- :GetPosition()
                distance = Utils.XZDistanceTwoVectors(position, unitPos)
            end
        end
    end
    if retUnit then
        return retUnit
    end
    return false
end

-- -----------------------------------------------------
--    Function: LeadTarget
--    Args:
--        platoon       - TML firing missile
--        target        - Target to fire at
--    Description:
--        Allows the TML to lead a target to hit them while moving.
--    Returns:
--        Map Position or false
--  Notes:
--      TML Specs(MU = Map Units): Max Speed: 12MU/sec
--                                 Acceleration: 3MU/sec/sec
--                                 Launch Time: ~3 seconds
-- -----------------------------------------------------
function LeadTarget(platoon, target)
    -- Get launcher and target position
    local LauncherPos = platoon:GetPlatoonPosition()
    local TargetPos = target:GetPosition()
    -- Get target position in 1 second intervals.
    -- This allows us to get speed and direction from the target
    local TargetStartPosition=0
    local Target1SecPos=0
    local Target2SecPos=0
    local XmovePerSec=0
    local YmovePerSec=0
    local XmovePerSecCheck=-1
    local YmovePerSecCheck=-1
    -- Check if the target is runing straight or circling
    -- If x/y and xcheck/ycheck are equal, we can be sure the target is moving straight
    -- in one direction. At least for the last 2 seconds.
    local LoopSaveGuard = 0
    while (XmovePerSec ~= XmovePerSecCheck or YmovePerSec ~= YmovePerSecCheck) and LoopSaveGuard < 10 do
        -- 1st position of target
        TargetPos = target:GetPosition()
        TargetStartPosition = {TargetPos[1], 0, TargetPos[3]}
        WaitTicks(10)
        -- 2nd position of target after 1 second
        TargetPos = target:GetPosition()
        Target1SecPos = {TargetPos[1], 0, TargetPos[3]}
        XmovePerSec = (TargetStartPosition[1] - Target1SecPos[1])
        YmovePerSec = (TargetStartPosition[3] - Target1SecPos[3])
        WaitTicks(10)
        -- 3rd position of target after 2 seconds to verify straight movement
        TargetPos = target:GetPosition()
        Target2SecPos = {TargetPos[1], TargetPos[2], TargetPos[3]}
        XmovePerSecCheck = (Target1SecPos[1] - Target2SecPos[1])
        YmovePerSecCheck = (Target1SecPos[3] - Target2SecPos[3])
        --We leave the while-do check after 10 loops (20 seconds) and try collateral damage
        --This can happen if a player try to fool the targetingsystem by circling a unit.
        LoopSaveGuard = LoopSaveGuard + 1
    end
    -- Get launcher position height
    local fromheight = GetTerrainHeight(LauncherPos[1], LauncherPos[3])
    if GetSurfaceHeight(LauncherPos[1], LauncherPos[3]) > fromheight then
        fromheight = GetSurfaceHeight(LauncherPos[1], LauncherPos[3])
    end
    -- Get target position height
    local toheight = GetTerrainHeight(Target2SecPos[1], Target2SecPos[3])
    if GetSurfaceHeight(Target2SecPos[1], Target2SecPos[3]) > toheight then
        toheight = GetSurfaceHeight(Target2SecPos[1], Target2SecPos[3])
    end
    -- Get height difference between launcher position and target position
    -- Adjust for height difference by dividing the height difference by the missiles max speed
    local HeightDifference = math.abs(fromheight - toheight) / 12
    -- Speed up time is distance the missile will travel while reaching max speed (~22.47 MapUnits)
    -- divided by the missiles max speed (12) which is equal to 1.8725 seconds flight time
    local SpeedUpTime = 22.47 / 12
    --  Missile needs 3 seconds to launch
    local LaunchTime = 3
    -- Get distance from launcher position to targets starting position and position it moved to after 1 second
    local dist1 = VDist2(LauncherPos[1], LauncherPos[3], Target1SecPos[1], Target1SecPos[3])
    local dist2 = VDist2(LauncherPos[1], LauncherPos[3], Target2SecPos[1], Target2SecPos[3])
    -- Missile has a faster turn rate when targeting targets < 50 MU away, so it will level off faster
    local LevelOffTime = 0.25
    local CollisionRangeAdjust = 0
    if dist2 < 50 then
        LevelOffTime = 0.02
        CollisionRangeAdjust = 2
    end
    -- Divide both distances by missiles max speed to get time to impact
    local time1 = (dist1 / 12) + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    local time2 = (dist2 / 12) + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    -- Get the missile travel time by extrapolating speed and time from dist1 and dist2
    local MissileTravelTime = (time2 + (time2 - time1)) + ((time2 - time1) * time2)
    -- Now adding all times to get final missile flight time to the position where the target will be
    local MissileImpactTime = MissileTravelTime + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    -- Create missile impact corrdinates based on movePerSec * MissileImpactTime
    local MissileImpactX = Target2SecPos[1] - (XmovePerSec * MissileImpactTime)
    local MissileImpactY = Target2SecPos[3] - (YmovePerSec * MissileImpactTime)
    -- Adjust for targets CollisionOffsetY. If the hitbox of the unit is above the ground
    -- we nedd to fire "behind" the target, so we hit the unit in midair.
    local TargetCollisionBoxAdjust = 0
    local TargetBluePrint = target:GetBlueprint()
    if TargetBluePrint.CollisionOffsetY and TargetBluePrint.CollisionOffsetY > 0 then
        -- if the unit is far away we need to target farther behind the target because of the projectile flight angel
        local DistanceOffset = (100 / 256 * dist2) * 0.06
        TargetCollisionBoxAdjust = TargetBluePrint.CollisionOffsetY * CollisionRangeAdjust + DistanceOffset
    end
    -- To calculate the Adjustment behind the target we use a variation of the Pythagorean theorem. (Percent scale technique)
    -- (a²+b²=c²) If we add x% to c² then also a² and b² are x% larger. (a²)*x% + (b²)*x% = (c²)*x%
    local Hypotenuse = VDist2(LauncherPos[1], LauncherPos[3], MissileImpactX, MissileImpactY)
    local HypotenuseScale = 100 / Hypotenuse * TargetCollisionBoxAdjust
    local aLegScale = (MissileImpactX - LauncherPos[1]) / 100 * HypotenuseScale
    local bLegScale = (MissileImpactY - LauncherPos[3]) / 100 * HypotenuseScale
    -- Add x percent (behind) the target coordinates to get our final missile impact coordinates
    MissileImpactX = MissileImpactX + aLegScale
    MissileImpactY = MissileImpactY + bLegScale
    -- Add some optional randomization to make the AI easier
    local TMLRandom = tonumber(ScenarioInfo.Options.TMLRandom) or 0
    MissileImpactX = MissileImpactX + (Random(0, TMLRandom) - TMLRandom / 2) / 5
    MissileImpactY = MissileImpactY + (Random(0, TMLRandom) - TMLRandom / 2) / 5
    -- Cancel firing if target is outside map boundries
    if MissileImpactX < 0 or MissileImpactY < 0 or MissileImpactX > ScenarioInfo.size[1] or MissileImpactY > ScenarioInfo.size[2] then
        return false
    end
    -- Also cancel if target would be out of weaponrange or inside minimum range.
    local maxRadius = 256
    local minRadius = 15
    local dist3 = VDist2(LauncherPos[1], LauncherPos[3], MissileImpactX, MissileImpactY)
    if dist3 < minRadius or dist3 > maxRadius then
        return false
    end
    -- return extrapolated target position / missile impact coordinates
    return {MissileImpactX, Target2SecPos[2], MissileImpactY}
end

-- -----------------------------------------------------
--    Function: CheckBlockingTerrain
--    Args:
--        pos           - Platoon position
--      targetPos       - Target position
--      firingArc       - Firing Arc
--      turretPitch     - Turret pitch
--    Description:
--        Checks to see if there is terrain blocking a unit from hiting a target.
--    Returns:
--        true (there is something blocking) or false (there is not something blocking)
-- -----------------------------------------------------
function CheckBlockingTerrain(pos, targetPos, firingArc, turretPitch)
    -- High firing arc indicates Artillery unit
    if firingArc == 'high' then
        return false
    end
    -- Distance to target
    local distance = VDist2Sq(pos[1], pos[3], targetPos[1], targetPos[3])
    distance = math.sqrt(distance)

    -- This allows us to break up the distance into 5 points so we can check
    -- 5 points between the unit and target
    local step = math.ceil(distance / 5)
    local xstep = (pos[1] - targetPos[1]) / step
    local ystep = (pos[3] - targetPos[3]) / step

    -- Loop through the 5 points to check for blocking terrain
    -- Start at zero in case there is only 1 step. if we start at 1 with 1 step it wont check it
    for i = 0, step do
        if i > 0 then
            -- We want to check the slope and angle between one point along the path and the next point
            local lastPos = {pos[1] - (xstep * (i - 1)), 0, pos[3] - (ystep * (i - 1))}
            local nextpos = {pos[1] - (xstep * i), 0, pos[3] - (ystep * i)}

            -- Get height for both points
            local lastPosHeight = GetTerrainHeight(lastPos[1], lastPos[3])
            local nextposHeight = GetTerrainHeight(nextpos[1], nextpos[3])
            if GetSurfaceHeight(lastPos[1], lastPos[3]) > lastPosHeight then
                lastPosHeight = GetSurfaceHeight(lastPos[1], lastPos[3])
            end
            if GetSurfaceHeight(nextpos[1], nextpos[3]) > nextposHeight then
                nextposHeight = GetSurfaceHeight(nextpos[1], nextpos[3])
            else
                nextposHeight = nextposHeight + .5
            end
            -- Get the slope and angle between the 2 points
            local angle, slope = GetSlopeAngle(lastPos, nextpos, lastPosHeight, nextposHeight)
            -- There is an obstruction
            if angle > turretPitch then
                return true
            end
        end
    end
    return false
end

-- -----------------------------------------------------
--    Function: GetSlopeAngle
--    Args:
--        pos           - Starting position
--      targetPos       - Target position
--      posHeight       - Starting position height
--      targetHeight    - Target position height
--    Description:
--        Gets the slope and angle between 2 points.
--    Returns:
--        slope and angle
-- -----------------------------------------------------
function GetSlopeAngle(pos, targetPos, posHeight, targetHeight)
    -- Distance between points
    local distance = VDist2Sq(pos[1], pos[3], targetPos[1], targetPos[3])
    distance = math.sqrt(distance)

    local heightDif

    -- If heights are the same return 0
    -- Otherwise we want the absolute value of the height difference
    if targetHeight == posHeight then
        return 0
    else
        heightDif = math.abs(targetHeight - posHeight)
    end

    -- Get the slope and angle between the points
    local slope = heightDif / distance
    local angle = math.deg(math.atan(slope))

    return angle, slope
end



-- -----------------------------------------------------
--    Function: GetGuards
--    Args:
--        aiBrain       - AI Brain
--        Unit          - Unit
--    Description:
--        Gets number of units assisting a unit.
--    Returns:
--        Number of assisters
-- -----------------------------------------------------
function GetGuards(aiBrain, Unit)
    local engs = aiBrain:GetUnitsAroundPoint(categories.ENGINEER - categories.POD, Unit:GetPosition(), 10, 'Ally')
    local count = 0
    local UpgradesFrom = Unit:GetBlueprint().General.UpgradesFrom
    for k,v in engs do
        if v.UnitBeingBuilt == Unit then
            count = count + 1
        end
    end
    if UpgradesFrom and UpgradesFrom ~= 'none' then -- Used to filter out upgrading units
        local oldCat = ParseEntityCategory(UpgradesFrom)
        local oldUnit = aiBrain:GetUnitsAroundPoint(oldCat, Unit:GetPosition(), 0, 'Ally')
        if oldUnit then
            count = count + 1
        end
    end
    return count
end

-- -----------------------------------------------------
--    Function: GetGuardCount
--    Args:
--        aiBrain       - AI Brain
--        Unit          - Unit
--      cat             - Unit category to check for
--    Description:
--        Gets the number of units guarding a unit.
--    Returns:
--        Number of guards
-- -----------------------------------------------------
function GetGuardCount(aiBrain, Unit, cat)
    local guards = Unit:GetGuards()
    local count = 0
    for k,v in guards do
        if not v.Dead and EntityCategoryContains(cat, v) then
            count = count + 1
        end
    end
    return count
end

-- -----------------------------------------------------
--    Function: Nuke
--    Args:
--        aiBrain       - AI Brain
--    Description:
--        Finds targets for the AIs nuke launchers and fires them all simultaneously.
--    Returns:
--        nil
-- -----------------------------------------------------
function Nuke(aiBrain)
    local atkPri = { 'STRUCTURE STRATEGIC EXPERIMENTAL', 'EXPERIMENTAL ARTILLERY OVERLAYINDIRECTFIRE', 'EXPERIMENTAL ORBITALSYSTEM', 'STRUCTURE ARTILLERY TECH3', 'STRUCTURE NUKE TECH3', 'EXPERIMENTAL ENERGYPRODUCTION STRUCTURE', 'COMMAND', 'TECH3 MASSFABRICATION STRUCTURE', 'TECH3 ENERGYPRODUCTION STRUCTURE', 'TECH2 STRATEGIC STRUCTURE', 'TECH3 DEFENSE STRUCTURE', 'TECH2 DEFENSE STRUCTURE', 'TECH2 ENERGYPRODUCTION STRUCTURE' }
    local maxFire = false
    local Nukes = aiBrain:GetListOfUnits(categories.NUKE * categories.SILO * categories.STRUCTURE * categories.TECH3, true)
    local nukeCount = 0
    local launcher
    local bp
    local weapon
    local maxRadius
    -- This table keeps a list of all the nukes that have fired this round
    local fired = {}
    for k, v in Nukes do
        if not maxFire then
            bp = v:GetBlueprint()
            weapon = bp.Weapon[1]
            maxRadius = weapon.MaxRadius
            launcher = v
            maxFire = true
        end
        -- Add launcher to the fired table with a value of false
        fired[v] = false
        if v:GetNukeSiloAmmoCount() > 0 then
            nukeCount = nukeCount + 1
        end
    end
    -- If we have nukes
    if nukeCount > 0 then
        -- This table keeps track of all targets fired at this round to keep from firing multiple nukes
        -- at the same target unless we have to to overwhelm anti-nukes.
        local oldTarget = {}
        local target
        local fireCount = 0
        local aitarget
        local tarPosition
        local antiNukes
        -- Repeat until all launchers have fired or we run out of targets
        repeat
            -- Get a target and target position. This function also ensures that we fire at a new target
            -- and one that we have enough nukes to hit the target
            target, tarPosition, antiNukes = AIUtils.AIFindBrainNukeTargetInRangeSorian(aiBrain, launcher, maxRadius, atkPri, nukeCount, oldTarget)
            if target then
                -- Send a message to allies letting them know we are letting nukes fly
                -- Also ping the map where we are targeting
                aitarget = target:GetAIBrain():GetArmyIndex()
                AISendChat('allies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'nukechat', ArmyBrains[aitarget].Nickname)
                AISendPing(tarPosition, 'attack', aiBrain:GetArmyIndex())
                -- Randomly taunt the enemy
                if Random(1,5) == 3 and (not aiBrain.LastTaunt or GetGameTimeSeconds() - aiBrain.LastTaunt > 90) then
                    aiBrain.LastTaunt = GetGameTimeSeconds()
                    AISendChat(aitarget, ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'nuketaunt')
                end
                -- Get anti-nukes int the area
                -- local antiNukes = aiBrain:GetNumUnitsAroundPoint(categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, tarPosition, 90, 'Enemy')
                local nukesToFire = {}
                for k, v in Nukes do
                    -- If we have nukes that have not fired yet
                    if v:GetNukeSiloAmmoCount() > 0 and not fired[v] then
                        table.insert(nukesToFire, v)
                        nukeCount = nukeCount - 1
                        fireCount = fireCount + 1
                        fired[v] = true
                    end
                    -- If we fired enough nukes at the target, or we are out of nukes
                    if fireCount > (antiNukes + 2) or nukeCount == 0 or (fireCount > 0 and antiNukes == 0) then
                        break
                    end
                end
                ForkThread(LaunchNukesTimed, nukesToFire, tarPosition)
            end
            -- Keep track of old targets
            table.insert(oldTarget, target)
            fireCount = 0
            -- WaitSeconds(15)
        until nukeCount <= 0 or target == false
    end
end

function CheckCost(aiBrain, pos, massCost)
    if massCost == 0 then
        massCost = 12000
    end
    local units = aiBrain:GetUnitsAroundPoint(categories.ALLUNITS, pos, 30, 'Enemy')
    local massValue = 0
    for k,v in units do
        if not v.Dead then
            local unitValue = (v:GetBlueprint().Economy.BuildCostMass * v:GetFractionComplete())
            massValue = massValue + unitValue
        end
        if massValue > massCost then return true end
    end
    return false
end

-- -----------------------------------------------------
--    Function: LaunchNukesTimed
--    Args:
--        nukesToFire   - Table of Nukes
--        target            - Target to attack
--    Description:
--        Launches nukes so that they all reach the target at about the same time.
--    Returns:
--        nil
-- -----------------------------------------------------
function LaunchNukesTimed(nukesToFire, target)
    local nukes = {}
    for k,v in nukesToFire do
        local pos = v:GetPosition()
        local timeToTarget = Round(math.sqrt(VDist2Sq(target[1], target[3], pos[1], pos[3]))/40)
        table.insert(nukes,{unit = v, flightTime = timeToTarget})
    end
    table.sort(nukes, function(a,b) return a.flightTime > b.flightTime end)
    local lastFT = nukes[1].flightTime
    for k,v in nukes do
        WaitSeconds(lastFT - v.flightTime)
        IssueNuke({v.unit}, target)
        lastFT = v.flightTime
    end
end

-- -----------------------------------------------------
--    Function: FindUnfinishedUnits
--    Args:
--        aiBrain       - AI Brain
--        locationType  - Location to look at
--      buildCat        - Building category to search for
--    Description:
--        Finds unifinished units in an area.
--    Returns:
--        unit or false
-- -----------------------------------------------------
function FindUnfinishedUnits(aiBrain, locationType, buildCat)
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    local unfinished = aiBrain:GetUnitsAroundPoint(buildCat, engineerManager:GetLocationCoords(), engineerManager.Radius, 'Ally')
    local retUnfinished = false
    for num, unit in unfinished do
        donePercent = unit:GetFractionComplete()
        if donePercent < 1 and GetGuards(aiBrain, unit) < 1 and not unit:IsUnitState('Upgrading') then
            retUnfinished = unit
            break
        end
    end
    return retUnfinished
end

-- -----------------------------------------------------
--    Function: FindDamagedShield
--    Args:
--        aiBrain       - AI Brain
--        locationType  - Location to look at
--      buildCat        - Building category to search for
--    Description:
--        Finds damaged shields in an area.
--    Returns:
--        damaged shield or false
-- -----------------------------------------------------
function FindDamagedShield(aiBrain, locationType, buildCat)
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    local shields = aiBrain:GetUnitsAroundPoint(buildCat, engineerManager:GetLocationCoords(), engineerManager.Radius, 'Ally')
    local retShield = false
    for num, unit in shields do
        if not unit.Dead and unit:ShieldIsOn() then
            shieldPercent = (unit.MyShield:GetHealth() / unit.MyShield:GetMaxHealth())
            if shieldPercent < 1 and GetGuards(aiBrain, unit) < 3 then
                retShield = unit
                break
            end
        end
    end
    return retShield
end

-- -----------------------------------------------------
--    Function: NumberofUnitsBetweenPoints
--    Args:
--        start         - Starting point
--      finish          - Ending point
--      unitCat         - Unit category
--      stepby          - MUs to step along path by
--      alliance        - Unit alliance to check for
--    Description:
--        Counts units between 2 points.
--    Returns:
--        Number of units
-- -----------------------------------------------------
function NumberofUnitsBetweenPoints(aiBrain, start, finish, unitCat, stepby, alliance)
    if type(unitCat) == 'string' then
        unitCat = ParseEntityCategory(unitCat)
    end

    local returnNum = 0

    -- Get distance between the points
    local distance = math.sqrt(VDist2Sq(start[1], start[3], finish[1], finish[3]))
    local steps = math.floor(distance / stepby)

    local xstep = (start[1] - finish[1]) / steps
    local ystep = (start[3] - finish[3]) / steps
    -- For each point check to see if the destination is close
    for i = 0, steps do
        local numUnits = aiBrain:GetNumUnitsAroundPoint(unitCat, {finish[1] + (xstep * i),0 , finish[3] + (ystep * i)}, stepby, alliance)
        returnNum = returnNum + numUnits
    end

    return returnNum
end

-- -----------------------------------------------------
--    Function: DestinationBetweenPoints
--    Args:
--        destination   - Destination
--        start         - Starting point
--      finish          - Ending point
--    Description:
--        Checks to see if the destination is between the 2 given path points.
--    Returns:
--        true or false
-- -----------------------------------------------------
function DestinationBetweenPoints(destination, start, finish)
    -- Get distance between the points
    local distance = VDist2Sq(start[1], start[3], finish[1], finish[3])
    distance = math.sqrt(distance)

    -- This allows us to break the distance up and check points every 100 MU
    local step = math.ceil(distance / 100)
    local xstep = (start[1] - finish[1]) / step
    local ystep = (start[3] - finish[3]) / step
    -- For each point check to see if the destination is close
    for i = 1, step do
        -- DrawCircle({start[1] - (xstep * i), 0, start[3] - (ystep * i)}, 5, '0000ff')
        -- DrawCircle({start[1] - (xstep * i), 0, start[3] - (ystep * i)}, 100, '0000ff')
        if VDist2Sq(start[1] - (xstep * i), start[3] - (ystep * i), finish[1], finish[3]) <= 10000 then break end
        if VDist2Sq(start[1] - (xstep * i), start[3] - (ystep * i), destination[1], destination[3]) < 10000 then
            return true
        end
    end
    return false
end

-- -----------------------------------------------------
--    Function: GetNumberOfAIs
--    Args:
--        aiBrain           - AI Brain
--    Description:
--        Gets the number of AIs in the game.
--    Returns:
--        Number of AIs
-- -----------------------------------------------------
-- function GetNumberOfAIs(aiBrain)
    -- local numberofAIs = 0
    -- for k,v in ArmyBrains do
        -- if not v:IsDefeated() and not ArmyIsCivilian(v:GetArmyIndex()) and v:GetArmyIndex() ~= aiBrain:GetArmyIndex() then
            -- numberofAIs = numberofAIs + 1
        -- end
    -- end
    -- return numberofAIs
-- end

-- -----------------------------------------------------
--    Function: GetNumberOfAIs
--    Args:
--        x             - Number to round
--      places          - Number of places to round to
--    Description:
--        Rounds a number to the specifed places.
--    Returns:
--        Rounded number
-- -----------------------------------------------------
function Round(x, places)
    if places then
        shift = 10 ^ places
        result = math.floor(x * shift + 0.5) / shift
        return result
    else
        result = math.floor(x + 0.5)
        return result
    end
end

-- -----------------------------------------------------
--    Function: Trim
--    Args:
--        s             - String to trim
--    Description:
--        Trims blank spaces around a string.
--    Returns:
--        String
-- -----------------------------------------------------
function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function GetRandomEnemyPos(aiBrain)
    for k, v in ArmyBrains do
        if IsEnemy(aiBrain:GetArmyIndex(), v:GetArmyIndex()) and not v:IsDefeated() then
            if v:GetArmyStartPos() then
                local ePos = v:GetArmyStartPos()
                return ePos[1], ePos[3]
            end
        end
    end
    return false
end

-- -----------------------------------------------------
--    Function: GetArmyData
--    Args:
--        army          - Army
--    Description:
--        Returns army data for an army.
--    Returns:
--        Army data table
-- -----------------------------------------------------
function GetArmyData(army)
    local result
    if type(army) == 'string' then
        for i, v in ArmyBrains do
            if v.Nickname == army then
                result = v
                break
            end
        end
    end
    return result
end

-- -----------------------------------------------------
--    Function: IsAIArmy
--    Args:
--        army          - Army
--    Description:
--        Checks to see if the army is an AI.
--    Returns:
--        true or false
-- -----------------------------------------------------
function IsAIArmy(army)
    if type(army) == 'string' then
        for i, v in ArmyBrains do
            if v.Nickname == army and v.BrainType == 'AI' then
                return true
            end
        end
    elseif type(army) == 'number' then
        if ArmyBrains[army].BrainType == 'AI' then
            return true
        end
    end
    return false
end

-- -----------------------------------------------------
--    Function: AIHasAlly
--    Args:
--        army          - Army
--    Description:
--        Checks to see if an AI has an ally.
--    Returns:
--        true or false
-- -----------------------------------------------------
function AIHasAlly(army)
    for k, v in ArmyBrains do
        if IsAlly(army:GetArmyIndex(), v:GetArmyIndex()) and army:GetArmyIndex() ~= v:GetArmyIndex() and not v:IsDefeated() then
            return true
        end
    end
    return false
end

-- -----------------------------------------------------
--    Function: TimeConvert
--    Args:
--        temptime      - Time in seconds
--    Description:
--        Converts seconds into eaier to read time.
--    Returns:
--        Converted time
-- -----------------------------------------------------
function TimeConvert(temptime)
    hours = math.floor(temptime / 3600)
    minutes = math.floor(temptime/60)
    seconds = math.floor(math.mod(temptime, 60))
    hours = tostring(hours)
    if minutes < 10 then
        minutes = '0'..tostring(minutes)
    else
        minutes = tostring(minutes)
    end
    if seconds < 10 then
        seconds = '0'..tostring(seconds)
    else
        seconds = tostring(seconds)
    end
    returntext = hours..':'..minutes..':'..seconds
    return returntext
end

-- Small function the draw intel points on the map for debugging
function DrawIntel(aiBrain)
    threatColor = {
        -- ThreatType = { ARGB value }
        StructuresNotMex = 'ff00ff00', -- Green
        Commander = 'ff00ffff', -- Cyan
        Experimental = 'ffff0000', -- Red
        Artillery = 'ffffff00', -- Yellow
        Land = 'ffff9600', -- Orange
    }
    while true do
        if aiBrain:GetArmyIndex() == GetFocusArmy() then
            for k, v in aiBrain.InterestList.HighPriority do
                if threatColor[v.Type] then
                    DrawCircle(v.Position, 1, threatColor[v.Type])
                    DrawCircle(v.Position, 3, threatColor[v.Type])
                    DrawCircle(v.Position, 5, threatColor[v.Type])
                end
            end
        end
        WaitSeconds(2)
    end
end

-- Deprecated functions / unused
function GiveAwayMyCrap(aiBrain)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function GiveAwayMyCrap() called.')
end
function AIMicro(aiBrain, platoon, target, threatatLocation, mySurfaceThreat)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function AIMicro() called.')
end
function CircleAround(aiBrain, platoon, target)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function CircleAround() called.')
end
function OrderedRetreat(aiBrain, platoon)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function OrderedRetreat() called.')
end
function LeadTargetArtillery(platoon, unit, target)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function LeadTargetArtillery() called.')
end
function MajorLandThreatExists(aiBrain)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function MajorLandThreatExists() called.')
end
function MajorAirThreatExists(aiBrain)
    WARN('[sorianeditutilities.lua '..debug.getinfo(1).currentline..'] - Deprecated function MajorAirThreatExists() called.')
end

function ExtractorPauseSorian(self, aiBrain, MassExtractorUnitList, ratio, techLevel)
    local UpgradingBuilding = nil
    local UpgradingBuildingNum = 0
    local PausedUpgradingBuilding = nil
    local PausedUpgradingBuildingNum = 0
    local DisabledBuilding = nil
    local DisabledBuildingNum = 0
    local IdleBuilding = nil
    local BussyBuilding = nil
    local IdleBuildingNum = 0
    -- loop over all MASSEXTRACTION buildings 
    for unitNum, unit in MassExtractorUnitList do
        if unit
            and not unit.Dead
            and not unit:BeenDestroyed()
            and not unit:GetFractionComplete() < 1
            and EntityCategoryContains(ParseEntityCategory(techLevel), unit)
        then
            -- Is the building upgrading ?
            if unit:IsUnitState('Upgrading') then
                -- If is paused
                if unit:IsPaused() then
                    if not PausedUpgradingBuilding then
                        PausedUpgradingBuilding = unit
                    end
                    PausedUpgradingBuildingNum = PausedUpgradingBuildingNum + 1
                -- The unit is upgrading but not paused
                else
                    if not UpgradingBuilding then
                         UpgradingBuilding = unit
                    end
                    UpgradingBuildingNum = UpgradingBuildingNum + 1
                end
            -- check if we have stopped the production
            elseif unit:GetScriptBit('RULEUTC_ProductionToggle') then
                if not DisabledBuilding then
                    DisabledBuilding = unit
                end
                DisabledBuildingNum = DisabledBuildingNum + 1
            -- we have left buildings that are not disabled, and not upgrading. Mabe they are paused ?
            else
                if not unit:IsPaused() then
                    if not IdleBuilding then
                        IdleBuilding = unit
                    end
                else
                    unit:SetPaused( false )
                end
               IdleBuildingNum = IdleBuildingNum + 1
            end
        end
    end
    --LOG('* ExtractorPauseSorian: Idle= '..UpgradingBuildingNum..'   Upgrading= '..UpgradingBuildingNum..'   Paused= '..PausedUpgradingBuildingNum..'   Disabled= '..DisabledBuildingNum..'   techLevel= '..techLevel)
    --Check for energy stall
    -- if aiBrain:GetEconomyStoredRatio('ENERGY') < 0.50 and aiBrain:GetEconomyStoredRatio('MASS') > aiBrain:GetEconomyStoredRatio('ENERGY') then
    if aiBrain:GetEconomyStoredRatio('MASS') -0.1 > aiBrain:GetEconomyStoredRatio('ENERGY') then
        -- Have we a building that is actual upgrading
        if UpgradingBuilding then
            -- Its upgrading, now check fist if we only have 1 building that is upgrading
            if UpgradingBuildingNum <= 1 and table.getn(MassExtractorUnitList) >= 6 then
            else
                -- we don't have the eco to upgrade the extractor. Pause it!
                UpgradingBuilding:SetPaused( true )
                --UpgradingBuilding:SetCustomName('Upgrading paused')
                --LOG('Upgrading paused')
                return true
            end
        end
        -- -- All buildings that are doing nothing
        -- if IdleBuilding then
            -- if IdleBuildingNum <= 1 then
            -- else
                -- IdleBuilding:SetScriptBit('RULEUTC_ProductionToggle', true)
                -- --IdleBuilding:SetCustomName('Production off')
                -- --LOG('Production off')
                -- return true
            -- end
        -- end
    -- Do we produce more mass then we need ? Disable some for more energy    
    -- else
        -- if DisabledBuilding then
            -- DisabledBuilding:SetScriptBit('RULEUTC_ProductionToggle', false)
            -- --DisabledBuilding:SetCustomName('Production on')
            -- --LOG('Production on')
            -- return true
        -- end
    end
    -- Check for positive Mass/Upgrade ratio
    local MassRatioCheckPositive = GlobalMassUpgradeCostVsGlobalMassIncomeRatioSorian( self, aiBrain, ratio, techLevel, '<' )
    -- Did we found a paused unit ?
    if PausedUpgradingBuilding then
        if MassRatioCheckPositive then
            -- We have good Mass ratio. We can unpause an extractor
            PausedUpgradingBuilding:SetPaused( false )
            --PausedUpgradingBuilding:SetCustomName('PausedUpgradingBuilding2 unpaused')
            --LOG('PausedUpgradingBuilding2 unpaused')
            return true
        elseif not MassRatioCheckPositive and UpgradingBuildingNum < 1 and table.getn(MassExtractorUnitList) >= 6 then
            PausedUpgradingBuilding:SetPaused( false )
            --PausedUpgradingBuilding:SetCustomName('PausedUpgradingBuilding1 unpaused')
            --LOG('PausedUpgradingBuilding1 unpaused')
            return true
        end
    end
    -- Check for negative Mass/Upgrade ratio
    local MassRatioCheckNegative = GlobalMassUpgradeCostVsGlobalMassIncomeRatioSorian( self, aiBrain, ratio, techLevel, '>=')
    --LOG('* ExtractorPauseSorian 2 MassRatioCheckNegative >: '..repr(MassRatioCheckNegative)..' - IF this is true , we have bad eco and we should pause.')
    if MassRatioCheckNegative then
        if UpgradingBuildingNum > 1 then
            -- we don't have the eco to upgrade the extractor. Pause it!
            if aiBrain:GetEconomyTrend('MASS') <= 0 and aiBrain:GetEconomyStored('MASS') <= 0.01  then
                UpgradingBuilding:SetPaused( true )
                --UpgradingBuilding:SetCustomName('UpgradingBuilding paused')
                --LOG('UpgradingBuilding paused')
                --LOG('* ExtractorPauseSorian: Pausing upgrading extractor')
                return true
            end
        end
        -- if PausedUpgradingBuilding then
            -- -- if we stall mass, then cancel the upgrade
            -- if aiBrain:GetEconomyTrend('MASS') <= 0 and aiBrain:GetEconomyStored('MASS') <= 0  then
                -- IssueClearCommands({PausedUpgradingBuilding})
                -- PausedUpgradingBuilding:SetPaused( false )
                -- --PausedUpgradingBuilding:SetCustomName('Upgrade canceled')
                -- --LOG('Upgrade canceled')
                -- --LOG('* ExtractorPauseSorian: Cancel upgrading extractor')
                -- return true
            -- end 
        -- end
    end
    return false
end

-- ExtractorUpgradeSorian is upgrading the nearest building to our own main base instead of a random building.
function ExtractorUpgradeSorian(self, aiBrain, MassExtractorUnitList, ratio, techLevel, UnitUpgradeTemplates, StructureUpgradeTemplates)
    -- Do we have the eco to upgrade ?
    local MassRatioCheckPositive = GlobalMassUpgradeCostVsGlobalMassIncomeRatioSorian(self, aiBrain, ratio, techLevel, '<' )
    local aiBrain = self:GetBrain()
    -- search for the neares building to the base for upgrade.
    local BasePosition = aiBrain.BuilderManagers['MAIN'].Position
    local factionIndex = aiBrain:GetFactionIndex()
    local UpgradingBuilding = 0
    local DistanceToBase = nil
    local LowestDistanceToBase = nil
    local upgradeID = nil
    local upgradeBuilding = nil
    local UnitPos = nil
    local FactionToIndex  = { UEF = 1, AEON = 2, CYBRAN = 3, SERAPHIM = 4, NOMADS = 5}
    local UnitBeingUpgradeFactionIndex = nil
    for k, v in MassExtractorUnitList do
        local TempID
        -- Check if we don't want to upgrade this unit
        if not v
            or v.Dead
            or v:BeenDestroyed()
            or v:IsPaused()
            or not EntityCategoryContains(ParseEntityCategory(techLevel), v)
            or v:GetFractionComplete() < 1
        then
            -- Skip this loop and continue with the next array
            continue
        end
        if v:IsUnitState('Upgrading') then
            UpgradingBuilding = UpgradingBuilding + 1
            -- Skip this loop and continue with the next array
            continue
        end
        -- Check for the nearest distance from mainbase
        UnitPos = v:GetPosition()
        DistanceToBase= VDist2(BasePosition[1] or 0, BasePosition[3] or 0, UnitPos[1] or 0, UnitPos[3] or 0)
        if not LowestDistanceToBase or DistanceToBase < LowestDistanceToBase then
            -- Get the factionindex from the unit to get the right update (in case we have captured this unit from another faction)
            UnitBeingUpgradeFactionIndex = FactionToIndex[v.factionCategory] or factionIndex
            -- see if we can find a upgrade
            if EntityCategoryContains(categories.MOBILE, v) then
                TempID = aiBrain:FindUpgradeBP(v:GetUnitId(), UnitUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                if not TempID then
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find UnitUpgradeTemplate for mobile unit: ' .. repr(v:GetUnitId()) )
                end
            else
                TempID = aiBrain:FindUpgradeBP(v:GetUnitId(), StructureUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                if not TempID then
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find StructureUpgradeTemplate for structure: ' .. repr(v:GetUnitId()) )
                end
            end 
            -- Check if we can build the upgrade
            if TempID and EntityCategoryContains(categories.STRUCTURE, v) and not v:CanBuild(TempID) then
                WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t upgrade structure with StructureUpgradeTemplate: ' .. repr(v:GetUnitId()) )
            elseif TempID then
                upgradeID = TempID
                upgradeBuilding = v
                LowestDistanceToBase = DistanceToBase
            end
        end
    end
    -- If we have not the Eco then return false. Exept we have none extractor upgrading or 100% mass storrage
    if not MassRatioCheckPositive and aiBrain:GetEconomyStoredRatio('MASS') < 1.00 then
        -- if we have at least 1 extractor upgrading or less then 4 extractors, then return false
        if UpgradingBuilding > 0 or table.getn(MassExtractorUnitList) < 4 then
            return false
        end
        -- Even if we don't have the Eco for it; If we have more then 4 Extractors, then upgrade at least one of them.
    end
    -- Have we found a unit that can upgrade ?
    if upgradeID and upgradeBuilding then
        --LOG('* ExtractorUpgradeSorian: Upgrading Building in DistanceToBase '..(LowestDistanceToBase or 'Unknown ???')..' '..techLevel..' - UnitId '..upgradeBuilding:GetUnitId()..' - upgradeID '..upgradeID..' - GlobalUpgrading '..techLevel..': '..(UpgradingBuilding + 1) )
        IssueUpgrade({upgradeBuilding}, upgradeID)
        coroutine.yield(10)
        return true
    end
    return false
end

-- Helperfunction for ExtractorUpgradeAISorian. 
function GlobalMassUpgradeCostVsGlobalMassIncomeRatioSorian(self, aiBrain, ratio, techLevel, compareType)
    local GlobalUpgradeCost = 0
    -- get all units matching 'category'
    local unitsBuilding = aiBrain:GetListOfUnits(categories.MASSEXTRACTION * (categories.TECH1 + categories.TECH2), true)
    local numBuilding = 0
    -- if we compare for more buildings, add the cost for a building.
    if compareType == '<' or compareType == '<=' then
        numBuilding = 1
        if techLevel == 'TECH1' then
            GlobalUpgradeCost = 10
            MassIncomeLost = 2
        else
            GlobalUpgradeCost = 26
            MassIncomeLost = 6
        end
    end
    local SingleUpgradeCost
    -- own armyIndex
    local armyIndex = aiBrain:GetArmyIndex()
    -- loop over all units and search for upgrading units
    for unitNum, unit in unitsBuilding do
        if unit
            and not unit:BeenDestroyed()
            and not unit.Dead
            and not unit:IsPaused()
            and not unit:GetFractionComplete() < 1
            and unit:IsUnitState('Upgrading')
            and unit:GetAIBrain():GetArmyIndex() == armyIndex
        then
            numBuilding = numBuilding + 1
            -- look for every building, category can hold different categories / techlevels for multiple building search
            local UpgraderBlueprint = unit:GetBlueprint()
            local BeingUpgradeEconomy = __blueprints[UpgraderBlueprint.General.UpgradesTo].Economy
            SingleUpgradeCost = (UpgraderBlueprint.Economy.BuildRate / BeingUpgradeEconomy.BuildTime) * BeingUpgradeEconomy.BuildCostMass
            GlobalUpgradeCost = GlobalUpgradeCost + SingleUpgradeCost
        end
    end
    -- If we have under 20 Massincome return always false
    local MassIncome = ( aiBrain:GetEconomyIncome('MASS') * 10 ) - MassIncomeLost
    if MassIncome < 20 and ( compareType == '<' or compareType == '<=' ) then
        return false
    end
    return CompareBody(GlobalUpgradeCost / MassIncome, ratio, compareType)
end

function HaveUnitRatio(aiBrain, ratio, categoryOne, compareType, categoryTwo)
    local numOne = aiBrain:GetCurrentUnits(categoryOne)
    local numTwo = aiBrain:GetCurrentUnits(categoryTwo)
    --LOG(aiBrain:GetArmyIndex()..' CompareBody {World} ( '..numOne..' '..compareType..' '..numTwo..' ) -- ['..ratio..'] -- return '..repr(CompareBody(numOne / numTwo, ratio, compareType)))
    return CompareBody(numOne / numTwo, ratio, compareType)
end

function CompareBody(numOne, numTwo, compareType)
    if compareType == '>' then
        if numOne > numTwo then
            return true
        end
    elseif compareType == '<' then
        if numOne < numTwo then
            return true
        end
    elseif compareType == '>=' then
        if numOne >= numTwo then
            return true
        end
    elseif compareType == '<=' then
        if numOne <= numTwo then
            return true
        end
    else
       error('*AI ERROR: Invalid compare type: ' .. compareType)
       return false
    end
    return false
end

function StartMoveDestination(self,destination)
    local NowPosition = self:GetPosition()
    local x, z, y = unpack(self:GetPosition())
    local count = 0
    IssueClearCommands({self})
    while x == NowPosition[1] and y == NowPosition[3] and count < 20 do
        count = count + 1
        IssueClearCommands({self})
        IssueMove( {self}, destination )
        coroutine.yield(10)
    end
end

local PropBlacklist = {}
function ReclaimAIThreadSorian(platoon,self,aiBrain)
    local scanrange = 25
    local scanKM = 0
    local playablearea
    if ScenarioInfo.MapData.PlayableRect then
        playablearea = ScenarioInfo.MapData.PlayableRect
    else
        playablearea = {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
    end
    local basePosition = aiBrain.BuilderManagers['MAIN'].Position
    local MassStorageRatio
    local EnergyStorageRatio
    local SelfPos
    while aiBrain:PlatoonExists(platoon) and self and not self.Dead do
        SelfPos = self:GetPosition()
        MassStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
        EnergyStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
        -- 1==1 is always true, i use this to clean up the base from wreckages even if we have full eco.
        if (MassStorageRatio < 0.50 or EnergyStorageRatio < 1.00) and not aiBrain.HasParagon then
            --LOG('Searching for reclaimables')
            local x1 = SelfPos[1]-scanrange
            local y1 = SelfPos[3]-scanrange
            local x2 = SelfPos[1]+scanrange
            local y2 = SelfPos[3]+scanrange
            if x1 < playablearea[1]+6 then x1 = playablearea[1]+6 end
            if y1 < playablearea[2]+6 then y1 = playablearea[2]+6 end
            if x2 > playablearea[3]-6 then x2 = playablearea[3]-6 end
            if y2 > playablearea[4]-6 then y2 = playablearea[4]-6 end
            --LOG('GetReclaimablesInRect from x1='..math.floor(x1)..' - x2='..math.floor(x2)..' - y1='..math.floor(y1)..' - y2='..math.floor(y2)..' - scanrange='..scanrange..'')
            local props = GetReclaimablesInRect(Rect(x1, y1, x2, y2))
            local NearestWreckDist = -1
            local NearestWreckPos = {}
            local WreckDist = 0
            local WrackCount = 0
            if props and table.getn( props ) > 0 then
                for _, p in props do
                    local WreckPos = p.CachePosition
                    -- Start Blacklisted Props
                    local blacklisted = false
                    for _, BlackPos in PropBlacklist do
                        if WreckPos[1] == BlackPos[1] and WreckPos[3] == BlackPos[3] then
                            blacklisted = true
                            break
                        end
                    end
                    if blacklisted then continue end
                    -- End Blacklisted Props
                    local BPID = p.AssociatedBP or "unknown"
                    if BPID == 'ueb5101' or BPID == 'uab5101' or BPID == 'urb5101' or BPID == 'xsb5101' then -- Walls will not be reclaimed on patrols
                        continue
                    end
					-- reclaim mass if mass is lower than energy and reclaim energy if energy is lower than mass and gametime is higher then 4 minutes.
                    if (MassStorageRatio <= EnergyStorageRatio and p.MaxMassReclaim and p.MaxMassReclaim > 1) or (GetGameTimeSeconds() > 240 and MassStorageRatio > EnergyStorageRatio and p.MaxEnergyReclaim and p.MaxEnergyReclaim > 1) then
                        --LOG('Found Wreckage no.('..WrackCount..') from '..BPID..'. - Distance:'..WreckDist..' - NearestWreckDist:'..NearestWreckDist..' '..repr(MassStorageRatio < EnergyStorageRatio)..' '..repr(p.MaxMassReclaim)..' '..repr(p.MaxEnergyReclaim))
                        WreckDist = VDist2(SelfPos[1], SelfPos[3], WreckPos[1], WreckPos[3])
                        WrackCount = WrackCount + 1
                        if WreckDist < NearestWreckDist or NearestWreckDist == -1 then
                            NearestWreckDist = WreckDist
                            NearestWreckPos = WreckPos
                            --LOG('Found Wreckage no.('..WrackCount..') from '..BPID..'. - Distance:'..WreckDist..' - NearestWreckDist:'..NearestWreckDist..'')
                        end
                        if NearestWreckDist < 20 then
                            --LOG('Found Wreckage nearer then 20. break!')
                            break
                        end
                    end
                end
            end
            if self.Dead then
				--LOG('* ReclaimAIThreadSorian: Unit Dead')
                return
            end
            if NearestWreckDist == -1 then
                scanrange = math.floor(scanrange + 100)
                if scanrange > 512 then -- 5 Km
                    IssueClearCommands({self})
                    scanrange = 25
                    local HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
                    if HomeDist > 50 then
                        --LOG('noop returning home')
                        StartMoveDestination(self, {basePosition[1], basePosition[2], basePosition[3]})
                    end
                    PropBlacklist = {}
                end
                --LOG('No Wreckage, expanding scanrange:'..scanrange..'.')
            elseif math.floor(NearestWreckDist) < scanrange then
                scanrange = math.floor(NearestWreckDist)
                if scanrange < 25 then
                    scanrange = 25
                end
                --LOG('Adapting scanrange to nearest Object:'..scanrange..'.')
            end
            scanKM = math.floor(10000/512*NearestWreckDist)
            if NearestWreckDist > 20 and not self.Dead then
                --LOG('NearestWreck is > 20 away Distance:'..NearestWreckDist..'. Moving to Wreckage!')
				-- We don't need to go too close to the mapborder for reclaim, we have reclaimdrones with a flightradius of 25!
                if NearestWreckPos[1] < playablearea[1]+21 then
                    NearestWreckPos[1] = playablearea[1]+21
                end
                if NearestWreckPos[1] > playablearea[3]-21 then
                    NearestWreckPos[1] = playablearea[3]-21
                end
                if NearestWreckPos[3] < playablearea[2]+21 then
                    NearestWreckPos[3] = playablearea[2]+21
                end
                if NearestWreckPos[3] > playablearea[4]-21 then
                    NearestWreckPos[3] = playablearea[4]-21
                end
                 if self.lastXtarget == NearestWreckPos[1] and self.lastYtarget == NearestWreckPos[3] then
                    self.blocked = self.blocked + 1
                    if self.blocked > 10 then
                        self.blocked = 0
                        table.insert (PropBlacklist, NearestWreckPos)
                    end
                else
                    self.blocked = 0
                    self.lastXtarget = NearestWreckPos[1]
                    self.lastYtarget = NearestWreckPos[3]
                    StartMoveDestination(self, NearestWreckPos)
                end
            end 
            coroutine.yield(10)
            if not self.Dead and self:IsUnitState("Moving") then
                --LOG('Moving to Wreckage.')
                while self and not self.Dead and self:IsUnitState("Moving") do
                    coroutine.yield(10)
                end
                scanrange = 25
            end
            IssueClearCommands({self})
            IssuePatrol({self}, self:GetPosition())
            -- IssuePatrol({self}, self:GetPosition())
        else
            --LOG('Storage Full')
            local HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
            if HomeDist > 50 then
                --LOG('full, moving home')
                StartMoveDestination(self, {basePosition[1], basePosition[2], basePosition[3]})
                coroutine.yield(10)
                if not self.Dead and self:IsUnitState("Moving") then
                    while self and not self.Dead and self:IsUnitState("Moving") and (MassStorageRatio == 1 or EnergyStorageRatio == 1) and HomeDist > 30 do
                        MassStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
                        EnergyStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
                        HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
                        coroutine.yield(30)
                    end
                    IssueClearCommands({self})
                    scanrange = 25
                end
            else
				--LOG('* ReclaimAIThreadSorian: Storrage are full, and we are home.')
                return
            end
        end
        coroutine.yield(10)
    end
end

 -- Uveso Utilities -- Just to prevent Issues


function ExtractorPause(self, aiBrain, MassExtractorUnitList, ratio, techLevel)
    local UpgradingBuilding = nil
    local UpgradingBuildingNum = 0
    local PausedUpgradingBuilding = nil
    local PausedUpgradingBuildingNum = 0
    local DisabledBuilding = nil
    local DisabledBuildingNum = 0
    local IdleBuilding = nil
    local BussyBuilding = nil
    local IdleBuildingNum = 0
    -- loop over all MASSEXTRACTION buildings 
    for unitNum, unit in MassExtractorUnitList do
        if unit
            and not unit.Dead
            and not unit:BeenDestroyed()
            and not unit:GetFractionComplete() < 1
            and EntityCategoryContains(ParseEntityCategory(techLevel), unit)
        then
            -- Is the building upgrading ?
            if unit:IsUnitState('Upgrading') then
                -- If is paused
                if unit:IsPaused() then
                    if not PausedUpgradingBuilding then
                        PausedUpgradingBuilding = unit
                    end
                    PausedUpgradingBuildingNum = PausedUpgradingBuildingNum + 1
                -- The unit is upgrading but not paused
                else
                    if not UpgradingBuilding then
                         UpgradingBuilding = unit
                    end
                    UpgradingBuildingNum = UpgradingBuildingNum + 1
                end
            -- check if we have stopped the production
            elseif unit:GetScriptBit('RULEUTC_ProductionToggle') then
                if not DisabledBuilding then
                    DisabledBuilding = unit
                end
                DisabledBuildingNum = DisabledBuildingNum + 1
            -- we have left buildings that are not disabled, and not upgrading. Mabe they are paused ?
            else
                if not unit:IsPaused() then
                    if not IdleBuilding then
                        IdleBuilding = unit
                    end
                else
                    unit:SetPaused( false )
                end
               IdleBuildingNum = IdleBuildingNum + 1
            end
        end
    end
    --LOG('* ExtractorPause: Idle= '..UpgradingBuildingNum..'   Upgrading= '..UpgradingBuildingNum..'   Paused= '..PausedUpgradingBuildingNum..'   Disabled= '..DisabledBuildingNum..'   techLevel= '..techLevel)
    -- Check for positive Mass/Upgrade ratio
    local MassRatioCheckPositive = GlobalMassUpgradeCostVsGlobalMassIncomeRatio( self, aiBrain, ratio, techLevel, '<' )
    -- Did we found a paused unit ?
    if PausedUpgradingBuilding then
        if MassRatioCheckPositive then
            -- We have good Mass ratio. We can unpause an extractor
            PausedUpgradingBuilding:SetPaused( false )
            --PausedUpgradingBuilding:SetCustomName('PausedUpgradingBuilding2 unpaused')
            --LOG('PausedUpgradingBuilding2 unpaused')
            return true
        elseif not MassRatioCheckPositive and UpgradingBuildingNum < 1 and table.getn(MassExtractorUnitList) >= 6 then
            PausedUpgradingBuilding:SetPaused( false )
            --PausedUpgradingBuilding:SetCustomName('PausedUpgradingBuilding1 unpaused')
            --LOG('PausedUpgradingBuilding1 unpaused')
            return true
        end
    end
    -- Check for negative Mass/Upgrade ratio
    local MassRatioCheckNegative = GlobalMassUpgradeCostVsGlobalMassIncomeRatio( self, aiBrain, ratio, techLevel, '>=')
    --LOG('* ExtractorPause 2 MassRatioCheckNegative >: '..repr(MassRatioCheckNegative)..' - IF this is true , we have bad eco and we should pause.')
    if MassRatioCheckNegative then
        if UpgradingBuildingNum > 1 then
            -- we don't have the eco to upgrade the extractor. Pause it!
            if aiBrain:GetEconomyTrend('MASS') <= 0 and aiBrain:GetEconomyStored('MASS') <= 0.80  then
                UpgradingBuilding:SetPaused( true )
                --UpgradingBuilding:SetCustomName('UpgradingBuilding paused')
                --LOG('UpgradingBuilding paused')
                --LOG('* ExtractorPause: Pausing upgrading extractor')
                return true
            end
        end
        if PausedUpgradingBuilding then
            -- if we stall mass, then cancel the upgrade
            if aiBrain:GetEconomyTrend('MASS') <= 0 and aiBrain:GetEconomyStored('MASS') <= 0  then
                IssueClearCommands({PausedUpgradingBuilding})
                PausedUpgradingBuilding:SetPaused( false )
                --PausedUpgradingBuilding:SetCustomName('Upgrade canceled')
                --LOG('Upgrade canceled')
                --LOG('* ExtractorPause: Cancel upgrading extractor')
                return true
            end 
        end
    end
    return false
end

-- UnitUpgradeAIUveso is upgrading the nearest building to our own main base instead of a random building.
function ExtractorUpgrade(self, aiBrain, MassExtractorUnitList, ratio, techLevel, UnitUpgradeTemplates, StructureUpgradeTemplates)
    -- Do we have the eco to upgrade ?
    local MassRatioCheckPositive = GlobalMassUpgradeCostVsGlobalMassIncomeRatio(self, aiBrain, ratio, techLevel, '<' )
    local aiBrain = self:GetBrain()
    -- search for the neares building to the base for upgrade.
    local BasePosition = aiBrain.BuilderManagers['MAIN'].Position
    local factionIndex = aiBrain:GetFactionIndex()
    local UpgradingBuilding = 0
    local DistanceToBase = nil
    local LowestDistanceToBase = nil
    local upgradeID = nil
    local upgradeBuilding = nil
    local UnitPos = nil
    local FactionToIndex  = { UEF = 1, AEON = 2, CYBRAN = 3, SERAPHIM = 4, NOMADS = 5}
    local UnitBeingUpgradeFactionIndex = nil
    for k, v in MassExtractorUnitList do
        local TempID
        -- Check if we don't want to upgrade this unit
        if not v
            or v.Dead
            or v:BeenDestroyed()
            or v:IsPaused()
            or not EntityCategoryContains(ParseEntityCategory(techLevel), v)
            or v:GetFractionComplete() < 1
        then
            -- Skip this loop and continue with the next array
            continue
        end
        if v:IsUnitState('Upgrading') then
            UpgradingBuilding = UpgradingBuilding + 1
            -- Skip this loop and continue with the next array
            continue
        end
        -- Check for the nearest distance from mainbase
        UnitPos = v:GetPosition()
        DistanceToBase= VDist2(BasePosition[1] or 0, BasePosition[3] or 0, UnitPos[1] or 0, UnitPos[3] or 0)
        if not LowestDistanceToBase or DistanceToBase < LowestDistanceToBase then
            -- Get the factionindex from the unit to get the right update (in case we have captured this unit from another faction)
            UnitBeingUpgradeFactionIndex = FactionToIndex[v.factionCategory] or factionIndex
            -- see if we can find a upgrade
            if EntityCategoryContains(categories.MOBILE, v) then
                TempID = aiBrain:FindUpgradeBP(v:GetUnitId(), UnitUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                if not TempID then
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find UnitUpgradeTemplate for mobile unit: ' .. repr(v:GetUnitId()) )
                end
            else
                TempID = aiBrain:FindUpgradeBP(v:GetUnitId(), StructureUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                if not TempID then
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find StructureUpgradeTemplate for structure: ' .. repr(v:GetUnitId()) )
                end
            end 
            -- Check if we can build the upgrade
            if TempID and EntityCategoryContains(categories.STRUCTURE, v) and not v:CanBuild(TempID) then
                WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t upgrade structure with StructureUpgradeTemplate: ' .. repr(v:GetUnitId()) )
            elseif TempID then
                upgradeID = TempID
                upgradeBuilding = v
                LowestDistanceToBase = DistanceToBase
            end
        end
    end
    -- If we have not the Eco then return false. Exept we have none extractor upgrading or 100% mass storrage
    -- mass < 95 then return false
    -- aiBrain:GetEconomyStoredRatio('MASS') < 0.95
    if not MassRatioCheckPositive and aiBrain:GetEconomyStoredRatio('MASS') < 0.80 or aiBrain:GetEconomyStoredRatio('ENERGY') < 0.95 then
        -- if we have at least 1 extractor upgrading or less then 4 extractors, then return false
        if UpgradingBuilding > 0 or table.getn(MassExtractorUnitList) < 4 then
            return false
        end
        -- Even if we don't have the Eco for it; If we have more then 4 Extractors, then upgrade at least one of them.
    end
    -- Have we found a unit that can upgrade ?
    if upgradeID and upgradeBuilding then
        --LOG('* UnitUpgradeAIUveso: Upgrading Building in DistanceToBase '..(LowestDistanceToBase or 'Unknown ???')..' '..techLevel..' - UnitId '..upgradeBuilding:GetUnitId()..' - upgradeID '..upgradeID..' - GlobalUpgrading '..techLevel..': '..(UpgradingBuilding + 1) )
        IssueUpgrade({upgradeBuilding}, upgradeID)
        coroutine.yield(10)
        return true
    end
    return false
end

-- Helperfunction for ExtractorUpgradeAI. 
function GlobalMassUpgradeCostVsGlobalMassIncomeRatio(self, aiBrain, ratio, techLevel, compareType)
    local GlobalUpgradeCost = 0
    -- get all units matching 'category'
    local unitsBuilding = aiBrain:GetListOfUnits(categories.MASSEXTRACTION * (categories.TECH1 + categories.TECH2), true)
    local numBuilding = 0
    -- if we compare for more buildings, add the cost for a building.
    if compareType == '<' or compareType == '<=' then
        numBuilding = 1
        if techLevel == 'TECH1' then
            GlobalUpgradeCost = 10
            MassIncomeLost = 2
        else
            GlobalUpgradeCost = 26
            MassIncomeLost = 6
        end
    end
    local SingleUpgradeCost
    -- own armyIndex
    local armyIndex = aiBrain:GetArmyIndex()
    -- loop over all units and search for upgrading units
    for unitNum, unit in unitsBuilding do
        if unit
            and not unit:BeenDestroyed()
            and not unit.Dead
            and not unit:IsPaused()
            and not unit:GetFractionComplete() < 1
            and unit:IsUnitState('Upgrading')
            and unit:GetAIBrain():GetArmyIndex() == armyIndex
        then
            numBuilding = numBuilding + 1
            -- look for every building, category can hold different categories / techlevels for multiple building search
            local UpgraderBlueprint = unit:GetBlueprint()
            local BeingUpgradeEconomy = __blueprints[UpgraderBlueprint.General.UpgradesTo].Economy
            SingleUpgradeCost = (UpgraderBlueprint.Economy.BuildRate / BeingUpgradeEconomy.BuildTime) * BeingUpgradeEconomy.BuildCostMass
            GlobalUpgradeCost = GlobalUpgradeCost + SingleUpgradeCost
        end
    end
    -- If we have under 20 Massincome return always false
    local MassIncome = ( aiBrain:GetEconomyIncome('MASS') * 10 ) - MassIncomeLost
    if MassIncome < 20 and ( compareType == '<' or compareType == '<=' ) then
        return false
    end
    return CompareBody(GlobalUpgradeCost / MassIncome, ratio, compareType)
end

function HaveUnitRatio(aiBrain, ratio, categoryOne, compareType, categoryTwo)
    local numOne = aiBrain:GetCurrentUnits(categoryOne)
    local numTwo = aiBrain:GetCurrentUnits(categoryTwo)
    --LOG(aiBrain:GetArmyIndex()..' CompareBody {World} ( '..numOne..' '..compareType..' '..numTwo..' ) -- ['..ratio..'] -- return '..repr(CompareBody(numOne / numTwo, ratio, compareType)))
    return CompareBody(numOne / numTwo, ratio, compareType)
end

function CompareBody(numOne, numTwo, compareType)
    if compareType == '>' then
        if numOne > numTwo then
            return true
        end
    elseif compareType == '<' then
        if numOne < numTwo then
            return true
        end
    elseif compareType == '>=' then
        if numOne >= numTwo then
            return true
        end
    elseif compareType == '<=' then
        if numOne <= numTwo then
            return true
        end
    else
       error('*AI ERROR: Invalid compare type: ' .. compareType)
       return false
    end
    return false
end

local PropBlacklist = {}
function ReclaimAIThread(platoon,self,aiBrain)
    local scanrange = 25
    local scanKM = 0
    local playablearea
    if  ScenarioInfo.MapData.PlayableRect then
        playablearea = ScenarioInfo.MapData.PlayableRect
    else
        playablearea = {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
    end
    local basePosition = aiBrain.BuilderManagers['MAIN'].Position
    local MassStorageRatio
    local EnergyStorageRatio
    local SelfPos
    while aiBrain:PlatoonExists(platoon) and self and not self.Dead do
        SelfPos = self:GetPosition()
        MassStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
        EnergyStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
        -- 1==1 is always true, i use this to clean up the base from wreckages even if we have full eco.
        if (MassStorageRatio < 1.00 or EnergyStorageRatio < 1.00) and not aiBrain.PriorityManager.HasParagon then
            --LOG('Searching for reclaimables')
            local x1 = SelfPos[1]-scanrange
            local y1 = SelfPos[3]-scanrange
            local x2 = SelfPos[1]+scanrange
            local y2 = SelfPos[3]+scanrange
            if x1 < playablearea[1]+6 then x1 = playablearea[1]+6 end
            if y1 < playablearea[2]+6 then y1 = playablearea[2]+6 end
            if x2 > playablearea[3]-6 then x2 = playablearea[3]-6 end
            if y2 > playablearea[4]-6 then y2 = playablearea[4]-6 end
            --LOG('GetReclaimablesInRect from x1='..math.floor(x1)..' - x2='..math.floor(x2)..' - y1='..math.floor(y1)..' - y2='..math.floor(y2)..' - scanrange='..scanrange..'')
            local props = GetReclaimablesInRect(Rect(x1, y1, x2, y2))
            local NearestWreckDist = -1
            local NearestWreckPos = {}
            local WreckDist = 0
            local WrackCount = 0
            if props and table.getn( props ) > 0 then
                for _, p in props do
                    local WreckPos = p.CachePosition
                    -- Start Blacklisted Props
                    local blacklisted = false
                    for _, BlackPos in PropBlacklist do
                        if WreckPos[1] == BlackPos[1] and WreckPos[3] == BlackPos[3] then
                            blacklisted = true
                            break
                        end
                    end
                    if blacklisted then continue end
                    -- End Blacklisted Props
                    local BPID = p.AssociatedBP or "unknown"
                    if BPID == 'ueb5101' or BPID == 'uab5101' or BPID == 'urb5101' or BPID == 'xsb5101' then -- Walls will not be reclaimed on patrols
                        continue
                    end
					-- reclaim mass if mass is lower than energy and reclaim energy if energy is lower than mass and gametime is higher then 4 minutes.
                    if (MassStorageRatio <= EnergyStorageRatio and p.MaxMassReclaim and p.MaxMassReclaim > 1) or (GetGameTimeSeconds() > 240 and MassStorageRatio > EnergyStorageRatio and p.MaxEnergyReclaim and p.MaxEnergyReclaim > 1) then
                        --LOG('Found Wreckage no.('..WrackCount..') from '..BPID..'. - Distance:'..WreckDist..' - NearestWreckDist:'..NearestWreckDist..' '..repr(MassStorageRatio < EnergyStorageRatio)..' '..repr(p.MaxMassReclaim)..' '..repr(p.MaxEnergyReclaim))
                        WreckDist = VDist2(SelfPos[1], SelfPos[3], WreckPos[1], WreckPos[3])
                        WrackCount = WrackCount + 1
                        if WreckDist < NearestWreckDist or NearestWreckDist == -1 then
                            NearestWreckDist = WreckDist
                            NearestWreckPos = WreckPos
                            --LOG('Found Wreckage no.('..WrackCount..') from '..BPID..'. - Distance:'..WreckDist..' - NearestWreckDist:'..NearestWreckDist..'')
                        end
                        if NearestWreckDist < 20 then
                            --LOG('Found Wreckage nearer then 20. break!')
                            break
                        end
                    end
                end
            end
            if self.Dead then
				--LOG('* ReclaimAIThread: Unit Dead')
                return
            end
            if NearestWreckDist == -1 then
                scanrange = math.floor(scanrange + 100)
                if scanrange > 512 then -- 5 Km
                    IssueClearCommands({self})
                    scanrange = 25
                    local HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
                    if HomeDist > 50 then
                        --LOG('noop returning home')
                        StartMoveDestination(self, {basePosition[1], basePosition[2], basePosition[3]})
                    end
                    PropBlacklist = {}
                end
                --LOG('No Wreckage, expanding scanrange:'..scanrange..'.')
            elseif math.floor(NearestWreckDist) < scanrange then
                scanrange = math.floor(NearestWreckDist)
                if scanrange < 25 then
                    scanrange = 25
                end
                --LOG('Adapting scanrange to nearest Object:'..scanrange..'.')
            end
            scanKM = math.floor(10000/512*NearestWreckDist)
            if NearestWreckDist > 20 and not self.Dead then
                --LOG('NearestWreck is > 20 away Distance:'..NearestWreckDist..'. Moving to Wreckage!')
				-- We don't need to go too close to the mapborder for reclaim, we have reclaimdrones with a flightradius of 25!
                if NearestWreckPos[1] < playablearea[1]+21 then
                    NearestWreckPos[1] = playablearea[1]+21
                end
                if NearestWreckPos[1] > playablearea[3]-21 then
                    NearestWreckPos[1] = playablearea[3]-21
                end
                if NearestWreckPos[3] < playablearea[2]+21 then
                    NearestWreckPos[3] = playablearea[2]+21
                end
                if NearestWreckPos[3] > playablearea[4]-21 then
                    NearestWreckPos[3] = playablearea[4]-21
                end
                 if self.lastXtarget == NearestWreckPos[1] and self.lastYtarget == NearestWreckPos[3] then
                    self.blocked = self.blocked + 1
                    if self.blocked > 10 then
                        self.blocked = 0
                        table.insert (PropBlacklist, NearestWreckPos)
                    end
                else
                    self.blocked = 0
                    self.lastXtarget = NearestWreckPos[1]
                    self.lastYtarget = NearestWreckPos[3]
                    StartMoveDestination(self, NearestWreckPos)
                end
            end 
            coroutine.yield(10)
            if not self.Dead and self:IsUnitState("Moving") then
                --LOG('Moving to Wreckage.')
                while self and not self.Dead and self:IsUnitState("Moving") do
                    coroutine.yield(10)
                end
                scanrange = 25
            end
            IssueClearCommands({self})
            IssuePatrol({self}, self:GetPosition())
            IssuePatrol({self}, self:GetPosition())
        else
            --LOG('Storage Full')
            local HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
            if HomeDist > 36 then
                --LOG('full, moving home')
                StartMoveDestination(self, {basePosition[1], basePosition[2], basePosition[3]})
                coroutine.yield(10)
                if not self.Dead and self:IsUnitState("Moving") then
                    while self and not self.Dead and self:IsUnitState("Moving") and (MassStorageRatio == 1 or EnergyStorageRatio == 1) and HomeDist > 30 do
                        MassStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
                        EnergyStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
                        HomeDist = VDist2(SelfPos[1], SelfPos[3], basePosition[1], basePosition[3])
                        coroutine.yield(30)
                    end
                    IssueClearCommands({self})
                    scanrange = 25
                end
            else
				--LOG('* ReclaimAIThread: Storrage are full, and we are home.')
                return
            end
        end
        coroutine.yield(10)
    end
end

function StartMoveDestination(self,destination)
    local NowPosition = self:GetPosition()
    local x, z, y = unpack(self:GetPosition())
    local count = 0
    IssueClearCommands({self})
    while x == NowPosition[1] and y == NowPosition[3] and count < 20 do
        count = count + 1
        IssueClearCommands({self})
        IssueMove( {self}, destination )
        coroutine.yield(10)
    end
end

---------------------------------------------
--   Tactical Missile Launcher AI Thread   --
---------------------------------------------
local MissileTimer = 0
local EBC = '/lua/editor/EconomyBuildConditions.lua'

function TMLAIThread(platoon,self,aiBrain)
    local bp = self:GetBlueprint()
    local weapon = bp.Weapon[1]
    local maxRadius = weapon.MaxRadius or 256
    local minRadius = weapon.MinRadius or 15
    local MaxLoad = weapon.MaxProjectileStorage or 4
    self:SetAutoMode(true)
    while aiBrain:PlatoonExists(platoon) and self and not self.Dead do
        local target = false
        while self and not self.Dead and self:GetTacticalSiloAmmoCount() < 2 do
            coroutine.yield(10)
        end
        while self and not self.Dead and self:IsPaused() do
            coroutine.yield(10)
        end
        if not EBC.GreaterThanEconTrend( 0.4, 0.8 ) then
			self:SetAutoMode(false)
			IssueClearCommands({self})
            coroutine.yield(10)
		else
			self:SetAutoMode(true)
        end
        while self and not self.Dead and self:GetTacticalSiloAmmoCount() > 1 and not target and not self:IsPaused() do
            target = false
            while self and not self.Dead and not target do
                coroutine.yield(10)
                while self and not self.Dead and not self:IsIdleState() do
                    coroutine.yield(10)
                end
                if self.Dead then return end
                target = FindTargetUnit(self, minRadius, maxRadius, MaxLoad)
            end
        end
        if self and not self.Dead and target and not target.Dead and MissileTimer < GetGameTimeSeconds() then
            MissileTimer = GetGameTimeSeconds() + 1
            if EntityCategoryContains(categories.STRUCTURE, target) then
                if self:GetTacticalSiloAmmoCount() >= MaxLoad then
                    IssueTactical({self}, target)
                end
            else
                targPos = LeadTarget(self, target)
                if targPos and targPos[1] > 0 and targPos[3] > 0 then
                    if EntityCategoryContains(categories.EXPERIMENTAL - categories.AIR, target) or self:GetTacticalSiloAmmoCount() >= MaxLoad then
                        IssueTactical({self}, targPos)
                    end
                else
                    target = false
                end
            end
        end
        coroutine.yield(10)
    end
end

function FindTargetUnit(self, minRadius, maxRadius, MaxLoad)
    local position = self:GetPosition()
    local aiBrain = self:GetAIBrain()
    local targets = GetEnemyUnitsInSphereOnRadar(aiBrain, position, minRadius, maxRadius)
    if not targets or not self or self.Dead then return false end
    local MissileCount = self:GetTacticalSiloAmmoCount()
    local AllTargets = {}
    local MaxHealthpoints = 0
    local UnitHealth
    local uBP
    for k, v in targets do
        -- Only check if Unit is 100% builded and not AIR
        if not v.Dead and not v:BeenDestroyed() and v:GetFractionComplete() == 1 and EntityCategoryContains(categories.SELECTABLE - categories.AIR, v) then
            -- Get Target Data
            uBP = v:GetBlueprint()
            UnitHealth = uBP.Defense.Health or 1
            -- Check Targets
            if not v:BeenDestroyed() and EntityCategoryContains(categories.COMMAND, v) and (not IsProtected(self,v:GetPosition())) then
                AllTargets[1] = v
            elseif not v:BeenDestroyed() and (UnitHealth > MaxHealthpoints or (UnitHealth == MaxHealthpoints and v.distance < AllTargets[2].distance)) and EntityCategoryContains(categories.EXPERIMENTAL * categories.MOBILE, v) and (not IsProtected(self,v:GetPosition())) then
                AllTargets[2] = v
                MaxHealthpoints = UnitHealth
            elseif not v:BeenDestroyed() and UnitHealth > MaxHealthpoints and EntityCategoryContains(categories.MOBILE, v) and uBP.StrategicIconName == 'icon_experimental_generic' and (not IsProtected(self,v:GetPosition())) then
                AllTargets[3] = v
                MaxHealthpoints = UnitHealth
            elseif not v:BeenDestroyed() and (not AllTargets[5] or v.distance < AllTargets[5].distance) and EntityCategoryContains(categories.STRUCTURE - categories.WALL, v) and (not IsProtected(self,v:GetPosition())) then
                AllTargets[5] = v
                break
            elseif not v:BeenDestroyed() and v:IsMoving() == false then
                if (not AllTargets[4] or v.distance < AllTargets[4].distance) and EntityCategoryContains(categories.TECH3 * categories.MOBILE * categories.INDIRECTFIRE, v) and (not IsProtected(self,v:GetPosition())) then
                    AllTargets[4] = v
                elseif (not AllTargets[6] or v.distance < AllTargets[6].distance) and EntityCategoryContains(categories.ENGINEER - categories.STATIONASSISTPOD, v) and (not IsProtected(self,v:GetPosition())) then
                    AllTargets[6] = v
                elseif (not AllTargets[7] or v.distance < AllTargets[7].distance) and EntityCategoryContains(categories.MOBILE, v) and (not IsProtected(self,v:GetPosition())) then
                    AllTargets[7] = v
                end
            end
        end
    end
    local TargetType = {
        "Com", -- 1 Commander
        "Exp", -- 2 Experimental. Attack order: highes maxunithealth. (not actual healthbar!)
        "Hea", -- 3 Heavy Assault. (small experimentals from Total Mayhem, Experimental Wars etc.)
        "Art", -- 4 Mobile T3 Unit with indirect Fire and only if the unit don't move. (Artillery / Missilelauncher)
        "Bui", -- 5 T1,T2,T3 Structures. Attack order: nearest completed building.
        "Eng", -- 6 Engineer (fire only on not moving units)
        "Mob", -- 7 Mobile (fire only on not moving units)
    }
    for k, v in sortedpairs(AllTargets) do
        -- Don't shoot at protected targets
        if MissileCount >= 2 then
            if k <= 3 then
                return v
            end
        end
        if MissileCount >= MaxLoad - 2 then
            if k <= 4 then
                return v
            end
        end
        if MissileCount >= MaxLoad then
            return v
        end
    end
    return false
end
function LeadTarget(launcher, target)
    -- Get launcher and target position
    local LauncherPos = launcher:GetPosition()
    local TargetPos
    -- Get target position in 1 second intervals.
    -- This allows us to get speed and direction from the target
    local TargetStartPosition=0
    local Target1SecPos=0
    local Target2SecPos=0
    local XmovePerSec=0
    local YmovePerSec=0
    local XmovePerSecCheck=-1
    local YmovePerSecCheck=-1
    -- Check if the target is runing straight or circling
    -- If x/y and xcheck/ycheck are equal, we can be sure the target is moving straight
    -- in one direction. At least for the last 2 seconds.
    local LoopSaveGuard = 0
    while target and (XmovePerSec ~= XmovePerSecCheck or YmovePerSec ~= YmovePerSecCheck) and LoopSaveGuard < 10 do
        -- 1st position of target
        TargetPos = target:GetPosition()
        TargetStartPosition = {TargetPos[1], 0, TargetPos[3]}
        coroutine.yield(10)
        -- 2nd position of target after 1 second
        TargetPos = target:GetPosition()
        Target1SecPos = {TargetPos[1], 0, TargetPos[3]}
        XmovePerSec = (TargetStartPosition[1] - Target1SecPos[1])
        YmovePerSec = (TargetStartPosition[3] - Target1SecPos[3])
        coroutine.yield(10)
        -- 3rd position of target after 2 seconds to verify straight movement
        TargetPos = target:GetPosition()
        Target2SecPos = {TargetPos[1], TargetPos[2], TargetPos[3]}
        XmovePerSecCheck = (Target1SecPos[1] - Target2SecPos[1])
        YmovePerSecCheck = (Target1SecPos[3] - Target2SecPos[3])
        --We leave the while-do check after 10 loops (20 seconds) and try collateral damage
        --This can happen if a player try to fool the targetingsystem by circling a unit.
        LoopSaveGuard = LoopSaveGuard + 1
    end
    -- Get launcher position height
    local fromheight = GetTerrainHeight(LauncherPos[1], LauncherPos[3])
    if GetSurfaceHeight(LauncherPos[1], LauncherPos[3]) > fromheight then
        fromheight = GetSurfaceHeight(LauncherPos[1], LauncherPos[3])
    end
    -- Get target position height
    local toheight = GetTerrainHeight(Target2SecPos[1], Target2SecPos[3])
    if GetSurfaceHeight(Target2SecPos[1], Target2SecPos[3]) > toheight then
        toheight = GetSurfaceHeight(Target2SecPos[1], Target2SecPos[3])
    end
    -- Get height difference between launcher position and target position
    -- Adjust for height difference by dividing the height difference by the missiles max speed
    local HeightDifference = math.abs(fromheight - toheight) / 12
    -- Speed up time is distance the missile will travel while reaching max speed (~22.47 MapUnits)
    -- divided by the missiles max speed (12) which is equal to 1.8725 seconds flight time
    local SpeedUpTime = 22.47 / 12
    --  Missile needs 3 seconds to launch
    local LaunchTime = 3
    -- Get distance from launcher position to targets starting position and position it moved to after 1 second
    local dist1 = VDist2(LauncherPos[1], LauncherPos[3], Target1SecPos[1], Target1SecPos[3])
    local dist2 = VDist2(LauncherPos[1], LauncherPos[3], Target2SecPos[1], Target2SecPos[3])
    -- Missile has a faster turn rate when targeting targets < 50 MU away, so it will level off faster
    local LevelOffTime = 0.25
    local CollisionRangeAdjust = 0
    if dist2 < 50 then
        LevelOffTime = 0.02
        CollisionRangeAdjust = 2
    end
    -- Divide both distances by missiles max speed to get time to impact
    local time1 = (dist1 / 12) + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    local time2 = (dist2 / 12) + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    -- Get the missile travel time by extrapolating speed and time from dist1 and dist2
    local MissileTravelTime = (time2 + (time2 - time1)) + ((time2 - time1) * time2)
    -- Now adding all times to get final missile flight time to the position where the target will be
    local MissileImpactTime = MissileTravelTime + LaunchTime + SpeedUpTime + LevelOffTime + HeightDifference
    -- Create missile impact corrdinates based on movePerSec * MissileImpactTime
    local MissileImpactX = Target2SecPos[1] - (XmovePerSec * MissileImpactTime)
    local MissileImpactY = Target2SecPos[3] - (YmovePerSec * MissileImpactTime)
    -- Adjust for targets CollisionOffsetY. If the hitbox of the unit is above the ground
    -- we nedd to fire "behind" the target, so we hit the unit in midair.
    local TargetCollisionBoxAdjust = 0
    local TargetBluePrint = target:GetBlueprint()
    if TargetBluePrint.CollisionOffsetY and TargetBluePrint.CollisionOffsetY > 0 then
        -- if the unit is far away we need to target farther behind the target because of the projectile flight angel
        local DistanceOffset = (100 / 256 * dist2) * 0.06
        TargetCollisionBoxAdjust = TargetBluePrint.CollisionOffsetY * CollisionRangeAdjust + DistanceOffset
    end
    -- To calculate the Adjustment behind the target we use a variation of the Pythagorean theorem. (Percent scale technique)
    -- (a²+b²=c²) If we add x% to c² then also a² and b² are x% larger. (a²)*x% + (b²)*x% = (c²)*x%
    local Hypotenuse = VDist2(LauncherPos[1], LauncherPos[3], MissileImpactX, MissileImpactY)
    local HypotenuseScale = 100 / Hypotenuse * TargetCollisionBoxAdjust
    local aLegScale = (MissileImpactX - LauncherPos[1]) / 100 * HypotenuseScale
    local bLegScale = (MissileImpactY - LauncherPos[3]) / 100 * HypotenuseScale
    -- Add x percent (behind) the target coordinates to get our final missile impact coordinates
    MissileImpactX = MissileImpactX + aLegScale
    MissileImpactY = MissileImpactY + bLegScale
    -- Cancel firing if target is outside map boundries
    if MissileImpactX < 0 or MissileImpactY < 0 or MissileImpactX > ScenarioInfo.size[1] or MissileImpactY > ScenarioInfo.size[2] then
        return false
    end
    -- Also cancel if target would be out of weaponrange or inside minimum range.
    local LauncherBluePrint = launcher:GetBlueprint()
    local maxRadius = LauncherBluePrint.Weapon[1].MaxRadius or 256
    local minRadius = LauncherBluePrint.Weapon[1].MinRadius or 15
    local dist3 = VDist2(LauncherPos[1], LauncherPos[3], MissileImpactX, MissileImpactY)
    if dist3 < minRadius or dist3 > maxRadius then
        return false
    end
    -- return extrapolated target position / missile impact coordinates
    return {MissileImpactX, Target2SecPos[2], MissileImpactY}
end
function GetEnemyUnitsInSphereOnRadar(aiBrain, position, minRadius, maxRadius)
    local x1 = position[1] - maxRadius
    local z1 = position[3] - maxRadius
    local x2 = position[1] + maxRadius
    local z2 = position[3] + maxRadius
    local UnitsinRec = GetUnitsInRect( Rect(x1, z1, x2, z2) )
    if not UnitsinRec then
        return UnitsinRec
    end
    local SelfArmyIndex = aiBrain:GetArmyIndex()
    local RadEntities = {}
    coroutine.yield(1)
    local lagstopper = 0
    for Index, EnemyUnit in UnitsinRec do
        lagstopper = lagstopper + 1
        if lagstopper > 20 then
            coroutine.yield(1)
            lagstopper = 0
        end
        if (not EnemyUnit.Dead) and IsEnemy( SelfArmyIndex, EnemyUnit:GetArmy() ) then
            local EnemyPosition = EnemyUnit:GetPosition()
            -- check if the target is under water.
            local SurfaceHeight = GetSurfaceHeight(EnemyPosition[1], EnemyPosition[3])
            if EnemyPosition[2] < SurfaceHeight - 0.5 then
                continue
            end
            local dist = VDist2(position[1], position[3], EnemyPosition[1], EnemyPosition[3])
            if (dist <= maxRadius) and (dist > minRadius) then
                local blip = EnemyUnit:GetBlip(SelfArmyIndex)
                if blip then
                    if blip:IsOnRadar(SelfArmyIndex) or blip:IsSeenEver(SelfArmyIndex) then
                        if not blip:BeenDestroyed() and not blip:IsKnownFake(SelfArmyIndex) and not blip:IsMaybeDead(SelfArmyIndex) then
                            EnemyUnit.distance = dist
                            table.insert(RadEntities, EnemyUnit)
                        end
                    end
                end
            end
        end
    end
    return RadEntities
end
function IsProtected(self,position)
    local maxRadius = 14
    local x1 = position.x - maxRadius
    local z1 = position.z - maxRadius
    local x2 = position.x + maxRadius
    local z2 = position.z + maxRadius
    local UnitsinRec = GetUnitsInRect( Rect(x1, z1, x2, z2) )
    if not UnitsinRec then
        return false
    end
    coroutine.yield(1)
    local lagstopper = 0
    local counter = 0
    for _, EnemyUnit in UnitsinRec do
        counter = counter + 1
        lagstopper = lagstopper + 1
        if lagstopper > 20 then
            coroutine.yield(1)
            lagstopper = 0
        end
        if (not EnemyUnit.Dead) and IsEnemy( self:GetArmy(), EnemyUnit:GetArmy() ) then
            if EntityCategoryContains(categories.ANTIMISSILE * categories.TECH2 * categories.STRUCTURE, EnemyUnit) then
                local EnemyPosition = EnemyUnit:GetPosition()
                local dist = VDist2(position[1], position[3], EnemyPosition[1], EnemyPosition[3])
                if dist <= maxRadius then
                    return true
                end
            end
        end
    end
    return false
end

function ComHealth(cdr)
    local armorPercent = 100 / cdr:GetMaxHealth() * cdr:GetHealth()
    local shieldPercent = armorPercent
    if cdr.MyShield then
        shieldPercent = 100 / cdr.MyShield:GetMaxHealth() * cdr.MyShield:GetHealth()
    end
    return ( armorPercent + shieldPercent ) / 2
end

function CDRRunHomeEnemyNearBase(platoon,cdr,UnitsInBasePanicZone)
    local minEnemyDist, EnemyPosition
    local enemyCount = 0
    for _, EnemyUnit in UnitsInBasePanicZone do
        if not EnemyUnit.Dead and not EnemyUnit:BeenDestroyed() then
            if EntityCategoryContains(categories.MOBILE * categories.EXPERIMENTAL, EnemyUnit) then
                --LOG('* ACUAttackAIUveso: CDRRunHomeEnemyNearBase EXPERIMENTAL!!!! RUN HOME:')
                minEnemyDist = 40
                break
            end
            enemyCount = enemyCount + 1
            EnemyPosition = EnemyUnit:GetPosition()
            local dist = VDist2(cdr.CDRHome[1], cdr.CDRHome[3], EnemyPosition[1], EnemyPosition[3])
            if not minEnemyDist or minEnemyDist > dist then
                minEnemyDist = dist
            end
        end
    end
    if minEnemyDist then
        local CDRDist = VDist2(cdr.position[1], cdr.position[3], cdr.CDRHome[1], cdr.CDRHome[3])
        local cdrNewPos = {}
        if CDRDist > minEnemyDist then
            cdrNewPos[1] = cdr.CDRHome[1] + Random(-6, 6)
            cdrNewPos[2] = cdr.CDRHome[2]
            cdrNewPos[3] = cdr.CDRHome[3] + Random(-6, 6)
            platoon:Stop()
            coroutine.yield(1)
            platoon:MoveToLocation(cdrNewPos, false)
            coroutine.yield(50)
            return true
        end
    end
    return false
end

function CDRRunHomeHealthRange(platoon,cdr,maxRadius)
    local cdrNewPos = {}
    if VDist2(cdr.position[1], cdr.position[3], cdr.CDRHome[1], cdr.CDRHome[3]) > maxRadius then
        cdrNewPos[1] = cdr.CDRHome[1] + Random(-6, 6)
        cdrNewPos[2] = cdr.CDRHome[2]
        cdrNewPos[3] = cdr.CDRHome[3] + Random(-6, 6)
        platoon:Stop()
        coroutine.yield(1)
        platoon:MoveToLocation(cdrNewPos, false)
        coroutine.yield(50)
        return true
    end
    return false
end

function CDRRunHomeAtDamage(platoon,cdr)
    local CDRHealth = ComHealth(cdr)
    local diff = CDRHealth - cdr.HealthOLD
    if diff < -1 then
        --LOG('Health diff = '..diff)
        local cdrNewPos = {}
        cdrNewPos[1] = cdr.CDRHome[1] + Random(-6, 6)
        cdrNewPos[2] = cdr.CDRHome[2]
        cdrNewPos[3] = cdr.CDRHome[3] + Random(-6, 6)
        platoon:Stop()
        coroutine.yield(1)
        platoon:MoveToLocation(cdrNewPos, false)
        coroutine.yield(10)
        cdr.HealthOLD = CDRHealth
        return true
    end    
    cdr.HealthOLD = CDRHealth
    return false
end

function CDRForceRunHome(platoon,cdr)
    local cdrNewPos = {}
    cdrNewPos[1] = cdr.CDRHome[1] + Random(-6, 6)
    cdrNewPos[2] = cdr.CDRHome[2]
    cdrNewPos[3] = cdr.CDRHome[3] + Random(-6, 6)
    platoon:Stop()
    coroutine.yield(1)
    platoon:MoveToLocation(cdrNewPos, false)
    coroutine.yield(30)
    if VDist2(cdr.position[1], cdr.position[3], cdr.CDRHome[1], cdr.CDRHome[3]) > 20 then
        return true
    end
    return false
end

function CDRParkingHome(platoon,cdr)
    local cdrNewPos = {}
    while VDist2(cdr.position[1], cdr.position[3], cdr.CDRHome[1], cdr.CDRHome[3]) > 20 do
        cdr.position = platoon:GetPlatoonPosition()
        cdrNewPos[1] = cdr.CDRHome[1] + Random(-6, 6)
        cdrNewPos[2] = cdr.CDRHome[2]
        cdrNewPos[3] = cdr.CDRHome[3] + Random(-6, 6)
        platoon:Stop()
        coroutine.yield(1)
        platoon:MoveToLocation(cdrNewPos, false)
        coroutine.yield(30)
    end
    return
end

function RandomizePosition(position)
    local Posx = position[1]
    local Posz = position[3]
    local X = -1
    local Z = -1
    while X <= 0 or X >= ScenarioInfo.size[1] do
        X = Posx + Random(-10, 10)
    end
    while Z <= 0 or Z >= ScenarioInfo.size[2] do
        Z = Posz + Random(-10, 10)
    end
    local Y = GetTerrainHeight(Posx, Posz)
    if GetSurfaceHeight(Posx, Posz) > Y then
        Y = GetSurfaceHeight(Posx, Posz)
    end
    return {X, Y, Z}
end

-- Please don't change any range here!!!
-- Called from AIBuilders/*.*, simInit.lua, aiarchetype-managerloader.lua
function GetDangerZoneRadii(bool)
    -- Military zone is the half the map size (10x10map) or maximal 250.
    local BaseMilitaryZone = math.max( ScenarioInfo.size[1]-50, ScenarioInfo.size[2]-50 ) / 2
    BaseMilitaryZone = math.max( 250, BaseMilitaryZone )
    -- Panic Zone is half the BaseMilitaryZone. That's 1/4 of a 10x10 map
    local BasePanicZone = BaseMilitaryZone / 2
    -- Make sure the Panic Zone is not smaller than 60 or greater than 120
    BasePanicZone = math.max( 60, BasePanicZone )
    BasePanicZone = math.min( 120, BasePanicZone )
    -- The rest of the map is enemy zone
    local BaseEnemyZone = math.max( ScenarioInfo.size[1], ScenarioInfo.size[2] ) * 1.5
    -- "bool" is only true if called from "AIBuilders/Mobile Land.lua", so we only print this once.
    if bool then
        LOG('* AI-Uveso: BasePanicZone= '..math.floor( BasePanicZone * 0.01953125 ) ..' Km - ('..BasePanicZone..' units)' )
        LOG('* AI-Uveso: BaseMilitaryZone= '..math.floor( BaseMilitaryZone * 0.01953125 )..' Km - ('..BaseMilitaryZone..' units)' )
        LOG('* AI-Uveso: BaseEnemyZone= '..math.floor( BaseEnemyZone * 0.01953125 )..' Km - ('..BaseEnemyZone..' units)' )
    end
    return BasePanicZone, BaseMilitaryZone, BaseEnemyZone
end

function AIGetReclaimablesAroundLocationSorianEdit(aiBrain, locationType)
    local position, radius
    if aiBrain.HasPlatoonList then
        for _, v in aiBrain.PBM.Locations do
            if v.LocationType == locationType then
                position = v.Location
                radius = 500
                break
            end
        end
    elseif aiBrain.BuilderManagers[locationType] then
        radius = 500
        position = aiBrain.BuilderManagers[locationType].FactoryManager:GetLocationCoords()
    end

    if not position then
        return false
    end

    local x1 = position[1] - radius
    local x2 = position[1] + radius
    local z1 = position[3] - radius
    local z2 = position[3] + radius
    local rect = Rect(x1, z1, x2, z2)

    return GetReclaimablesInRect(rect)
end

function IsTableArray(tTable)
    if tTable[1] == nil then
        --LOG('tTable[1] is a nil value')
        return false end
    return true
end

function GetTableSize(tTable)
    local count = 0
    for _ in pairs(tTable) do count = count + 1 end
    return count
end

function GetAIBrainArmyNumber(aiBrain)
    return tonumber(string.sub(aiBrain.Name, (string.len(aiBrain.Name)-7)))
end

function GetBuildingTypeInfo(BuildingType, iInfoWanted, sFaction)
    --iInfoWanted: 1 = Array with the building size, returnign X and Z size (doesnt return Y); 2 = Unit blueprint for sFaction; sFaction can be UEF, CYBRAN, AEON, SERAPHIM, or nil (will use UEF)

    local SizeArray = {}
    local UnitBlueprint = nil
    if sFaction == nil then sFaction = 'UEF' end
    if BuildingType == 'T1LandFactory' then
        SizeArray = {8, 8}
        if sFaction == 'AEON' then UnitBlueprint = 'UAB0101'
        elseif sFaction == 'CYBRAN' then UnitBlueprint = 'URB0101'
        elseif sFaction == 'SERAPHIM' then UnitBlueprint = 'XSB0101'
        else UnitBlueprint = 'UEB0101'
        end
    elseif BuildingType == 'T1Resource' then
        SizeArray = {2, 2}
        if sFaction == 'AEON' then UnitBlueprint = 'UAB1103'
        elseif sFaction == 'CYBRAN' then UnitBlueprint = 'URB1103'
        elseif sFaction == 'SERAPHIM' then UnitBlueprint = 'XSB1103'
        else UnitBlueprint = 'UEB1103'
        end
    elseif BuildingType == 'T1EnergyProduction' then
        SizeArray = {2, 2}
        if sFaction == 'AEON' then UnitBlueprint = 'UAB1101'
        elseif sFaction == 'CYBRAN' then UnitBlueprint = 'URB1101'
        elseif sFaction == 'SERAPHIM' then UnitBlueprint = 'XSB1101'
        else UnitBlueprint = 'UEB1101'
        end

    else
        --NOTE: Any additions to above should also be reflected in BlueprintToBuildingType
        LOG('* ERROR: MICRO27AI: utilitites.lua: GetBuildingSize: NEED TO ADD IN SIZE FOR BuildingType='..BuildingType)
    end
    if iInfoWanted == 1 then
        return SizeArray
    else
        return UnitBlueprint
    end
end

function GetDistanceBetweenPositions(Position1, Position2, iBuildingSize)
    -- Returns distance ignoring the y value and taking just x and z values
    --if iBuildingSize is set to a value, then will instead reduce the distance to determine the distance between 1 position and the nearest part of the other position with iBuildingSize
    --iBuildingSize should be the building size from its build location, in 'wall units' - so a land fac is an 8x8 size, and the build position will be the centre of it, making the building size 4, a T1 PGen a size of 1, etc.
    -- LOG('Position1='..Position1[1]..'-'..Position1[3]..'; Position2='..Position2[1]..'-'..Position2[3])
    if iBuildingSize == nil then
        return VDist2(Position1[1], Position1[3], Position2[1], Position2[3])
    else
        local ModPos1X = Position1[1]
        local ModPos1Z = Position1[3]
        if Position1[1] > Position2[1] then
            ModPos1X = Position1[1] - iBuildingSize
            if ModPos1X < Position2[1] then
                    ModPos1X = Position2[1]
            end
        elseif Position1[1] < Position2[1] then
            ModPos1X = Position1[1] + iBuildingSize
            if ModPos1X > Position2[1] then
                ModPos1X = Position2[1] end
        end
        if Position1[3] > Position2[3] then
            ModPos1Z = Position1[3] - iBuildingSize
            if ModPos1Z < Position2[3] then ModPos1Z = Position2[3] end
        elseif Position1[3] < Position2[3] then
            ModPos1Z = Position1[3] + iBuildingSize
            if ModPos1Z > Position2[3] then ModPos1Z = Position2[3] end
        end
        -- LOG('iBuildingSize was set so ModPos used; Position1='..Position1[1]..'-'..Position1[3]..'; Position2='..Position2[1]..'-'..Position2[3]..'iBuildingSize='..iBuildingSize..'iModPos1X='..ModPos1X..'iModPos1Z='..ModPos1Z)
        return VDist2(ModPos1X, ModPos1Z, Position2[1], Position2[3])

    end
end

function GetAdjacencyLocationForTarget(tablePosTarget, TargetBuildingType, NewBuildingType, bCheckValid, aiBrain, bReturnOnlyBestMatch, pBuilderPos, iBuilderMaxDistance, bIgnoreOutsideBuildArea, bBetterIfNoReclaim)
    --Returns all co-ordinates that will result in a NewBuildingType being built adjacent to PosTarget; if bCheckValid is true (default) then will also check it's a valid location to build
    -- tablePosTarget can either be a table (e.g. a table of mex locations), or just a single position
    --Only need to specify aiBrain if bCheckValid = true
    --bIgnoreOutsideBuildArea - if true then ignore any locations outside of the builder's build area
    --bReturnOnlyBestMatch: if true then applies prioritisation and returns only the best match
    --bBetterIfNoReclaim - if true, then will ignore any build location that contains any reclaim (to avoid ACU trying to build somewhere that it has to walk to and reclaim)
    if bCheckValid == nil then bCheckValid = false end
    if aiBrain == nil then bCheckValid = false end
    if bReturnOnlyBestMatch == nil then bReturnOnlyBestMatch = false end
    if pBuilderPos == nil then
        pBuilderPos = {100000, 100000, 100000}
        bIgnoreOutsideBuildArea = false
    end
    if iBuilderMaxDistance == nil then iBuildDistance = 5 end --ACU is 10
    if bIgnoreOutsideBuildArea == nil then bIgnoreOutsideBuildArea = false end
    if bBetterIfNoReclaim == nil then bBetterIfNoReclaim = false end

    local bDebugMessages = false --set to true for certain positions where want logs to print
    local TargetSize = GetBuildingTypeInfo(TargetBuildingType, 1)
    local NewBuildingSize = GetBuildingTypeInfo(NewBuildingType, 1)
    local fSizeMod = 0.5
    local iMaxX, iMinX, iMaxZ, iMinZ, iTargetMaxX, iTargetMinX, iTargetMaxZ, iTargetMinZ, OptionsX, OptionsZ
    local iNewX, iNewZ
    local iValidPosCount = 0
    local CurPosition = {}
    local PossiblePositions = {}
    local iPriority
    local iDistanceBetween
    local iMaxPriority = -100
    local tBestPosition = {}
    local bMultipleTargets = IsTableArray(tablePosTarget[1])
    local iTotalTargets = 1
    local PosTarget = {}
    if bMultipleTargets == true then iTotalTargets = GetTableSize(tablePosTarget) end
    local bNewBuildingLargerThanNewTarget = false
    if TargetSize[1] < NewBuildingSize[1] or TargetSize[2] < NewBuildingSize[2] then bNewBuildingLargerThanNewTarget = true end
    for iCurTarget = 1, iTotalTargets do
        if bMultipleTargets == true then
            PosTarget = tablePosTarget[iCurTarget]
        else
            PosTarget = tablePosTarget
        end
        --LOG('PosTarget[1]='..PosTarget[1])
        --LOG('TargetSize[1]='..TargetSize[1])
        --LOG('NewBuildingSize[1]='..NewBuildingSize[1])
        iMaxX = PosTarget[1] + TargetSize[1] * fSizeMod + NewBuildingSize[1]*fSizeMod
        iMinX = PosTarget[1] - TargetSize[1] * fSizeMod - NewBuildingSize[1]* fSizeMod
        iMaxZ = PosTarget[3] + TargetSize[2] * fSizeMod + NewBuildingSize[2]* fSizeMod
        iMinZ = PosTarget[3] - TargetSize[2] * fSizeMod - NewBuildingSize[2]* fSizeMod
        iTargetMaxX = PosTarget[1] + TargetSize[1] * fSizeMod
        iTargetMinX = PosTarget[1] - TargetSize[1] * fSizeMod
        iTargetMaxZ = PosTarget[3] + TargetSize[2] * fSizeMod
        iTargetMinZ = PosTarget[3] - TargetSize[2] * fSizeMod
        OptionsX = math.floor(iMaxX - iMinX)
        OptionsZ = math.floor(iMaxZ - iMinZ)

        for xi = 0, OptionsX do
            iNewX = iMinX + xi
            --if iNewX >= (iMinX + TargetSize[1]*fSizeMod) or iNewX >= (iTargetMaxX - NewBuildingSize[1]*fSizeMod) then
            for zi = 0, OptionsZ do
                iPriority = 0
                iNewZ = iMinZ + zi
                --if iNewX == 491.5 and iNewZ == 20.5 then bDebugMessages = true end
                --if iNewZ < (iTargetMinZ + NewBuildingSize[2]* fSizeMod) or iNewZ > (iTargetMaxZ - NewBuildingSize[2]* fSizeMod) then
                --ignore corner results (new building larger than target):
                local bIgnore = false
                if bNewBuildingLargerThanNewTarget == true then
                    if iNewX - NewBuildingSize[1] * fSizeMod > iTargetMinX or iNewX + NewBuildingSize[1] * fSizeMod < iTargetMaxX then
                        if iNewZ - NewBuildingSize[2] * fSizeMod > iTargetMinZ or iNewZ + NewBuildingSize[2] * fSizeMod < iTargetMaxZ then
                            iPriority = iPriority - 4
                            --bIgnore = true
                            if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: Corner position failed where NewBuilding > NewTarget size; iNewX='..iNewX..'; iNewZ='..iNewZ) end
                        end
                    end
                else
                    if iNewX >= iTargetMinX and iNewX <= iTargetMaxX then
                        --z value needs to be right by the min or max values:
                        if iNewZ == (iTargetMinZ - NewBuildingSize[2]*fSizeMod) or iNewZ == (iTargetMaxZ + NewBuildingSize[2]*fSizeMod) then
                            --valid co-ordinate
                        else
                            --If it's within the target building area then ignore, otherwise record with lower priority as no adjacency:
                            if iNewZ < (iTargetMinZ - NewBuildingSize[2]*fSizeMod) or iNewZ > (iTargetMaxZ + NewBuildingSize[2]*fSizeMod) then
                                iPriority = iPriority - 4
                            else bIgnore = true end
                            if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: NewBuilding <= NewTarget size 1 - failed to find adjacency match; iNewX='..iNewX..'; iNewZ='..iNewZ) end
                        end
                    else
                        if iNewZ >= iTargetMinZ and iNewZ <= iTargetMaxZ then
                            if iNewX == (iTargetMinX - NewBuildingSize[1]*fSizeMod) or iNewX == (iTargetMaxX + NewBuildingSize[1]*fSizeMod) then
                                --Valid match
                            else
                                --If it's within the target building area then ignore, otherwise record with lower priority as no adjacency:
                                if iNewX < (iTargetMinX - NewBuildingSize[1]*fSizeMod) or iNewX > (iTargetMaxX + NewBuildingSize[1]*fSizeMod) then
                                    iPriority = iPriority - 4
                                    else bIgnore = true end
                                if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: NewBuilding <= NewTarget size 2 - failed to find match; iNewX='..iNewX..'; iNewZ='..iNewZ) end
                            end
                        else
                            if (iNewX < (iTargetMinX - NewBuildingSize[1]*fSizeMod) or iNewX > (iTargetMaxX + NewBuildingSize[1]*fSizeMod)) and (iNewZ < (iTargetMinZ - NewBuildingSize[2]*fSizeMod) or iNewZ > (iTargetMaxZ + NewBuildingSize[2]*fSizeMod)) then
                                --should be valid just no adjacency
                                iPriority = iPriority - 4
                            else bIgnore = true end
                            if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: NewBuilding <= NewTarget size 3 - failed to find match; iNewX='..iNewX..'; iNewZ='..iNewZ) end
                        end
                    end
                    -- If bCheckValid then see if aiBrain can build the desired structure at the location
                end
                if bIgnore == false then
                    --Check for reclaim:
                    if bBetterIfNoReclaim == true then
                        --local iMaxReclaimDist = math.sqrt(NewBuildingSize[1]*NewBuildingSize[1]*fSizeMod*fSizeMod + NewBuildingSize[1]*NewBuildingSize[1]*fSizeMod*fSizeMod)
                        --local checkUnits = aiBrain:GetUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) - categories.AIR, CurPosition, iMaxReclaimDist, 'Enemy')
                        local Reclaimables = GetReclaimablesInRect(Rect(iNewX - NewBuildingSize[1]*fSizeMod, iNewZ - NewBuildingSize[2]*fSizeMod, iNewX + NewBuildingSize[1]*fSizeMod, iNewZ + NewBuildingSize[2]*fSizeMod))
                        if Reclaimables and table.getn( Reclaimables ) > 0 then
                            local iWreckCount = 0
                            --local iMassValue = nil --only used for log/testing
                            --local bIsProp = nil  --only used for log/testing
                            for _, v in Reclaimables do
                            local WreckPos = v.CachePosition
                                if WreckPos[1]==nil then
                                    if bDebugMessages == true then LOG('Reclaim position: iWreckCount '..iWreckCount..' has a WreckPos[1] that is nil') end
                                else
                                    iWreckCount = iWreckCount + 1
                                    --iMassValue = v.MaxMassReclaim  --only used for log/testing
                                    --bIsProp = IsProp(v) --only used for log/testing
                                    --if bDebugMessages == true then LOG('Reclaim position '..iWreckCount..'='..WreckPos[1]..'-'..WreckPos[2]..'-'..WreckPos[3]..'; IsProp='..tostring(bIsProp)..'; MassValue='..iMassValue) end
                                    if bDebugMessages == true then LOG('Reclaim position '..iWreckCount..'='..WreckPos[1]..'-'..WreckPos[2]..'-'..WreckPos[3]) end
                                end
                            end
                            if iWreckCount > 0 then
                                if bDebugMessages == true then LOG('Ignoring possible location due to presence of reclaim; iNewX='..iNewX..'iNewZ='..iNewZ) end
                                --bIgnore = true
                                iPriority = iPriority - 4
                            end
                        end
                    end
                end
                if bIgnore ==  false then
                    CurPosition = {iNewX, PosTarget[2], iNewZ}
                    if bCheckValid then
                        if aiBrain:CanBuildStructureAt(GetBuildingTypeInfo(NewBuildingType, 2), CurPosition) == false then
                            bIgnore = true
                            if bDebugMessages == true then
                                if bDebugMessages == true then
                                    LOG('GetAdjacencyLocationForTarget: aiBrain cant build at iNewX='..iNewX..'; iNewZ='..iNewZ..'; CurPosition='..CurPosition[1]..'-'..CurPosition[2]..'-'..CurPosition[3])
                                    LOG('aiBrain:CanBuildStructureAt(UEB0101, CurPosition)='..tostring(aiBrain:CanBuildStructureAt('UEB0101', CurPosition)))
                                end
                            end
                        end
                    end
                end
                --Ignore if -ve priority and already have better:
                if iPriority < 0 and iMaxPriority > iPriority then bIgnore = true end
                
                if bIgnore == false then
                    -- We now have a co-ordinate that should result in newbuilding being built adjacent to target building (unless negative priority); check other conditions/priorities
                    if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: CurPosition[1]='..CurPosition[1]..'-'..CurPosition[2]..'-'..CurPosition[3]) end
                    if bIgnoreOutsideBuildArea == true or bReturnOnlyBestMatch == true then iDistanceBetween = GetDistanceBetweenPositions(pBuilderPos, CurPosition, NewBuildingSize[1]*fSizeMod) end
                    --if bIgnoreOutsideBuildArea == true or bReturnOnlyBestMatch == true then iDistanceBetween = GetDistanceBetweenPositions(pBuilderPos, PosTarget) end
                    -- DrawLocations({CurPosition},0, 4, 10)
                    if bReturnOnlyBestMatch == true then
                        --Check if within build area:
                        if iDistanceBetween <= iBuilderMaxDistance then
                            if iDistanceBetween > 0 then
                                iPriority = iPriority + 4
                            else iPriority = iPriority + 1
                            end
                        end
                        --Deduct 3 if ACU would have to move to build - should hopefully be covered by above
                        --if pBuilderPos[1] >= iNewX - NewBuildingSize[1] * fSizeMod and pBuilderPos[1] <= iNewX + NewBuildingSize[1] * fSizeMod then
                        --if pBuilderPos[3] >= iNewZ - NewBuildingSize[2] * fSizeMod and pBuilderPos[3] <= iNewX + NewBuildingSize[2] * fSizeMod then
                        --iPriority = iPriority - 3
                        --end
                        --end
                        --Check if level with target (makes it easier for other buildings to get adjacency):
                        if CurPosition[1] - NewBuildingSize[1]*fSizeMod == iTargetMinX then iPriority = iPriority + 1 end
                        if CurPosition[1] + NewBuildingSize[1]*fSizeMod == iTargetMaxX then iPriority = iPriority + 1 end
                        if CurPosition[3] - NewBuildingSize[2]*fSizeMod == iTargetMinZ then iPriority = iPriority + 1 end
                        if CurPosition[3] + NewBuildingSize[2]*fSizeMod == iTargetMaxZ then iPriority = iPriority + 1 end
                    end
                    if bIgnoreOutsideBuildArea == true then
                        if iDistanceBetween > iBuilderMaxDistance then
                            bIgnore = true
                            if bDebugMessages == true then LOG('GetAdjacencyLocationForTarget: Ignoring as iDistanceBetween='..iDistanceBetween..'; normal dist='..GetDistanceBetweenPositions(pBuilderPos, CurPosition)) end
                        else iPriority = iPriority - 2
                        end
                    end

                    if bIgnore == false then
                        iValidPosCount = iValidPosCount + 1
                        PossiblePositions[iValidPosCount] = CurPosition
                        if iPriority > iMaxPriority then
                            iMaxPriority = iPriority
                            if bReturnOnlyBestMatch == true then
                                tBestPosition = CurPosition
                            end
                        end
                        if bDebugMessages == true then if bReturnOnlyBestMatch == true then LOG('iPriority='..iPriority..'; iDistanceBetween='..iDistanceBetween) end end
                        if bDebugMessages == true then LOG('*MICRO27AI: utilities.lua: GetAdjacencyLocationForTarget: iValidPosCount='..iValidPosCount..'; PossiblePositions[iValidPosCount][1-2-3]='..PossiblePositions[iValidPosCount][1]..'-'..PossiblePositions[iValidPosCount][2]..'-'..PossiblePositions[iValidPosCount][3]..'; bReturnOnlyBestMatch='..tostring(bReturnOnlyBestMatch)) end
                    end
                end
                --end
            end
            --end
        end
    end
    if iValidPosCount >= 1 then
        if bReturnOnlyBestMatch then
            LOG('*MICRO27AI: utilities.lua: GetAdjacencyLocationForTarget: Returning best possible position; tBestPosition[1]='..tBestPosition[1]..'-'..tBestPosition[2]..'-'..tBestPosition[3]..'; iMaxPriority='..iMaxPriority)
            return tBestPosition
        else
            LOG('*MICRO27AI: utilities.lua: GetAdjacencyLocationForTarget: Returning table of possible positions; PossiblePositions[1][1]='..PossiblePositions[1][1]..'-'..PossiblePositions[1][2]..'-'..PossiblePositions[1][3])
            return PossiblePositions
        end
    else
            LOG('ERROR: *MICRO27AI: utilities.lua: GetAdjacencyLocationForTarget: No valid matches found. PosTarget='..PosTarget[1]..'-'..PosTarget[3])
            return nil
    end

end

function ConvertAbsolutePositionToRelative(tableAbsolutePositions, relativePosition, bIgnoreY)
    --NOTE: Not suitable for e.g. giving a build order location, since that appears to be affected by the direction the unit is facing as well?
    -- returns a table of relative positions based on the position of absoluteposition to the relativeposition
    -- if bIgnoreY is false then will do relative y position=0, otherwise will use relativePosition's y value
    local RelX, RelY, RelZ
    local tableRelative = {}
    if bIgnoreY == nil then bIgnoreY = true end
    --LOG('ConvertAbsolutePositionToRelative: tableAbsolutePositions[1]='..tostring(tableAbsolutePositions[1]))
    local bMultiDimensionalTable = IsTableArray(tableAbsolutePositions[1])
    if bMultiDimensionalTable == false then
        RelX = tableAbsolutePositions[1] - relativePosition[1]
        if bIgnoreY then RelY = 0
        else RelY = tableAbsolutePositions[2] - relativePosition[2]
        end
        RelZ = tableAbsolutePositions[3] - relativePosition[3]
        tableRelative = {RelX, RelY, RelZ}
    else
        for i, v in ipairs(tableAbsolutePositions) do
            RelX = tableAbsolutePositions[i][1] - relativePosition[1]
            if bIgnoreY then RelY = 0
            else RelY = tableAbsolutePositions[i][2] - relativePosition[2]
            end
            RelZ = tableAbsolutePositions[i][3] - relativePosition[3]
            tableRelative[i] = {RelX, RelY, RelZ}
            --LOG('Converting Abs to Rel: Abs='..tableAbsolutePositions[i][1]..'-'..tableAbsolutePositions[i][2]..'-'..tableAbsolutePositions[i][3]..'; RelPos='..RelX..RelY..RelZ..'; builderPos='..relativePosition[1]..'-'..relativePosition[2]..'-'..relativePosition[3])
        end

    end
    return tableRelative
end

function DrawLocations(tableLocations, relativeStart, iColour, iDisplayCount)
    --Draw circles around a table of locations to help with debugging - note that as this doesnt use ForkThread (might need to have global variables and no function pulled variables for forkthread to work beyond the first few seconds) this will pause all the AI code
    --if relativeStart is blank then will treat as absolute co-ordinates
    --assumes tableLocations[x][y] where y is table of 3 values
    -- iColour: integer to allow easy selection of different colours (see below code)
    -- iDisplayCount - No. of times to cycle through drawing; limit of 100 (2s) for performance reasons
    if iDisplayCount == nil then iDisplayCount = 10
    elseif iDisplayCount <= 0 then iDisplayCount = 1
    elseif iDisplayCount >= 100 then iDisplayCount = 100
    end
    local sColour
    if iColour == nil then sColour = 'c00000FF' --dark blue
    elseif iColour == 1 then sColour = 'c00000FF'
    elseif iColour == 2 then sColour = 'ffFF4040' --orange
    elseif iColour == 3 then sColour = 'c0000000'
    elseif iColour == 4 then sColour = 'ffFF6060'
    end
    if relativeStart == nil then relativeStart = {0,0,0} end
    local iMaxDrawCount = iDisplayCount
    local iCurDrawCount = 0
    while true do
        for i, v in ipairs(tableLocations) do
            DrawCircle(tableLocations[i], 2, sColour)
        end
        iCurDrawCount = iCurDrawCount + 1
        if iCurDrawCount > iMaxDrawCount then return end
        coroutine.yield(2)
    end
end

function ConvertLocationsToBuildTemplate(tableUnits, tableRelativePositions)
    -- Returns a table that can be used as a baseTemplate by AIExecuteBuildStructure and similar functions
    local baseTemplate = {}
    baseTemplate[1] = {} --allows for different locations for different units, wont use this functionality though
    baseTemplate[1][1] = tableUnits -- Units that this applies to
    --baseTemplate[1][1+x] is the dif co-ordinates, each a 3 value table
    --LOG('About to attempt to convert tableRelativePositions into build template')
    local bMultiDimensionalTable = IsTableArray(tableRelativePositions[1])
    if bMultiDimensionalTable == true then
        for i, v in ipairs(tableRelativePositions) do
            baseTemplate[1][1+i] = {}
            baseTemplate[1][1 + i][1] = v[1]
            baseTemplate[1][1 + i][3] = v[2] -- basetemplate changes direction in first 2 of the 3 co-ords
            baseTemplate[1][1 + i][2] = v[3]
            --LOG('ConvertLocationsToBuildTemplate: i='..i..'; baseTemplate[1][1=i][1],2,3='..baseTemplate[1][1+i][1]..'-'..baseTemplate[1][1+i][2]..'-'..baseTemplate[1][1+i][3])
        end
    else
        baseTemplate[1][2] = {}
        baseTemplate[1][2][1] = tableRelativePositions[1]
        baseTemplate[1][2][3] = tableRelativePositions[2]
        baseTemplate[1][2][2] = tableRelativePositions[3]
    end
    return baseTemplate
end

function GetIsACU(UnitID)
    if UnitID == 'ual0001' then -- Aeon
        return true
    elseif UnitID == 'uel0001' then -- UEF
        return true
    elseif UnitID == 'url0001' then -- Cybran
        return true
    elseif UnitID == 'xsl0001' then --Sera
        return true
    else
        return false
    end
end

function AIGetMassMarkerLocations(aiBrain, includeWater, waterOnly)
    local markerList = {}
        local markers = ScenarioUtils.GetMarkers()
        if markers then
            for k, v in markers do
                if v.type == 'Mass' then
                    if waterOnly then
                        if PositionInWater(v.position) then
                            table.insert(markerList, {Position = v.position, Name = k})
                        end
                    elseif includeWater then
                        table.insert(markerList, {Position = v.position, Name = k})
                    else
                        if not PositionInWater(v.position) then
                            table.insert(markerList, {Position = v.position, Name = k})
                        end
                    end
                end
            end
        end
    return markerList
end

-- This is Sproutos function 
function PositionInWater(pos)
	return GetTerrainHeight(pos[1], pos[3]) < GetSurfaceHeight(pos[1], pos[3])
end

function AIFindBrainTargetInCloseRangeRNG(aiBrain, platoon, position, squad, maxRange, targetQueryCategory, TargetSearchCategory, enemyBrain)
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
        [3] = maxRange + 30,
    }
    local TargetUnit = false
    local TargetsInRange, EnemyStrength, TargetPosition, category, distance, targetRange, baseTargetRange, canAttack
    for _, range in RangeList do
        if not position then
            WARN('* AI-Uveso: AIFindNearestCategoryTargetInCloseRange: position is empty')
            return false
        end
        if not range then
            WARN('* AI-Uveso: AIFindNearestCategoryTargetInCloseRange: range is empty')
            return false
        end
        if not TargetSearchCategory then
            WARN('* AI-Uveso: AIFindNearestCategoryTargetInCloseRange: TargetSearchCategory is empty')
            return false
        end
        TargetsInRange = GetUnitsAroundPoint(aiBrain, targetQueryCategory, position, range, 'Enemy')
        --DrawCircle(position, range, '0000FF')
        for _, v in TargetSearchCategory do
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
                -- check if we have a special player as enemy
                if enemyBrain and enemyIndex and enemyBrain ~= enemyIndex then continue end
                -- check if the Target is still alive, matches our target priority and can be attacked from our platoon
                if not Target.Dead and not Target.CaptureInProgress and EntityCategoryContains(category, Target) and platoon:CanAttackTarget(squad, Target) then
                    -- yes... we need to check if we got friendly units with GetUnitsAroundPoint(_, _, _, 'Enemy')
                    if not IsEnemy( MyArmyIndex, Target:GetAIBrain():GetArmyIndex() ) then continue end
                    if Target.ReclaimInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRange: ReclaimInProgress !!! Ignoring the target.')
                        continue
                    end
                    if Target.CaptureInProgress then
                        --WARN('* AIFindNearestCategoryTargetInRange: CaptureInProgress !!! Ignoring the target.')
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
                --LOG('Target Found in target aquisition function')
                return TargetUnit
            end
           coroutine.yield(10)
        end
        coroutine.yield(1)
    end
    --LOG('NO Target Found in target aquisition function')
    return TargetUnit
end
