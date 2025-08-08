local takeStacksArgs = {}
local M = {}

local function prepareTakeStacksArgs(focusedContainer, player, performOnAllItems, settingsTakeStacks)
	takeStacksArgs.sourceContainer = focusedContainer
	takeStacksArgs.targetContainer = player
	takeStacksArgs.performOnAllItems = performOnAllItems
	takeStacksArgs.transferOrder = settingsTakeStacks.TransferOrder
	takeStacksArgs.player = player
	takeStacksArgs.allowOverEncumbrance = settingsTakeStacks.AllowOverEncumbrance
	takeStacksArgs.notifyCountTransferred = settingsTakeStacks.NotifyCountTransferred
	takeStacksArgs.notifyCountNotTransferred = settingsTakeStacks.NotifyCountNotTransferred
	takeStacksArgs.items = PerformerHelpers.getItemsFromContainerInTransferOrder(
		takeStacksArgs.sourceContainer,
		takeStacksArgs.targetContainer,
		takeStacksArgs.transferOrder,
		performOnAllItems
	)
end

local function prepareTakeStacksNotification() end

local function performTakeStacksNotification()
	prepareTakeStacksNotification()
end

local function takeStacks() end

M.performTakeStacks = function(args)
	DB.log("\n==\nperformTakeStacks called!")
	local focusedContainer, player, uiMode, performOnAllItems, settingsCommonBehavior, settingsTakeStacks =
		table.unpack(args)

	if
		not Helpers.canPerformStackAction(focusedContainer, Types, uiMode, PlaceStacksGlobals:get("CurrentStackType"))
	then
		return
	end
	PlaceStacksGlobals:set("CurrentStackType", Keys.CONSTANT_KEYS.Options.StackType.Take)
	prepareTakeStacksArgs(focusedContainer, player, performOnAllItems, settingsTakeStacks)
	--
	takeStacks()
	performTakeStacksNotification()
	PerformerHelpers.performAutoClose()
	--
	PlaceStacksGlobals:set("CurrentStackType", Keys.CONSTANT_KEYS.Options.StackType.None)
end

return M
