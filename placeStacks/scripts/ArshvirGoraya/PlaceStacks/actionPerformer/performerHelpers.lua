local M = {}

function M.sortItemsToTransferOrder(items, transferOrder)
	-- items = list of items that extend gameObject: https://openmw.readthedocs.io/en/openmw-0.49.0/reference/lua-scripting/openmw_core.html##(GameObject)
	-- >: decending (greatest to smallest)
	-- <: ascending (smallest to greatest)

	local sortedReferencesOfItems = {}

	local length = #items

	-- require making a proper table for table.sort -- is userdata. Could create custom sort function that handles userdata instead?
	for i = 1, length do
		sortedReferencesOfItems[i] = items[i]
	end

	transferOrder = EnumHelpers.stringToEnum(EnumHelpers.enumNames.TRANSFER_ORDER, transferOrder)

	if DB.logging then
		DB.log(
			"sortedReferencesOfItems before ordering: ",
			EnumHelpers.enumToString(EnumHelpers.enumNames.TRANSFER_ORDER, transferOrder)
		)
		for _, v in ipairs(sortedReferencesOfItems) do
			DB.log("weight: " .. v.type.record(v).weight, "value: " .. v.type.record(v).value)
		end
	end

	if transferOrder == Enums.TRANSFER_ORDER.Heaviest then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).weight > b.type.record(b).weight
		end)
	elseif transferOrder == Enums.TRANSFER_ORDER.Lightest then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).weight < b.type.record(b).weight
		end)
	elseif transferOrder == Enums.TRANSFER_ORDER.Valuable then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).value > b.type.record(b).value
		end)
	elseif transferOrder == Enums.TRANSFER_ORDER.Cheapest then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).value < b.type.record(b).value
		end)
	end

	if DB.logging then
		DB.log("sortedReferencesOfItems after ordering=====================")
		for _, v in ipairs(sortedReferencesOfItems) do
			DB.log("weight: " .. v.type.record(v).weight, "value: " .. v.type.record(v).value)
		end
	end

	return sortedReferencesOfItems
end

local function getItemsFromContainer(sourceContainer)
	DB.log("source container: ", sourceContainer)
	return sourceContainer.type.inventory(sourceContainer):getAll()
end

function M.getItemsFromContainerInTransferOrder(sourceContainer, transferOrder)
	return M.sortItemsToTransferOrder(getItemsFromContainer(sourceContainer), transferOrder)
end

function M.getRemainingCapacity(capacity, weight)
	return capacity - weight
end

function M.getMoveableItemsCountFromStack(item, capacity)
	local itemWeight = item.type.record(item).weight
	local moveableItemCount = math.floor(capacity / itemWeight) -- how many items of this weight can fit into this container?
	moveableItemCount = math.max(moveableItemCount, 0)
	if moveableItemCount >= item.count then -- all items in item stack can fit
		moveableItemCount = item.count
	end
	return moveableItemCount
end

function M.performAutoClose()
	-- @UNFINISHED
	DB.log("performing auto close!")
	-- if not helpers.canCloseContainer() then
	-- 	return
	-- end
end

return M
