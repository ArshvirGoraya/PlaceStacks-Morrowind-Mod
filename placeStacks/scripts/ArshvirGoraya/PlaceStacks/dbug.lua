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

return M

