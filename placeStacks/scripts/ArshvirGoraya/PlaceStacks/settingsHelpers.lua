local M = {}

-- order doesn't matter:
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

-- Order matters: Make into list first and then table
---@class OptionsTable
---@field options {
---StackType: {None:string, Place:string, Take:string},
---}
---@field settingOptions {
---ModifierSetting: {Default:string, Invert:string, Disable:string},
---TransferOrder: {Any:string, Valuable:string, Lightest:string, Cheapest:string, Heaviest:string},
---AutoClose: {Never:string, Fit:string, Always:string},
---Modifier: {Shift:string, Ctrl:string, Alt:string, Super:string},
---}
M.allOptions = {
	options = {
		StackType = { "None", "Place", "Take" },
	},
	settingOptions = {
		ModifierSetting = { "Default", "Invert", "Disable" },
		TransferOrder = { "Any", "Valuable", "Lightest", "Cheapest", "Heaviest" },
		AutoClose = { "Never", "Fit", "Always" },
		Modifier = { "Shift", "Ctrl", "Alt", "Super" },
	},
}

local function convertListToTable(list)
	local tbl = {}
	for _, v in ipairs(list) do
		tbl[v] = v
	end
	return tbl
end
---@return OptionsTable
function M.createOptionsTable()
	local optionTable = {}
	for tableName, tbl in pairs(M.allOptions) do
		optionTable[tableName] = {}
		for k, list in pairs(tbl) do
			optionTable[tableName][k] = convertListToTable(list)
		end
	end
	DB.printTable(optionTable, 3)
	return optionTable
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
