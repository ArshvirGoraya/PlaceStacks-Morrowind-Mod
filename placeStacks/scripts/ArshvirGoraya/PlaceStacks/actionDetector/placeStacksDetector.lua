local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")

local M = {}

-- Local Variables
local holdTime = 0
local detectingPlaceStacksHold = false
local previousFramePress = false

-- Local Functions

local getCalculatedHoldTime = function(core, settingsHoldMS)
	return core.getRealTime() + settingsHoldMS / 1000 -- convert ms to seconds
end

M.stopDetectingPlaceStacksHold = function()
	detectingPlaceStacksHold = false
end

local shouldCancelPlaceStacksHoldDetection = function(input, I)
	if not input.isActionPressed(input.ACTION.Activate) then
		return true
	end
	if I.UI.getMode() ~= "Container" then
		return true
	end

	return false
end

M.detectPlaceStacksPress = function(input)
	local detected = false
	local currentFramePress = input.getBooleanActionValue("PlaceStacksKey")
	if helpers.detectPress(previousFramePress, currentFramePress) then
		M.stopDetectingPlaceStacksHold()
		detected = true
	end
	previousFramePress = currentFramePress
	return detected
end

M.detectPlaceStacksHold = function(core, input, I)
	local detected = false

	if detectingPlaceStacksHold and shouldCancelPlaceStacksHoldDetection(input, I) then
		M.stopDetectingPlaceStacksHold()
		DB.log("place stacks hold cancelled")
		return detected
	end
	if detectingPlaceStacksHold then
		if core.getRealTime() >= holdTime then
			M.stopDetectingPlaceStacksHold()
			detected = true
		end
	end
	return detected
end

M.startDetectingPlaceStacksHoldIfEnabled = function(core, storage)
	local settingsPlaceStacks = storage.playerSection("settingsPlaceStacks")
	local settingsHoldMS = settingsPlaceStacks:get("HoldMS")
	local placeStacksHoldEnabled = settingsHoldMS > 0
	DB.log("placeStacksHoldEnabled: ", placeStacksHoldEnabled)

	if placeStacksHoldEnabled then
		holdTime = getCalculatedHoldTime(core, settingsHoldMS)
		DB.log("place stacks hold started - time set to: ", holdTime)
		detectingPlaceStacksHold = true
	end
end

return M
