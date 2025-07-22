local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
-- local DB = require("dbug")

local M = {}

M.sharedVariables = {
	focusedContainer = nil,

	currentStackType = 0,

	notificationStruct = {
		countTransfered = 0,
		countNotTransfered = 0,
		typeNotTransfered = {},
	},

	placeStacksArgs = {
		sourceContainer = nil,
		targetContainer = nil,
		performOnAllItems = false,
		transferOrder = nil,
		player = nil,
		items = nil,
		depositEquipped = false,
		notifyCountTransferred = false,
		notifyCountNotTransferred = false,
		notifyTypeNotTransferred = false,
	},

	takeStacksArgs = {
		sourceContainer = nil,
		targetContainer = nil,
		performOnAllItems = false,
		transferOrder = nil,
		player = nil,
		items = nil,
		allowOverEncumbrance = false,
		notifyCountTransferred = false,
		notifyCountNotTransferred = false,
	},
}

function M.printTable(t, indent)
	indent = indent or 0
	local spacing = string.rep("  ", indent)

	for k, _ in pairs(t) do
		local v = t[k]
		if type(v) == "table" then
			DB.log(spacing .. tostring(k) .. ": {")
			M.printTable(v, indent + 1)
			DB.log(spacing .. "}")
		else
			DB.log(spacing .. tostring(k) .. ": " .. tostring(v))
		end
	end
end

-- if openMW API provides a better way to make enums (without explicitly setting the values) use that instead!
M.enumNames = {
	TRANSFER_ORDER = "TRANSFER_ORDER",
	STACK_TYPE = "STACK_TYPE",
}

M.enumStrings = {
	[M.enumNames.TRANSFER_ORDER] = { "Any", "Valuable", "Lightest", "Cheapest", "Heaviest" },
	[M.enumNames.STACK_TYPE] = { "None", "Place", "Take" },
}

M.enums = {}
local enumsReverse = {}

local function makeEnums()
	for enumListKey, enumStringList in pairs(M.enumStrings) do
		M.enums[enumListKey] = {}
		enumsReverse[enumListKey] = {}
		for index, enumString in ipairs(enumStringList) do
			M.enums[enumListKey][enumString] = index - 1 -- 0 index
			enumsReverse[enumListKey][index - 1] = enumString
		end
	end
end

makeEnums()

M.sharedVariables.currentStackType = M.enums.STACK_TYPE.None

if DB.logging then
	DB.log("made enums: ", M.enums)
	table.sort(M.enums)
	M.printTable(M.enums, 1)

	DB.log("made enums: ", enumsReverse)
	table.sort(enumsReverse)
	M.printTable(enumsReverse, 1)
end

function M.enumValueToEnumKey(enumName, enumValue)
	return enumsReverse[enumName][enumValue]
end

function M.getCurrentStackTypeString()
	DB.log("enum name: ", M.enumNames.STACK_TYPE)
	DB.log("current stacktype: ", M.sharedVariables.currentStackType)
	return M.enumValueToEnumKey(M.enumNames.STACK_TYPE, M.sharedVariables.currentStackType)
end

function M.canPerformStackAction(types, I, stackType)
	if not M.isValidContainerOpen(types, I) then
		DB.log(
			"attempt to "
				.. M.enumValueToEnumKey(M.enumNames.STACK_TYPE, stackType)
				.. " stacks while valid container is not open"
		)
		return false
	end

	if M.sharedVariables.currentStackType ~= M.enums.STACK_TYPE.None then
		if DB.logging then
			DB.log(
				"attempt to do "
					.. M.enumValueToEnumKey(M.enumNames.STACK_TYPE, stackType)
					.. " stacks while "
					.. M.getCurrentStackTypeString()
					.. " stacks is already running"
			)
		end
		return false
	end
	return true
end

function M.isContainerValid(container, types)
	if container == nil then
		return false
	end
	if types.Actor.objectIsInstance(container) and types.Actor.isDead(container) then
		return false
	end
	if not types.Container.objectIsInstance(container) then
		return false
	end

	DB.log("Container is Valid")
	return true
end
local function getItemsFromContainer(types, sourceContainer)
	return types.Container.inventory(sourceContainer):getAll()
end

local function sortItemsToTransferOrder(items, transferOrder)
	-- items = list of items that extend gameObject: https://openmw.readthedocs.io/en/openmw-0.49.0/reference/lua-scripting/openmw_core.html##(GameObject)
	-- >: decending (greatest to smallest)
	-- <: ascending (smallest to greatest)

	if DB.logging then
		DB.log("items before ordering")
		for _, v in ipairs(items) do
			DB.log("weight: " .. v.type.record.weight, "value: " .. v.type.record.value)
		end
	end

	if transferOrder == M.enums.TRANSFER_ORDER.Heaviest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight > b.type.record(b).weight
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Lightest then
		table.sort(items, function(a, b)
			return a.type.record(a).weight < b.type.record(b).weight
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Valuable then
		table.sort(items, function(a, b)
			return a.type.record(a).value > b.type.record(b).value
		end)
	elseif transferOrder == M.enums.TRANSFER_ORDER.Cheapest then
		table.sort(items, function(a, b)
			return a.type.record(a).value < b.type.record(b).value
		end)
	end

	if DB.logging then
		DB.log("items before ordering")
		for _, v in ipairs(items) do
			DB.log("weight: " .. v.type.record.weight, "value: " .. v.type.record.value)
		end
	end

	return items
end

function M.getItemsFromContainerInTransferOredr(types, sourceContainer, transferOrder)
	return sortItemsToTransferOrder(getItemsFromContainer(types, sourceContainer), transferOrder)
end

function M.isModifierKeyPressed(input, Modifier)
	return (input.isCtrlPressed() and Modifier == "Ctrl")
		or (input.isShiftPressed() and Modifier == "Shift")
		or (input.isAltPressed() and Modifier == "Alt")
		or (input.isSuperPressed() and Modifier == "Super")
end

function M.detectPerformOnAllItems(input, settingsCommonBehavior)
	local modifierPressed = M.isModifierKeyPressed(input, settingsCommonBehavior:get("Modifier"))
	local modifierIsAll = settingsCommonBehavior:get("ModifierIsAll")
	if modifierIsAll then
		return modifierPressed
	else
		return not modifierPressed
	end
end

function M.detectContainerOpened(data)
	-- DB.log("UiModeChanged from", data.oldMode, "to", data.newMode, "(" .. tostring(data.arg) .. ")")
	if data.oldMode == "Container" and data.newMode == "Container" then
		DB.log("Container Refreshed")
		return false
	end
	if data.newMode ~= "Container" then
		return false
	end
	return true
end

function M.isValidContainerOpen(types, I)
	if I.UI.getMode() ~= "Container" then
		return false
	end
	if not M.isContainerValid(M.sharedVariables.focusedContainer, types) then
		return false
	end
	return true
end

function M.detectPress(previousFramePress, currentFramePress)
	return (currentFramePress and not previousFramePress)
end

function M.currentlyStacking(tsp, psp)
	return tsp.currentlyStacking or psp.currentlyStacking
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

return M
