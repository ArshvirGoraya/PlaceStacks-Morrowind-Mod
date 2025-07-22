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

local performTakeStacks = function(storage) --@ UNFINISHED!
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.Take
	local settingsPlaceStacks = storage.playerSection("settingsPlaceStacks")
	local settingsCommonBehavior = storage.playerSection("settingsCommonBehavior")

	helpers.sharedVariables.takeStacksArgs.sourceContainer = helpers.sharedVariables.focusedContainer
	helpers.sharedVariables.takeStacksArgs.targetContainer = self
	helpers.sharedVariables.takeStacksArgs.performOnAllItems =
		helpers.detectPerformOnAllItems(input, settingsCommonBehavior)
	helpers.sharedVariables.takeStacksArgs.player = self
	helpers.sharedVariables.takeStacksArgs.allowOverEncumbrance = settingsPlaceStacks:get("AllowOverEncumbrance")
	helpers.sharedVariables.takeStacksArgs.takeOrder = settingsPlaceStacks:get("TakeOrder")
	helpers.sharedVariables.takeStacksArgs.notifyCountTransferred = settingsPlaceStacks:get("NotifyCountTransferred")
	helpers.sharedVariables.takeStacksArgs.notifyCountNotTransferred =
		settingsPlaceStacks:get("NotifyCountNotTransferred")
	helpers.sharedVariables.takeStacksArgs.notifyTypeNotTransferred =
		settingsPlaceStacks:get("NotifyTypeNotTransferred")
	DB.log("performTakeStacks called!")
	DB.log("- perform on all: " .. tostring(helpers.sharedVariables.takeStacksArgs.performOnAllItems))

	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.None
end

local performPlaceStacks = function(storage) --@ UNFINISHED!
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.Place
	-- this function only works as intended if it is run on the same frame as the function that detects when hold/press action is triggered
	local settingsPlaceStacks = storage.playerSection("settingsPlaceStacks")
	local settingsCommonBehavior = storage.playerSection("settingsCommonBehavior")

	helpers.sharedVariables.placeStacksArgs.sourceContainer = self
	helpers.sharedVariables.placeStacksArgs.targetContainer = helpers.sharedVariables.focusedContainer
	helpers.sharedVariables.placeStacksArgs.performOnAllItems =
		helpers.detectPerformOnAllItems(input, settingsCommonBehavior)
	helpers.sharedVariables.placeStacksArgs.player = self
	helpers.sharedVariables.placeStacksArgs.depositEquipped = settingsPlaceStacks:get("DepositEquipped")
	helpers.sharedVariables.placeStacksArgs.notifyCountTransferred = settingsPlaceStacks:get("NotifyCountTransferred")
	helpers.sharedVariables.placeStacksArgs.notifyCountNotTransferred =
		settingsPlaceStacks:get("NotifyCountNotTransferred")
	helpers.sharedVariables.placeStacksArgs.notifyTypeNotTransferred =
		settingsPlaceStacks:get("NotifyTypeNotTransferred")
	DB.log("performPlaceStacks called")
	DB.log("- perform on all: " .. tostring(helpers.sharedVariables.placeStacksArgs.performOnAllItems))

	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.None
end

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
		if helpers.canPerformStackAction(types, I, helpers.enums.STACK_TYPE.Place) then
			performPlaceStacks(storage)
		end
	end
	if tsd.detectTakeStacksPress(input, psd, DB) then
		if helpers.canPerformStackAction(types, I, helpers.enums.STACK_TYPE.Take) then
			performTakeStacks(storage)
		end
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
