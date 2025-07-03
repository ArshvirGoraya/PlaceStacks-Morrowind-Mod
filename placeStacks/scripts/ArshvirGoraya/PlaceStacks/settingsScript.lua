local I = require("openmw.interfaces")
local input = require("openmw.input")

input.registerAction({
	type = input.ACTION_TYPE.Boolean,
	defaultValue = false,
	key = "PlaceStacksModifier",
	l10n = "PlaceStacks",
	name = "Place Stacks Modifier -> ",
	description = 'Hold with "Activate" to Place Stacks on container.',
})

I.Settings.registerPage({
	key = "PlaceStacksPage",
	l10n = "PlaceStacks",
	name = "Place Stacks",
	description = "Author: Arshvir Goraya\nA Mod that allows for quickly placing stacks of items in containers if they contains those items already.\nInspired by Valheim's Place Stacks mechanic.",
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
			description = "If enabled, will display a notification that shows how many stacks were placed in the container.",
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
			default = 1000,
			renderer = "number",
			argument = {
				integer = true, -- only allow integers,
				min = 0,
				max = 3000,
			},
		},
	},
})

-- this is not implemented yet:
--
--
-- input.registerActionHandler(
-- 	"PlaceStacksModifier",
-- 	require("openmw.async"):callback(function() -- isn't working?
-- 	async:callback(function() -- isn't working?
-- 		print("place stacks modifier is pressed")
-- 		ui.showMessage("modifier pressed")
-- 	end)
-- )
--
-- I.Settings.registerGroup({
-- 	key = "SettingsPlaceStacksModHover",
-- 	page = "PlaceStacksPage",
-- 	l10n = "PlaceStacks",
-- 	name = "Press on Hover To Stack",
-- 	description = "Settings that control pressing activate with a modifier to place stacks.",
-- 	permanentStorage = true,
-- 	settings = {
-- 		{
-- 			key = "PlaceStacksHover",
-- 			name = "Press on Hover To Place Stacks",
-- 			description = 'If enabled, will allow you to place stacks without entering the container. Just hold the modifier and press "activate".',
-- 			default = true,
-- 			renderer = "checkbox",
-- 			argument = {
-- 				trueLabel = "Enabled",
-- 				falseLabel = "Disabled",
-- 			},
-- 		},
-- 		{
-- 			key = "PlaceStacksModifierSetting",
-- 			name = "StackModifier",
-- 			description = 'Press with "activate" key to place stacks when hovering over a container.',
-- 			default = tostring(input.getKeyName(input.KEY.LeftShift)),
-- 			renderer = "inputBinding",
-- 			argument = {
-- 				disabled = true,
-- 				key = "PlaceStacksModifier",
-- 				type = "action",
-- 			},
-- 		},
-- 	},
-- })
