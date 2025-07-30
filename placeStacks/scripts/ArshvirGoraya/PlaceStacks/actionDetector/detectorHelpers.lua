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

function M.detectPerformOnAllItems(input)
	local modifierPressed = M.isModifierKeyPressed(input, SettingsCommonBehavior:get("Modifier"))
	local modifierIsAll = SettingsCommonBehavior:get("ModifierIsAll")
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

function M.settingsChanged(section, key)
	local resetAll = key == nil
	if resetAll then -- 0.49: should be true if hit "reset" but this is never true.
		DB.log("RESET ALL")
	end
	DB.log("settings changed: " .. section, key)
	if section == "settingsCommonBehavior" then
		SettingsCommonBehaviorTable[key] = SettingsCommonBehavior:get(key)
	elseif section == "settingsTakeStacks" then
		SettingsTakeStacksTable[key] = SettingsTakeStacks:get(key)
	elseif section == "settingsPlaceStacks" then
		SettingsPlaceStacksTable[key] = SettingsPlaceStacks:get(key)
	end
end

-- @refactor: this should be a loop of all keys instead of manually typing every one
function M.getSettingsCommonBehaviorAsTable()
	return {
		AutoClose = SettingsCommonBehavior:get("AutoClose"),
		ModifierIsAll = SettingsCommonBehavior:get("ModifierIsAll"),
		Modifier = SettingsCommonBehavior:get("Modifier"),
	}
end
function M.getSettingsPlaceStacksAsTable()
	return {
		Key = SettingsPlaceStacks:get("Key"),
		TransferOrder = SettingsPlaceStacks:get("TransferOrder"),
		AllowOverEncumbrance = SettingsPlaceStacks:get("AllowOverEncumbrance"),
		NotifyCountTransferred = SettingsPlaceStacks:get("NotifyCountTransferred"),
		NotifyCountNotTransferred = SettingsPlaceStacks:get("NotifyCountNotTransferred"),
	}
end
function M.getSettingsTakeStacksAsTable()
	return {
		Key = SettingsTakeStacks:get("Key"),
		HoldMS = SettingsTakeStacks:get("HoldMS"),
		TransferOrder = SettingsTakeStacks:get("TransferOrder"),
		DepositEquipped = SettingsTakeStacks:get("DepositEquipped"),
		NotifyCountTransferred = SettingsTakeStacks:get("NotifyCountTransferred"),
		NotifyCountNotTransferred = SettingsTakeStacks:get("NotifyCountNotTransferred"),
		NotifyTypesNotTransferred = SettingsTakeStacks:get("NotifyTypesNotTransferred"),
	}
end

return M
