local M = {}

M.enums = {}
local enumsReverse = {}
local function makeEnums()
	for enumListKey, enumStringList in pairs(Helpers.enumStrings) do
		M.enums[enumListKey] = {}
		enumsReverse[enumListKey] = {}
		for index, enumString in ipairs(enumStringList) do
			M.enums[enumListKey][enumString] = index - 1 -- 0 index
			enumsReverse[enumListKey][index - 1] = enumString
		end
	end
end
makeEnums()

if DB.logging then
	DB.log("made enums: ", M.enums)
	table.sort(M.enums)
	Helpers.printTable(M.enums, 1)
	-- DB.log("made enums reverse: ", enumsReverse)
	-- table.sort(enumsReverse)
	-- Helpers.printTable(enumsReverse, 1)
end

local function enumToString(enumName, enumValue)
	return enumsReverse[enumName][enumValue]
end

local function stringToEnum(enumName, enumString)
	return M.enums[enumName][enumString]
end

function M.stackTypeToString(stackType)
	return enumToString(Helpers.enumNames.STACK_TYPE, stackType)
end

function M.canPerformStackAction(focusedContainer, types, uiMode, currentStackType, targetStackType)
	if not M.isValidContainerOpen(focusedContainer, types, uiMode) then
		DB.log("attempt to " .. M.stackTypeToString(targetStackType) .. " stacks while valid container is not open")
		return false
	end

	if currentStackType ~= M.enums.STACK_TYPE.None then
		if DB.logging then
			DB.log(
				"attempt to do "
					.. M.stackTypeToString(targetStackType)
					.. " stacks while "
					.. M.stackTypeToString(currentStackType)
					.. " stacks is already running"
			)
		end
		return false
	end
	return true
end

function M.isValidContainerOpen(focusedContainer, types, uiMode)
	if uiMode ~= "Container" then
		DB.log("ui mode does not equal container: ", uiMode)
		return false
	end
	if not Helpers.isContainerValid(focusedContainer, types) then
		return false
	end
	return true
end

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

	transferOrder = stringToEnum(Helpers.enumNames.TRANSFER_ORDER, transferOrder)

	if DB.logging then
		DB.log(
			"sortedReferencesOfItems before ordering: ",
			enumToString(Helpers.enumNames.TRANSFER_ORDER, transferOrder)
		)
		for _, v in ipairs(sortedReferencesOfItems) do
			DB.log("weight: " .. v.type.record(v).weight, "value: " .. v.type.record(v).value)
		end
	end

	if transferOrder == M.enums.TRANSFER_ORDER.Heaviest then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).weight > b.type.record(b).weight
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Lightest then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).weight < b.type.record(b).weight
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Valuable then
		table.sort(sortedReferencesOfItems, function(a, b)
			return a.type.record(a).value > b.type.record(b).value
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Cheapest then
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
