--***************************************************************************
--*
--**  File     :  /mods/SorianEdit/lua/ai/SorianEditStrategyBuilders.lua
--**
--**  Summary  : Default Naval structure builders for skirmish
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local BBTmplFile = '/lua/basetemplates.lua'
local ExBaseTmpl = 'ExpansionBaseTemplates'
local BuildingTmpl = 'BuildingTemplates'
local BaseTmpl = 'BaseTemplates'
local Adj2x2Tmpl = 'Adjacency2x2'
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local OAUBC = '/lua/editor/OtherArmyUnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local PCBC = '/lua/editor/PlatoonCountBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local PlatoonFile = '/lua/platoon.lua'
local SBC = '/mods/Sorian Edit/lua/editor/SorianEditBuildConditions.lua'
local SIBC = '/mods/Sorian Edit/lua/editor/SorianEditInstantBuildConditions.lua'
local AIUtils = import('/lua/ai/aiutilities.lua')
local Behaviors = import('/lua/ai/aibehaviors.lua')
local AIAttackUtils = import('/lua/ai/aiattackutilities.lua')
local UnitUpgradeTemplates = import('/lua/upgradetemplates.lua').UnitUpgradeTemplates
local StructureUpgradeTemplates = import('/lua/upgradetemplates.lua').StructureUpgradeTemplates
local SUtils = import('/mods/Sorian Edit/lua/AI/SorianEditutilities.lua')
local econThread
local BasePanicZone, BaseMilitaryZone, BaseEnemyZone = import('/mods/AI-Uveso/lua/AI/uvesoutilities.lua').GetDangerZoneRadii(true)

	do
	LOG('--------------------- SorianEdit Strategy Builders loading')
	end
	
function EconWatch(aiBrain)
    local factionIndex = aiBrain:GetFactionIndex()
    local cats = {
        categories.MASSEXTRACTION * categories.TECH1,
        categories.FACTORY * categories.TECH1,
        categories.MASSEXTRACTION * categories.TECH2,
        categories.FACTORY * categories.TECH2,
        categories.MASSEXTRACTION * categories.TECH3,
        categories.FACTORY * categories.TECH3,
    }
    repeat
        for _,cat in cats do
            local units = aiBrain:GetListOfUnits(cat, false)
            if table.getn(units) <= 0 then continue end
            for k, unit in units do
                if unit.Dead then continue end
                local upgradeID
                if EntityCategoryContains(categories.MOBILE, unit) then
                    upgradeID = aiBrain:FindUpgradeBP(unit:GetUnitId(), UnitUpgradeTemplates[factionIndex])
                else
                    upgradeID = aiBrain:FindUpgradeBP(unit:GetUnitId(), StructureUpgradeTemplates[factionIndex])
                end
                if upgradeID and EntityCategoryContains(categories.STRUCTURE, unit) and not unit:CanBuild(upgradeID) then
                    continue
                end
                if upgradeID then
                    IssueStop({unit})
                    IssueUpgrade({unit}, upgradeID)
                end
                WaitSeconds(2)
                if AIUtils.AIGetEconomyNumbers(aiBrain).MassEfficiency < 1.0
                or AIUtils.AIGetEconomyNumbers(aiBrain).EnergyEfficiency < 1.0 then break end
            end
            if AIUtils.AIGetEconomyNumbers(aiBrain).MassEfficiency < 1.0
            or AIUtils.AIGetEconomyNumbers(aiBrain).EnergyEfficiency < 1.0 then break end
        end
        WaitSeconds(1)
    until AIUtils.AIGetEconomyNumbers(aiBrain).MassEfficiency < 1.0
    or AIUtils.AIGetEconomyNumbers(aiBrain).EnergyEfficiency < 1.0

    econThread = nil
end

BuilderGroup {
    BuilderGroupName = 'SorianEdit Excess Mass Strategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Excess Mass Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = true
            if econThread then
                KillThread(econThread)
            end
            LOG('*AI DEBUG: --------------  SorianEdit Excess Mass Strategy Activated by '..aiBrain.Nickname..'!')
            econThread = ForkThread(EconWatch, aiBrain)
        end,
        OnStrategyDeactivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = false
            if econThread then
                KillThread(econThread)
                econThread = nil
            end
        end,
        PriorityFunction = function(self, aiBrain)
            if econThread or not (econThread and Builders[self.BuilderName].Running) then
        LOG('---------------------  Excess Mass Strategy 100')
                return 100
            elseif not econThread and Builders[self.BuilderName].Running then
        LOG('---------------------  Excess Mass Strategy 0')
                return 0
            end
        end,
        BuilderConditions = {
            { UCBC, 'GreaterThanGameTimeSeconds', { 300 }},
            { SBC, 'CategoriesNotRestricted', { {'T2', 'T3'} }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.0, 1.0}},
            { SIBC, 'GreaterThanEconEfficiency', { 1.0, 1.0 }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T3 Land Exp1 Engineer - Excess Mass',
                'SorianEdit T3 Land Exp1 Engineer - Large Map - Excess Mass',
                'SorianEdit T3 Engineer Assist Experimental Mobile Land - Excess Mass',
                'SorianEdit T3 Air Exp1 Engineer 1 - Excess Mass',
                'SorianEdit T3 Air Exp1 Engineer 1 - Small Map - Excess Mass',
                'SorianEdit T3 Engineer Assist Experimental Mobile Air - Excess Mass',
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Tele SCU Strategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Tele SCU Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = true
            local x,z = aiBrain:GetArmyStartPos()
            local faction = aiBrain:GetFactionIndex()
            local upgrades
            local removes
            LOG('*AI DEBUG: --------------  SorianEdit Tele SCU Strategy Activated by '..aiBrain.Nickname..'!')
            if faction == 2 then
                upgrades = {'StabilitySuppressant', 'Teleporter'}
            elseif faction == 4 then
                upgrades = {'Shield', 'Teleporter'}
            end
            local SCUs = {}
            local possSCUs = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.SUBCOMMANDER, {x,0,z}, 200)
            for k,v in possSCUs do
                table.insert(SCUs, v)
                if table.getn(SCUs) > 2 then
                    break
                end
            end
            for k,v in SCUs do
                if v.PlatoonHandle and aiBrain:PlatoonExists(v.PlatoonHandle) then
                    v.PlatoonHandle:RemoveEngineerCallbacksSorianEdit()
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
                if v:HasEnhancement('Overcharge') then
                    local order = {
                        TaskName = "EnhanceTask",
                        Enhancement = "OverchargeRemove"
                    }
                    IssueScript({v}, order)
                elseif v:HasEnhancement('ResourceAllocation') then
                    local order = {
                        TaskName = "EnhanceTask",
                        Enhancement = "ResourceAllocationRemove"
                    }
                    IssueScript({v}, order)
                end
            end
            local plat = aiBrain:MakePlatoon('', '')
            aiBrain:AssignUnitsToPlatoon(plat, SCUs, 'attack', 'None')
            for k,v in SCUs do
                for x,z in upgrades do
                    if not v:HasEnhancement(z) then
                        local order = {
                            TaskName = "EnhanceTask",
                            Enhancement = z
                        }
                        IssueScript({v}, order)
                    end
                end
            end
            local allDead
            local upgradesFinished
            repeat
                WaitSeconds(5)
                allDead = true
                upgradesFinished = true
                if not aiBrain:PlatoonExists(plat) then
                    Builders[self.BuilderName].Running = false
                    return
                end
                for k,v in plat:GetPlatoonUnits() do
                    if not v.Dead then
                        allDead = false
                    end
                    if not v:HasEnhancement(upgrades[2]) then
                        upgradesFinished = false
                    end
                end
            until allDead or upgradesFinished

            if allDead then return end

            local targetLocation = Behaviors.GetHighestThreatClusterLocationSorianEdit(aiBrain, plat)
            for k,v in SCUs do
                local telePos = AIUtils.RandomLocation(targetLocation[1],targetLocation[3])
                IssueTeleport({v}, telePos)
            end
            WaitSeconds(45)
            plat:HuntAISorianEdit()
            Builders[self.BuilderName].Running = false
        end,
        PriorityFunction = function(self, aiBrain)
            if Builders[self.BuilderName].Running then
                return 100
            end
            local enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            if Random(1,10) == 7 then
                returnval = 100
            end
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Tele SCU Strategy '..returnval)

            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { MIBC, 'FactionIndex', {2, 4}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, 'SUBCOMMANDER' }},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.3}},
            -- { EBC, 'GreaterThanEconIncome', {15, 1000}},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {}
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit Engy Drop Strategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Engy Drop Strategy',
        StrategyType = 'Intermediate',
        Priority = 0, --100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = true
            LOG('*AI DEBUG: --------------  Engy Drop Strategy Activated by '..aiBrain.Nickname..'!')
            local x,z = aiBrain:GetArmyStartPos()
            local count = 0
            repeat
                WaitSeconds(5)
                count = count + 1
                if count > 18 then
                    Builders[self.BuilderName].Running = false
                    Builders[self.BuilderName].Done = true
                    return
                end
                airfacs = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.AIR * categories.FACTORY, {x,0,z}, 150)
            until table.getn(airfacs) > 0
            local ex, ey = aiBrain:GetCurrentEnemy():GetArmyStartPos()
            local Engies = {}
            local possEngies = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.ENGINEER * categories.TECH1, {x,0,z}, 200)
            for k,v in possEngies do
                table.insert(Engies, v)
                if table.getn(Engies) > 3 then
                    break
                end
            end
            if table.getn(Engies) < 2 then
                Builders[self.BuilderName].Running = false
                Builders[self.BuilderName].Done = true
                return
            end
            for k,v in Engies do
                if v.PlatoonHandle and aiBrain:PlatoonExists(v.PlatoonHandle) then
                    v.PlatoonHandle:RemoveEngineerCallbacksSorianEdit()
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
            end
            local plat = aiBrain:MakePlatoon('', '')
            aiBrain:AssignUnitsToPlatoon(plat, Engies, 'support', 'None')
            for x=-60, 60, 60 do
                for y=-60, 60, 60 do
                    if not (x == 0 and y == 0) then
                        tempPos = {ex + x ,0, ey + y}
                        local nextbase = (table.getn(aiBrain.TacticalBases) + 1)
                        table.insert(aiBrain.TacticalBases,
                            {
                            Position = tempPos,
                            Name = 'TacticalBase'..nextbase,
                            }
                        )
                    end
                end
            end
            local targetPos = AIUtils.AIFindFirebaseLocationSorianEdit(aiBrain, 'Main', 75, 'Expansion Area', -1000, 99999, 1, 'AntiSurface', 1, 'STRATEGIC', 20)
            if not targetPos then
                Builders[self.BuilderName].Running = false
                Builders[self.BuilderName].Done = true
                return
            end
            local data = {
                Construction = {
                    BuildClose = false,
                    BaseTemplate = 'ExpansionBaseTemplates',
                    FireBase = true,
                    FireBaseRange = 75,
                    NearMarkerType = 'Expansion Area',
                    LocationType = 'MAIN',
                    ThreatMin = -1000,
                    ThreatMax = 99999,
                    ThreatRings = 1,
                    ThreatType = 'AntiSurface',
                    MarkerUnitCount = 1,
                    MarkerUnitCategory = 'STRATEGIC',
                    MarkerRadius = 20,
                    BuildStructures = {
                        'T1GroundDefense',
                        'T1GroundDefense',
                        'T1GroundDefense',
                        'T1GroundDefense',
                        'T1AADefense',
                        'T1GroundDefense',
                        'T1GroundDefense',
                        'T1GroundDefense',
                        'T1GroundDefense',
                    }
                }
            }
            plat:SetPlatoonData(data)
            local usedTransports = AIAttackUtils.SendPlatoonWithTransportsSorianEdit(aiBrain, plat, targetPos, true, true, true)
            if not usedTransports then
                Builders[self.BuilderName].Running = false
                Builders[self.BuilderName].Done = true
                return
            end
            plat:EngineerBuildAISorianEdit()
            Builders[self.BuilderName].Running = false
            Builders[self.BuilderName].Done = true
        end,
        PriorityFunction = function(self, aiBrain)
            if Builders[self.BuilderName].Running then
                return 100
            --elseif Builders[self.BuilderName].Done then
            --	return 0
            end
            local enemyIndex
            local returnval = 0
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            --if Random(1,100) == 100 then
                returnval = 100
            --end
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Engy Drop Strategy '..returnval)

            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'ENGINEER TECH1' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY' }},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            { SBC, 'MapLessThan', { 1000, 1000 }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1 Air Transport - GG',
            },
            EngineerManager = {
                'SorianEditAirFactoryHighPrio',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEdit PD Creep Strategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit PD Creep Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = true
            local x,z = aiBrain:GetArmyStartPos()
            local ex, ez = aiBrain:GetCurrentEnemy():GetArmyStartPos()
            local path, reason = AIAttackUtils.PlatoonGenerateSafePathTo(aiBrain, 'Land', {x,0,z}, {ex,0,ez}, 10)
            LOG('*AI DEBUG: --------------  SorianEditRushGunUpgrades Activated by '..aiBrain.Nickname..'!')
            if path then
                for pathnum,waypoint in path do
                    local nextbase = (table.getn(aiBrain.TacticalBases) + 1)
                    table.insert(aiBrain.TacticalBases,
                        {
                        Position = waypoint,
                        Name = 'PDCreep'..nextbase,
                        }
                    )
                end
            end
        end,
        PriorityFunction = function(self, aiBrain)
            if Builders[self.BuilderName].Running then
                return 100
            elseif Builders[self.BuilderName].Done then
                return 0
            end
            local enemyIndex
            local returnval = 0
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            if Random(1,15) == 3 then
                returnval = 100
            end

            Builders[self.BuilderName].Done = true
        -- startTime = GetGameTimeSeconds(),

        LOG('---------------------  PD Creep Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { SBC, 'MapLessThan', { 1000, 1000 }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T1 - High Prio Defensive Point Engineer',
                'SorianEdit T2 - High Prio Defensive Point Engineer UEF',
                'SorianEdit T2 - High Prio Defensive Point Engineer Cybran',
                'SorianEdit T2 - High Prio Defensive Point Engineer',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditWaterMapLowLand',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Water Map Low Land',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        BuilderConditions = {
            { SBC, 'IsIslandMap', { true } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            FactoryManager = {
                -- 'SorianEdit T1 Bot - Early Game Rush',
                -- 'SorianEdit T1 Bot - Early Game',
                -- 'SorianEdit T1 Light Tank - Tech 1',
                -- 'SorianEdit T1 Light Tank - Tech 2',
                -- 'SorianEdit T1 Light Tank - Tech 3',
                -- 'SorianEdit T1 Mortar',
                -- 'SorianEdit T1 Mortar - Not T1',
                -- 'SorianEdit T1 Mortar - tough def',
                -- 'SorianEdit T1 Mobile AA',
                -- 'SorianEdit T1 Mobile AA - Response',
                -- 'SorianEdit T1 Tank Enemy Nearby',
                -- 'SorianEdit T2 Tank - Tech 2',
                -- 'SorianEdit T2 Tank 2 - Tech 3',
                -- 'SorianEdit T2 MML',
                -- 'SorianEditT2LandAA',
                -- 'SorianEditT1ReactionDF',
                -- 'SorianEdit T2MobileShields - T3 Factories',
                -- 'SorianEdit T2AttackTank - Tech 2',
                -- 'SorianEdit T2AttackTank2 - Tech 3',
                -- 'SorianEdit T2MobileShields',
                -- 'SorianEdit T2 Tank Enemy Nearby',
                -- 'SorianEdit T2 Mobile Flak',
                -- 'SorianEdit T2 Mobile Flak Response',
                -- 'SorianEdit T3 Siege Assault Bot',
                -- 'SorianEdit T3 Mobile Heavy Artillery',
                -- 'SorianEdit T3 Mobile Heavy Artillery - tough def',
                -- 'SorianEdit T3 Mobile Flak',
                -- 'SorianEdit T3SniperBots',
                -- 'SorianEdit T3MobileMissile',
                -- 'SorianEdit T3MobileShields',
                -- 'SorianEdit T3 Mobile AA Response',
                -- 'SorianEdit T3 Assault Enemy Nearby',
                -- 'SorianEdit T3 SiegeBot Enemy Nearby',
            },
        },
        AddBuilders = {}
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditBigAirGroup',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Big Air Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditBigAirGroup Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end
            if not aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * categories.TECH3) > 1 then
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiAir', enemyIndex)
            local numEUnits = aiBrain:GetNumUnitsAroundPoint(categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, Vector(0,0,0), 100000, 'Enemy')

            returnval = (enemyThreat * 1.5) - numEUnits
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- BigAirGroup '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            -- { SBC, 'GreaterThanThreatAtEnemyBase', { 'AntiAir', 55 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY AIR TECH2' }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 15, categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, 'Enemy'}},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1Gunship',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
                -- 'SorianEdit T2 Air Gunship',
                -- 'SorianEdit T2 Air Gunship - Anti Navy',
                -- 'SorianEdit T2 Air Gunship - Stomp Enemy',
                -- 'SorianEdit T2FighterBomber',
                -- 'SorianEdit T2 Air Gunship2',
                -- 'SorianEdit T2FighterBomber2',
                -- 'SorianEdit T3 Air Gunship',
                -- 'SorianEdit T3 Air Gunship - Anti Navy',
                -- 'SorianEdit T3 Air Bomber',
                -- 'SorianEdit T3 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T3 Air Gunship2',
                -- 'SorianEdit T3 Air Bomber2',
            -- },
            -- PlatoonFormManager = {
                -- 'SorianEdit BomberAttackT1Frequent',
                -- 'SorianEdit BomberAttackT1Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT1Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT2Frequent',
                -- 'SorianEdit BomberAttackT2Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT2Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT3Frequent',
                -- 'SorianEdit BomberAttackT3Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT3Frequent - Anti-Resource',
                -- 'SorianEdit T1 Bomber Attack Weak Enemy Response',
                -- --'SorianEdit BomberAttack Mass Hunter',
            -- }
        },
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T2 Air Bomber - High Prio',
                'SorianEdit T3 Air Bomber Special - High Prio',
            },
            PlatoonFormManager = {
                'SorianEdit Bomber Attack - Big',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditJesterRush',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Jester Rush Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditJesterRush Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            local myFacs = aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR)

            if aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * (categories.TECH3 + categories.TECH2)) > 0 or myFacs < 1 then
                return returnval
            end

            local eUnits = aiBrain:GetUnitsAroundPoint(categories.AIR * categories.FACTORY, Vector(0,0,0), 100000, 'Enemy')
            local count = 0

            for k,v in eUnits do
                if v:GetAIBrain():GetArmyIndex() == enemyIndex then
                    count = count + 1
                end
            end

            returnval = 74 + (myFacs * 5) - (count * 4)
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Jester Rush Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { MIBC, 'FactionIndex', {3}},
            { SBC, 'MapLessThan', { 1000, 1000 }},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY AIR TECH3' }},
            { SBC, 'TargetHasLessThanUnitsWithCategory', { 3, categories.AIR * categories.FACTORY }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 10, categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, 'Enemy'}},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1Gunship',
                -- 'SorianEdit T1 Air Fighter',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
            -- },
            -- PlatoonFormManager = {
                -- 'SorianEdit GunshipAttackT1Frequent',
                -- 'SorianEdit T1 GunShip Attack Weak Enemy Response',
                -- 'SorianEdit Mass Hunter Gunships',
            -- }
        },
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1Gunship - High Prio',
            },
            PlatoonFormManager = {
                'SorianEdit GunShip Attack - Large',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditRushGunUpgrades',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Rush Gun Upgrades',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            Builders[self.BuilderName].Running = true
            LOG('*AI DEBUG: --------------  SorianEditRushGunUpgrades Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            if Builders[self.BuilderName].Running then
                return 100
            elseif Builders[self.BuilderName].Done then
                return 0
            end
            local returnval = 0

            if Random(1,10) > 5 then
                returnval = 100
            end

            Builders[self.BuilderName].Done = true
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Rush Gun Upgrades '..returnval)

            return returnval
        end,
        BuilderConditions = {
            { SBC, 'ClosestEnemyLessThan', { 750 } },
            { SBC, 'EnemyToAllyRatioLessOrEqual', { 1.0 } },
            { SBC, 'IsBadMap', { false } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            EngineerManager = {
                'SorianEdit UEF CDR Upgrade AdvEng - Pods',
                'SorianEdit UEF CDR Upgrade T3 Eng - Shields',
                'SorianEdit Aeon CDR Upgrade AdvEng - Resource - Crysalis',
                'SorianEdit Aeon CDR Upgrade T3 Eng - ResourceAdv - EnhSensor',
                'SorianEdit Cybran CDR Upgrade AdvEng - Laser Gen',
                'SorianEdit Cybran CDR Upgrade T3 Eng - Resource',
                'SorianEdit Seraphim CDR Upgrade AdvEng - Resource - Crysalis',
                'SorianEdit Seraphim CDR Upgrade T3 Eng - ResourceAdv - EnhSensor',
            },
        },
        AddBuilders = {
            EngineerManager = {
                'SorianEdit UEF CDR Upgrade - Rush - Gun',
                'SorianEdit UEF CDR Upgrade - Rush - Eng',
                'SorianEdit UEF CDR Upgrade - Rush - Shield',
                'SorianEdit Aeon CDR Upgrade - Rush - Gun',
                'SorianEdit Aeon CDR Upgrade - Rush - Eng',
                'SorianEdit Aeon CDR Upgrade T3 - Rush - Shield',
                'SorianEdit Cybran CDR Upgrade - Rush - Gun',
                'SorianEdit Cybran CDR Upgrade - Rush - Eng',
                'SorianEdit Cybran CDR Upgrade - Rush - Laser',
                'SorianEdit Seraphim CDR Upgrade - Rush - Gun',
                'SorianEdit Seraphim CDR Upgrade - Rush - Eng',
                'SorianEdit Seraphim CDR Upgrade - Rush - Regen',
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditGhettoGunship',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Ghetto Gunship Strategy',
        StrategyType = 'Intermediate',
        Priority = 0, --100,
        InstanceCount = 1,
        StrategyTime = 300,
        InterruptStrategy = true,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditGhettoGunship Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            local myFacs = aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR)

            if aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * (categories.TECH3 + categories.TECH2)) > 0 or myFacs < 1 then
                return returnval
            end

            local eUnits = aiBrain:GetUnitsAroundPoint(categories.AIR * categories.FACTORY, Vector(0,0,0), 100000, 'Enemy')
            local count = 0

            for k,v in eUnits do
                if v:GetAIBrain():GetArmyIndex() == enemyIndex then
                    count = count + 1
                end
            end

            returnval = 69 + (myFacs * 5) - (count * 2)
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Ghetto Gunship Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { MIBC, 'FactionIndex', {1, 2, 3}},
            { SBC, 'MapLessThan', { 1000, 1000 }},
            -- { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'FACTORY AIR' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY AIR TECH3' }},
            { SBC, 'TargetHasLessThanUnitsWithCategory', { 3, categories.AIR * categories.FACTORY }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 10, categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, 'Enemy'}},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1 Air Transport - GG',
                'SorianEdit T1 Bot - GG',
            },
            PlatoonFormManager = {
                'SorianEdit GG Force',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditSmallMapRush',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Small Map Rush Strategy',
        StrategyType = 'Overall',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditSmallMapRush Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local returnval = 1
            local enemies = 0
            local allies = 0
            for k,v in ArmyBrains do
                if not v.Result == "defeat" and not ArmyIsCivilian(v:GetArmyIndex()) and IsEnemy(v:GetArmyIndex(), aiBrain:GetArmyIndex()) then
                    enemies = enemies + 1
                elseif not v.Result == "defeat" and not ArmyIsCivilian(v:GetArmyIndex()) and IsAlly(v:GetArmyIndex(), aiBrain:GetArmyIndex()) then
                    allies = allies + 1
                end
            end

            local ratio = allies / enemies

            local gtime = GetGameTimeSeconds()

            returnval = 75 + (ratio * 5) - (gtime * .004)
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  Small Map Rush Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            { SBC, 'IsIslandMap', { false } },
            { SBC, 'ClosestEnemyLessThan', { 750 } },
            -- { SBC, 'NoRushTimeCheck', { 0 }},
            -- { SBC, 'EnemyToAllyRatioLessOrEqual', { 1 } },
            { SBC, 'LessThanGameTime', { 420 } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- EngineerManager = {
                -- 'SorianEdit T1VacantStartingAreaEngineer - Rush',
                -- 'SorianEdit T1VacantStartingAreaEngineer',
                -- 'SorianEdit T1 Vacant Expansion Area EngineerFull Base',
            -- },
        },
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T1VacantStartingAreaEngineer - HP Strategy',
                'SorianEdit T1VacantStartingAreaEngineer Strategy',
                'SorianEdit T1 Vacant Expansion Area EngineerFull Base - Strategy',
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT3FBRush',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit T3 FB Rush Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditT3FBRush Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local returnval = 1
            --If activated by an ally
            if aiBrain.Focus == 'rush arty' then
                return 100
            end
            local arties = aiBrain:GetCurrentUnits(categories.ARTILLERY * categories.STRUCTURE * categories.TECH3)

            local eUnits = aiBrain:GetNumUnitsAroundPoint(categories.SHIELD * categories.STRUCTURE * categories.TECH3, Vector(0,0,0), 100000, 'Enemy')

            if arties - eUnits >= 3 then
                return returnval
            end

            returnval = 70 + (arties * 5) - (eUnits * 5)
        -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  T3 FB Rush Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'ENGINEER TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'ARTILLERY STRUCTURE TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 6, categories.SHIELD * categories.TECH3 * categories.STRUCTURE, 'Enemy'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            -- { EBC, 'GreaterThanEconIncome',  { 100, 3000}},
            -- CanBuildFirebase { 1000, 1000 }},
            { SBC, 'EnemyInT3ArtilleryRange', { 'LocationType', false } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - UEF - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - UEF - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - DP - HP',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEnemyTurtle - In Range',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEditEnemyTurtle - In Range',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditEnemyTurtle - In Range Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            --local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiSurface', enemyIndex)
            local enemyThreat = SUtils.GetThreatAtPosition(aiBrain, {StartX, 0, StartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex)

            --If enemy base has more than 1750 anti-surface threat
            --T2 Arty, T1 PD, T2 PD, Bots, Tanks, Mobile Arty, Gunships, Bombers, ACU, SCUs.
            returnval = enemyThreat * 0.0429
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- EnemyTurtle - In Range '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { SBC, 'EnemyInT3ArtilleryRange', { 'LocationType', true } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- PlatoonFormManager = {
                -- 'SorianEdit Frequent Land Attack T1',
                -- 'SorianEdit Frequent Land Attack T2',
                -- 'SorianEdit Start Location Attack',
                -- 'SorianEdit Early Attacks Small',
                -- 'SorianEdit Early Attacks Medium',
                -- 'SorianEdit T2/T3 Land Weak Enemy Response',
                -- 'SorianEdit T1 Land Weak Enemy Response',
                -- 'SorianEdit T1 Hunters',
                -- 'SorianEdit T2 Hunters',
            -- }
        },
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T3 Arty Engineer - High Prio',
                'SorianEdit T3 Engineer Assist Build Arty - High Prio',
                'SorianEdit T3 Nuke Engineer - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke Missile - High Prio',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditEnemyTurtle - Out of Range',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEditEnemyTurtle - Out of Range',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditEnemyTurtle - Out of Range Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            --local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiSurface', enemyIndex)
            local enemyThreat = SUtils.GetThreatAtPosition(aiBrain, {StartX, 0, StartZ}, 1, 'AntiSurface', {'Commander', 'Air', 'Experimental'}, enemyIndex)

            --If enemy base has more than 1750 anti-surface threat
            --T2 Arty, T1 PD, T2 PD, Bots, Tanks, Mobile Arty, Gunships, Bombers, ACU, SCUs.
            returnval = enemyThreat * 0.0429
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- EnemyTurtle - Out of Range '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { SBC, 'EnemyInT3ArtilleryRange', { 'LocationType', false } },
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- PlatoonFormManager = {
                -- 'SorianEdit Frequent Land Attack T1',
                -- 'SorianEdit Frequent Land Attack T2',
                -- 'SorianEdit Start Location Attack',
                -- 'SorianEdit Early Attacks Small',
                -- 'SorianEdit Early Attacks Medium',
                -- 'SorianEdit T2/T3 Land Weak Enemy Response',
                -- 'SorianEdit T1 Land Weak Enemy Response',
                -- 'SorianEdit T1 Hunters',
                -- 'SorianEdit T2 Hunters',
            -- }
        },
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - UEF - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Cybran - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Aeon - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - UEF - DP - HP',
                'SorianEdit T3 Expansion Area Firebase Engineer - Seraphim - DP - HP',
                'SorianEdit T3 Nuke Engineer - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke Missile - High Prio',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditNukeRush',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Nuke Rush Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditNukeRush Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local returnval = 1
            --If activated by an ally
            if aiBrain.Focus == 'rush nuke' then
                return 100
            end
            local antis = 0
            local nukes = aiBrain:GetCurrentUnits(categories.NUKE * categories.SILO * categories.STRUCTURE * categories.TECH3)

            for k,v in ArmyBrains do
                local eStartX, eStartZ = v:GetArmyStartPos()
                local eUnits = aiBrain:GetNumUnitsAroundPoint(categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, {eStartX, 0, eStartZ}, 250, 'Enemy')
                if eUnits > antis then
                    antis = eUnits
                end
            end

            if nukes - antis >= 3 then
                return returnval
            end

            returnval = 70 + (nukes * 5) - (antis * 10)
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- NukeRush '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'ENGINEER TECH3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'NUKE SILO STRUCTURE TECH3' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 1, categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, 'Enemy'}},
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 1.35, 1.35}},
            --CanBuildFirebase { 500, 500 }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T3 Nuke Engineer - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke - High Prio',
                'SorianEdit T3 Engineer Assist Build Nuke Missile - High Prio',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditStopNukes',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Stop Nukes Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditStopNukes Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local antis = 99999
            local returnval = 1

            local nukes = aiBrain:GetCurrentUnits(categories.NUKE * categories.SILO * categories.STRUCTURE * categories.TECH3)

            for k,v in ArmyBrains do
                local eStartX, eStartZ = v:GetArmyStartPos()
                local eUnits = aiBrain:GetNumUnitsAroundPoint(categories.ANTIMISSILE * categories.TECH3 * categories.STRUCTURE, {eStartX, 0, eStartZ}, 250, 'Enemy')
                if eUnits < antis then
                    antis = eUnits
                end
            end

            returnval = (antis - nukes) * 20
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- StopNukes '..returnval)
            return returnval
        end,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'ENGINEER TECH3' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- EngineerManager = {
                -- 'SorianEdit T3 Nuke Engineer',
                -- 'SorianEdit T3 Nuke Engineer - 10x10',
            -- }
        },
        AddBuilders = {}
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditT2ACUSnipe',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit T2 ACU Snipe Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditT2ACUSnipe Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemyIndex
            local returnval = 1
            if aiBrain:GetCurrentEnemy() then
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end

            local eUnits = aiBrain:GetUnitsAroundPoint(categories.ANTIMISSILE * categories.TECH2 * categories.STRUCTURE, Vector(0,0,0), 100000, 'Enemy')

            local count = 0

            for k,v in eUnits do
                if v:GetAIBrain():GetArmyIndex() == enemyIndex then
                    count = count + 1
                end
            end

            returnval = 100 - (count * 6)
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- T2ACUSnipe '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'ENGINEER TECH2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON } },
            -- { SBC, 'TargetHasLessThanUnitsWithCategory', { 6, categories.ANTIMISSILE * categories.TECH2 * categories.STRUCTURE }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 10, categories.ANTIMISSILE * categories.TECH2 * categories.STRUCTURE, 'Enemy'}},
            -- { MABC, 'CanBuildFirebase', { 'LocationType', 256, 'Expansion Area', -1000, 5, 1, 'AntiSurface', 1, 'STRATEGIC', 20} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.3 } },
			{ EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
			{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.25 }},
            ----CanBuildFirebase { 500, 500 }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {},
        AddBuilders = {
            EngineerManager = {
                'SorianEdit T2 Firebase Engineer - High Prio',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditHeavyAirStrategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit T1 Heavy Air Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditHeavyAirStrategy Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            --If activated by an ally
            if aiBrain.Focus == 'air' then
                return 100
            end
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end
            if aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * (categories.TECH2 + categories.TECH3)) > 0 then
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiAir', enemyIndex)
            local numEUnits = aiBrain:GetNumUnitsAroundPoint(categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, Vector(0,0,0), 100000, 'Enemy')

            returnval = 90 - enemyThreat - numEUnits
        -- startTime = GetGameTimeSeconds(),
        LOG('--------------------- HeavyAirStrategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'LessThanThreatAtEnemyBase', { 'AntiAir', 150 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY AIR TECH3' }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 15, categories.MOBILE * categories.ANTIAIR - categories.BOMBER, 'Enemy'}},
            -- { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY AIR TECH2, FACTORY AIR TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR TECH1' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
                -- 'SorianEdit T2 Air Gunship',
                -- 'SorianEdit T2 Air Gunship - Anti Navy',
                -- 'SorianEdit T2 Air Gunship - Stomp Enemy',
                -- 'SorianEdit T2FighterBomber',
            -- },
            -- PlatoonFormManager = {
                -- 'SorianEdit BomberAttackT1Frequent',
                -- 'SorianEdit BomberAttackT1Frequent - Anti-Land',
                -- 'SorianEdit T1Gunship',
                -- --'SorianEdit BomberAttackT1Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT2Frequent',
                -- 'SorianEdit BomberAttackT2Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT2Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT3Frequent',
                -- 'SorianEdit BomberAttackT3Frequent - Anti-Land',
                -- 'SorianEdit T3 Air Bomber',
                -- 'SorianEdit T3 Air Gunship',
                -- --'SorianEdit BomberAttackT3Frequent - Anti-Resource',
                -- 'SorianEdit T1 Bomber Attack Weak Enemy Response',
                -- --'SorianEdit BomberAttack Mass Hunter',
            -- }
        },
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1 Air Bomber - High Prio',
                'SorianEdit T2 Air Bomber - High Prio',
                'SorianEdit T3 Air Bomber - High Prio',
            },
            PlatoonFormManager = {
                'SorianEdit Bomber Attack - Large T1',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T2 Heavy Air Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEdit T2 Heavy Air Strategy Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            --If activated by an ally
            if aiBrain.Focus == 'air' then
                return 100
            end
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end
            if aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * categories.TECH3) > 0 or
            aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * categories.TECH2) < 1 then
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiAir', enemyIndex)
            local numEUnits = aiBrain:GetNumUnitsAroundPoint(categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, Vector(0,0,0), 100000, 'Enemy')

            returnval = 90 - (enemyThreat * 0.5) - numEUnits
                -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  T2 Heavy Air Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'LessThanThreatAtEnemyBase', { 'AntiAir', 19 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, 'FACTORY AIR TECH3' }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 15, categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, 'Enemy'}},
            { UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY AIR TECH3' }},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR TECH2' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1Gunship',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
                -- 'SorianEdit T2 Air Gunship',
                -- 'SorianEdit T2 Air Gunship - Anti Navy',
                -- 'SorianEdit T2 Air Gunship - Stomp Enemy',
            -- },
            -- PlatoonFormManager = {
                -- 'SorianEdit BomberAttackT1Frequent',
                -- 'SorianEdit BomberAttackT1Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT1Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT2Frequent',
                -- 'SorianEdit BomberAttackT2Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT2Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT3Frequent',
                -- 'SorianEdit BomberAttackT3Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT3Frequent - Anti-Resource',
                -- 'SorianEdit T2/T3 Bomber Attack Weak Enemy Response',
                -- --'SorianEdit BomberAttack Mass Hunter',
            -- }
        },
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1 Air Bomber - High Prio',
                'SorianEdit T2 Air Bomber - High Prio',
                'SorianEdit T3 Air Bomber - High Prio',
            },
            PlatoonFormManager = {
                'SorianEdit Bomber Attack - Large',
            }
        }
    },
    Builder {
        BuilderName = 'SorianEdit T3 Heavy Air Strategy',
        StrategyType = 'Intermediate',
        Priority = 100,
        InstanceCount = 1,
        StrategyTime = 300,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEdit T3 Heavy Air Strategy Activated by '..aiBrain.Nickname..'!')
        end,
        PriorityFunction = function(self, aiBrain)
            local enemy, enemyIndex
            local returnval = 1
            --If activated by an ally
            if aiBrain.Focus == 'air' then
                return 100
            end
            if aiBrain:GetCurrentEnemy() then
                enemy = aiBrain:GetCurrentEnemy()
                enemyIndex = aiBrain:GetCurrentEnemy():GetArmyIndex()
            else
                return returnval
            end
            if aiBrain:GetCurrentUnits(categories.FACTORY * categories.AIR * categories.TECH3) < 1 then
                return returnval
            end

            local StartX, StartZ = enemy:GetArmyStartPos()

            local enemyThreat = aiBrain:GetThreatAtPosition({StartX, 0, StartZ}, 1, true, 'AntiAir', enemyIndex)
            local numEUnits = aiBrain:GetNumUnitsAroundPoint(categories.MOBILE * categories.AIR * categories.ANTIAIR - categories.BOMBER, Vector(0,0,0), 100000, 'Enemy')

            returnval = 90 - (enemyThreat * 0.15) - numEUnits
                -- startTime = GetGameTimeSeconds(),
        LOG('---------------------  T3 Heavy Air Strategy '..returnval)
            return returnval
        end,
        BuilderConditions = {
            -- { SBC, 'LessThanThreatAtEnemyBase', { 'AntiAir', 55 }},
            -- { SBC, 'NoRushTimeCheck', { 600 }},
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { false, 15, categories.MOBILE * categories.AIR * categories.ANTIAIR * categories.TECH3 - categories.BOMBER, 'Enemy'}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR TECH3' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1Gunship',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
                -- 'SorianEdit T2 Air Gunship',
                -- 'SorianEdit T2 Air Gunship - Anti Navy',
                -- 'SorianEdit T2 Air Gunship - Stomp Enemy',
            -- },
            -- PlatoonFormManager = {
                -- 'SorianEdit BomberAttackT1Frequent',
                -- 'SorianEdit BomberAttackT1Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT1Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT2Frequent',
                -- 'SorianEdit BomberAttackT2Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT2Frequent - Anti-Resource',
                -- 'SorianEdit BomberAttackT3Frequent',
                -- 'SorianEdit BomberAttackT3Frequent - Anti-Land',
                -- --'SorianEdit BomberAttackT3Frequent - Anti-Resource',
                -- 'SorianEdit T2/T3 Bomber Attack Weak Enemy Response',
                -- --'SorianEdit BomberAttack Mass Hunter',
            -- }
        },
        AddBuilders = {
            FactoryManager = {
                'SorianEdit T1 Air Bomber - High Prio',
                'SorianEdit T2 Air Bomber - High Prio',
                'SorianEdit T3 Air Bomber - High Prio',
            },
            PlatoonFormManager = {
                'SorianEdit Bomber Attack - Large',
            }
        }
    },
}

--[[ BuilderGroup {
    BuilderGroupName = 'SorianEditParagonStrategy',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Paragon Strategy',
        StrategyType = 'Overall',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditParagonStrategy Activated by '..aiBrain.Nickname..'!')
        end,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION EXPERIMENTAL STRUCTURE' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            PlatoonFormManager = {
                'T1 Mass Extractor Upgrade Storage Based',
                'SorianEdit T1 Mass Extractor Upgrade Timeless Single',
                'SorianEdit T1 Mass Extractor Upgrade Timeless Two',
                'SorianEdit T1 Mass Extractor Upgrade Timeless LOTS',
                'SorianEdit T2 Mass Extractor Upgrade Timeless',
                'SorianEdit T2 Mass Extractor Upgrade Timeless Multiple',
                'SorianEdit Balanced T1 Land Factory Upgrade Initial',
                'SorianEdit BalancedT1AirFactoryUpgrade Initial',
                'SorianEdit Balanced T1 Land Factory Upgrade',
                'SorianEdit BalancedT1AirFactoryUpgrade',
                'SorianEdit Balanced T1 Sea Factory Upgrade',
                'SorianEdit Balanced T1 Land Factory Upgrade - T3',
                'SorianEdit BalancedT1AirFactoryUpgrade - T3',
                'SorianEdit Balanced T2 Land Factory Upgrade - initial',
                'SorianEdit Balanced T2 Air Factory Upgrade - initial',
                'SorianEdit Balanced T2 Land Factory Upgrade',
                'SorianEdit Balanced T2 Air Factory Upgrade',
                'SorianEdit Balanced T2 Sea Factory Upgrade',
                'SorianEdit Naval T1 Land Factory Upgrade Initial',
                'SorianEdit Naval T1 Air Factory Upgrade Initial',
                'SorianEdit Naval T1 Naval Factory Upgrade Initial',
                'SorianEdit Naval T1 Land Factory Upgrade',
                'SorianEdit Naval T1 AirFactory Upgrade',
                'SorianEdit Naval T1 Sea Factory Upgrade',
                'SorianEdit Naval T1 Land Factory Upgrade - T3',
                'SorianEdit Naval T1AirFactoryUpgrade - T3',
                'SorianEdit Naval T2 Land Factory Upgrade',
                'SorianEdit Naval T2 Air Factory Upgrade',
                'SorianEdit Naval T2 Sea Factory Upgrade',
            },
        },
        AddBuilders = {
            PlatoonFormManager = {
                'SorianEdit T1 Mass Extractor Upgrade Timeless Strategy',
                'SorianEdit T2 Mass Extractor Upgrade Timeless Strategy',
                'SorianEdit Balanced T1 Land Factory Upgrade Expansion Strategy',
                'SorianEdit BalancedT1AirFactoryUpgrade Expansion Strategy',
                'SorianEdit Balanced T1 Sea Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Land Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Air Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Sea Factory Upgrade Expansion Strategy',
            },
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianEditParagonStrategyExp',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit Paragon Strategy Expansion',
        StrategyType = 'Overall',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditParagonStrategyExp Activated by '..aiBrain.Nickname..'!')
        end,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'ENERGYPRODUCTION EXPERIMENTAL STRUCTURE' }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            PlatoonFormManager = {
                'SorianEdit Balanced T1 Land Factory Upgrade Expansion',
                'SorianEdit BalancedT1AirFactoryUpgrade Expansion',
                'SorianEdit Balanced T1 Sea Factory Upgrade Expansion',
                'SorianEdit Balanced T2 Land Factory Upgrade Expansion',
                'SorianEdit Balanced T2 Air Factory Upgrade Expansion',
                'SorianEdit Balanced T2 Sea Factory Upgrade Expansion',
                'SorianEdit Naval T1 Land Factory Upgrade Initial',
                'SorianEdit Naval T1 Air Factory Upgrade Initial',
                'SorianEdit Naval T1 Naval Factory Upgrade Initial',
                'SorianEdit Naval T1 Land Factory Upgrade',
                'SorianEdit Naval T1 AirFactory Upgrade',
                'SorianEdit Naval T1 Sea Factory Upgrade',
                'SorianEdit Naval T1 Land Factory Upgrade - T3',
                'SorianEdit Naval T1AirFactoryUpgrade - T3',
                'SorianEdit Naval T2 Land Factory Upgrade',
                'SorianEdit Naval T2 Air Factory Upgrade',
                'SorianEdit Naval T2 Sea Factory Upgrade',
            },
        },
        AddBuilders = {
            PlatoonFormManager = {
                'SorianEdit Balanced T1 Land Factory Upgrade Expansion Strategy',
                'SorianEdit BalancedT1AirFactoryUpgrade Expansion Strategy',
                'SorianEdit Balanced T1 Sea Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Land Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Air Factory Upgrade Expansion Strategy',
                'SorianEdit Balanced T2 Sea Factory Upgrade Expansion Strategy',
            },
        }
    },
} ]]--

BuilderGroup {
    BuilderGroupName = 'SorianEditTeamLevelAdjustment',
    BuildersType = 'StrategyBuilder',
    Builder {
        BuilderName = 'SorianEdit AI Outnumbered',
        StrategyType = 'Overall',
        Priority = 100,
        InstanceCount = 1,
        OnStrategyActivate = function(self, aiBrain)
            LOG('*AI DEBUG: --------------  SorianEditTeamLevelAdjustment Activated by '..aiBrain.Nickname..'!')
        end,
        BuilderConditions = {
            --CanBuildFirebase { 1000, 1000 }},
            { SBC, 'AIOutnumbered', { true }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- FactoryManager = {
                -- 'SorianEdit T1 Air Bomber',
                -- 'SorianEdit T1 Air Bomber - Stomp Enemy',
                -- 'SorianEdit T1Gunship',
                -- 'SorianEdit T1 Air Fighter',
                -- 'SorianEdit T1 Air Bomber 2',
                -- 'SorianEdit T1Gunship2',
                -- 'SorianEdit T1 Bot - Early Game Rush',
                -- 'SorianEdit T1 Bot - Early Game',
                -- 'SorianEdit T1 Light Tank - Tech 1',
                -- 'SorianEdit T1 Mortar',
                -- 'SorianEdit T1 Mortar - tough def',
            -- },
            -- StrategyManager = {
                -- 'SorianEdit T1 Heavy Air Strategy',
                -- 'SorianEdit Jester Rush Strategy',
            -- }
        },
        AddBuilders = {}
    },
    Builder {
        BuilderName = 'SorianEdit AI Outnumbers Enemies',
        StrategyType = 'Overall',
        Priority = 100,
        InstanceCount = 1,
        BuilderConditions = {
            --CanBuildFirebase { 1000, 1000 }},
            { SBC, 'AIOutnumbered', { false }},
        },
        BuilderType = 'Any',
        RemoveBuilders = {
            -- EngineerManager = {
                -- 'SorianEdit T1 Mass Adjacency Defense Engineer',
                -- 'SorianEdit T1 Base D Engineer - Perimeter',
                -- 'SorianEdit T1 Defensive Point Engineer',
            -- }
        },
        AddBuilders = {}
    },
}
	do
	LOG('--------------------- SorianEdit Strategy Builders loaded')
	end
