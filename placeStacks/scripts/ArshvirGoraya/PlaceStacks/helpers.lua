local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
-- local DB = require("dbug")

local M = {}

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

-- used in both performer and detector

function M.canPerformStackAction(focusedContainer, types, uiMode, currentStackType)
	if not M.isValidContainerOpen(focusedContainer, types, uiMode) then
		-- DB.log("attempt to perform stack action while valid container is not open")
		return false
	end

	if currentStackType ~= Enums.STACK_TYPE.None then
		-- if DB.logging then
		-- 	DB.log(
		-- 		"attempt to do stack action"
		-- 			.. " stacks while "
		-- 			.. M.stackTypeToString(currentStackType)
		-- 			.. " stacks is already running"
		-- 	)
		-- end
		return false
	end
	return true
end

function M.isValidContainerOpen(focusedContainer, types, uiMode)
	if uiMode ~= "Container" then
		-- DB.log("ui mode does not equal container: ", uiMode)
		return false
	end
	if not M.isContainerValid(focusedContainer, types) then
		return false
	end
	return true
end

function M.isContainerValid(container, types)
	if container == nil then
		return false
	end
	if types.Actor.objectIsInstance(container) then
		return not types.Actor.isDead(container)
	end
	if not types.Container.objectIsInstance(container) then
		return false
	end

	-- DB.log("Container is Valid: ", container)
	return true
end

function M.stackTypeToString(stackType)
	return EnumHelpers.enumToString(EnumHelpers.enumNames.STACK_TYPE, stackType)
end

return M
