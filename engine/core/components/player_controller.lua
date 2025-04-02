--- @class PlayerControllerComponent : ControllerComponent
--- @overload fun(): ControllerComponent
--- @type PlayerControllerComponent
local PlayerController = prism.components.Controller:extend("PlayerController")

---@param level prism.Level
---@param actor prism.Actor
function PlayerController:act(level, actor)
   local actionDecision = level:yield(prism.decisions.ActionDecision(actor))
   --- @cast actionDecision prism.decisions.ActionDecision

   return actionDecision.action
end

return PlayerController
