local M = {}

local function printItem(item)
	DB.log(
		"weight: " .. item.type.record(item).weight,
		"value: " .. item.type.record(item).value,
		"id: " .. item.type.record(item).name .. "(" .. item.type.record(item).id .. ")"
	)
end

local function printAllItems(items)
	for _, v in ipairs(items) do
		printItem(v)
	end
end

function M.sortItemsToTransferOrder(items, transferOrder)
	-- items = list of items that extend gameObject: https://openmw.readthedocs.io/en/openmw-0.49.0/reference/lua-scripting/openmw_core.html##(GameObject)
	-- >: decending (greatest to smallest)
	-- <: ascending (smallest to greatest)

	if DB.logging then
		DB.log("items before ordering: ", transferOrder)
		printAllItems(items)
	end

	if transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.ValuableByWeight then
		-- 0/1 knapsack problem - greedy solution: does not guarantee best set of items:
		-- - Can miss a lower value-weight ratio item that, when paired with others, gives a better total value
		-- Dynamic programming approach is better but requires a hard decision of a weight interval in this case.
		-- - Must loop through weight intervals up to the container capacity: how big the interval is depends on how granular you want to get.
		-- - The more granular the more accurate but the longer it will take. The smallest items in Morrowind can be as low as 0.01?
		-- - Other mods may also add items that are less than that.
		-- - That much granularity is not optimal, but required for accuracy.
		-- - A possible solution is treating items smaller than 1 as simply being 1.
		--  - But treating a value of 100 by 0.01 the same as 100 by 1 has negative side effects of potentially not being able to take a bunch of the 0.01's.
		-- For now just doing this greedy solution instead.
		table.sort(items, function(a, b)
			-- no tie breaker
			return (a.type.record(a).value / a.type.record(a).weight)
				> (b.type.record(b).value / b.type.record(b).weight)
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Heaviest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight > b.type.record(b).weight
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Lightest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight < b.type.record(b).weight
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Valuable then
		table.sort(items, function(a, b)
			return a.type.record(a).value > b.type.record(b).value
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Cheapest then
		table.sort(items, function(a, b)
			return a.type.record(a).value < b.type.record(b).value
		end)
	end

	if DB.logging then
		DB.log("items after ordering=====================")
		printAllItems(items)
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
