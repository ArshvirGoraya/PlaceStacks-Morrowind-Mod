local input = require("openmw.input")
local self = require("openmw.self")
local core = require("openmw.core")
local storage = require("openmw.storage")
local settingsHold = storage.playerSection("settingsPlaceStacksModHold")
local settingsNotify = storage.playerSection("settingsPlaceStacksModNotification")
local ui = require("openmw.ui")
local I = require("openmw.interfaces")

local focusedContainer = nil
local heldWhenOpening = false
local targetTime = 0

return {
	eventHandlers = {
		UiModeChanged = function(data)
			heldWhenOpening = false
			-- print("UiModeChanged from", data.oldMode, "to", data.newMode, "(" .. tostring(data.arg) .. ")")
			if data.newMode ~= "Container" then
				return
			end

			focusedContainer = data.arg

			if input.isActionPressed(input.ACTION.Activate) then -- depracted. says to use getBooleanActionValue instead, but there doesn't seem to be a registered action for Activate in input.actions yes... so can't?
				heldWhenOpening = true
				targetTime = core.getRealTime() + settingsHold:get("PlaceStacksHoldMS") / 1000 -- convert ms to seconds
			end
		end,

		PlaceStacksComplete = function(movedItemsCount)
			if settingsNotify:get("PlaceStacksNotify") then
				ui.showMessage("Placed Stacks: " .. tostring(movedItemsCount))
			end
			-- ui.updateAll() -- doesnt seem to work
			I.UI.setMode() -- exit container mode.
		end,
	},

	engineHandlers = {
		onFrame = function(dt)
			if input.isKeyPressed(input.KEY.G) then
				print("notify: ", settingsNotify:get("PlaceStacksNotify"))
			end
			-- Hold Activate when in container:
			if heldWhenOpening then
				if not input.isActionPressed(input.ACTION.Activate) then
					heldWhenOpening = false
					return
				end
				-- print("time remaining: ", targetTime - core.getRealTime())
				if core.getRealTime() >= targetTime then
					heldWhenOpening = false
					core.sendGlobalEvent("PlaceStacks", { sourceContainer = self, targetContainer = focusedContainer })
				end
			end
		end,
	},
}
