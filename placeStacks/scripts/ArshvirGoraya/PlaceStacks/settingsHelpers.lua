local M = {}

M.keys = {
	sectionKeys = {
		commonBehavior = "settingsCommonBehavior",
		takeStacks = "settingsTakeStacks",
		placeStacks = "settingsPlaceStacks",
	},
	commonBehaviorKeys = {
		AutoClose = "AutoClose",
		ModifierIsAll = "ModifierIsAll",
		Modifier = "Modifier",
	},
	takeStacksKeys = {
		Key = "Key",
		TransferOrder = "TransferOrder",
		AllowOverEncumbrance = "AllowOverEncumbrance",
		NotifyCountTransferred = "NotifyCountTransferred",
		NotifyCountNotTransferred = "NotifyCountNotTransferred",
	},
	placeStacksKeys = {
		Key = "Key",
		HoldMS = "HoldMS",
		TransferOrder = "TransferOrder",
		DepositEquipped = "DepositEquipped",
		NotifyCountTransferred = "NotifyCountTransferred",
		NotifyCountNotTransferred = "NotifyCountNotTransferred",
		NotifyTypesNotTransferred = "NotifyTypesNotTransferred",
	},
}
M.keys.outline = {
	settingsCommonBehavior = {
		sectionKey = M.keys.sectionKeys.commonBehavior,
		settingsKeys = M.keys.commonBehaviorKeys,
	},
	settingsTakeStacks = {
		sectionKey = M.keys.sectionKeys.takeStacks,
		settingsKeys = M.keys.takeStacksKeys,
	},
	settingsPlaceStacks = {
		sectionKey = M.keys.sectionKeys.placeStacks,
		settingsKeys = M.keys.takeStacksKeys,
	},
}

M.settingValues = {
	defaultSettings = {},
	currentSettings = {},
	tableSettings = {},
}

local function settingsChanged(section, key)
	local resetAll = key == nil
	if resetAll then -- 0.49: should be true if hit "reset" but this is never true.
		DB.log("RESET ALL")
	end
	DB.log("settings changed: " .. section, key .. ": " .. tostring(M.settingValues.currentSettings[section]:get(key)))
	M.settingValues.tableSettings[section][key] = M.settingValues.currentSettings[section]:get(key)
end

local function getSettingsAsTable(defaultSettings, currentSettings)
	local tableSettings = {}
	for _, v in pairs(defaultSettings.settings) do
		tableSettings[v.key] = currentSettings:get(v.key)
		DB.log(v.key)
	end
	return tableSettings
end

M.buildTableSettings = function(async, storage, defaultSettings)
	M.settingValues.defaultSettings = defaultSettings
	for _, section in pairs(defaultSettings) do
		M.settingValues.currentSettings[section.key] = storage.playerSection(section.key)

		-- Convert settings to tables when changed (so they can pass in events to global script -> which cant access playersection storage)
		M.settingValues.tableSettings[section.key] = getSettingsAsTable(
			M.settingValues.defaultSettings[section.key],
			M.settingValues.currentSettings[section.key]
		)
		-- Subscribe to changed to settings (to update the tables)
		M.settingValues.currentSettings[section.key]:subscribe(async:callback(settingsChanged))
	end
end

return M
