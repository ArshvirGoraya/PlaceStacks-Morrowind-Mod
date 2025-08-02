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
	maxDepth = maxDepth or 1
	M.log("====")
	M.log(util.deepToString(t, maxDepth))
	M.log("====")
end

return M
