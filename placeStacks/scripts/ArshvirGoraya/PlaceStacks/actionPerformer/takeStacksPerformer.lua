local M = {}

local function prepareTakeStacksArgs(types, input, player, settingsCommonBehavior, settingsTakeStacks, helpers)
	helpers.sharedVariables.takeStacksArgs.sourceContainer = helpers.sharedVariables.focusedContainer
	helpers.sharedVariables.takeStacksArgs.targetContainer = self
	helpers.sharedVariables.takeStacksArgs.performOnAllItems =
		helpers.detectPerformOnAllItems(input, settingsCommonBehavior)
	helpers.sharedVariables.takeStacksArgs.transferOrder = settingsTakeStacks:get("TransferOrder")
	helpers.sharedVariables.takeStacksArgs.player = player
	helpers.sharedVariables.takeStacksArgs.items = helpers.getItemsFromContainerInTransferOrder(
		types,
		helpers.sharedVariables.takeStacksArgs.sourceContainer,
		helpers.sharedVariables.takeStacksArgs.transferOrder
	)
	helpers.sharedVariables.takeStacksArgs.allowOverEncumbrance = settingsTakeStacks:get("AllowOverEncumbrance")
	helpers.sharedVariables.takeStacksArgs.notifyCountTransferred = settingsTakeStacks:get("NotifyCountTransferred")
	helpers.sharedVariables.takeStacksArgs.notifyCountNotTransferred =
		settingsTakeStacks:get("NotifyCountNotTransferred")
end

local function prepareTakeStacksNotification() end

local function performTakeStacksNotification()
	prepareTakeStacksNotification()
end

local function takeStacks() end

M.performTakeStacks = function(core, input, types, I, storage, player, helpers, DB)
	DB.log("\n==\nperformTakeStacks called!")
	if not helpers.canPerformStackAction(types, I, helpers.enums.STACK_TYPE.Take) then
		return
	end
	local settingsTakeStacks = storage.playerSection("settingsTakeStacks")
	local settingsCommonBehavior = storage.playerSection("settingsCommonBehavior")
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.Take
	prepareTakeStacksArgs(types, input, player, settingsCommonBehavior, settingsTakeStacks, helpers)
	--
	takeStacks()
	performTakeStacksNotification()
	core.sendGlobalEvent("performContainerClose")
	--
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.None
end

return M
