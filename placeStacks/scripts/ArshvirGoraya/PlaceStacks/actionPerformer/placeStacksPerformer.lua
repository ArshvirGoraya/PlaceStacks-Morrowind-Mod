local placeStacksArgs = {}
local M = {}

local function preparePlaceStacksArgs(focusedContainer, player, performOnAllItems, settingsPlaceStacks)
	placeStacksArgs.sourceContainer = player
	placeStacksArgs.targetContainer = focusedContainer
	placeStacksArgs.performOnAllItems = performOnAllItems
	placeStacksArgs.transferOrder = settingsPlaceStacks.TransferOrder
	placeStacksArgs.player = player
	placeStacksArgs.items = PerformerHelpers.getItemsFromContainerInTransferOrder(
		placeStacksArgs.sourceContainer,
		placeStacksArgs.targetContainer,
		placeStacksArgs.transferOrder,
		performOnAllItems
	)
	placeStacksArgs.depositEquipped = settingsPlaceStacks.DepositEquipped
	placeStacksArgs.notifyCountTransferred = settingsPlaceStacks.NotifyCountTransferred
	placeStacksArgs.notifyCountNotTransferred = settingsPlaceStacks.NotifyCountNotTransferred
	placeStacksArgs.notifyTypeNotTransferred = settingsPlaceStacks.NotifyTypeNotTransferred
end

local function preparePlaceStacksNotification() end

local function performPlaceStacksNotification()
	preparePlaceStacksNotification()
end

local function placeStacks() end

M.performPlaceStacks = function(args)
	DB.log("\n==\nperformPlaceStacks called!")
	-- Helpers.printTable(args)
	local focusedContainer, player, uiMode, performOnAllItems, settingsCommonBehavior, settingsPlaceStacks =
		table.unpack(args)

	-- DB.log("player: ", player)
	if
		not Helpers.canPerformStackAction(focusedContainer, Types, uiMode, PlaceStacksGlobals:get("CurrentStackType"))
	then
		return
	end
	PlaceStacksGlobals:set("CurrentStackType", Enums.STACK_TYPE.Place)
	preparePlaceStacksArgs(focusedContainer, player, performOnAllItems, settingsPlaceStacks)
	--
	placeStacks()
	performPlaceStacksNotification()
	PerformerHelpers.performAutoClose()
	PlaceStacksGlobals:set("CurrentStackType", Enums.STACK_TYPE.None)
end
return M
