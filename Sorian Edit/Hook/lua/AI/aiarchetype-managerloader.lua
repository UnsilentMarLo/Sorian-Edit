--WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * AI-SorianEdit: offset aiarchetype-managerloader.lua' )

local BuffSorianEdit = import('/lua/sim/Buff.lua')
local lastCall = GetGameTimeSeconds()
local Buff = import('/lua/sim/Buff.lua')
local HighestThreat = {}
local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')
-- local CanGraphAreaTo = import("/mods/AI-Uveso/lua/AI/AIMarkerGenerator.lua").CanGraphAreaTo -- deprecated
local NavUtils = import("/lua/sim/navutils.lua")

SorianEditExecutePlanFunction = ExecutePlan
function ExecutePlan(aiBrain)
    if not aiBrain.sorianedit then
        -- Debug for Platoon names
        if (aiBrain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all') and not aiBrain.BuilderManagers.MAIN.FactoryManager:HasBuilderList() then
            aiBrain:ForkThread(LocationRangeManagerThreadSorianEdit, aiBrain)
        end
        -- execute the original function
        SorianEditExecutePlanFunction(aiBrain)
        return
    end
	-- WARN('[aiarchetype-managerloader.lua ------------------------ SorianEditExecutePlanFunction.')
    aiBrain:SetConstantEvaluate(false)
    local behaviors = import('/lua/ai/AIBehaviors.lua')
    coroutine.yield(10)
    if not aiBrain.BuilderManagers.MAIN.FactoryManager or not aiBrain.BuilderManagers.MAIN.FactoryManager:HasBuilderList() then
        aiBrain:SetResourceSharing(true)
        SetupMainBase(aiBrain)
        -- Get units out of pool and assign them to the managers
        local mainManagers = aiBrain.BuilderManagers.MAIN
        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
        for k,v in pool:GetPlatoonUnits() do
            if EntityCategoryContains(categories.ENGINEER - categories.STATIONASSISTPOD - categories.POD, v) then
                mainManagers.EngineerManager:AddUnit(v)
            elseif EntityCategoryContains(categories.FACTORY * categories.STRUCTURE, v) then
                mainManagers.FactoryManager:AddFactory(v)
            end
        end
        -- aiBrain:ForkThread(MarkerGridThreatManagerThreadSorianEdit, aiBrain)  -- start after 10 seconds
        aiBrain:ForkThread(LocationRangeManagerThreadSorianEdit, aiBrain)     -- start after 30 seconds
        aiBrain:ForkThread(BaseTargetManagerThreadSorianEdit, aiBrain)        -- start after 50 seconds
        -- aiBrain:ForkThread(PriorityManagerThreadSE, aiBrain)          -- start after 1 minute 10 seconds
        aiBrain:ForkThread(EcoManagerThreadSorianEdit, aiBrain)               -- start after 4 minutes
    end
    if aiBrain.PBM then
        aiBrain:PBMSetEnabled(false)
    end
end

function SetArmyPoolBuffSorianEdit(aiBrain, CheatMult, BuildMult)
    -- Store the new mult inside options, so new units get the new mult automatically
    if tostring(CheatMult) == tostring(ScenarioInfo.Options.CheatMult) and tostring(BuildMult) == tostring(ScenarioInfo.Options.BuildMult) then
        --LOG('* SetArmyPoolBuffSorianEdit: CheatMult+BuildMult not changed. No buffing needed!')
        return
    end
    ScenarioInfo.Options.CheatMult = tostring(CheatMult)
    ScenarioInfo.Options.BuildMult = tostring(BuildMult)
    -- Modify Buildrate buff
    local buffDef = Buffs['CheatBuildRate']
    local buffAffects = buffDef.Affects
    buffAffects.BuildRate.Mult = BuildMult
    -- Modify CheatIncome buff
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = CheatMult
    buffAffects.MassProduction.Mult = CheatMult
    allUnits = aiBrain:GetListOfUnits(categories.ALLUNITS, false, false)
    for _, unit in allUnits do
        -- Remove old build rate and income buffs
        BuffSorianEdit.RemoveBuff(unit, 'CheatIncome', true) -- true = removeAllCounts
        BuffSorianEdit.RemoveBuff(unit, 'CheatBuildRate', true) -- true = removeAllCounts
        -- Apply new build rate and income buffs
        BuffSorianEdit.ApplyBuff(unit, 'CheatIncome')
        BuffSorianEdit.ApplyBuff(unit, 'CheatBuildRate')
    end
end

function EcoManagerThreadSorianEdit(aiBrain)
    -- Start Ecomanager at game minute 4
    while GetGameTimeSeconds() < 60*4 + aiBrain:GetArmyIndex() do
        coroutine.yield(10)
    end
    local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
    aiBrain.CheatMult = tonumber(ScenarioInfo.Options.CheatMult)
    aiBrain.BuildMult = tonumber(ScenarioInfo.Options.BuildMult)
    if aiBrain.CheatMult ~= aiBrain.BuildMult then
        aiBrain.CheatMult = math.max(aiBrain.CheatMult,aiBrain.BuildMult)
        aiBrain.BuildMult = math.max(aiBrain.CheatMult,aiBrain.BuildMult)
    end
    if aiBrain.CheatEnabled then
        LOG('* AI-SorianEdit: Function EcoManagerThread() started! - Cheat(eco)Factor:( '..repr(aiBrain.CheatMult)..' ) - BuildFactor:( '..repr(aiBrain.BuildMult)..' ) - ['..aiBrain.Nickname..']')
    else
        LOG('* AI-SorianEdit: Function EcoManagerThread() started! - No Cheat(eco) or BuildFactor')
    end
    local lastCall = 0
    local busy
    -- Set all variables for the ecomanager
    local massNeed = math.floor(aiBrain:GetEconomyRequested('MASS') * 10)
    local massIncome = math.floor(aiBrain:GetEconomyIncome( 'MASS' ) * 10)
    local massTrend = massIncome - massNeed
    local energyNeed = math.floor(aiBrain:GetEconomyRequested('ENERGY') * 10)
    local energyIncome = math.floor(aiBrain:GetEconomyIncome( 'ENERGY' ) * 10)
    local energyTrend = energyIncome - energyNeed
    local safeguard
    -- splitted from table to single variables. (faster)
    local maxEnergyConsumptionUnitindex
    local maxEnergyConsumption
    local minEnergyConsumptionUnitindex
    local minEnergyConsumption
    local maxMassConsumptionUnitindex
    local maxMassConsumption
    local minMassConsumptionUnitindex
    local minMassConsumption
    local EcoUnits = {}
    local BasePanicZone, BaseMilitaryZone, BaseEnemyZone
    local baseposition
    local numUnitsPanicZone
    local AllUnits
    local time, energy, mass
    local function SetArmyPoolBuff(aiBrain, CheatMult, BuildMult)
        -- we are looping over all units with this, so we make it local
        local Buff = Buff
        -- Modify Buildrate buff
        local buffDef = Buffs['CheatBuildRate']
        local buffAffects = buffDef.Affects
        buffAffects.BuildRate.Mult = BuildMult
        -- Modify CheatIncome buff
        buffDef = Buffs['CheatIncome']
        buffAffects = buffDef.Affects
        buffAffects.EnergyProduction.Mult = CheatMult
        buffAffects.MassProduction.Mult = CheatMult
        allUnits = aiBrain:GetListOfUnits(categories.ALLUNITS, false, false)
        for _, unit in allUnits do
            -- Remove old build rate and income buffs
            Buff.RemoveBuff(unit, 'CheatIncome', true) -- true = removeAllCounts
            Buff.RemoveBuff(unit, 'CheatBuildRate', true) -- true = removeAllCounts
            -- Apply new build rate and income buffs
            Buff.ApplyBuff(unit, 'CheatIncome')
            Buff.ApplyBuff(unit, 'CheatBuildRate')
        end
    end
    while aiBrain.Result ~= "defeat" do
        --LOG('* AI-SorianEdit: Function EcoManagerThread() beat. ['..aiBrain.Nickname..']')
        coroutine.yield(2)
        -- Set all variables for the ecomanager
        massNeed = math.floor(aiBrain:GetEconomyRequested('MASS') * 10)
        massIncome = math.floor(aiBrain:GetEconomyIncome( 'MASS' ) * 10)
        massTrend = massIncome - massNeed
        energyNeed = math.floor(aiBrain:GetEconomyRequested('ENERGY') * 10)
        energyIncome = math.floor(aiBrain:GetEconomyIncome( 'ENERGY' ) * 10)
        energyTrend = energyIncome - energyNeed
        -- check if we have enemy units inside the base panic zone.
        BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua').GetDangerZoneRadii()
        baseposition = aiBrain.BuilderManagers['MAIN'].FactoryManager.Location
        numUnitsPanicZone = aiBrain:GetNumUnitsAroundPoint(categories.MOBILE * categories.LAND - categories.SCOUT, baseposition, BasePanicZone, 'Enemy')
        -- ECO manager
        EcoUnits = {}
        busy = false
        if aiBrain:GetEconomyStoredRatio('ENERGY') < 0.50 then
            AllUnits = aiBrain:GetListOfUnits( (categories.FACTORY - categories.TECH1) + (categories.ENGINEER - categories.POD) + categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
            if energyTrend < 0 then
                --AllUnits = aiBrain:GetListOfUnits(categories.ALLUNITS - categories.COMMAND - categories.SHIELD - categories.MASSEXTRACTION, false, false) -- also gets unbuilded units (planed to build)
                for index, unit in AllUnits do
                    if unit.pausedMass or unit.pausedEnergy then continue end
                    -- filter units that are not finished
                    if unit:GetFractionComplete() < 1 then continue end
                    -- if we build massextractors or energyproduction, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( ( categories.MASSEXTRACTION + categories.ENERGYPRODUCTION + categories.ENERGYSTORAGE ) , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- if we build tech1 factories, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( categories.FACTORY * categories.TECH1 , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- if we build tech 1 units from a factory, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( categories.MOBILE * categories.TECH1 , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- don't pause any ACU assisting
                    if unit.UnitBeingAssist and EntityCategoryContains( categories.COMMAND, unit.UnitBeingAssist) then
                        continue
                    end
                    if unit.pausedMass or unit.pausedEnergy then continue end
                    if EntityCategoryContains( (categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO, unit) then
                        if unit.ProductionEnabled then
                            -- siloBuildRate is only for debugging, we don't use it inside the code
                            --local siloBuildRate = unit:GetBuildRate() or 1
                            time, energy, mass = unit:GetBuildCosts(unit.SiloProjectile)
--                            LOG('* AI-SorianEdit: ECO Buildcost time '..time..' - mass '..mass..' - energy '..energy..' - siloBuildRate '..siloBuildRate)
                            energy = (energy / time)
                            mass = (mass / time)
--                            LOG('* AI-SorianEdit: ECO Buildcost time '..time..' - mass '..mass..' - energy '..energy..' - siloBuildRate '..siloBuildRate)
                            unit.ConsumptionPerSecondEnergy = energy
                        end
                    else
                        unit.ConsumptionPerSecondEnergy = unit:GetConsumptionPerSecondEnergy()
                    end
                    if unit.ConsumptionPerSecondEnergy > 0 then
                        table.insert(EcoUnits, unit)
                    end
                end
                -- Disable units until energytrend is positive
                safeguard = table.getn(EcoUnits)
                while energyTrend < 0 do
                    -- find unit with most energy consumption
                    maxEnergyConsumptionUnitindex = nil
                    maxEnergyConsumption = nil
                    if EcoUnits[1] then
                        for index, unit in EcoUnits do
                            if unit.pausedMass or unit.pausedEnergy then continue end
                            if not maxEnergyConsumption or maxEnergyConsumption < unit.ConsumptionPerSecondEnergy then
                                maxEnergyConsumption = unit.ConsumptionPerSecondEnergy
                                maxEnergyConsumptionUnitindex = index
                            end
                        end
                    else
                        break
                    end
                    if maxEnergyConsumptionUnitindex then
--                        LOG(' ')
--                        LOG('* AI-SorianEdit: ECO energyTrend < 0  ('..energyTrend..')')
                        busy = true
                        energyTrend = energyTrend + maxEnergyConsumption
                        if EntityCategoryContains(categories.FACTORY + (categories.ENGINEER - categories.POD) + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO), EcoUnits[maxEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetPaused( true ) Saving ('..maxEnergyConsumption..') energy')
                            EcoUnits[maxEnergyConsumptionUnitindex]:SetPaused( true )
                            EcoUnits[maxEnergyConsumptionUnitindex].pausedEnergy = true
                            EcoUnits[maxEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.COUNTERINTELLIGENCE, EcoUnits[maxEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( IntelToggle, true ) Saving ('..maxEnergyConsumption..') energy')
                            EcoUnits[maxEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_IntelToggle', true)
                            EcoUnits[maxEnergyConsumptionUnitindex].pausedEnergy = true
                            EcoUnits[maxEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.MASSFABRICATION, EcoUnits[maxEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( ProductionToggle, true ) Saving ('..maxEnergyConsumption..') energy')
                            EcoUnits[maxEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_ProductionToggle', true)
                            EcoUnits[maxEnergyConsumptionUnitindex].pausedEnergy = true
                            EcoUnits[maxEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE, EcoUnits[maxEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( JammingToggle, true ) Saving ('..maxEnergyConsumption..') energy')
                            EcoUnits[maxEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_JammingToggle', true)
                            EcoUnits[maxEnergyConsumptionUnitindex].pausedEnergy = true
                            EcoUnits[maxEnergyConsumptionUnitindex].managed = true
                        else
                            WARN('* AI-SorianEdit: Unit with unknown Category('..LOC(__blueprints[EcoUnits[maxEnergyConsumptionUnitindex].UnitId].Description)..') ['..EcoUnits[maxEnergyConsumptionUnitindex].UnitId..']')
                        end
                    else
--                        SPEW('* AI-SorianEdit: ECO cant pause any unit. break!')
                        break
                    end
--                    LOG('* AI-SorianEdit: ECO new energyTrend = '..energyTrend..'')
                    -- Never remove this safeguard! Modded units can screw it up and cause a DeadLoop!!!
                    safeguard = safeguard - 1
                    if safeguard < 0 then
                        WARN('* AI-SorianEdit: ECO E safeguard < 0')
                        break
                    end
                end
--                if busy then
--                    coroutine.yield(5)
--                    energyNeed = math.floor(aiBrain:GetEconomyRequested('ENERGY') * 10)
--                    energyIncome = math.floor(aiBrain:GetEconomyIncome( 'ENERGY' ) * 10)
--                    energyTrendCheck = energyIncome - energyNeed
--                    LOG('*ECO energyTrendCheck = '..energyTrendCheck..'')
--                end
            end
        end
        coroutine.yield(1)
        if busy then
            --WARN('* AI-SorianEdit: ECOmanager low energy is busy')
            continue -- while true do
        end
        EcoUnits = {}
        if aiBrain:GetEconomyStoredRatio('ENERGY') >= 0.50 then
            AllUnits = aiBrain:GetListOfUnits( (categories.FACTORY - categories.TECH1) + (categories.ENGINEER - categories.POD) + categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
--            LOG('* AI-SorianEdit: ECO conomyStoredRatio(ENERGY) > 0.50')
            if energyTrend > 0 then
                --AllUnits = aiBrain:GetListOfUnits(categories.ALLUNITS - categories.COMMAND - categories.SHIELD - categories.MASSEXTRACTION, false, false) -- also gets unbuilded units (planed to build)
                for index, unit in AllUnits do
                    if not unit.pausedEnergy then continue end
                    -- filter units that are not finished
                    if unit:GetFractionComplete() < 1 then continue end
--                    LOG('* AI-SorianEdit: ECO checking unit ['..index..']  paused:('..repr(unit.pausedMass)..'/'..repr(unit.pausedEnergy)..') '..LOC(__blueprints[unit.UnitId].Description))
                    if unit.ConsumptionPerSecondEnergy > 0 then
--                        LOG('* AI-SorianEdit: ECO Adding unit ['..index..'] to table '..LOC(__blueprints[unit.UnitId].Description))
                        table.insert(EcoUnits, unit)
                    end
                end
                -- Enable units until energytrend is negative
                safeguard = table.getn(EcoUnits)
                while energyTrend > 0 do
--                    SPEW('* AI-SorianEdit: ECO safeguard = '..safeguard)
                    -- find unit with most energy consumption
                    minEnergyConsumptionUnitindex = nil
                    minEnergyConsumption = nil
                    if EcoUnits[1] then
                        for index, unit in EcoUnits do
                            if not unit.pausedEnergy then continue end
                            if not minEnergyConsumption or minEnergyConsumption > unit.ConsumptionPerSecondEnergy then
                                minEnergyConsumption = unit.ConsumptionPerSecondEnergy
                                minEnergyConsumptionUnitindex = index
                            end
                        end
                    else
                        break
                    end
                    if minEnergyConsumptionUnitindex then
--                        LOG(' ')
--                        LOG('* AI-SorianEdit: ECO energyTrend > 0  ('..energyTrend..')')
                        energyTrend = energyTrend - minEnergyConsumption
                        busy = true
                        if EntityCategoryContains(categories.FACTORY + (categories.ENGINEER - categories.POD) + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO)), EcoUnits[minEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetPaused( false ) Consuming ('..minEnergyConsumption..') energy')
                            EcoUnits[minEnergyConsumptionUnitindex]:SetPaused( false )
                            EcoUnits[minEnergyConsumptionUnitindex].pausedEnergy = false
                            EcoUnits[minEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.COUNTERINTELLIGENCE, EcoUnits[minEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( IntelToggle, false ) Consuming ('..minEnergyConsumption..') energy')
                            EcoUnits[minEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_IntelToggle', false)
                            EcoUnits[minEnergyConsumptionUnitindex].pausedEnergy = false
                            EcoUnits[minEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.MASSFABRICATION, EcoUnits[minEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( ProductionToggle, false ) Consuming ('..minEnergyConsumption..') energy')
                            EcoUnits[minEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_ProductionToggle', false)
                            EcoUnits[minEnergyConsumptionUnitindex].pausedEnergy = false
                            EcoUnits[minEnergyConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE, EcoUnits[minEnergyConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minEnergyConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minEnergyConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( JammingToggle, false ) Consuming ('..minEnergyConsumption..') energy')
                            EcoUnits[minEnergyConsumptionUnitindex]:SetScriptBit('RULEUTC_JammingToggle', false)
                            EcoUnits[minEnergyConsumptionUnitindex].pausedEnergy = false
                            EcoUnits[minEnergyConsumptionUnitindex].managed = true
                        else
                            WARN('* AI-SorianEdit: Unit with unknown Category('..LOC(__blueprints[EcoUnits[minEnergyConsumptionUnitindex].UnitId].Description)..') ['..EcoUnits[minEnergyConsumptionUnitindex].UnitId..']')
                        end
--                            EcoUnits[minEnergyConsumptionUnitindex]:OnProductionUnpaused()
--                            EcoUnits[minEnergyConsumptionUnitindex]:SetActiveConsumptionActive()
                    else
--                        SPEW('* AI-SorianEdit: ECO cant activate any unit. break!')
                        break
                    end
--                    LOG('* AI-SorianEdit: ECO new energyTrend = '..energyTrend..'')
                    -- Never remove this safeguard! Modded units can screw it up and cause a DeadLoop!!!
                    safeguard = safeguard - 1
                    if safeguard < 0 then
                        WARN('* AI-SorianEdit: ECO E safeguard > 0')
                        break
                    end
                end
--                if busy then
--                    coroutine.yield(5)
--                    energyNeed = math.floor(aiBrain:GetEconomyRequested('ENERGY') * 10)
--                    energyIncome = math.floor(aiBrain:GetEconomyIncome( 'ENERGY' ) * 10)
--                    energyTrendCheck = energyIncome - energyNeed
--                    LOG('*ECO energyTrendCheck = '..energyTrendCheck..'')
--                end
            end
        end
        coroutine.yield(1)
        if busy then
            --WARN('* AI-SorianEdit: ECOmanager high energy is busy')
            continue -- while true do
        end
        EcoUnits = {}
        if aiBrain:GetEconomyStoredRatio('MASS') < 0.15 then
            --AllUnits = aiBrain:GetListOfUnits( (categories.FACTORY - categories.TECH1) + (categories.ENGINEER - categories.POD) + categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
            AllUnits = aiBrain:GetListOfUnits( categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
            if massTrend < 0 then
                --AllUnits = aiBrain:GetListOfUnits(categories.ALLUNITS - categories.COMMAND - categories.SHIELD - categories.MASSEXTRACTION, false, false) -- also gets unbuilded units (planed to build)
                for index, unit in AllUnits do
                    if unit.pausedMass or unit.pausedEnergy then continue end
                    -- filter units that are not finished
                    if unit:GetFractionComplete() < 1 then continue end
                    -- if we build massextractors or energyproduction, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( ( categories.MASSEXTRACTION + categories.ENERGYPRODUCTION + categories.ENERGYSTORAGE ) , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- if we build tech1 factories, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( categories.FACTORY * categories.TECH1 , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- if we build tech 1 units from a factory, don't pause it
                    if unit.UnitBeingBuilt and EntityCategoryContains( categories.MOBILE * categories.TECH1 , unit.UnitBeingBuilt) then
                        continue
                    end
                    -- don't pause any ACU assisting
                    if unit.UnitBeingAssist and EntityCategoryContains( categories.COMMAND, unit.UnitBeingAssist) then
                        continue
                    end
                    unit.ConsumptionPerSecondMass = unit:GetConsumptionPerSecondMass()
                    if unit.ConsumptionPerSecondMass > 0 then
--                        LOG('* AI-SorianEdit: ECO Adding unit ['..index..'] to table '..LOC(__blueprints[unit.UnitId].Description))
                        table.insert(EcoUnits, unit)
                    end
                end
                -- Disable units until massTrend is positive
                safeguard = table.getn(EcoUnits)
                while massTrend < 0 do
                    -- find unit with most mass consumption
                    maxMassConsumptionUnitindex = nil
                    maxMassConsumption = nil
                    if EcoUnits[1] then
                        for index, unit in EcoUnits do
                            -- Don't pause factories if we have enemies inside the Paniczone
                            if numUnitsPanicZone > 0 and EntityCategoryContains( categories.FACTORY, unit) then continue end
                            if unit.pausedMass or unit.pausedEnergy then continue end
                            if not maxMassConsumption or maxMassConsumption < unit.ConsumptionPerSecondMass then
                                maxMassConsumption = unit.ConsumptionPerSecondMass
                                maxMassConsumptionUnitindex = index
                            end
                        end
                    else
--                        LOG('* AI-SorianEdit: ECO low mass; EcoUnits empty array. break!')
                        break
                    end
                    if maxMassConsumptionUnitindex then
--                        LOG(' ')
--                        LOG('* AI-SorianEdit: ECO massTrend < 0  ('..massTrend..')')
                        busy = true
                        massTrend = massTrend + maxMassConsumption
                        -- if EntityCategoryContains(categories.FACTORY + categories.ENGINEER + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO)), EcoUnits[maxMassConsumptionUnitindex]) then
-- --                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxMassConsumptionUnitindex].UnitId].Description)..') unit:SetPaused( true ) Saving ('..maxMassConsumption..') mass')
                            -- EcoUnits[maxMassConsumptionUnitindex]:SetPaused( true )
                            -- EcoUnits[maxMassConsumptionUnitindex].pausedMass = true
                            -- EcoUnits[maxMassConsumptionUnitindex].managed = true
                        -- else -- do not pause engies for fucks sake
                        if EntityCategoryContains(categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.COUNTERINTELLIGENCE, EcoUnits[maxMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( IntelToggle, true ) Saving ('..maxMassConsumption..') mass')
                            EcoUnits[maxMassConsumptionUnitindex]:SetScriptBit('RULEUTC_IntelToggle', true)
                            EcoUnits[maxMassConsumptionUnitindex].pausedMass = true
                            EcoUnits[maxMassConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.MASSFABRICATION, EcoUnits[maxMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( ProductionToggle, true ) Saving ('..maxMassConsumption..') mass')
                            EcoUnits[maxMassConsumptionUnitindex]:SetScriptBit('RULEUTC_ProductionToggle', true)
                            EcoUnits[maxMassConsumptionUnitindex].pausedMass = true
                            EcoUnits[maxMassConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE, EcoUnits[maxMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[maxMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[maxMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( JammingToggle, true ) Saving ('..maxMassConsumption..') mass')
                            EcoUnits[maxMassConsumptionUnitindex]:SetScriptBit('RULEUTC_JammingToggle', true)
                            EcoUnits[maxMassConsumptionUnitindex].pausedMass = true
                            EcoUnits[maxMassConsumptionUnitindex].managed = true
                        else
                            WARN('* AI-SorianEdit: Unit with unknown Category('..LOC(__blueprints[EcoUnits[maxMassConsumptionUnitindex].UnitId].Description)..') ['..EcoUnits[maxMassConsumptionUnitindex].UnitId..']')
                        end
                    else
--                        SPEW('* AI-SorianEdit: ECO cant pause any unit. break!')
                        break
                    end
--                    LOG('*ECO new massTrend = '..massTrend..'')
                    -- Never remove this safeguard! Modded units can screw it up and cause a DeadLoop!!!
                    safeguard = safeguard - 1
                    if safeguard < 0 then
                        WARN('* AI-SorianEdit: ECO M safeguard < 0')
                        break
                    end
                end
--                if busy then
--                    coroutine.yield(5)
--                    massNeed = math.floor(aiBrain:GetEconomyRequested('MASS') * 10)
--                    massIncome = math.floor(aiBrain:GetEconomyIncome( 'MASS' ) * 10)
--                    massTrendCheck = massIncome - massNeed
--                    LOG('* AI-SorianEdit: ECO massTrendCheck = '..massTrendCheck..'')
--                end
            end
        end
        coroutine.yield(1)
        if busy then
            --WARN('* AI-SorianEdit: ECOmanager low mass is busy')
            continue -- while true do
        end
        EcoUnits = {}
        if aiBrain:GetEconomyStoredRatio('MASS') >= 0.15 then
            AllUnits = aiBrain:GetListOfUnits( (categories.FACTORY - categories.TECH1) + (categories.ENGINEER - categories.POD) + categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
            if massTrend > 0 then
                --AllUnits = aiBrain:GetListOfUnits(categories.ALLUNITS - categories.COMMAND - categories.SHIELD - categories.MASSEXTRACTION, false, false) -- also gets unbuilded units (planed to build)
                for index, unit in AllUnits do
                    if not unit.pausedMass then continue end
                    -- filter units that are not finished
                    if unit:GetFractionComplete() < 1 then continue end
--                    LOG('* AI-SorianEdit: ECO checking unit ['..index..']  paused:('..repr(unit.pausedMass)..'/'..repr(unit.pausedEnergy)..') '..LOC(__blueprints[unit.UnitId].Description))
                    if unit.ConsumptionPerSecondMass > 0 then
--                        LOG('* AI-SorianEdit: ECO Adding unit ['..index..'] to table '..LOC(__blueprints[unit.UnitId].Description))
                        table.insert(EcoUnits, unit)
                    end
                end
                -- Enable units until massTrend is negative
                safeguard = table.getn(EcoUnits)
                while massTrend > 0 do
--                    SPEW('* AI-SorianEdit: ECO safeguard = '..safeguard)
                    -- find unit with most mass consumption
                    minMassConsumptionUnitindex = nil
                    minMassConsumption = nil
                    if EcoUnits[1] then
                        for index, unit in EcoUnits do
                            if not unit.pausedMass then continue end
                            if not minMassConsumption or minMassConsumption > unit.ConsumptionPerSecondMass then
                                minMassConsumption = unit.ConsumptionPerSecondMass
                                minMassConsumptionUnitindex = index
                            end
                        end
                    else
--                        LOG('* AI-SorianEdit: ECO high mass; EcoUnits empty array ')
                        break
                    end
                    if minMassConsumptionUnitindex then
--                        LOG(' ')
--                        LOG('* AI-SorianEdit: ECO massTrend > 0  ('..massTrend..')')
                        massTrend = massTrend - minMassConsumption
                        busy = true
                        if EntityCategoryContains(categories.FACTORY + (categories.ENGINEER - categories.POD) + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO)), EcoUnits[minMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minMassConsumptionUnitindex].UnitId].Description)..') unit:SetPaused( false ) Consuming ('..minMassConsumption..') mass')
                            EcoUnits[minMassConsumptionUnitindex]:SetPaused( false )
                            EcoUnits[minMassConsumptionUnitindex].pausedMass = false
                            EcoUnits[minMassConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.COUNTERINTELLIGENCE, EcoUnits[minMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( IntelToggle, false ) Consuming ('..minMassConsumption..') mass')
                            EcoUnits[minMassConsumptionUnitindex]:SetScriptBit('RULEUTC_IntelToggle', false)
                            EcoUnits[minMassConsumptionUnitindex].pausedMass = false
                            EcoUnits[minMassConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.MASSFABRICATION, EcoUnits[minMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( ProductionToggle, false ) Consuming ('..minMassConsumption..') mass')
                            EcoUnits[minMassConsumptionUnitindex]:SetScriptBit('RULEUTC_ProductionToggle', false)
                            EcoUnits[minMassConsumptionUnitindex].pausedMass = false
                            EcoUnits[minMassConsumptionUnitindex].managed = true
                        elseif EntityCategoryContains(categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE, EcoUnits[minMassConsumptionUnitindex]) then
--                            LOG('* AI-SorianEdit: ECO ['..EcoUnits[minMassConsumptionUnitindex].UnitId..'] ('..LOC(__blueprints[EcoUnits[minMassConsumptionUnitindex].UnitId].Description)..') unit:SetScriptBit( JammingToggle, false ) Consuming ('..minMassConsumption..') mass')
                            EcoUnits[minMassConsumptionUnitindex]:SetScriptBit('RULEUTC_JammingToggle', false)
                            EcoUnits[minMassConsumptionUnitindex].pausedMass = false
                            EcoUnits[minMassConsumptionUnitindex].managed = true
                        else
                            WARN('* AI-SorianEdit: Unit with unknown Category('..LOC(__blueprints[EcoUnits[minMassConsumptionUnitindex].UnitId].Description)..') ['..EcoUnits[minMassConsumptionUnitindex].UnitId..']')
                        end
--                            EcoUnits[minMassConsumptionUnitindex]:OnProductionUnpaused()
--                            EcoUnits[minMassConsumptionUnitindex]:SetActiveConsumptionActive()
                    else
--                        SPEW('* AI-SorianEdit: ECO cant activate any unit. break!')
                        break
                    end
--                    LOG('* AI-SorianEdit: ECO new massTrend = '..massTrend..'')
                    -- Never remove this safeguard! Modded units can screw it up and cause a DeadLoop!!!
                    safeguard = safeguard - 1
                    if safeguard < 0 then
                        WARN('* AI-SorianEdit: ECO M safeguard > 0')
                        break
                    end
                end
--                if busy then
--                    coroutine.yield(5)
--                    massNeed = math.floor(aiBrain:GetEconomyRequested('MASS') * 10)
--                    massIncome = math.floor(aiBrain:GetEconomyIncome( 'MASS' ) * 10)
--                    massTrendCheck = massIncome - massNeed
--                    LOG('* AI-SorianEdit: ECO massTrendCheck = '..massTrendCheck..'')
--                end
            end
        end
        coroutine.yield(1)
        if busy then
            --WARN('* AI-SorianEdit: ECOmanager high mass is busy')
            continue -- while true do
        end
        EcoUnits = {}
        if aiBrain:GetEconomyStoredRatio('ENERGY') >= 0.60 and aiBrain:GetEconomyStoredRatio('MASS') >= 0.20 then
            AllUnits = aiBrain:GetListOfUnits( (categories.FACTORY - categories.TECH1) + (categories.ENGINEER - categories.POD) + categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE + categories.MASSFABRICATION + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD) + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO ) - categories.COMMAND , false, false) -- also gets unbuilded units (planed to build)
            for index, unit in AllUnits do
                if not unit.managed then
                    continue
                end
                -- filter units that are not finished
                if unit:GetFractionComplete() < 1 then continue end
                if EntityCategoryContains(categories.FACTORY + (categories.ENGINEER - categories.POD) + (categories.ENGINEERSTATION - categories.STATIONASSISTPOD + ((categories.NUKE + categories.TACTICALMISSILEPLATFORM) * categories.SILO)), unit) then
                    unit:SetPaused( false )
                    unit.pausedMass = false
                    unit.pausedEnergy = false
                    unit.managed = false
                elseif EntityCategoryContains(categories.RADAR + categories.OMNI + categories.OPTICS + categories.SONAR + categories.COUNTERINTELLIGENCE, unit) then
                    unit:SetScriptBit('RULEUTC_IntelToggle', false)
                    unit.pausedMass = false
                    unit.pausedEnergy = false
                    unit.managed = false
                elseif EntityCategoryContains(categories.MASSFABRICATION, unit) then
                    unit:SetScriptBit('RULEUTC_ProductionToggle', false)
                    unit.pausedMass = false
                    unit.pausedEnergy = false
                    unit.managed = false
                elseif EntityCategoryContains(categories.OVERLAYCOUNTERINTEL + categories.COUNTERINTELLIGENCE, unit) then
                    unit:SetScriptBit('RULEUTC_JammingToggle', false)
                    unit.pausedMass = false
                    unit.pausedEnergy = false
                    unit.managed = false
                else
                    WARN('* AI-SorianEdit: Unit with unknown Category('..LOC(__blueprints[unit.UnitId].Description)..') ['..unit.UnitId..']')
                    unit:SetPaused( false )
                    unit.pausedMass = false
                    unit.pausedEnergy = false
                    unit.managed = false
                end
                -- we only check 1 unit per tick.
                break -- for index, unit in AllUnits do
            end
        end
    end
end

function DisableUnitsSorianEdit(aiBrain, Category, UnitType)
    local Units = aiBrain:GetListOfUnits(Category, false, false) -- also gets unbuilded units (planed to build)
    for _, unit in Units do
        if unit.Dead then continue end
        if unit:GetFractionComplete() ~= 1 then continue end
        -- Units that only needs to be set on pause
        if UnitType == 'Nuke' or UnitType == 'AntiNuke' then
            if not unit:IsPaused() then
                --LOG('*DisableUnitsSorianEdit: Unit :SetPaused true'..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
                unit:SetPaused( true )
                -- now return, we only want do disable one unit per loop
                return true
            end
        end
        -- Maintenance -- for units that are usually "on": radar, mass extractors, etc.
        if unit.MaintenanceConsumption == true then
            unit:OnProductionPaused()
            --LOG('*DisableUnitsSorianEdit: Unit OnProductionPaused '..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
            return true
        end
        -- Active -- when upgrading, constructing, or something similar.
        if unit.ActiveConsumption == true then
            unit:SetActiveConsumptionInactive()
            --LOG('*DisableUnitsSorianEdit: Unit SetActiveConsumptionInactive '..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
            return true
        end
    end
    return false
end

function EnableUnitsSorianEdit(aiBrain, Category, UnitType)
    local Units = aiBrain:GetListOfUnits(Category, false, false) -- also gets unbuilded units (planed to build)
    for _, unit in Units do
        if unit.Dead then continue end
        if unit:GetFractionComplete() ~= 1 then continue end
        -- Units that only needs to be set on pause
        if UnitType == 'Nuke' or UnitType == 'AntiNuke' then
            if unit:IsPaused() then
                --LOG('*EnableUnitsSorianEdit: Unit :SetPaused false '..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
                unit:SetPaused( false )
                -- now return, we only want do disable one unit per loop
                return true
            end
        end
        -- Maintenance -- for units that are usually "on": radar, mass extractors, etc.
        if unit.MaintenanceConsumption == false then
            unit:OnProductionUnpaused()
            --LOG('*EnableUnitsSorianEdit: Unit OnProductionUnpaused '..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
            return true
        end
        -- Active -- when upgrading, constructing, or something similar.
        if unit.ActiveConsumption == false then
            unit:SetActiveConsumptionActive()
            --LOG('*EnableUnitsSorianEdit: Unit SetActiveConsumptionActive '..UnitType..' - '..unit:GetBlueprint().BlueprintId..' - '..aiBrain.Name)
            return true
        end
    end
    return false
end

function LocationRangeManagerThreadSorianEdit(aiBrain)
    SPEW('* AI-SorianEdit: Function LocationRangeManagerThreadSorianEdit() started. ['..aiBrain.Nickname..']')
    local unitcounterdelayer = 0
    local ArmyUnits = {}
    -- wait at start of the game for delayed AI message
    while GetGameTimeSeconds() < 15 + aiBrain:GetArmyIndex() do
        coroutine.yield(10)
    end
    -- if not import('/lua/AI/sorianutilities.lua').CheckForMapMarkers(aiBrain) then
        -- import('/lua/AI/sorianutilities.lua').AISendChat('all', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'badmap')
    -- end

    while aiBrain.Result ~= "defeat" do
        coroutine.yield(50)
        --LOG('* AI-SorianEdit: Function LocationRangeManagerThreadSorianEdit() beat. ['..aiBrain.Nickname..']')
        -- Check and set the location radius of our main base and expansions
        local BasePositions = BaseRangerSorianEdit(aiBrain)
        -- Check if we have units outside the range of any BaseManager
        -- Get all units from our ArmyPool. These are units without a special platoon or task. They have nothing to do.
        ArmyUnits = aiBrain:GetListOfUnits(categories.MOBILE - categories.MOBILESONAR, false, false) -- also gets unbuilded units (planed to build)
        -- Loop over every unit that has no platton and is idle
        local LoopDelay = 0
        for _, unit in ArmyUnits do
            if unit.Dead then
                continue
            end
            -- check if we have name debugging enabled (ScenarioInfo.Options.AIPLatoonNameDebug = SorianEdit or Sorian or Dilli)
            if (aiBrain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all')  then
                if unit.PlatoonHandle then
                    local Plan = unit.PlatoonHandle.PlanName
                    local Builder = unit.PlatoonHandle.BuilderName
                    if Plan or Builder then
                        unit:SetCustomName(''..(Builder or 'Unknown')..' ('..(Plan or 'Unknown')..')')
                        -- unit:SetCustomName(''..(Builder or 'Unknown'))
                        unit.LastPlatoonHandle = {}
                        unit.LastPlatoonHandle.PlanName = unit.PlatoonHandle.PlanName
                        unit.LastPlatoonHandle.BuilderName = unit.PlatoonHandle.BuilderName
--                    else
--                        if unit.LastPlatoonHandle then
--                            local Plan = unit.LastPlatoonHandle.PlanName
--                            local Builder = unit.LastPlatoonHandle.BuilderName
--                            unit:SetCustomName('+ no Plan, Old: '..(Builder or 'Unknown')..' ('..(Plan or 'Unknown')..')')
--                        else
--                            unit:SetCustomName('+ Platoon, no Plan')
--                        end
                    end
                else
                    unit:SetCustomName('Pool')
                end
            end
            local WeAreInRange = false
            local nearestbase
            if not unit.Dead
                and EntityCategoryContains(categories.MOBILE - categories.COMMAND - categories.ENGINEER, unit)
                and unit:GetFractionComplete() == 1
                and unit:IsIdleState()
                and not unit:IsMoving()
                and (not unit.PlatoonHandle or (not unit.PlatoonHandle.PlanName and not unit.PlatoonHandle.BuilderName))
            then
                local UnitPos = unit:GetPosition()
                local NeedNavalBase = EntityCategoryContains(categories.NAVAL, unit)
                -- loop over every location and check the distance between the unit and the location
                for location, base in BasePositions do
                    -- If we need a naval base then skip all non naval areas
                    if NeedNavalBase and base.Type ~= 'Naval Area' then
                        --LOG('* AI-SorianEdit: Need naval; but got land base: '..base.Type)
                        continue
                    end
                    -- If we need a land base then skip all naval areas
                    if not NeedNavalBase and base.Type == 'Naval Area' then
                        --LOG('* AI-SorianEdit: Need land; but got naval base: '..base.Type)
                        continue
                    end
                    local dist = VDist2( UnitPos[1], UnitPos[3], base.Pos[1], base.Pos[3] )
                    -- if we are in range of a base, continue. We don't need to move the unit. It's in range of a basemanager
                    if dist < base.Rad then
                        WeAreInRange = true
                        break
                    end
                    -- remember the nearest base. We will move to it.
                    if not nearestbase or nearestbase.dist > dist then
                        nearestbase = {}
                        nearestbase.Pos = base.Pos
                        nearestbase.dist = dist
                    end
                end
                -- if we are not in range of an base, then move closer to a base.
                if WeAreInRange == false and not unit.Dead then
                    if nearestbase then
                        if aiBrain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all' then
                            unit:SetCustomName('Outside LocationManager')
                        end
                        IssueClearCommands({unit})
                        IssueStop({unit})
                        IssueMove({unit}, { nearestbase.Pos[1] + (Random(-10, 10)), nearestbase.Pos[2], nearestbase.Pos[3] + (Random(-10, 10)) })
                    end
                end
            end
            -- delay the loop after every 50 units. looping over 1000 units will take 2 seconds
            LoopDelay = LoopDelay + 1
            if LoopDelay > 50 then
                LoopDelay = 0
                coroutine.yield(1)
            end
        end

        coroutine.yield(1)

        -- check for factories without a location manager
        ArmyUnits = aiBrain:GetListOfUnits(categories.STRUCTURE * categories.FACTORY, false, false) -- also gets unbuilded units (planed to build)
        for _, factory in ArmyUnits do
            if factory.Dead then
                continue
            end
            if factory:GetFractionComplete() ~= 1 then
                continue
            end
            -- naval factory ?
            if EntityCategoryContains(categories.NAVAL, factory) then
                -- Is this a Naval Factory and assigned to the main base ?
                if factory.BuilderManagerData.FactoryBuildManager.LocationType == 'MAIN' then
                    -- Search the Main base FactoryList and delte the factory from it
                    for k,v in factory.BuilderManagerData.FactoryBuildManager.FactoryList do
                        -- if we found the factory, delete it. It will assign to a new location
                        if v == factory then
                            factory.BuilderManagerData.FactoryBuildManager.FactoryList[k] = nil
                            factory.BuilderManagerData = nil
                            factory.lost = GetGameTimeSeconds() - 12
                        end
                    end

                end
            end
            -- welcher manager ?
            if not factory.BuilderManagerData then
                if not factory.lost then
                    factory.lost = GetGameTimeSeconds()
                elseif factory.lost + 10 < GetGameTimeSeconds() then
                    AddFactoryToClosestManagerSorianEdit(aiBrain, factory)
                end
            end
            -- Debug, show the actual location where the factory is assigned to as name.
            --factory:SetCustomName(factory.BuilderManagerData.FactoryBuildManager.LocationType or 'Unknown')
        end


        if 1 == 2 then
        -- watching the unit Cap for AI balance.
            unitcounterdelayer = unitcounterdelayer + 1
            if unitcounterdelayer > 12 then
                unitcounterdelayer = 0
                local MaxCap = GetArmyUnitCap(aiBrain:GetArmyIndex())
                LOG('  ')
                LOG('* AI-SorianEdit:  05.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.MOBILE * (categories.ENGINEER - categories.POD) * categories.TECH1, false, false) ) )..' -  Engineers TECH1  - ' )
                LOG('* AI-SorianEdit:  05.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.MOBILE * (categories.ENGINEER - categories.POD) * categories.TECH2, false, false) ) )..' -  Engineers TECH2  - ' )
                LOG('* AI-SorianEdit:  05.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.MOBILE * (categories.ENGINEER - categories.POD) * categories.TECH3 - categories.SUBCOMMANDER, false, false) ) )..' -  Engineers TECH3  - ' )
                LOG('* AI-SorianEdit:  03.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.MOBILE * categories.SUBCOMMANDER, false, false) ) )..' -  SubCommander   - ' )
                LOG('* AI-SorianEdit:  45.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.MOBILE - ((categories.ENGINEER - categories.POD) * categories.MOBILE), false, false) ) )..' -  Mobile Attack Force  - ' )
                LOG('* AI-SorianEdit:  10.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE * categories.MASSEXTRACTION, false, false) ) )..' -  Extractors    - ' )
                LOG('* AI-SorianEdit:  12.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE * categories.DEFENSE, false, false) ) )..' -  Structures Defense   - ' )
                LOG('* AI-SorianEdit:  12.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE - categories.MASSEXTRACTION - categories.DEFENSE - (categories.STRUCTURE * categories.FACTORY), false, false) ) )..' -  Structures all   - ' )
                LOG('* AI-SorianEdit:  02.4 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE * categories.FACTORY * categories.LAND, false, false) ) )..' -  Factory Land  - ' )
                LOG('* AI-SorianEdit:  02.4 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE * categories.FACTORY * categories.AIR, false, false) ) )..' -  Factory Air   - ' )
                LOG('* AI-SorianEdit:  02.4 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE * categories.FACTORY * categories.NAVAL, false, false) ) )..' -  Factory Sea   - ' )
                LOG('* AI-SorianEdit: ------|------')
                LOG('* AI-SorianEdit: 100.0 | '..math.floor(100 / MaxCap * table.getn(aiBrain:GetListOfUnits(categories.STRUCTURE + categories.MOBILE, false, false) ) )..' -  Structure + Mobile   - ' )
--                UNITS = aiBrain:GetListOfUnits(categories.STRUCTURE - categories.MASSEXTRACTION - categories.DEFENSE - (categories.STRUCTURE * categories.FACTORY), false, false)
--                for k,unit in UNITS do
--                    local description = unit:GetBlueprint().Description
--                    local location = unit:GetPosition()
--                    LOG('* AI-SorianEdit: K='..k..' - Unit= '..description..' - '..repr(location))
--                end
            end
        end
        
--        local SUtils = import('/lua/AI/sorianutilities.lua')
--        SUtils.AIRandomizeTaunt(aiBrain)

    end
end

function BaseRangerSorianEdit(aiBrain)
    local BaseRangerSorianEdit = {}
    if aiBrain.BuilderManagers then
        local BaseLocations = {
            [1] = 'MAIN',
            [2] = 'Naval Area',
            [3] = 'Blank Marker',
            [4] = 'Large Expansion Area',
            [5] = 'Expansion Area',
        }
        -- Check BaseLocations
        for Index, BaseType in BaseLocations do
            -- loop over BuilderManagers and check every location
            for k,v in aiBrain.BuilderManagers do
                -- Check baselocations sorted by BaseLocations Index
                if k ~= BaseType and Scenario.MasterChain._MASTERCHAIN_.Markers[v.FactoryManager.LocationType].type ~= BaseType then
                    -- No BaseLocation. Continue with the next array-key
                    continue
                end
                -- We found a BaseLocation
                local StartPos = v.FactoryManager.Location
                local StartRad = v.FactoryManager.Radius
                local V1Naval = string.find(k, 'Naval Area')
                -- This is the maximum base radius.
                local NewMax = 120
                -- Now check against every other baseLocation, and see if we need to reduce our base radius.
                for k2,v2 in aiBrain.BuilderManagers do
                    local V2Naval = string.find(k2, 'Naval Area')
                    -- Only check, if base markers are not the same. Exclude compare between land and water locations
                    if v ~= v2 and ((V1Naval and V2Naval) or (not V1Naval and not V2Naval)) then
                        local EndPos = v2.FactoryManager.Location
                        local EndRad = v2.FactoryManager.Radius
                        local dist = VDist2( StartPos[1], StartPos[3], EndPos[1], EndPos[3] )
                        -- If this is true, then we compare our MAIN base versus expansion location
                        if k == 'MAIN' then
                            -- Mainbase can use 66% of the distance to the next location (minimum 90). But only if we have enough space for the second base (>=30)
                            if NewMax > dist/3*2 and dist/3*2 > 90 and dist/3 >= 30 then
                                NewMax = dist/3*2
                                --LOG('* AI-SorianEdit: Distance from mainbase['..k..']->['..k2..']='..dist..' Mainbase radius='..StartRad..' Set Radius to '..dist/3*2)
                            -- If we have not enough spacee for the second base, then use half the distance as location radius
                            elseif NewMax > dist/2 and dist/2 > 90 and dist/2 >= 30 then
                                NewMax = dist/2
                                --LOG('* AI-SorianEdit: Distance to location['..k..']->['..k2..']='..dist..' location radius='..StartRad..' Set Radius to '..dist/2)
                            -- We have not enough space for the mainbase. Set it to 90. Wee need this radius for gathering plattons etc
                            else
                                NewMax = 90
                            end
                        -- This is true, then we compare expansion location versus MAIN base
                        elseif k2 == 'MAIN' then
                            -- Expansion can use 33% of the distance to the Mainbase.
                            if NewMax > dist - EndRad and dist - EndRad >= 30 then
                                NewMax = dist - EndRad
                                --LOG('* AI-SorianEdit: Distance to mainbase['..k..']->['..k2..']='..dist..' Mainbase radius='..EndRad..' Set Radius to '..dist - EndRad)
                            end
                        -- Use as base radius half the way to the next marker.
                        else
                            -- if we dont compare against the mainbase then use 50% of the distance to the next location
                            if NewMax > dist/2 and dist/2 >= 30 then
                                NewMax = dist/2
                                --LOG('* AI-SorianEdit: Distance to location['..k..']->['..k2..']='..dist..' location radius='..StartRad..' Set Radius to '..dist/2)
                            end
                        end
                    end
                end
                -- Now check for existing managers and set the new value to it
                if v.FactoryManager then
                    v.FactoryManager.Radius = NewMax
                end
                if v.EngineerManager then
                    v.EngineerManager.Radius = NewMax
                end
                if v.PlatoonFormManager then
                    v.PlatoonFormManager.Radius = NewMax
                end
                if v.StrategyManager then
                    v.StrategyManager.Radius = NewMax
                end
                -- Check if we have a terranhigh (or we can't draw the debug BaseRangerSorianEdit)
                if StartPos[2] == 0 then
                    StartPos[2] = GetTerrainHeight(StartPos[1], StartPos[3])
                    -- store the TerranHeight inside Factorymanager
                    v.FactoryManager.Location = StartPos
                end
                -- Add the position and radius to the BaseRangerSorianEdit table
                BaseRangerSorianEdit[k] = {Pos = StartPos, Rad = math.floor(NewMax), Type = BaseType}
            end
        end
        -- store all bases ang radii global inside Scenario.MasterChain
        -- Wee need this to draw the debug circles
        if aiBrain.sorianedit then
            if ScenarioInfo.Options.AIPathingDebug == 'pathlocation' then
                Scenario.MasterChain._MASTERCHAIN_.BaseRangerSorianEdit = Scenario.MasterChain._MASTERCHAIN_.BaseRangerSorianEdit or {}
                Scenario.MasterChain._MASTERCHAIN_.BaseRangerSorianEdit[aiBrain:GetArmyIndex()] = BaseRangerSorianEdit
            end
        end
    end
    return BaseRangerSorianEdit
end

function BaseTargetManagerThreadSorianEdit(aiBrain)
    while GetGameTimeSeconds() < 20 + aiBrain:GetArmyIndex() do
        coroutine.yield(10)
    end
    SPEW('* AI-SorianEdit: Function BaseTargetManagerThreadSorianEdit() started. ['..aiBrain.Nickname..']')
    local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua').GetDangerZoneRadii()
    local targets = {}
    local baseposition, radius
    local ClosestTarget
    local distance
    local armyIndex = aiBrain:GetArmyIndex()
    while aiBrain.Result ~= "defeat" do
        --LOG('* AI-SorianEdit: Function BaseTargetManagerThreadSorianEdit() beat. ['..aiBrain.Nickname..']')
        ClosestTarget = nil
        distance = 8192
        coroutine.yield(50)
        if not baseposition then
            if aiBrain:PBMHasPlatoonList() then
                for k,v in aiBrain.PBM.Locations do
                    if v.LocationType == 'MAIN' then
                        baseposition = v.Location
                        radius = v.Radius
                        break
                    end
                end
            elseif aiBrain.BuilderManagers['MAIN'] then
                baseposition = aiBrain.BuilderManagers['MAIN'].FactoryManager.Location
                radius = aiBrain.BuilderManagers['MAIN'].FactoryManager:GetLocationRadius()
            end
            if not baseposition then
                continue
            end
        end
        -- Search for experimentals in BasePanicZone
        targets = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL - categories.AIR - categories.INSIGNIFICANTUNIT, baseposition, BasePanicZone, 'Enemy')
        for _, unit in targets do
            if not unit.Dead then
                if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                local TargetPosition = unit:GetPosition()
                local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                if targetRange < distance then
                    distance = targetRange
                    ClosestTarget = unit
                end
            end
        end
        coroutine.yield(1)
        -- Search for experimentals in BaseMilitaryZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL - categories.AIR - categories.INSIGNIFICANTUNIT, baseposition, BaseMilitaryZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for Submarine Nuke units
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.NUKESUB, baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for Paragons in EnemyZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL * categories.ECONOMIC, baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for Arty in EnemyZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.ARTILLERY * (categories.TECH3 + categories.EXPERIMENTAL), baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for Nuke in EnemyZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE * categories.NUKE * (categories.TECH3 + categories.EXPERIMENTAL), baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for experimentals in EnemyZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL - categories.AIR - categories.INSIGNIFICANTUNIT, baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for High Threat Area
        if not ClosestTarget and HighestThreat[armyIndex].TargetLocation then
            -- search for any unit in this area
            targets = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL + categories.TECH3 + categories.ALLUNITS, HighestThreat[armyIndex].TargetLocation, 60, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                        -- we only need a single unit for targeting this area
                        --LOG('* AI-SorianEdit: High Threat Area: '.. repr(HighestThreat[armyIndex].TargetThreat)..' - '..repr(HighestThreat[armyIndex].TargetLocation))
                        break --for _, unit in targets do
                    end
                end
            end
            coroutine.yield(1)
        end
        -- Search for T3 Factories / Gates in EnemyZone
        if not ClosestTarget then
            targets = aiBrain:GetUnitsAroundPoint((categories.STRUCTURE * categories.GATE) + (categories.STRUCTURE * categories.FACTORY * categories.TECH3 - categories.SUPPORTFACTORY), baseposition, BaseEnemyZone, 'Enemy')
            for _, unit in targets do
                if not unit.Dead then
                    if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then continue end
                    local TargetPosition = unit:GetPosition()
                    local targetRange = VDist2(baseposition[1], baseposition[3], TargetPosition[1], TargetPosition[3])
                    if targetRange < distance then
                        distance = targetRange
                        ClosestTarget = unit
                    end
                end
            end
            coroutine.yield(1)
        end
        aiBrain.PrimaryTarget = ClosestTarget
    end
end

--OLD: - Highest:0.023910 - Average:0.017244
--NEW: - Highest:0.002929 - Average:0.002018
function MarkerGridThreatManagerThreadSorianEdit(aiBrain)
    while GetGameTimeSeconds() < 10 + aiBrain:GetArmyIndex() do
        coroutine.yield(10)
    end
    SPEW('* AI-SorianEdit: Function MarkerGridThreatManagerThreadSorianEdit() started. ['..aiBrain.Nickname..']')
    local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')
    local numTargetTECH123 = 0
    local numTargetTECH4 = 0
    local numTargetCOM = 0
    local armyIndex = aiBrain:GetArmyIndex()
    local PathGraphs = AIAttackUtils.GetPathGraphs()
    local vector
    if not (PathGraphs['Land'] or PathGraphs['Amphibious'] or PathGraphs['Air'] or PathGraphs['Water']) then
        WARN('* AI-SorianEdit: Function MarkerGridThreatManagerThreadSorianEdit() No AI path markers found on map. ThreatManager disabled!  '..ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality)
        -- end this forked thead
        return
    end
    while aiBrain.Result ~= "defeat" do
        HighestThreat[armyIndex] = HighestThreat[armyIndex] or {}
        HighestThreat[armyIndex].ThreatCount = 0
        --LOG('* AI-SorianEdit: Function MarkerGridThreatManagerThreadSorianEdit() beat. ['..aiBrain.Nickname..']')
        for Layer, LayerMarkers in PathGraphs do
            for graph, GraphMarkers in LayerMarkers do
                for nodename, markerInfo in GraphMarkers do
-- possible options for GetThreatAtPosition
--  Overall
--  OverallNotAssigned
--  StructuresNotMex
--  Structures
--  Naval
--  Air
--  Land
--  Experimental
--  Commander
--  Artillery
--  AntiAir
--  AntiSurface
--  AntiSub
--  Economy
--  Unknown
                    local Threat = 0
                    vector = Vector(markerInfo.position[1],markerInfo.position[2],markerInfo.position[3])
                    if markerInfo.layer == 'Land' then
                        Threat = aiBrain:GetThreatAtPosition(vector, 0, true, 'AntiSurface')
                    elseif markerInfo.layer == 'Amphibious' then
                        Threat = aiBrain:GetThreatAtPosition(vector, 0, true, 'AntiSurface')
                        Threat = Threat + aiBrain:GetThreatAtPosition(vector, 0, true, 'AntiSub')
                    elseif markerInfo.layer == 'Water' then
                        Threat = aiBrain:GetThreatAtPosition(vector, 0, true, 'AntiSurface')
                        Threat = Threat + aiBrain:GetThreatAtPosition(vector, 0, true, 'AntiSub')
                    elseif markerInfo.layer == 'Air' then
                        Threat = aiBrain:GetThreatAtPosition(vector, 1, true, 'AntiAir')
                        Threat = Threat + aiBrain:GetThreatAtPosition(vector, 0, true, 'Structures')
                    end
                    --LOG('* AI-SorianEdit: MarkerGridThreatManagerThreadSorianEdit: 1='..numTargetTECH1..'  2='..numTargetTECH2..'  3='..numTargetTECH123..'  4='..numTargetTECH4..' - Threat='..Threat..'.' )
                    Scenario.MasterChain._MASTERCHAIN_.Markers[nodename][armyIndex] = Threat
                    if Threat > HighestThreat[armyIndex].ThreatCount then
                        HighestThreat[armyIndex].ThreatCount = Threat
                        HighestThreat[armyIndex].Location = vector
                    end
                end
            end
            -- Wait after checking a layer, so we need 0.4 seconds for all 4 layers.
            coroutine.yield(1)
        end
        if HighestThreat[armyIndex].ThreatCount > 1 then
            HighestThreat[armyIndex].TargetThreat = HighestThreat[armyIndex].ThreatCount
            HighestThreat[armyIndex].TargetLocation = HighestThreat[armyIndex].Location
        end
    end
end

function AddFactoryToClosestManagerSorianEdit(aiBrain, factory)
    SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: Factory '..factory.UnitId..' is not assigned to a factory manager!')
    local FactoryPos = factory:GetPosition()
    local NavalFactory = EntityCategoryContains(categories.NAVAL, factory)
    local ClosestMarkerBasePos, MarkerBaseName, layer, dist, areatype, BaseRadius
    -- searching for the closest location near the factory (MAIN, Expansion Area)
    if NavalFactory then
        ClosestMarkerBasePos, MarkerBaseName = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Naval Area', FactoryPos[1], FactoryPos[3])
        layer = 'Water'
    else
        ClosestMarkerBasePos, MarkerBaseName = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Blank Marker', FactoryPos[1], FactoryPos[3], {'Expansion Area', 'Large Expansion Area'})
        layer = 'Land'
    end
    if not ClosestMarkerBasePos then
        WARN('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: ClosestMarkerBasePos is NIL for layer '..layer)
    end
    --  if exist, get the distance to the closest Marker Location
    if ClosestMarkerBasePos then
        dist = VDist2(FactoryPos[1], FactoryPos[3], ClosestMarkerBasePos[1], ClosestMarkerBasePos[3])
    else
        dist = 0
    end
    --  if we have already found a manager, get it's BaseRadius
    if aiBrain.BuilderManagers[MarkerBaseName].FactoryManager.Radius then
        BaseRadius = aiBrain.BuilderManagers[MarkerBaseName].FactoryManager.Radius
    else
        BaseRadius = 30
    end
    -- check if the distance from our factory to the closest basemanager is closeer than the managers max range and check if we are on the same land/sea
    if not FactoryPos then
        WARN('FactoryPos = NIL')
    end
    if not ClosestMarkerBasePos then
        WARN('ClosestMarkerBasePos = NIL')
    end
    
    -- if dist > BaseRadius or (not ClosestMarkerBasePos) or (not CanGraphAreaTo(FactoryPos, ClosestMarkerBasePos, layer)) then -- needs graph check for land and naval locations
    if dist > BaseRadius or (not ClosestMarkerBasePos) or (not NavUtils.CanPathTo(layer, FactoryPos, ClosestMarkerBasePos)) then -- needs graph check for land and naval locations
        WARN('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: Found ['..MarkerBaseName..'] Baseradius('..math.floor(BaseRadius)..') but it\'s to not reachable: Distance to base: '..math.floor(dist)..' - Creating new location')
        if NavalFactory then
            MarkerBaseName = 'Naval Area '..Random(1000,5000)
            areatype = 'Naval Area'
        else
            MarkerBaseName = 'Expansion Area '..Random(1000,5000)
            areatype = 'Expansion Area'
        end
        -- creating a marker for the expansion or AIUtils.AIGetClosestMarkerLocation() will not find it.
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName] = {}
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].color = 'fff4a460'
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].hint = true
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].orientation = { 0, 0, 0 }
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].prop = "/env/common/props/markers/M_Expansion_prop.bp"
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].type = areatype
        Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].position = FactoryPos
        ClosestMarkerBasePos = FactoryPos
    end
    -- get the location type of this marker ( Blank Marker, Naval Area, Expansion Area, Large Expansion Area )
    local LocationType = Scenario.MasterChain._MASTERCHAIN_.Markers[MarkerBaseName].type
    -- Is this a start location ?
    if LocationType == 'Blank Marker' then
        -- Is this our own start location ?
        if MarkerBaseName == 'ARMY_'..aiBrain:GetArmyIndex() then
            -- Our mainbase is called 'MAIN', so rename ARMY_x
            MarkerBaseName = 'MAIN'
            -- FirstBaseFunction does not need an expansion name, so we can use a custom name here
            LocationType = 'Start Area '..aiBrain:GetArmyIndex()
        else
            -- Not our own start area, lets make an large expansion here
            LocationType = 'Large Expansion Area'
        end
    -- This is only for debug in case map markers have wrong .type
    elseif LocationType ~= 'Naval Area' and LocationType ~= 'Expansion Area' and LocationType ~= 'Large Expansion Area' then
        WARN('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: unknown LocationType '..tostring(LocationType)..' !')
    end
    SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: Factory '..factory.UnitId..' is close ('..math.floor(dist)..') to MarkerBaseName '..MarkerBaseName..' ('..tostring(LocationType)..')')
    -- search for an manager on this location
    if aiBrain.BuilderManagers[MarkerBaseName] then
        SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: BuilderManagers for MarkerBaseName '..MarkerBaseName..' exist!')
        -- Just a failsafe, normaly we have an FactoryManager if the BuilderManagers on this location is present.
        if aiBrain.BuilderManagers[MarkerBaseName].FactoryManager then
            SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: FactoryManager at MarkerBaseName '..MarkerBaseName..' exist! Adding Factory!')
            -- using AddFactory() from the factory manager to add the factory to the manager.
            aiBrain.BuilderManagers[MarkerBaseName].FactoryManager:AddFactory(factory)
            factory.lost = nil
        end
    else
        -- no basemanager found, create a new one.
        SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: BuilderManagers for MarkerBaseName '..MarkerBaseName..' does not exist! Creating Manager')
        -- Create the new expansion on the expansion marker position with a radius of 100. 100 is only an default value, it will be changed from BaseRangerSorianEdit() thread
        aiBrain:AddBuilderManagers(ClosestMarkerBasePos, 100, MarkerBaseName, true)
        -- add the factory to the new manager
        SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: FactoryManager at MarkerBaseName '..MarkerBaseName..' created! Adding Factory!')
        aiBrain.BuilderManagers[MarkerBaseName].FactoryManager:AddFactory(factory)
        -- Factory is no longer without an manager
        factory.lost = nil
        -- Search for a basetemplates for the new expansion ( original code can be found in aibuildstructures.lua.AINewExpansionBase() )
        -- Calling the ExpansionFunction inside all /AIBaseTemplates/*.* files to find the right expansion template
        local baseValues = {}
        local highPri = false
        for templateName, baseData in BaseBuilderTemplates do
            local baseValue = baseData.ExpansionFunction(aiBrain, ClosestMarkerBasePos, LocationType)
            table.insert(baseValues, { Base = templateName, Value = baseValue })
            if not highPri or baseValue > highPri then
                highPri = baseValue
            end
        end
        -- create a table with all possible base expansion templates
        local validNames = {}
        for k,v in baseValues do
            if v.Value == highPri then
                table.insert(validNames, v.Base)
            end
        end
        -- get a random name if we have more than one possible base template
        local pick = validNames[ Random(1, table.getn(validNames)) ]
        SPEW('* AI-SorianEdit: AddFactoryToClosestManagerSorianEdit: picked basetemplate '..pick..' for location '..MarkerBaseName..' ('..tostring(LocationType)..')')
        -- finaly loading the templates for the new base location. From now on the new factory can work for us :D
        import('/lua/ai/AIAddBuilderTable.lua').AddGlobalBaseTemplate(aiBrain, MarkerBaseName, pick)
    end
end

function PriorityManagerThreadSE(aiBrain)
    local UCBC = import('/lua/editor/UnitCountBuildConditions.lua')
    local MABC = import('/lua/editor/MarkerBuildConditions.lua')
    local MIBC = import('/lua/editor/MiscBuildConditions.lua')
    aiBrain.PriorityManager = {}
    aiBrain.PriorityManager.NeedMass = true
    aiBrain.PriorityManager.NeedMobileLand = true
    aiBrain.PriorityManager.NeedMobileHover = true
    aiBrain.PriorityManager.NeedMobileAmphibious = true
    aiBrain.PriorityManager.NeedMobileAir = true
    aiBrain.PriorityManager.NeedMobileNaval = true
    while GetGameTimeSeconds() < 5 + aiBrain:GetArmyIndex() do
        coroutine.yield(10)
    end
    SPEW('* AI-SorianEdit: Function PriorityManagerThread() started. ['..aiBrain.Nickname..']')
    local LANDSTRUCTURE
    local LANDMOBILE
    local AIRSTRUCTURE
    local AIRMOBILE
    local NAVALSTRUCTURE
    local NAVALMOBILE
    while aiBrain.Result ~= "defeat" do
        coroutine.yield(50)
        -- Check for mass need. (EngineerBuilder)
        -- Are less then 10% of all structures are extractors ? - Then we need more
        if UCBC.HaveUnitRatioVersusCapSE(aiBrain, 0.10, '<', categories.STRUCTURE * categories.MASSEXTRACTION)
        -- Do we have a free mass spot ? - Then we can more
        and MABC.CanBuildOnMass(aiBrain, 'MAIN', 1000, -500, 1, 0, 'AntiSurface', 1) then
            aiBrain.PriorityManager.NeedMass = true
        else
            aiBrain.PriorityManager.NeedMass = false
        end
        -- check for layer with least units
        LANDFACTORY = aiBrain:GetCurrentUnits(categories.LAND * categories.FACTORY)
        LANDMOBILE = aiBrain:GetCurrentUnits(categories.LAND * categories.MOBILE - categories.SCOUT - categories.ENGINEER)
        AIRFACTORY = aiBrain:GetCurrentUnits(categories.AIR * categories.FACTORY)
        AIRMOBILE = aiBrain:GetCurrentUnits(categories.AIR * categories.MOBILE - categories.SCOUT - categories.TRANSPORTFOCUS)
        NAVALFACTORY = aiBrain:GetCurrentUnits(categories.NAVAL * categories.FACTORY)
        NAVALMOBILE = aiBrain:GetCurrentUnits(categories.NAVAL * categories.MOBILE)
        --LOG('* AI-SorianEdit:  '..LANDFACTORY..'/'..AIRFACTORY..'/'..NAVALFACTORY..' - LANDMOBILE: '..LANDMOBILE..' - AIRMOBILE: '..AIRMOBILE..' - NAVALMOBILE: '..NAVALMOBILE..'.')
        -- can we build more units ?
        if UCBC.HaveUnitRatioVersusCapSE(aiBrain, 0.45, '<', categories.MOBILE) then
            if (LANDMOBILE >= AIRMOBILE) and (LANDMOBILE >= NAVALMOBILE) then
                aiBrain.PriorityManager.NeedMobileLand = false
                aiBrain.PriorityManager.NeedMobileHover = false
                aiBrain.PriorityManager.NeedMobileAmphibious = false
                if AIRFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileAir = true
                end
                if NAVALFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileNaval = true
                end
            elseif (AIRMOBILE >= LANDMOBILE) and (AIRMOBILE >= NAVALMOBILE) then
                if LANDFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileLand = true
                    aiBrain.PriorityManager.NeedMobileHover = true
                    aiBrain.PriorityManager.NeedMobileAmphibious = true
                end
                aiBrain.PriorityManager.NeedMobileAir = false
                if NAVALFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileNaval = true
                end
            elseif (NAVALMOBILE >= LANDMOBILE) and (NAVALMOBILE >= AIRMOBILE) then
                if LANDFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileLand = true
                    aiBrain.PriorityManager.NeedMobileHover = true
                    aiBrain.PriorityManager.NeedMobileAmphibious = true
                end
                if AIRFACTORY > 0 then
                    aiBrain.PriorityManager.NeedMobileAir = true
                end
                aiBrain.PriorityManager.NeedMobileNaval = false
            else
            end
        -- we can't build more units because of unitcap
        else
            aiBrain.PriorityManager.NeedMobileLand = false
            aiBrain.PriorityManager.NeedMobileHover = false
            aiBrain.PriorityManager.NeedMobileAmphibious = false
            aiBrain.PriorityManager.NeedMobileAir = false
            aiBrain.PriorityManager.NeedMobileNaval = false
        end
    end
end

