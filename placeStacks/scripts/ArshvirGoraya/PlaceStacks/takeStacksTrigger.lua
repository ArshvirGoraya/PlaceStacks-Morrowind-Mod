local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local ui = require("openmw.ui")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local input = require("openmw.input")
local storage = require("openmw.storage")

local takingStacks = false
local previousFrameTakeStacksActionValue = false

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
					-- just pressed
					if I.UI.getMode() == "Container" then
						self:sendEvent("TakeStacksTriggerCheck") -- leads to TakeStacksTriggerResponse
					end
				end
				previousFrameTakeStacksActionValue = input.getBooleanActionValue("TakeStacksKey")
			end
		end,
	},

	eventHandlers = {
		-- UiModeChanged = function(data)
		-- 	if data.newMode ~= "Container" then
		-- 	end
		-- end,

		TakeStacksComplete = function(args)
			DB.log("take stacks complete!")
			takingStacks = false
		end,
		TakeStacksTriggerResponse = function(args)
			if not args.inHeldOpenState and not takingStacks then -- dont take stacks if in held open state (when placing stacks from player into container)
				takingStacks = true
				core.sendGlobalEvent("TakeStacks", {
					sourceContainer = args.focusedContainer,
					targetContainer = self,
					player = self,
				})
			end
		end,
	},
}
