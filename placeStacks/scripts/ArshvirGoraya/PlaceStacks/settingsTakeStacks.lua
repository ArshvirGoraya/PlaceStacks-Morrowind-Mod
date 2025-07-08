local I = require("openmw.interfaces")
local input = require("openmw.input")

I.Settings.registerPage({
	key = "TakeStacksPage",
	l10n = "PlaceStacks",
	name = "Take Stacks",
	description = "Author: Arshvir Goraya\nPart of the Place Stacks mod. Take Stacks you to quickly take stacks out of a container, and allows you to modify the taking behaviour: take only matching items, take all but dont over-encumber, etc.",
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
			default = input.getKeyName(input.KEY.R), -- this doesn't seem to work?
			renderer = "inputBinding",
			argument = {
				name = "Take Stacks key",
				key = "TakeStacksKey",
				type = "action",
			},
		},
	},
})
