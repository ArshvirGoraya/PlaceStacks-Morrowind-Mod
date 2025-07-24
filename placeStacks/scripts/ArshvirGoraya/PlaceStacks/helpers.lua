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

	DB.log("Container is Valid: ", container)
	return true
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

return M
