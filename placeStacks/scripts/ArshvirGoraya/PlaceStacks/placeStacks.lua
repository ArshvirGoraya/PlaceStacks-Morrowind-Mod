local types = require("openmw.types")
local auxUtils = require("openmw_aux.util")

local sourceInventory = nil
local targetInventory = nil
local targetItemList = nil
local movedItemsCount = 0

return {
	-- engineHandlers = {
	-- 	onPlayerAdded = function(player)
	-- 		playerReference = player
	-- 	end,
	-- },
	eventHandlers = {
		PlaceStacks = function(args)
			sourceInventory = types.Container.inventory(args.sourceContainer)
			targetInventory = types.Container.inventory(args.targetContainer)
			print("sourceContainer: ", auxUtils.deepToString(sourceInventory))
			print("targetContainer: ", auxUtils.deepToString(targetInventory))

			-- loop through all items of source container and make a list.
			targetItemList = targetInventory:getAll() -- iterateable list of GameObjects
			if #targetItemList == 0 then -- empty list
				return
			end

			movedItemsCount = 0

			for _, item in pairs(targetItemList) do -- pairs instead of ipairs = no need for it to be ordered
				-- print(item, ": ", targetInventory:countOf(item.recordId))
				for _, sItem in pairs(sourceInventory:findAll(item.recordId)) do
					-- gameobjectReference = sItem
					movedItemsCount = movedItemsCount + sourceInventory:countOf(sItem.recordId)
					print("source Inventory has: ", sItem.recordId, "->", sourceInventory:countOf(sItem.recordId))
					sItem:moveInto(targetInventory)
				end
			end
			if movedItemsCount > 0 then
				-- send signal to player script
				args.sourceContainer:sendEvent("PlaceStacksComplete", movedItemsCount) -- reference to player so can send event (cant use self and cant send local events from global script?)
			end
		end,
	},
}
