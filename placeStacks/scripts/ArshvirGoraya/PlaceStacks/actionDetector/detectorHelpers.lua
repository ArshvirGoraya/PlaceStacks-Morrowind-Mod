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

function M.isModifierKeyPressed(input, modifierKey)
	return (input.isCtrlPressed() and modifierKey == "Ctrl")
		or (input.isShiftPressed() and modifierKey == "Shift")
		or (input.isAltPressed() and modifierKey == "Alt")
		or (input.isSuperPressed() and modifierKey == "Super")
end

function M.detectPerformOnAllItems(input, modifierKey, modifierSetting)
	if modifierSetting == SettingsOptions.ModifierSetting.Disable then
		return false
	end
	local modifierPressed = M.isModifierKeyPressed(input, modifierKey)
	local modifierInverted = modifierSetting == SettingsOptions.ModifierSetting.Invert
	if modifierInverted then
		return not modifierPressed
	end
	return modifierPressed
end

function M.cancelDetectionThisFrame(focusedContainer, Types, uiMode, currentStackType, psd)
	if not Helpers.canPerformStackAction(focusedContainer, Types, uiMode, currentStackType) then
		psd.stopDetectingPlaceStacksHold()
		return true
	end
	return false
end

return M
