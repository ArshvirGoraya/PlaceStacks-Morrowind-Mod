return {
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
