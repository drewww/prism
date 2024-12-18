--- @class BTControllerComponent : ControllerComponent
--- @field root BTRoot
--- @field blackboard table<string, any>
local BTController = prism.components.Controller:extend("BTControllerComponent")

function BTController:__new(behavior)
   assert(behavior:is(prism.BehaviorTree.Root))
   self.root = behavior
end

---@param level Level
---@param actor Actor
function BTController:act(level, actor)
   self.blackboard = {}
   return self.root:run(level, actor, actor:getComponent(prism.components.BTController))
end

return BTController
