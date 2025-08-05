local vfs = require("openmw.vfs")
local markup = require("openmw.markup")
local core = require("openmw.core")
--
local l10n = "placeStacks"
local FILE_PATH = "l10n/" .. l10n .. "/en.yaml"

local localizationFunction = core.l10n(l10n, "en") -- English is the fallback language

DB.log("NeverTranslation : ", localizationFunction("AutoCloseSelect", { ChoiceVar = "Never" }))

if vfs.fileExists(FILE_PATH) then
	DB.log("en.yaml does NOT exist: " .. FILE_PATH)
	return
end

---@class KeyDescriptionTable
---@field Name string
---@field Description string

---@class LocalizedKeys
---@field settings {
---   Name: string,
---   Description: string,
---   CommonBehavior:{
---     Name: string,
---     Description: string,
---     AutoClose: {
---       Name: string,
---       Description: string,
---       Options: string[],
---     },
---   },
---}
---@field settingOptions {
---ModifierSetting: {Default:string, Invert:string, Disable:string},
---TransferOrder: {Any:string, Valuable:string, Lightest:string, Cheapest:string, Heaviest:string},
---AutoClose: {Never:string, Fit:string, Always:string},
---Modifier: {Shift:string, Ctrl:string, Alt:string, Super:string},
---}

local M = {}

---@type LocalizedKeys
M.LOCALIZED_KEYS = markup.loadYaml(FILE_PATH)

local autoCloseOptions = {
	Never = M.LOCALIZED_KEYS.settings.CommonBehavior.AutoClose.Options[0],
	Always = M.LOCALIZED_KEYS.settings.CommonBehavior.AutoClose.Options[1],
	Fit = M.LOCALIZED_KEYS.settings.CommonBehavior.AutoClose.Options[2],
}

M.CONSTANT_KEYS = {
	SettingsPageName = "PlaceStacksPage",
	L10n = l10n,
	CommonBehavior = {
		SectionKey = "settingsCommonBehavior",
		AutoClose = {
			Key = "AutoClose",
			Options = autoCloseOptions,
		},
		ModifierKey = "Modifier",
	},
}

-- M.CONSTANT_KEYS.CommonBehavior.AutoClose.Options.Never

return M
