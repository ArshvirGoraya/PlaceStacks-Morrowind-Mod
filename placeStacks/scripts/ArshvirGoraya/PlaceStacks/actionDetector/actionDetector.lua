-- API
local types = require("openmw.types")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local input = require("openmw.input")
local storage = require("openmw.storage")
-- Custom
local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
local psd = require("scripts.ArshvirGoraya.PlaceStacks.actionDetector.placeStacksDetector")
local tsd = require("scripts.ArshvirGoraya.PlaceStacks.actionDetector.takeStacksDetector")

-- debug
local detectDebugAction = function(key)
	if not DB.logging then
		return false
	end
	if key.symbol == "\\" then
		return true
	end
end

local performDebugAction = function()
	--ui.showMessage()
	DB.log("placeStacks debug action")
	--DB.uilog("debug action")
end

-- ENTRY
local onKeyPress = function(key)
	if detectDebugAction(key) then
		performDebugAction()
	end
end

local onFrame = function(_) --@ ENTRY
	if psd.detectPlaceStacksHold(core, input, I) or psd.detectPlaceStacksPress(input) then
		core.sendGlobalEvent("performPlaceStacks", core, input, types, I, storage, self, helpers, DB)
	end
	if tsd.detectTakeStacksPress(input, psd, DB) then
		core.sendGlobalEvent("performTakeStacks", core, input, types, I, storage, self, helpers, DB)
	end
end

local UIModeChanged = function(data) --@ ENTRY
	if helpers.detectContainerOpened(data) then
		helpers.sharedVariables.focusedContainer = data.arg
		DB.log("Container Opened/Focused = ", helpers.sharedVariables.focusedContainer)
		if helpers.isContainerValid(helpers.sharedVariables.focusedContainer, types) then
			psd.startDetectingPlaceStacksHoldIfEnabled(core, storage)
		end
	end
end

--
local M = {
	eventHandlers = { UiModeChanged = UIModeChanged },
	engineHandlers = { onFrame = onFrame, onKeyPress = onKeyPress },
}
return M
