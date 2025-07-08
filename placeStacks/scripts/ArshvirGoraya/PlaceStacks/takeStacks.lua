local types = require("openmw.types")
local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local sourceInventory = nil
local targetInventory = nil
local targetItemList = nil
local sourceItemList = nil

return {
	eventHandlers = {
		TakeStacks = function(args)
			sourceInventory = types.Container.inventory(args.sourceContainer)
			targetInventory = types.Container.inventory(args.targetContainer)

			targetItemList = targetInventory:getAll()
			sourceItemList = sourceInventory:getAll()

			for _, item in pairs(targetItemList) do -- pairs instead of ipairs = no need for it to be ordered
			end
			DB.log("take stacks complete")
			args.player:sendEvent("TakeStacksComplete", {})
		end,
	},
}
