local M = {}

function M.sortItemsToTransferOrder(items, transferOrder)
	-- items = list of items that extend gameObject: https://openmw.readthedocs.io/en/openmw-0.49.0/reference/lua-scripting/openmw_core.html##(GameObject)
	-- >: decending (greatest to smallest)
	-- <: ascending (smallest to greatest)

	if DB.logging then
		DB.log("items before ordering: ", transferOrder)
		for _, v in ipairs(items) do
			DB.log("weight: " .. v.type.record(v).weight, "value: " .. v.type.record(v).value)
		end
	end

	if transferOrder == SettingsOptions.TransferOrder.Heaviest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight > b.type.record(b).weight
		end)
	elseif transferOrder == SettingsOptions.TransferOrder.Lightest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight < b.type.record(b).weight
		end)
	elseif transferOrder == SettingsOptions.TransferOrder.Valuable then
		table.sort(items, function(a, b)
			return a.type.record(a).value > b.type.record(b).value
		end)
	elseif transferOrder == SettingsOptions.TransferOrder.Cheapest then
		table.sort(items, function(a, b)
			return a.type.record(a).value < b.type.record(b).value
		end)
	end

	if DB.logging then
		DB.log("items after ordering=====================")
		for _, v in ipairs(items) do
			DB.log("weight: " .. v.type.record(v).weight, "value: " .. v.type.record(v).value)
		end
	end

	return items
end

local function getMatchingItemsFromContainers(sourceContainer, targetContainer)
	local matchingItems = {}
	local searchedItems = {}
	local source = sourceContainer.type.inventory(sourceContainer)
	local target = targetContainer.type.inventory(targetContainer)
	for _, tItem in pairs(target:getAll()) do
		if searchedItems[tItem.recordId] == nil then
			searchedItems[tItem.recordId] = true
		else
			goto continue
		end
		for _, sItem in pairs(source:findAll(tItem.recordId)) do
			table.insert(matchingItems, sItem)
		end
		::continue::
	end
	return matchingItems
end

local function getAllItemsFromContainer(container)
	local items = {}
	-- must convert item list to a table to be able to sort later
	local userDataItems = container.type.inventory(container):getAll()
	for _, item in pairs(userDataItems) do
		table.insert(items, item)
	end
	return items
end

local function getItemsFromContainer(sourceContainer, targetContainer, allItems)
	if allItems then
		return getAllItemsFromContainer(sourceContainer)
	end
	return getMatchingItemsFromContainers(sourceContainer, targetContainer)
end

function M.getItemsFromContainerInTransferOrder(sourceContainer, targetContainer, transferOrder, performOnAllItems)
	return M.sortItemsToTransferOrder(
		getItemsFromContainer(sourceContainer, targetContainer, performOnAllItems),
		transferOrder
	)
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
