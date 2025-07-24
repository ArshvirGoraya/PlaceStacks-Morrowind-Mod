local M = {}
local previousFramePress = false

M.detectTakeStacksPress = function(psd)
	local detected = false
	local currentFramePress = Input.getBooleanActionValue("TakeStacksKey")
	if DetectorHelpers.detectPress(previousFramePress, currentFramePress) then
		psd.stopDetectingPlaceStacksHold()
		detected = true
	end
	previousFramePress = currentFramePress
	return detected
end

return M
