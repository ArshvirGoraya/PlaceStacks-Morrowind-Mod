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
	description = "Controls aspects of the take stacks notification",
	permanentStorage = true,
	settings = {
		{
			key = "TakeStacksNotify",
			name = "Show Take Stacks Notification",
			description = "If enabled, will show a notification each time take stacks is activated. Contents of the notification is how many items were taken.",
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
	description = "Modify take stacks behaviour",
	permanentStorage = true,
	settings = {
		{
			key = "TakeStacksActionKey",
			name = "Take Stacks Key",
			description = "If set, press key when container is open to trigger the take stacks behaviour.",
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
			key = "TakeStacksMoveType",
			name = "Take Behaviour",
			description = "- Take all: takes all items regardless of if they match or not.\n- Take Matching First: takes matching items first, and then all the rest.\n- Take Matching only: takes item if one of the same kind exists in your inventory (this works just like place stacks works).",
			default = "Take All",
			renderer = "select",
			argument = {
				items = { "Take All", "Matching First", "Matching Only" },
				l10n = "PlaceStacks",
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
