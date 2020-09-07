local SEUnitClass = Unit
Unit = Class(SEUnitClass) {
    OnStopBeingCaptured = function(self, captor)
        SEUnitClass.OnStopBeingCaptured(self, captor)
        local aiBrain = self:GetAIBrain()
		if aiBrain.sorianeditadaptivecheat or aiBrain.sorianeditadaptive or aiBrain.sorianedit then
            self:Kill()
        end
    end,
	
}