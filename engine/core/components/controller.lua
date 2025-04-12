--- @class ControllerComponent : Component
--- @field blackboard table|nil
--- @overload fun(): ControllerComponent
--- @type ControllerComponent
local Controller = prism.Component:extend("Controller")
Controller.name = "Controller"

---@return Action
function Controller:act(level, actor)
   error("Controller is an abstract class and must have act overwritten!")
end

return Controller
