-- if openMW API provides a better way to make enums (without explicitly setting the values) use that instead!

local M = {}

M.enumNames = {
	TRANSFER_ORDER = "TRANSFER_ORDER",
	STACK_TYPE = "STACK_TYPE",
	MODIFIER_SETTING = "MODIFIER_SETTING",
}

M.enumStrings = {
	TRANSFER_ORDER = { "Any", "Valuable", "Lightest", "Cheapest", "Heaviest" },
	STACK_TYPE = { "None", "Place", "Take" },
	MODIFIER_SETTING = { "Default", "Invert", "Disable" },
}

M.MODIFIER_SETTING = {
	Default = "Default",
	Invert = "Invert",
	Disable = "Disable",
}

local enumsReverse = {}

M.enums = {}
function M.makeEnums()
	for enumListKey, enumStringList in pairs(M.enumStrings) do
		M.enums[enumListKey] = {}
		enumsReverse[enumListKey] = {}
		for index, enumString in ipairs(enumStringList) do
			M.enums[enumListKey][enumString] = index
			enumsReverse[enumListKey][index] = enumString
		end
	end
	return M.enums
end

function M.enumToString(enumName, enumValue)
	return enumsReverse[enumName][enumValue]
end

function M.stringToEnum(enumName, enumString)
	return M.enums[enumName][enumString]
end

return M
