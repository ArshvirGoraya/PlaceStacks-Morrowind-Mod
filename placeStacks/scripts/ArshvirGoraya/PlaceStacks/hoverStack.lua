local input = require("openmw.input")
local async = require("openmw.async")
local self = require("openmw.self")
local nearby = require("openmw.nearby")

local castingRay = false

print("hoverstack loaded")

input.registerActionHandler(
	"Activate",
	async:callback(function()
		print("activate pressed")
	end)
)

-- local activation = require("openmw.interfaces").Activation -- only available in 0.50!
-- if activation == nil then
-- 	print("activation is nill")
-- end
--
-- local containerHandler = function()
-- 	print("container accessed!")
-- end

-- activation.addHandlerForType(types.Container, containerHandler)
-- activation.addHandlerForType(types.NPC, containerHandler)

-- if sneaking, then activating will open container on the alive NPC, sneaking not required if npc is dead.
-- if self.controls.ActionControls.sneak then
-- end

return {
	-- engineHandlers = {
	-- 	onUpdate = function(dt)
	-- 		if castingRay then
	-- 			-- check if ray hit anything yet.
	-- 			return
	-- 		end
	-- 		if not input.isActionPressed(input.ACTION.Activate) then
	-- 			return
	-- 		end
	-- 		castingRay = true
	-- 		-- start casting ray from play position to player reach
	-- 		nearby.castRay(from, to, {
	-- 			collisionType = nearby.COLLISION_TYPE.AnyPhysical,
	-- 		})
	-- 	end,
	-- },
}
