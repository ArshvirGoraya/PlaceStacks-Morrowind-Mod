-- GLOBAL SCRIPT
--
-- API Globals
Types = require("openmw.types")
Core = require("openmw.core")
-- I = require("openmw.interfaces") -- I.UI is onlyt accessed through player script. must send it
-- Input = require("openmw.input") -- cant use input in global script must send from player script.
Storage = require("openmw.storage")
-- Custom Globals
DB = require("scripts.ArshvirGoraya.PlaceStacks.dbug")
Helpers = require("scripts.ArshvirGoraya.PlaceStacks.helpers")
PerformerHelpers = require("scripts.ArshvirGoraya.PlaceStacks.actionPerformer.performerHelpers")
-- Custom Var Globals
CurrentStackType = PerformerHelpers.enums.STACK_TYPE.None
-- Locals
local tsp = require("scripts.ArshvirGoraya.PlaceStacks.actionPerformer.takeStacksPerformer")
local psp = require("scripts.ArshvirGoraya.PlaceStacks.actionPerformer.placeStacksPerformer")
--

local M = {
	eventHandlers = {
		performPlaceStacks = psp.performPlaceStacks,
		performTakeStacks = tsp.performTakeStacks,
	},
}
return M
