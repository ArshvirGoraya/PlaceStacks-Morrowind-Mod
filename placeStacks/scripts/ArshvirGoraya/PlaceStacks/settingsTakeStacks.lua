local I = require("openmw.interfaces")
local input = require("openmw.input")

I.Settings.registerPage({
	key = "TakeStacksPage",
	l10n = "PlaceStacks",
	name = "Take Stacks",
	description = "Author: Arshvir Goraya\nPart of the Place Stacks mod. Take Stacks lets you quickly take items out of a container, and allows you to modify the taking behaviour: take only matching items, take all but dont over-encumber, etc.",
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
			default = input.getKeyName(input.KEY.R), -- openMW doesn't set the default as of 0.49... so players will have to set it in game manually.
			renderer = "inputBinding",
			argument = {
				name = "Take Stacks key",
				key = "TakeStacksKey",
				type = "action",
			},
		},
	},
})
