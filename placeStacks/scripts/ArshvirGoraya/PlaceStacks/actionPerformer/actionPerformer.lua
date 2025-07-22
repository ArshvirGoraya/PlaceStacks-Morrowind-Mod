local storage = require("openmw.storage")
local types = require("openmw.types")
local I = require("openmw.interfaces")
local DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
local helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
local takeStacksPerformer = require("scripts.ArshvirGoraya.PlaceStacks.actionPerformer.takeStacksPerformer")
local placeStacksPerformer = require("scripts.ArshvirGoraya.PlaceStacks.actionPerformer.placeStacksPerformer")

local function performContainerClose()
	if not helpers.canCloseContainer() then
		return
	end
	-- @UNFINISHED
end

local M = {
	eventHandlers = {
		performPlaceStacks = placeStacksPerformer.performPlaceStacks,
		performTakeStacks = takeStacksPerformer.performTakeStacks,
		performContainerClose = performContainerClose,
	},
}
return M
