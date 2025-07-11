return {
	enumStackType = { -- if openMW API provides a better way to make enums (without explicitly setting the values) use that instead!
		all = 0,
		matching = 1,
	},

	isStackModifierKeyPressed = function(input, setting)
		return (input.isCtrlPressed() and setting == "Ctrl")
			or (input.isShiftPressed() and setting == "Shift")
			or (input.isAltPressed() and setting == "Alt")
			or (input.isSuperPressed() and setting == "Super")
	end,

	getRemainingCapacity = function(capacity, weight)
		return capacity - weight
	end,

	getMoveableItemsCount = function(item, capacity)
		local itemWeight = item.type.record(item).weight
		local moveableItemCount = math.floor(capacity / itemWeight) -- how many items of this weight can fit into this container?
		moveableItemCount = math.max(moveableItemCount, 0)
		if moveableItemCount >= item.count then -- all items in item stack can fit
			moveableItemCount = item.count
		end
		return moveableItemCount
	end,
}
