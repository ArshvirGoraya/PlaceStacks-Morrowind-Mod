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

local function getItemWeight(item)
	return item.type.record(item).weight
end

local function getItemValue(item)
	return item.type.record(item).value
end

function M.getItemName(item)
	return item.type.record(item).name
end

local function getItemRecordID(item)
	return item.type.record(item).id
end

local function getItemType(item)
	return tostring(item.type)
end

local function getItemValueWeightRatio(item)
	return getItemValue(item) / getItemWeight(item)
end

function M.sortItemsIntoTransferOrder(items, transferOrder)
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
			return getItemValueWeightRatio(a) > getItemValueWeightRatio(b)
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Heaviest then
		table.sort(items, function(a, b)
			return getItemWeight(a) > getItemWeight(b)
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Lightest then
		table.sort(items, function(a, b)
			return getItemWeight(a) < getItemWeight(b)
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Valuable then
		table.sort(items, function(a, b)
			return getItemValue(a) > getItemValue(b)
		end)
	elseif transferOrder == Keys.LOCALIZED_KEYS.Options.TransferOrder.Cheapest then
		table.sort(items, function(a, b)
			return getItemValue(a) < getItemValue(b)
		end)
	end

	if DB.logging then
		DB.log("items after ordering=====================")
		printAllItems(items)
	end

	return items
end

local function isItemEquipped(item, player, Types)
	return Types.Actor.hasEquipped(player, item)
end

local function isItemMoney(item)
	return getItemRecordID(item) == Keys.CONSTANT_KEYS.RecordIDs.gold
end

local function isItemConsidered(item, stackActionArgs, stackType, Types)
	if stackType == Keys.CONSTANT_KEYS.Options.StackType.Place then
		---@cast stackActionArgs PlaceStacksArgs
		if not stackActionArgs.depositEquipped then
			return not isItemEquipped(item, stackActionArgs.player, Types)
		end
		if not stackActionArgs.depositMoney then
			return not isItemMoney(item)
		end
	else
		---@cast stackActionArgs TakeStacksArgs
		return true
	end
end

function M.getStartingContainerCapacity(container, Types)
	if Types.Actor.objectIsInstance(container) then
		DB.log("target is player")
		return Types.Actor.getCapacity(container) - Types.Actor.getEncumbrance(container)
	else
		DB.log("target is container")
		return Types.Container.getCapacity(container) - Types.Container.getEncumbrance(container)
	end
end

function M.allItemsFitIntoContainer(containerCapacity, totalWeight)
	if DB.logging then
		DB.log(
			"container Capacity {"
				.. containerCapacity
				.. "} >= "
				.. "total items weight {"
				.. totalWeight
				.. "}: "
				.. tostring(containerCapacity >= totalWeight)
		)
	end
	return containerCapacity >= totalWeight
end

local function itemFitsCapacity(capacity, item)
	-- if DB.logging then
	-- 	DB.log(
	-- 		"container Capacity {"
	-- 			.. capacity
	-- 			.. "} >= "
	-- 			.. "item weight {"
	-- 			.. getItemWeight(item)
	-- 			.. "}: "
	-- 			.. tostring(capacity >= getItemWeight(item))
	-- 	)
	-- end
	return capacity >= getItemWeight(item)
end

---@param stackActionArgs PlaceStacksArgs | TakeStacksArgs
---@param notificationStruct NotificationStruct
local function filterUserDataItemsIntoTable(tbl, userDataItems, stackActionArgs, notificationStruct, stackType, Types)
	for _, item in pairs(userDataItems) do
		if isItemConsidered(item, stackActionArgs, stackType, Types) then
			if
				(stackType == Keys.CONSTANT_KEYS.Options.StackType.Take and stackActionArgs.allowOverEncumbrance)
				or itemFitsCapacity(stackActionArgs.startingTargetCapacity, item)
			then
				-- DB.log("transferable Item: ", M.getItemName(item))
				table.insert(tbl, item)
				-- else
				-- 	DB.log("item not transferable: ", M.getItemName(item))
			end
			M.updateNotificationStruct(notificationStruct, item, stackActionArgs)
		end
	end
	return tbl
end

---@param stackActionArgs PlaceStacksArgs | TakeStacksArgs
---@param notificationStruct NotificationStruct
function M.updateNotificationStruct(notificationStruct, item, stackActionArgs, stackSize)
	stackSize = stackSize or item.count

	if stackActionArgs.notifyTypesNotAllTransferred then
		notificationStruct.tableOfNotAllTransferredTypes[getItemType(item)] = true
	end
	if stackActionArgs.notifyCountTransferred then
		notificationStruct.totalConsidered.count = notificationStruct.totalConsidered.count + stackSize
	end
	if stackActionArgs.notifyValueTransferred then
		notificationStruct.totalConsidered.value = notificationStruct.totalConsidered.value
			+ getItemValue(item) * stackSize
	end

	-- weight value is used regardless of weight notifications setting
	notificationStruct.totalConsidered.weight = notificationStruct.totalConsidered.weight
		+ getItemWeight(item) * stackSize
end

---@param stackActionArgs PlaceStacksArgs | TakeStacksArgs
---@param notificationStruct NotificationStruct
function M.filterItemsIntoTable(stackActionArgs, notificationStruct, stackType, Types)
	local items = {}
	local userDataItems = nil

	---@diagnostic disable: undefined-field
	local sourceInventory = stackActionArgs.sourceContainer.type.inventory(stackActionArgs.sourceContainer)
	local targetInventory = stackActionArgs.targetContainer.type.inventory(stackActionArgs.targetContainer)
	---@diagnostic enable: undefined-field
	---
	if stackActionArgs.performOnAllItems then
		-- filter in all items
		userDataItems = sourceInventory:getAll()
		items =
			filterUserDataItemsIntoTable(items, userDataItems, stackActionArgs, notificationStruct, stackType, Types)
	else
		-- filter in only matching items
		local searchedItems = {}
		for _, item in pairs(targetInventory:getAll()) do
			if searchedItems[item.recordId] == nil then
				searchedItems[item.recordId] = true
				userDataItems = sourceInventory:findAll(item.recordId)
				items = filterUserDataItemsIntoTable(
					items,
					userDataItems,
					stackActionArgs,
					notificationStruct,
					stackType,
					Types
				)
			end
		end
	end
	return items
end

---@param notificationStruct NotificationStruct | nil
---@return NotificationStruct
function M.getCleanNotificationStruct(notificationStruct)
	if notificationStruct == nil then
		---@class NotificationStruct
		notificationStruct = {
			totalConsidered = {
				count = 0,
				value = 0,
				weight = 0,
			},
			totalTransferred = {
				count = 0,
				value = 0,
				weight = 0,
			},
			tableOfNotAllTransferredTypes = {},
			listOfNotAllTransferredTypes = {},
		}
	else
		---@cast notificationStruct NotificationStruct
		notificationStruct.totalConsidered.count = 0
		notificationStruct.totalConsidered.value = 0
		notificationStruct.totalConsidered.weight = 0

		notificationStruct.totalTransferred.count = 0
		notificationStruct.totalTransferred.value = 0
		notificationStruct.totalTransferred.weight = 0

		notificationStruct.tableOfNotAllTransferredTypes = {}
		notificationStruct.listOfNotAllTransferredTypes = {}
	end
	return notificationStruct
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
