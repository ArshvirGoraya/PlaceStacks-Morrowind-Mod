local takeStacksArgs = {}
local M = {}

local function prepareTakeStacksArgs(focusedContainer, player, performOnAllItems, settingsTakeStacks)
	takeStacksArgs.sourceContainer = focusedContainer
	takeStacksArgs.targetContainer = player
	takeStacksArgs.performOnAllItems = performOnAllItems
	takeStacksArgs.transferOrder = settingsTakeStacks.TransferOrder
	takeStacksArgs.player = player
	takeStacksArgs.items = PerformerHelpers.getItemsFromContainerInTransferOrder(
		takeStacksArgs.sourceContainer,
		takeStacksArgs.transferOrder
	)
	takeStacksArgs.allowOverEncumbrance = settingsTakeStacks.AllowOverEncumbrance
	takeStacksArgs.notifyCountTransferred = settingsTakeStacks.NotifyCountTransferred
	takeStacksArgs.notifyCountNotTransferred = settingsTakeStacks.NotifyCountNotTransferred
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
		not PerformerHelpers.canPerformStackAction(
			focusedContainer,
			Types,
			uiMode,
			CurrentStackType,
			PerformerHelpers.enums.STACK_TYPE.Take
		)
	then
		return
	end
	CurrentStackType = PerformerHelpers.enums.STACK_TYPE.Take
	prepareTakeStacksArgs(focusedContainer, player, performOnAllItems, settingsTakeStacks)
	--
	takeStacks()
	performTakeStacksNotification()
	PerformerHelpers.performAutoClose()
	--
	CurrentStackType = PerformerHelpers.enums.STACK_TYPE.None
end

return M
