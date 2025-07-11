local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
local ui = require("openmw.ui")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local input = require("openmw.input")
local storage = require("openmw.storage")
local settingsTakeStacksMod = storage.playerSection("settingsTakeStacksMod")
local settingsTakeStacksModNotification = storage.playerSection("settingsTakeStacksModNotification")

local takingStacks = false
local previousFrameTakeStacksActionValue = false
local focusedContainer = nil

local notificationString = ""

input.registerAction({
	key = "TakeStacksKey",
	type = input.ACTION_TYPE.Boolean,
	l10n = "PlaceStacks",
	name = "Take Stacks Key",
	description = "Triggers take stacks behaviour",
	defaultValue = false, -- boolean value
})

return {
	engineHandlers = {
		onFrame = function(dt)
			if input.getBooleanActionValue("TakeStacksKey") ~= previousFrameTakeStacksActionValue then
				if input.getBooleanActionValue("TakeStacksKey") then
					local stackType = helpers.enumStackType.matching
					if
						helpers.isStackModifierKeyPressed(
							input,
							settingsTakeStacksMod:get("TakeStacksActionModifierKey")
						)
					then
						stackType = helpers.enumStackType.all
					end
					-- just pressed
					if I.UI.getMode() == "Container" then
						self:sendEvent("TakeStacksTriggerCheck", { stackType = stackType }) -- leads to TakeStacksTriggerResponse
					end
				end
				previousFrameTakeStacksActionValue = input.getBooleanActionValue("TakeStacksKey")
			end
		end,
	},

	eventHandlers = {
		-- UiModeChanged = function(data)
		-- 	if data.newMode ~= "Container" then
		-- 		DB.log("not set to container")
		-- 	else
		-- 		DB.log("mode set to container")
		-- 	end
		-- end,

		TakeStacksComplete = function(args)
			DB.log("take stacks complete!")

			-- UI Behaviour

			local autoClose = settingsTakeStacksMod:get("TakeStacksAutoClose")
			-- DB.log("autoclose setting: ", autoClose)
			DB.log("all items fit: ", args.allItemsFit)

			if autoClose == "All Fit" then
				if args.allItemsFit then
					autoClose = "Always"
				else
					autoClose = "Never"
				end
			end
			if autoClose == "Never" then
				DB.log("set to container!")
				I.UI.setMode("Container", { target = focusedContainer }) -- will call uiModeChanged!
			else
				I.UI.setMode()
			end
			if settingsTakeStacksModNotification:get("TakeStacksNotify") then
				notificationString = ""
				if settingsTakeStacksModNotification:get("TakeStacksNotifyTakeCount") then
					notificationString = notificationString .. "Take Stacks: " .. tostring(args.movedItemsCount)
				end
				if not args.allItemsFit then
					if settingsTakeStacksModNotification:get("TakeStacksNotifyNotTakenCount") then
						if settingsTakeStacksModNotification:get("TakeStacksNotifyTakeCount") then
							notificationString = notificationString .. "\n"
						end
						notificationString = notificationString .. "Not Taken: " .. tostring(args.unfittableItemsCount)
					end
				end
				ui.showMessage(notificationString)
			end

			takingStacks = false
		end,

		TakeStacksTriggerResponse = function(args)
			if not args.inHeldOpenState and not takingStacks then -- dont take stacks if in held open state (when placing stacks from player into container)
				focusedContainer = args.focusedContainer
				takingStacks = true
				core.sendGlobalEvent("TakeStacks", {
					sourceContainer = args.focusedContainer,
					targetContainer = self,
					player = self,
					allowOverEncumber = settingsTakeStacksMod:get("TakeStacksOverEncumber"),
					stackType = args.stackType,
				})
			end
		end,
	},
}
