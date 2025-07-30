local M = {}

function M.detectContainerOpened(data)
	-- DB.log("UiModeChanged from", data.oldMode, "to", data.newMode, "(" .. tostring(data.arg) .. ")")
	if data.oldMode == "Container" and data.newMode == "Container" then
		DB.log("Container Refreshed")
		return false
	end
	if data.newMode ~= "Container" then
		return false
	end
	return true
end

function M.detectPress(previousFramePress, currentFramePress)
	return (currentFramePress and not previousFramePress)
end

function M.isModifierKeyPressed(input, Modifier)
	return (input.isCtrlPressed() and Modifier == "Ctrl")
		or (input.isShiftPressed() and Modifier == "Shift")
		or (input.isAltPressed() and Modifier == "Alt")
		or (input.isSuperPressed() and Modifier == "Super")
end

function M.detectPerformOnAllItems(input, settingsCommonBehavior)
	local modifierPressed = M.isModifierKeyPressed(input, settingsCommonBehavior:get("Modifier"))
	local modifierIsAll = settingsCommonBehavior:get("ModifierIsAll")
	if modifierIsAll then
		return modifierPressed
	else
		return not modifierPressed
	end
end

function M.cancelDetectionThisFrame(focusedContainer, Types, uiMode, currentStackType, psd)
	if not Helpers.canPerformStackAction(focusedContainer, Types, uiMode, currentStackType) then
		psd.stopDetectingPlaceStacksHold()
		return true
	end
	return false
end

function M.getSettingsCommonBehaviorAsTable(settingsCommonBehavior)
	return {
		AutoClose = settingsCommonBehavior:get("AutoClose"),
		ModifierIsAll = settingsCommonBehavior:get("ModifierIsAll"),
		Modifier = settingsCommonBehavior:get("Modifier"),
	}
end
function M.getSettingsPlaceStacksAsTable(settingsPlaceStacks)
	return {
		Key = settingsPlaceStacks:get("Key"),
		TransferOrder = settingsPlaceStacks:get("TransferOrder"),
		AllowOverEncumbrance = settingsPlaceStacks:get("AllowOverEncumbrance"),
		NotifyCountTransferred = settingsPlaceStacks:get("NotifyCountTransferred"),
		NotifyCountNotTransferred = settingsPlaceStacks:get("NotifyCountNotTransferred"),
	}
end
function M.getSettingsTakeStacksAsTable(settingsTakeStacks)
	return {
		Key = settingsTakeStacks:get("Key"),
		HoldMS = settingsTakeStacks:get("HoldMS"),
		TransferOrder = settingsTakeStacks:get("TransferOrder"),
		DepositEquipped = settingsTakeStacks:get("DepositEquipped"),
		NotifyCountTransferred = settingsTakeStacks:get("NotifyCountTransferred"),
		NotifyCountNotTransferred = settingsTakeStacks:get("NotifyCountNotTransferred"),
		NotifyTypesNotTransferred = settingsTakeStacks:get("NotifyTypesNotTransferred"),
	}
end

return M
