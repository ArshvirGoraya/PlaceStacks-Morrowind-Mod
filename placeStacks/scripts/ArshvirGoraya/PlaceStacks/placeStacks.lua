local types = require("openmw.types")
local auxUtils = require("openmw_aux.util")

local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local sourceInventory = nil
local targetInventory = nil
local targetItemList = nil
local movedItemsCount = 0
local stackWeight = 0
local remainingCapacity = 0
local itemWeight = 0
local moveableItemCount = 0
local allItemsFit = true
-- local trackedEncumbrance = 0

return {
	eventHandlers = {
		PlaceStacks = function(args)
			sourceInventory = types.Container.inventory(args.sourceContainer)
			targetInventory = types.Container.inventory(args.targetContainer)
			DB.log("sourceContainer: ", auxUtils.deepToString(sourceInventory))
			DB.log("targetContainer: ", auxUtils.deepToString(targetInventory))

			-- loop through all items of source container and make a list.
			targetItemList = targetInventory:getAll() -- iterateable list of GameObjects
			if #targetItemList == 0 then -- empty list
				return
			end

			movedItemsCount = 0
			allItemsFit = false
			remainingCapacity = types.Container.getCapacity(args.targetContainer)
				- types.Container.getEncumbrance(args.targetContainer)
			-- trackedEncumbrance = types.Container.getEncumbrance(args.targetContainer)

			for _, item in pairs(targetItemList) do -- pairs instead of ipairs = no need for it to be ordered
				for _, sItem in pairs(sourceInventory:findAll(item.recordId)) do
					-- args.sourceContainer.hasEquipped(sourceContainer, sItem) -- check if item is equipped!

					-- Ensure to only place the amount of items that container can carry!
					-- remainingCapacity = types.Container.getCapacity(args.targetContainer) - types.Container.getEncumbrance(args.targetContainer)

					itemWeight = sItem.type.record(sItem).weight
					stackWeight = sItem.count * itemWeight
					moveableItemCount = math.floor(remainingCapacity / itemWeight) -- how many items of this weight can fit into this container?

					if moveableItemCount > sItem.count then -- all items in item stack can fit
						moveableItemCount = sItem.count
					else
						allItemsFit = false
					end
					-- trackedEncumbrance = trackedEncumbrance + moveableItemCount * itemWeight -- have to track encumbrance changes. cant use getEncumbrance because it doesn't actually change in value for some reason?
					remainingCapacity = remainingCapacity - moveableItemCount * itemWeight

					-- DB.log(
					-- 	"Container: ",
					-- 	types.Container.getEncumbrance(args.targetContainer),
					-- 	"/",
					-- 	types.Container.getCapacity(args.targetContainer),
					-- )
					DB.log("Encumbrance = ", trackedEncumbrance)
					DB.log("Remaining = ", remainingCapacity)
					DB.log("stackWeight: ", stackWeight)
					DB.log("can fit", moveableItemCount, "of: ", sItem.count, "(", sItem.recordId, ")")
					if moveableItemCount ~= 0 then
						-- sItem:split(moveableItemCount):moveInto(targetInventory)
						-- movedItemsCount = movedItemsCount + moveableItemCount

						local testItems = sItem:split(moveableItemCount)
						testItems:moveInto(targetInventory)
						movedItemsCount = movedItemsCount + moveableItemCount
						DB.log("moving Items: ", testItems.count)
					end
					DB.log("")
				end
			end
			args.sourceContainer:sendEvent(
				"PlaceStacksComplete",
				{ movedItemsCount = movedItemsCount, allItemsFit = allItemsFit }
			) -- send event to player
		end,
	},
}
