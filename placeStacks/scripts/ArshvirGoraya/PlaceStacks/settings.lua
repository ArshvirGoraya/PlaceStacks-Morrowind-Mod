local settings = require("openmw.interfaces").Settings
local input = require("openmw.input")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")

local modDescription = [[
Initially inspired by Valheim's Place Stacks mechanic, this mod lets you quickly place/take matching items into or from containers.

- Place: Place all items, or place only matching items where if the container has the item and you have the item the item goes into the container.
- Take: Take all items, or take only matching items where if the container has the item and you have the item, the item goes into your inventory.
    - Options to take items in order: valuable, cheapest, heaviest, lightest. 

Mod Link: https://www.nexusmods.com/morrowind/mods/57067
Author: Arshvir Goraya
]]

local autoCloseDescription = [[
Control common behavior between place stacks and take stacks mechanics.

- Never: never close after taking/placing.
- Always: always close after taking/placing.
- AllFit: close when all relevant items are transferred. Will not close when items can't fit into a container without over encumbering it.
]]

local modifierIsAllDescription = [[
Control what the modifier key does when pressing along with take/place stack keys. 

- If yes, press modifier along with key to transfer all items, and press key without modifier to transfer only matching. 
- If no, press modifier along with key to transfer only matching, and press key without modifier to transfer all.
]]

local l10n = "PlaceStacks"

settings.registerPage({
	key = "PlaceStacksPage",
	l10n = l10n,
	name = "Place Stacks",
	description = modDescription,
})

local settingsCommonBehavior = {
	key = "settingsCommonBehavior",
	page = "PlaceStacksPage",
	l10n = l10n,
	name = "Common Behavior",
	description = "Control common behavior between place stacks and take stacks mechanics.",
	permanentStorage = true, -- false = placed in individual saves
	settings = {
		{
			key = "AutoClose",
			name = "Auto Close",
			description = autoCloseDescription,
			default = "All Fit",
			renderer = "select",
			argument = {
				items = { "Never", "All Fit", "Always" },
				l10n = l10n,
			},
		},
		{
			key = "ModifierIsAll",
			name = "Modifier Is All",
			description = modifierIsAllDescription,
			default = true,
			renderer = "checkbox",
		},
		{
			key = "Modifier",
			name = "Modifier Key",
			description = "Press along side take/place key to trigger modifier action.",
			default = "Shift",
			renderer = "select",
			argument = {
				items = { "Shift", "Ctrl", "Alt", "Super" },
				l10n = l10n,
			},
		},
	},
}

local settingsTakeStacks = {
	key = "settingsTakeStacks",
	page = "PlaceStacksPage",
	l10n = l10n,
	name = "Take Stacks",
	description = "Control behavior of the take stacks mechanic.",
	permanentStorage = true,
	settings = {
		{
			key = "Key",
			name = "Take Stacks Key",
			description = "Press this key when container is open to trigger the take mechanic (take matching by default). Press with modifier to trigger the modifier action (take all by default.)",
			default = "T", -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			renderer = "inputBinding",
			argument = {
				name = "Take Stacks key",
				key = "TakeStacksKey",
				type = "action",
			},
		},
		{
			key = "AllowOverEncumbrance",
			name = "Allow Over Encumbrance",
			description = "- No: only take as much items as you can carry and don't over encumber.\n- Yes: take matching/all items and allow over encumbering.",
			default = false,
			renderer = "checkbox",
		},
		{
			key = "TakeOrder",
			name = "Take Order",
			description = "Controls the order in which items are taken.\n- Valuable: take items from most valuable to least.\n- Lightness: take items from least heavy to most.",
			default = "Valuable",
			renderer = "select",
			argument = {
				items = helpers.enumStrings.TAKE_ORDER,
				l10n = l10n,
			},
		}, --
		{
			key = "NotifyCountTransferred",
			name = "Show amount taken in notification",
			description = "Yes: adds number of items taken from container to a notification.",
			default = true,
			renderer = "checkbox",
		},
		{
			key = "NotifyCountNotTransferred",
			name = "Show amount not taken in notification",
			description = "Yes: adds number of relevant items that could not be taken from container to notification.\nIf taking matching, shows how many matching items could be taken.\nIf taking all, shows total items that could not be taken.",
			default = true,
			renderer = "checkbox",
		},
	},
}

local settingsPlaceStacks = {
	key = "settingsPlaceStacks",
	page = "PlaceStacksPage",
	l10n = l10n,
	name = "Place Stacks",
	description = "Control behavior of the place stacks mechanic.",
	permanentStorage = true,
	settings = {
		{
			key = "Key",
			name = "Place Stacks Key",
			description = "Press this key when container is open to trigger the place mechanic (place matching by default). Press with modifier to trigger the modifier action (place all by default.)",
			default = "G",
			renderer = "inputBinding",
			argument = {
				name = "Place Stacks key",
				key = "PlaceStacksKey",
				type = "action",
			},
		},
		{
			key = "HoldMS",
			name = "Hold to Place Stack Milliseconds",
			description = 'Hover over a container and hold the "activate" key for these many milliseconds to place stacks (place matching by default).\nHold with modifier to trigger the modifier action (place all by default.)\nIf set to 0, disables this method of placing stacks.',
			default = 250,
			renderer = "number",
			argument = {
				integer = true, -- only allow integers,
				min = 0,
				max = 3000,
			},
		},
		{
			key = "DepositEquipped",
			name = "Deposit Equipped Items",
			description = "Yes: will also deposit equipped items.\nNo: will not deposit equipped items",
			default = false,
			renderer = "checkbox",
		}, --
		{
			key = "NotifyCountTransferred",
			name = "Show amount placed in notification",
			description = "Yes: adds number of items placed into container to a notification.",
			default = true,
			renderer = "checkbox",
		},
		{
			key = "NotifyCountNotTransferred",
			name = "Show amount not taken in notification",
			description = "Yes: adds number of relevant items that could not fit in container to notification.\nIf placing matching, shows how many matching items could be placed.\nIf taking all, shows total items that could not be placed.",
			default = true,
			renderer = "checkbox",
		},
		{
			key = "NotifyTypesNotTransferred",
			name = "Show item types of those that could not be placed",
			description = "Yes: adds list of relevant items types that could not fit in container to notification.",
			default = true,
			renderer = "checkbox",
		},
	},
}

-- register in reverse order = the way it appears in the settings page.
settings.registerGroup(settingsTakeStacks)
settings.registerGroup(settingsPlaceStacks)
settings.registerGroup(settingsCommonBehavior)

input.registerAction({
	key = "TakeStacksKey",
	type = input.ACTION_TYPE.Boolean,
	l10n = "PlaceStacks",
	name = "Take Stacks Key",
	description = "Triggers take stacks behavior",
	defaultValue = false,
})

input.registerAction({
	key = "PlaceStacksKey",
	type = input.ACTION_TYPE.Boolean,
	l10n = "PlaceStacks",
	name = "Place Stacks Key",
	description = "Triggers place stacks behavior",
	defaultValue = false,
})
