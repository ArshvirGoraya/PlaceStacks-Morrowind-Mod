local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")

local M = {}
local previousFramePress = false

M.detectTakeStacksPress = function(input, psd, DB)
	local detected = false
	local currentFramePress = input.getBooleanActionValue("TakeStacksKey")
	if helpers.detectPress(previousFramePress, currentFramePress) then
		psd.stopDetectingPlaceStacksHold()
		detected = true
	end
	previousFramePress = currentFramePress
	return detected
end

return M
