-- PLAYER SCRIPT
--
-- API Globals
Types = require("openmw.types")
Core = require("openmw.core")
I = require("openmw.interfaces")
Input = require("openmw.input")
Storage = require("openmw.storage")
local player = require("openmw.self")
local settingsCommonBehavior = Storage.playerSection("settingsCommonBehavior")
local settingsTakeStacks = Storage.playerSection("settingsTakeStacks")
local settingsPlaceStacks = Storage.playerSection("settingsPlaceStacks")
-- Custom API Globals
DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
Helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
DetectorHelpers = require("scripts.ArshvirGoraya.PlaceStacks.actionDetector.detectorHelpers")
local _ = require("scripts.ArshvirGoraya.PlaceStacks.settings") -- settings
-- Custom Var Globals
FocusedContainer = nil
-- Locals
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
	if psd.detectPlaceStacksHold() or psd.detectPlaceStacksPress() then
		Core.sendGlobalEvent("performPlaceStacks", {
			FocusedContainer,
			player,
			I.UI.getMode(),
			DetectorHelpers.detectPerformOnAllItems(Input, settingsCommonBehavior),
			DetectorHelpers.getSettingsCommonBehaviorAsTable(settingsCommonBehavior),
			DetectorHelpers.getSettingsPlaceStacksAsTable(settingsPlaceStacks),
		})
	end
	if tsd.detectTakeStacksPress(psd) then
		Core.sendGlobalEvent("performTakeStacks", {
			FocusedContainer,
			player,
			I.UI.getMode(),
			DetectorHelpers.detectPerformOnAllItems(Input, settingsCommonBehavior),
			DetectorHelpers.getSettingsCommonBehaviorAsTable(settingsCommonBehavior),
			DetectorHelpers.getSettingsTakeStacksAsTable(settingsTakeStacks),
		})
	end
end

local UIModeChanged = function(data) --@ ENTRY
	if DetectorHelpers.detectContainerOpened(data) then
		FocusedContainer = data.arg
		psd.startDetectingPlaceStacksHoldIfEnabled(settingsPlaceStacks)
	end
end

--
local M = {
	eventHandlers = { UiModeChanged = UIModeChanged },
	engineHandlers = { onFrame = onFrame, onKeyPress = onKeyPress },
}
return M
