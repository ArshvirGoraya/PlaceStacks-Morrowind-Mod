local I = require("openmw.interfaces")

I.Settings.registerPage({
	key = "PlaceStacksPage",
	l10n = "PlaceStacks",
	name = "Place Stacks",
	description = "Author: Arshvir Goraya\nA Mod that allows for quickly placing stacks of items in containers if they contains those items already.\nInspired by Valheim's Place Stacks mechanic.",
})

I.Settings.registerGroup({
	key = "settingsPlaceStacksModBehaviour",
	page = "PlaceStacksPage",
	l10n = "PlaceStacks",
	name = "Stack Behaviour",
	description = "Settings that control stacking behaviour",
	permanentStorage = true, -- false = placed in individual saves
	settings = {
		{
			key = "PlaceStacksDepositEquipped",
			name = "Deposit Equipped Items",
			description = "If enabled, will also deposit equipped items.",
			default = false,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
	},
})

I.Settings.registerGroup({
	key = "settingsPlaceStacksModNotification",
	page = "PlaceStacksPage",
	l10n = "PlaceStacks",
	name = "Notification",
	description = "Control aspects of the place stacks notification",
	permanentStorage = true, -- false = placed in individual saves
	settings = {
		{
			key = "PlaceStacksNotify",
			name = "Show Place Stacks Notification",
			description = "If enabled, will display a notification that shows how many items were placed in the container.",
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
		{
			key = "PlaceStacksNotifyNotAllItems",
			name = "Show Not All Items Notification",
			description = "If enabled, shows a notification if not all items could fit in the container.",
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
	},
})

I.Settings.registerGroup({
	key = "settingsPlaceStacksModHold",
	page = "PlaceStacksPage",
	l10n = "PlaceStacks",
	name = "Hold To Stack",
	description = "Settings that control holding activate to place stacks",
	permanentStorage = true, -- false = placed in individual saves
	settings = {
		{
			key = "PlaceStacksHold",
			name = "Hold Activate To Place Stacks",
			description = 'If enabled, hover over a container and hold the "activate" key to place stacks.',
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
		{
			key = "PlaceStacksHoldMS",
			name = "Milliseconds",
			description = 'How many milliseonds you must hold "activate" key before placing stacks. Doesn\'t do anything if above setting is disabled.',
			default = 250,
			renderer = "number",
			argument = {
				integer = true, -- only allow integers,
				min = 0,
				max = 3000,
			},
		},
		{
			key = "PlaceStacksHoldAutoClose",
			name = "Auto Close",
			description = "Automatically close the container once stacks are placed.",
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
	},
})
