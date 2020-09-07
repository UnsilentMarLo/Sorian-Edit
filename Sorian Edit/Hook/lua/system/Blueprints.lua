-- Copyright 2007 Gas Powered Games - All rights reserved
--
-- Author: Matt Mahon
--
-- Description:
--    Sample Mod to double economic output of econ units.
--


--this function is called already in game. This gives us a hook to screw the
--blueprint values for the units

do
    local oldModBlueprints = ModBlueprints

    function ModBlueprints(all_bps)
	    oldModBlueprints(all_bps)

        local CCdef = 0.5


        --loop through the blueprints and adjust as desired.
        for id,bp in all_bps.Unit do
            if bp.General.CapCost then
               bp.General.CapCost = bp.General.CapCost * CCdef
            else bp.General.CapCost = CCdef
            end
        end
    end
end