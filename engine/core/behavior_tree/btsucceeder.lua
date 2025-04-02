--- A succeeder node in the behavior tree.
--- @class BTSucceeder : BTNode
--- @overload fun(node: BTNode): BTSucceeder
--- @type BTSucceeder
local BTSucceeder = prism.BehaviorTree.Node:extend("BTSucceeder")

--- Creates a new BTSucceeder.
--- @param node BTNode
function BTSucceeder:__new(node)
   self.node = node
end

--- Runs the succeeder node.
--- @param level prism.Level
--- @param actor prism.Actor
--- @param controller ControllerComponent
--- @return boolean|prism.Action
function BTSucceeder:run(level, actor, controller)
   local ret = self.node:run(level, actor, controller)
   if ret == false then
      return true
   end
   return ret
end

return BTSucceeder
