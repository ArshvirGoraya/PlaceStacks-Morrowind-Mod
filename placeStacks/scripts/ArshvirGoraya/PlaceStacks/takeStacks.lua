local types = require("openmw.types")
local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
local sourceInventory = nil
local targetInventory = nil
local targetItemList = nil
local sourceItemList = nil

local remainingCapacity = nil
local allowOverEnumber = false

local itemWeight = nil
local stackWeight = nil
local moveableItemCount = nil

local allItemsFit = true

local movedItemsCount = 0

return {
	eventHandlers = {
		TakeStacks = function(args)
			sourceInventory = types.Container.inventory(args.sourceContainer)
			targetInventory = types.Container.inventory(args.targetContainer)
			allowOverEnumber = args.allowOverEncumber

			DB.log("allowOverEncumber: ", allowOverEnumber)

			-- targetItemList = targetInventory:getAll()
			sourceItemList = sourceInventory:getAll()

			remainingCapacity = types.Actor.getCapacity(args.targetContainer)
				- types.Actor.getEncumbrance(args.targetContainer)

			for _, sItem in pairs(sourceItemList) do
				itemWeight = sItem.type.record(sItem).weight

				if not allowOverEnumber then
					if DB.logging then
						local stackCount = sItem.count
						moveableItemCount = helpers.getMoveableItemsCount(sItem, remainingCapacity)
						if moveableItemCount ~= stackCount then
							DB.log(
								"can't take whole stack: ",
								moveableItemCount
									.. "["
									.. moveableItemCount * itemWeight
									.. "]"
									.. " ~= "
									.. stackCount
									.. "["
									.. stackCount * itemWeight
									.. "]"
							)
						end
					end
					moveableItemCount = helpers.getMoveableItemsCount(sItem, remainingCapacity)
					remainingCapacity = helpers.getRemainingCapacity(remainingCapacity, moveableItemCount * itemWeight)
					allItemsFit = moveableItemCount >= sItem.count
					if moveableItemCount > 0 then
						movedItemsCount = movedItemsCount + moveableItemCount
						sItem:split(moveableItemCount):moveInto(targetInventory)
					end
				else
					-- allow overEncumber (still have to check if overEncumbered in the end)
					if allItemsFit then
						remainingCapacity = helpers.getRemainingCapacity(remainingCapacity, sItem.count * itemWeight)
						allItemsFit = remainingCapacity > 0
					end
					movedItemsCount = movedItemsCount + sItem.count
					sItem:moveInto(targetInventory)
				end
			end
			--
			args.player:sendEvent("TakeStacksComplete", {
				allItemsFit = allItemsFit,
				movedItemsCount = movedItemsCount,
			})
		end,
	},
}
