local M = {}

-- used in both performer and detector

function M.canPerformStackAction(focusedContainer, types, uiMode, currentStackType)
	if not M.isValidContainerOpen(focusedContainer, types, uiMode) then
		-- DB.log("attempt to perform stack action while valid container is not open")
		return false
	end

	if currentStackType ~= Keys.CONSTANT_KEYS.Options.StackType.None then
		-- if DB.logging then
		-- 	DB.log(
		-- 		"attempt to do stack action"
		-- 			.. " stacks while "
		-- 			.. currentStackType
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

	return true
end

return M
