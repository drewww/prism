--- @class BTControllerComponent : ControllerComponent
local BTController = prism.components.Controller:extend("BTControllerComponent")

function BTController:__new(behavior)
   assert(behavior:is(prism.BehaviorTree.Root))
   self.root = behavior
end

---@param level Level
---@param actor Actor
function BTController:act(level, actor)
   return self.root:run(level, actor)
end

return BTController
