local M = {}

M.keys = {
	sectionKeys = {
		commonBehavior = "settingsCommonBehavior",
		takeStacks = "settingsTakeStacks",
		placeStacks = "settingsPlaceStacks",
	},
	commonBehaviorKeys = {
		AutoClose = "AutoClose",
		Modifier = "Modifier",
	},
	takeStacksKeys = {
		Key = "Key",
		TransferOrder = "TransferOrder",
		ModifierSetting = "ModifierSetting",
		AllowOverEncumbrance = "AllowOverEncumbrance",
		NotifyCountTransferred = "NotifyCountTransferred",
		NotifyCountNotTransferred = "NotifyCountNotTransferred",
	},
	placeStacksKeys = {
		Key = "Key",
		HoldMS = "HoldMS",
		TransferOrder = "TransferOrder",
		DepositEquipped = "DepositEquipped",
		ModifierSetting = "ModifierSetting",
		NotifyCountTransferred = "NotifyCountTransferred",
		NotifyCountNotTransferred = "NotifyCountNotTransferred",
		NotifyTypesNotTransferred = "NotifyTypesNotTransferred",
	},
}

M.options = {
	StackType = { None = "None", Place = "Place", Take = "Take" },
	SettingOptions = {
		ModifierSetting = {
			Default = "Default",
			Invert = "Invert",
			Disable = "Disable",
		},
		TransferOrder = {
			Any = "Any",
			Valuable = "Valuable",
			Lightest = "Lightest",
			Cheapest = "Cheapest",
			Heaviest = "Heaviest",
		},
		AutoClose = {
			Never = "Never",
			AllFit = "All Fit",
			Always = "Always",
		},
		Modifier = {
			Shift = "Shift",
			Ctrl = "Ctrl",
			Alt = "Alt",
			Super = "Super",
		},
	},
}
---@return { ModifierSetting: string[], TransferOrder: string[], AutoClose: string[], Modifier: string[] }
function M.createSettingOptionsLists()
	local optionList = {}
	for k, optionTable in pairs(M.options.SettingOptions) do
		-- DB.log("Key: ", k, "value:", optionTable)
		optionList[k] = {}
		for _, value in pairs(optionTable) do
			table.insert(optionList[k], value)
		end
	end
	DB.printTable(optionList, 2)
	return optionList
end

M.allSettings = {
	defaultSettings = {},
	currentSettings = {},
	tableSettings = {},
}

local function settingsChanged(section, key)
	local resetAll = key == nil
	if resetAll then -- 0.49: should be true if hit "reset" but this is never true.
		DB.log("RESET ALL")
	end
	DB.log("settings changed: " .. section, key .. ": " .. tostring(M.allSettings.currentSettings[section]:get(key)))
	M.allSettings.tableSettings[section][key] = M.allSettings.currentSettings[section]:get(key)
end

local function getSettingsAsTable(defaultSettings, currentSettings)
	local tableSettings = {}
	for _, v in pairs(defaultSettings.settings) do
		tableSettings[v.key] = currentSettings:get(v.key)
	end
	return tableSettings
end

M.buildTableSettings = function(async, storage, defaultSettings)
	M.allSettings.defaultSettings = defaultSettings
	for _, section in pairs(defaultSettings) do
		M.allSettings.currentSettings[section.key] = storage.playerSection(section.key)

		-- Convert settings to tables when changed (so they can pass in events to global script -> which cant access playersection storage)
		M.allSettings.tableSettings[section.key] =
			getSettingsAsTable(M.allSettings.defaultSettings[section.key], M.allSettings.currentSettings[section.key])
		-- Subscribe to changed to settings (to update the tables)
		M.allSettings.currentSettings[section.key]:subscribe(async:callback(settingsChanged))
	end
end

return M
