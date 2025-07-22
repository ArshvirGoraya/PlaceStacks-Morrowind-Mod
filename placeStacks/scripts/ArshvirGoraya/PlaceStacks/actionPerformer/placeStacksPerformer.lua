local M = {}

local function preparePlaceStacksArgs(types, input, player, settingsCommonBehavior, settingsPlaceStacks, helpers)
	helpers.sharedVariables.placeStacksArgs.sourceContainer = self
	helpers.sharedVariables.placeStacksArgs.targetContainer = helpers.sharedVariables.focusedContainer
	helpers.sharedVariables.placeStacksArgs.performOnAllItems =
		helpers.detectPerformOnAllItems(input, settingsCommonBehavior)
	helpers.sharedVariables.placeStacksArgs.transferOrder = settingsPlaceStacks:get("TransferOrder")
	helpers.sharedVariables.placeStacksArgs.player = player
	helpers.sharedVariables.placeStacksArgs.items = helpers.getItemsFromContainerInTransferOrder(
		types,
		helpers.sharedVariables.placeStacksArgs.sourceContainer,
		helpers.sharedVariables.placeStacksArgs.transferOrder
	)
	helpers.sharedVariables.placeStacksArgs.depositEquipped = settingsPlaceStacks:get("DepositEquipped")
	helpers.sharedVariables.placeStacksArgs.notifyCountTransferred = settingsPlaceStacks:get("NotifyCountTransferred")
	helpers.sharedVariables.placeStacksArgs.notifyCountNotTransferred =
		settingsPlaceStacks:get("NotifyCountNotTransferred")
	helpers.sharedVariables.placeStacksArgs.notifyTypeNotTransferred =
		settingsPlaceStacks:get("NotifyTypeNotTransferred")
end

local function preparePlaceStacksNotification() end

local function performPlaceStacksNotification()
	preparePlaceStacksNotification()
end

local function placeStacks() end

M.performPlaceStacks = function(core, input, types, I, storage, player, helpers, DB)
	DB.log("\n==\nperformPlaceStacks called")
	if not helpers.canPerformStackAction(types, I, helpers.enums.STACK_TYPE.Place) then
		return
	end
	local settingsPlaceStacks = storage.playerSection("settingsPlaceStacks")
	local settingsCommonBehavior = storage.playerSection("settingsCommonBehavior")
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.Place
	preparePlaceStacksArgs(types, input, player, settingsCommonBehavior, settingsPlaceStacks, helpers)
	--
	placeStacks()
	performPlaceStacksNotification()
	core.sendGlobalEvent("performContainerClose")
	--
	helpers.sharedVariables.currentStackType = helpers.enums.STACK_TYPE.None
end
return M
