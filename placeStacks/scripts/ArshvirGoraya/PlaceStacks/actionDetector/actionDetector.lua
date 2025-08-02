-- PLAYER SCRIPT
--
-- API Globals
Types = require("openmw.types")
Core = require("openmw.core")
I = require("openmw.interfaces")
Input = require("openmw.input")
Storage = require("openmw.storage")
local player = require("openmw.self")
local async = require("openmw.async")
--
PlaceStacksGlobals = Storage.globalSection("PlaceStacksGlobals")
-- Custom API Globals
DetectorHelpers = require("scripts.ArshvirGoraya.PlaceStacks.actionDetector.detectorHelpers")
EnumHelpers = require("scripts.ArshvirGoraya.PlaceStacks.enumHelpers")
Enums = EnumHelpers.makeEnums()
DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
Helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
--- Settings stuff
local settingsHelpers = require("scripts.ArshvirGoraya.PlaceStacks.settingsHelpers")
SettingsKeys = settingsHelpers.keys
local settings = require("scripts.ArshvirGoraya.PlaceStacks.settings")
settingsHelpers.buildTableSettings(async, Storage, settings.defaultSettings) -- to pass to global script(s)
Settings = settingsHelpers.settingValues
local settingsTableCommonBehavior = Settings.tableSettings[SettingsKeys.sectionKeys.commonBehavior]
local settingsTableTakeStacks = Settings.tableSettings[SettingsKeys.sectionKeys.takeStacks]
local settingsTablePlaceStacks = Settings.tableSettings[SettingsKeys.sectionKeys.placeStacks]
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
	if
		DetectorHelpers.cancelDetectionThisFrame(
			FocusedContainer,
			Types,
			I.UI.getMode(),
			PlaceStacksGlobals:get("CurrentStackType"),
			psd
		)
	then
		return
	end
	--
	if psd.detectPlaceStacksHold() or psd.detectPlaceStacksPress() then
		Core.sendGlobalEvent("performPlaceStacks", {
			FocusedContainer,
			player,
			I.UI.getMode(),
			DetectorHelpers.detectPerformOnAllItems(
				Input,
				settingsTableCommonBehavior.Modifier,
				settingsTablePlaceStacks.ModifierSetting
			),
			settingsTableCommonBehavior,
			settingsTablePlaceStacks,
		})
	end
	if tsd.detectTakeStacksPress(psd) then
		Core.sendGlobalEvent("performTakeStacks", {
			FocusedContainer,
			player,
			I.UI.getMode(),
			DetectorHelpers.detectPerformOnAllItems(
				Input,
				settingsTableCommonBehavior.Modifier,
				settingsTableTakeStacks.ModifierSetting
			),
			settingsTableCommonBehavior,
			settingsTableTakeStacks,
		})
	end
end

local UIModeChanged = function(data) --@ ENTRY
	if DetectorHelpers.detectContainerOpened(data) then
		FocusedContainer = data.arg
		DB.printTable(settingsTablePlaceStacks)
		psd.startDetectingPlaceStacksHoldIfEnabled(settingsTablePlaceStacks.HoldMS)
	end
end

--
local M = {
	eventHandlers = { UiModeChanged = UIModeChanged },
	engineHandlers = { onFrame = onFrame, onKeyPress = onKeyPress },
}
return M
