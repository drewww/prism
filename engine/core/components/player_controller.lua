--- @class PlayerControllerComponent : ControllerComponent
--- @overload fun(): ControllerComponent
--- @type PlayerControllerComponent
local PlayerController = prism.components.Controller:extend("PlayerController")

---@param level Level
---@param actor Actor
function PlayerController:act(level, actor)
   local action = level:yield(actor)
   assert(action, "UI returned a nil action!")

   return action
end

return PlayerController
