local SEUnitClass = Unit

local Buff = import('/lua/sim/Buff.lua')

do

BuffBlueprint {
	Name = 'MoveBuff',
	DisplayName = 'MoveBuff',
	BuffType = 'MoveBuff',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		MoveMult = {
			Add = 0,
			Mult = 1.2,
		},
	},
}

BuffBlueprint {
	Name = 'MoveBuff2',
	DisplayName = 'MoveBuff2',
	BuffType = 'MoveBuff2',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		MoveMult = {
			Add = 0,
			Mult = 1.4,
		},
	},
}

BuffBlueprint {
	Name = 'MoveBuff3',
	DisplayName = 'MoveBuff3',
	BuffType = 'MoveBuff3',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		MoveMult = {
			Add = 0,
			Mult = 1.6,
		},
	},
}

BuffBlueprint {
	Name = 'MoveBuffAir',
	DisplayName = 'MoveBuffAir',
	BuffType = 'MoveBuffAir',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		MoveMult = {
			Add = 0,
			Mult = 1.2,
		},
	},
}

BuffBlueprint {
	Name = 'VisBuff',
	DisplayName = 'VisBuff',
	BuffType = 'VisBuff',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		VisionRadius = {
			Add = 20,
			Mult = 1,
		},
	},
}

BuffBlueprint {
	Name = 'VisBuff2',
	DisplayName = 'VisBuff2',
	BuffType = 'VisBuff2',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		VisionRadius = {
			Add = 20,
			Mult = 1.2,
		},
	},
}

BuffBlueprint {
	Name = 'VisBuff3',
	DisplayName = 'VisBuff3',
	BuffType = 'VisBuff3',
	Stacks = 'ALWAYS',
	Duration = -1,
	Affects = {
		VisionRadius = {
			Add = 20,
			Mult = 1.4,
		},
	},
}

BuffBlueprint {
    Name = 'SECheatBuildRate',
    DisplayName = 'SECheatBuildRate',
    BuffType = 'SECheatBuildRateBuff',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 1.1,
        },
    },
}

BuffBlueprint {
    Name = 'SECheatBuildRate2',
    DisplayName = 'SECheatBuildRate2',
    BuffType = 'SECheatBuildRateBuff2',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 1.2,
        },
    },
}

BuffBlueprint {
    Name = 'SECheatBuildRate3',
    DisplayName = 'SECheatBuildRate3',
    BuffType = 'SECheatBuildRateBuff3',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 1.3,
        },
    },
}

BuffBlueprint {
    Name = 'FactoryAssistReplace',
    DisplayName = 'FactoryAssistReplace',
    BuffType = 'FactoryAssistReplace',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 1.25,
        },
    },
}

BuffBlueprint {
    Name = 'SECheatIncome',
    DisplayName = 'SECheatIncome',
    BuffType = 'SECheatIncomeBuff',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        EnergyProduction = {
            Add = 0,
            Mult = 1.2,
        },
        MassProduction = {
            Add = 0,
            Mult = 1.2,
        },
    },
}

BuffBlueprint {
    Name = 'SEIntelCheat',
    DisplayName = 'SEIntelCheat',
    BuffType = 'SEIntelCheatBuff',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        VisionRadius = {
            Add = 200,
            Mult = 1.0,
        },
        RadarRadius = {
            Add = 400,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'SEIntelCheat2',
    DisplayName = 'SEIntelCheat2',
    BuffType = 'SEIntelCheat2Buff',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        VisionRadius = {
            Add = 300,
            Mult = 1.0,
        },
        RadarRadius = {
            Add = 400,
            Mult = 1.0,
        },
        OmniRadius = {
            Add = 400,
            Mult = 1.0,
        },
    },
}
end

Unit = Class(SEUnitClass) {

    OnStopBeingBuilt = function(self,builder,layer, ...)
		SEUnitClass.OnStopBeingBuilt(self,builder,layer, unpack(arg))
		local bp = self:GetBlueprint()
        local aiBrain = self:GetAIBrain()
		local Buff = import('/lua/sim/Buff.lua')
		
		-- -- local factionIdx = aiBrain:GetFactionIndex()
		-- if aiBrain.sorianeditadaptivecheat or aiBrain.sorianeditadaptive or aiBrain.sorianedit then
			-- -- for _, unit in aiBrain:GetListOfUnits(categories.COMMAND, false) do
			-- if EntityCategoryContains(categories.COMMAND, self) then
				-- if EntityCategoryContains(categories.AEON, self) then
				-- self:CreateEnhancement(CrysalisBeam)
				-- self:CreateEnhancement(HeatSink)
				-- elseif EntityCategoryContains(categories.CYBRAN, self) then
				-- self:CreateEnhancement(CoolingUpgrade)
				-- elseif EntityCategoryContains(categories.UEF, self) then
				-- self:CreateEnhancement(DamageStabilization)
				-- self:CreateEnhancement(HeavyAntiMatterCannon)
				-- elseif EntityCategoryContains(categories.SERAPHIM, self) then
				-- self:CreateEnhancement(BlastAttack)
				-- self:CreateEnhancement(RateOfFire)
				-- elseif EntityCategoryContains(categories.NOMADS, self) then
				-- self:CreateEnhancement(GunUpgrade)
				-- self:CreateEnhancement(DoubleGuns)
				-- self:CreateEnhancement(MovementSpeedIncrease)
				-- end
			-- end
		-- end
		
		if aiBrain.sorianeditadaptivecheat or aiBrain.sorianeditadaptive or aiBrain.sorianedit then
		
			if not self:GetBlueprint().Intel.RadarRadius >= '1' then
				Buff.ApplyBuff(self, 'SEIntelCheat')
			end
			
			if not self:GetBlueprint().Intel.OmniRadius >= '1' then
				Buff.ApplyBuff(self, 'SEIntelCheat2')
			end
			
			if self:GetBlueprint().Physics.MotionType == 'RULEUMT_Air' then
				Buff.ApplyBuff(self, 'MoveBuffAir')
			end
			
			-- if self:GetBlueprint().General.Category == 'FACTORY' then
				-- Buff.ApplyBuff(self, 'FactoryAssistReplace')
			-- end
			
			local mapSizeX, mapSizeZ = GetMapSize()
			if mapSizeX < 514 or mapSizeZ < 514 then
				-- LOG('------------AI DEBUG: Map is 10km or smaller ')
				if not self:GetBlueprint().Physics.MotionType == ( 'RULEUMT_None' or 'RULEUMT_Air' ) then
					Buff.ApplyBuff(self, 'MoveBuff')
				end
				Buff.ApplyBuff(self, 'VisBuff')
			elseif mapSizeX < (514 * 2) or mapSizeZ < (514 * 2) then
				-- LOG('------------AI DEBUG: Map is 20km')
				if not self:GetBlueprint().Physics.MotionType == ( 'RULEUMT_None' and 'RULEUMT_Air' ) then
					Buff.ApplyBuff(self, 'MoveBuff2')
				end
				Buff.ApplyBuff(self, 'SECheatBuildRate2')
				Buff.ApplyBuff(self, 'VisBuff2')
				Buff.ApplyBuff(self, 'SECheatIncome')
			else
				-- LOG('------------AI DEBUG: Map is 40km or higher')
				if not self:GetBlueprint().Physics.MotionType == ( 'RULEUMT_None' and 'RULEUMT_Air' ) then
					Buff.ApplyBuff(self, 'MoveBuff3')
				end
				Buff.ApplyBuff(self, 'SECheatBuildRate3')
				Buff.ApplyBuff(self, 'VisBuff3')
				Buff.ApplyBuff(self, 'SECheatIncome')
			end
			
        end
    end,

    OnStopBeingCaptured = function(self, captor)
        SEUnitClass.OnStopBeingCaptured(self, captor)
        local aiBrain = self:GetAIBrain()
		if aiBrain.sorianeditadaptivecheat or aiBrain.sorianeditadaptive or aiBrain.sorianedit then
            self:Kill()
        end
    end,
	
	
}