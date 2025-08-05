local core = require("openmw.core")
--
local l10n = "placeStacks"

local localized = core.l10n(l10n, "en") -- English is the fallback language

local M = {}

M.CONSTANT_KEYS = {
	SettingsPageName = "PlaceStacksPage",
	L10n = l10n,
	Sections = {
		CommonBehavior = "settingsCommonBehavior",
		TakeStacks = "settingsTakeStacks",
		PlaceStacks = "settingsPlaceStacks",
	},
	CommonBehavior = {
		AutoCloseKey = "AutoClose",
		ModifierKey = "Modifier",
	},
	CommonSettings = {
		TransferOrder = "TransferOrder",
		ModifierSetting = "ModifierSetting",
		NotifyCountTransferred = "NotifyCountTransferred",
		NotifyCountNotTransferred = "NotifyCountNotTransferred",
		NotifyTypesNotTransferred = "NotifyTypesNotTransferred",
	},
	TakeStacks = {
		KeyBind = "KeyBind",
		AllowOverEncumbrance = "AllowOverEncumbrance",
	},
	PlaceStacks = {
		KeyBind = "KeyBind",
		HoldMS = "HoldMS",
		DepositEquipped = "DepositEquipped",
	},
	CustomInputs = {
		TakeStacks = "TakeStacksKeyBind",
		PlaceStacks = "PlaceStacksKeyBind",
	},
	Options = {
		StackType = { None = "None", Place = "Place", Take = "Take" },
	},
}

M.LOCALIZED_KEYS = {
	ModName = localized("ModName"),
	ModDescription = localized("ModDescription"),
	Sections = {
		CommonBehavior = {
			Name = localized("SectionName_CommonBehavior"),
			Description = localized("SectionDescription_CommonBehavior"),
		},
		TakeStacks = {
			Name = localized("SectionName_TakeStacks"),
			Description = localized("SectionDescription_TakeStacks"),
		},
		PlaceStacks = {
			Name = localized("SectionName_PlaceStacks"),
			Description = localized("SectionDescription_PlaceStacks"),
		},
	},
	Settings = {
		AutoClose = {
			Name = localized("SettingsNames_AutoClose"),
			Description = localized("SettingsDescription_AutoClose"),
			List = {
				localized("AutoClose_Never"),
				localized("AutoClose_Always"),
				localized("AutoClose_Fit"),
			},
		},
		Modifier = {
			Name = localized("SettingsNames_Modifier"),
			Description = localized("SettingsDescription_Modifier"),
			List = {
				localized("Modifier_Shift"),
				localized("Modifier_Ctrl"),
				localized("Modifier_Alt"),
				localized("Modifier_Super"),
			},
		},
		TakeStacksKeyBind = {
			Name = localized("SettingsNames_TakeStacksKeyBind"),
			Description = localized("SettingsDescription_TakeStacksKeyBind"),
		},
		PlaceStacksKeyBind = {
			Name = localized("SettingsNames_PlaceStacksKeyBind"),
			Description = localized("SettingsDescription_PlaceStacksKeyBind"),
		},
		AllowOverEncumber = {
			Name = localized("SettingsNames_AllowOverEncumber"),
			Description = localized("SettingsDescription_AllowOverEncumber"),
		},
		HoldMS = {
			Name = localized("SettingsNames_HoldMS"),
			Description = localized("SettingsDescription_HoldMS"),
		},
		DepositEquipped = {
			Name = localized("SettingsNames_DepositEquipped"),
			Description = localized("SettingsDescription_DepositEquipped"),
		},
		ModifierSetting = {
			Name = localized("SettingsNames_ModifierSetting"),
			Description = localized("SettingsDescription_ModifierSetting"),
			List = {
				localized("ModifierSetting_Default"),
				localized("ModifierSetting_Invert"),
				localized("ModifierSetting_Disable"),
			},
		},
		TransferOrder = {
			Take = {
				Name = localized("SettingsNames_TransferOrder_Take"),
				Description = localized("SettingsDescription_TransferOrder_Take"),
			},
			Place = {
				Name = localized("SettingsNames_TransferOrder_Place"),
				Description = localized("SettingsDescription_TransferOrder_Place"),
			},
			List = {
				localized("TransferOrder_Any"),
				localized("TransferOrder_Valuable"),
				localized("TransferOrder_Lightest"),
				localized("TransferOrder_Cheapest"),
				localized("TransferOrder_Heaviest"),
			},
		},
		NotifyCountTransferred = {
			Take = {
				Name = localized("SettingsNames_NotifyCountTransferred_Take"),
				Description = localized("SettingsDescription_NotifyCountTransferred_Take"),
			},
			Place = {
				Name = localized("SettingsNames_NotifyCountTransferred_Place"),
				Description = localized("SettingsDescription_NotifyCountTransferred_Place"),
			},
		},
		NotifyCountNotTransferred = {
			Take = {
				Name = localized("SettingsNames_NotifyCountNotTransferred_Take"),
				Description = localized("SettingsDescription_NotifyCountNotTransferred_Take"),
			},
			Place = {
				Name = localized("SettingsNames_NotifyCountNotTransferred_Place"),
				Description = localized("SettingsDescription_NotifyCountNotTransferred_Place"),
			},
		},
		NotifyTypesNotTransferred = {
			Name = localized("SettingsNames_NotifyTypesNotTransferred"),
			Description = localized("SettingsDescription_NotifyTypesNotTransferred"),
		},
	},
	Options = {
		AutoClose = {
			Never = localized("AutoClose_Never"),
			Always = localized("AutoClose_Always"),
			Fit = localized("AutoClose_Fit"),
		},
		TransferOrder = {
			Any = localized("TransferOrder_Any"),
			Valuable = localized("TransferOrder_Valuable"),
			Lightest = localized("TransferOrder_Lightest"),
			Cheapest = localized("TransferOrder_Cheapest"),
			Heaviest = localized("TransferOrder_Heaviest"),
		},
		ModifierSetting = {
			Default = localized("ModifierSetting_Default"),
			Invert = localized("ModifierSetting_Invert"),
			Disable = localized("ModifierSetting_Disable"),
		},
		Modifier = {
			Shift = localized("Modifier_Shift"),
			Ctrl = localized("Modifier_Ctrl"),
			Alt = localized("Modifier_Alt"),
			Super = localized("Modifier_Super"),
		},
	},
}
--
-- DB.log("Localized Keys: ")
-- DB.printTable(M.LOCALIZED_KEYS, 4)

return M
