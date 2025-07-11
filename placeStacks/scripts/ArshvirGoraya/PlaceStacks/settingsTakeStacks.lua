local I = require("openmw.interfaces")
local input = require("openmw.input")

I.Settings.registerPage({
	key = "TakeStacksPage",
	l10n = "PlaceStacks",
	name = "Take Stacks",
	description = "Author: Arshvir Goraya\nPart of the Place Stacks mod. Take Stacks lets you quickly take items out of a container, and allows you to modify the taking behaviour: take only matching items, take all but dont over-encumber, etc.",
})

I.Settings.registerGroup({
	key = "settingsTakeStacksModNotification",
	page = "TakeStacksPage",
	l10n = "PlaceStacks",
	name = "Notification",
	description = "Controls aspects of the take stacks notification.",
	permanentStorage = true,
	settings = {
		{
			key = "TakeStacksNotify",
			name = "Show Take Stacks Notification",
			description = "If enabled, will show a notification each time take stacks is activated. Contents of the notification can be enabled below. If all content options are disabled, will not show any notification, even if this is enabled.",
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
		{
			key = "TakeStacksNotifyTakeCount",
			name = "Show Take Stacks Count",
			description = "If enabled, adds number of items taken from container to notification.",
			default = true,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
		{
			key = "TakeStacksNotifyNotTakenCount",
			name = "Show Take Stacks Notification",
			description = "If enabled, adds number of items that could not be taken from container to notification if any could not be taken. Useful if have allow over encumber set to false.",
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
	key = "settingsTakeStacksMod",
	page = "TakeStacksPage",
	l10n = "PlaceStacks",
	name = "Take Stacks",
	description = "Modify take stacks behaviour.",
	permanentStorage = true,
	settings = {
		{
			key = "TakeStacksActionKey",
			name = "Take Stacks Key",
			description = "If set, press key when container is open to trigger the take all matching items.",
			default = "R", -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			-- default = input.getKeyName(input.KEY.R), -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			renderer = "inputBinding",
			argument = {
				name = "Take Stacks key",
				key = "TakeStacksKey",
				type = "action",
			},
		},
		{
			key = "TakeStacksActionModifierKey",
			name = "Take Stacks Modifier Key",
			description = "Press with key to take all items.",
			default = "Shift", -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			-- default = input.getKeyName(input.KEY.R), -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			renderer = "select",
			argument = {
				items = { "Ctrl", "Shift", "Alt", "Super" },
				l10n = "PlaceStacks",
			},
		},
		{
			key = "TakeStacksOverEncumber",
			name = "Allow Over Encumber",
			description = "If enabled, will take items even if it would over encumber you.",
			default = false,
			renderer = "checkbox",
			argument = {
				trueLabel = "Enabled",
				falseLabel = "Disabled",
			},
		},
		{
			key = "TakeStacksAutoClose",
			name = "Auto Close",
			description = "- Never: never auto close the container.\n- All Fit: close if all items fit in your inventory. Leave open if over-encumbered or not all fit.\n- Always: will always auto close container.",
			default = "All Fit",
			renderer = "select",
			argument = {
				items = { "Never", "All Fit", "Always" },
				l10n = "PlaceStacks",
			},
		},
	},
})
