--- Defines what an actor does on its turn.
--- @class ControllerComponent : Component
--- @field blackboard table|nil
--- @overload fun(): ControllerComponent
local Controller = prism.Component:extend "ControllerComponent"
Controller.name = "Controller"

--- Returns the :lua:class:`Action` that the actor will take on its turn. 
--- This should not modify the :lua:class:`Level` directly.
--- @param level Level
--- @param actor Actor
--- @return Action
function Controller:act(level, actor)
   error("Controller is an abstract class and must have act overwritten!")
end

return Controller
