local util = require("openmw_aux.util")

local M = {}

M.logging = false
M.logging = true -- comment this out in production builds!

function M.log(...)
	if not M.logging then
		return
	end
	print(...)
end

-- function M.uilog(...)
-- 	if not M.logging then
-- 		return
-- 	end
-- end

function M.printTable(t, maxDepth)
	if not M.logging then
		return
	end
	maxDepth = maxDepth or 1
	print("====")
	print(util.deepToString(t, maxDepth))
	print("====")
end

return M
