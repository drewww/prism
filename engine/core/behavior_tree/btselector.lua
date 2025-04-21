--- A selector node in the behavior tree.
--- @class BTSelector : BTNode
--- @overload fun(children: BTNode[]): BTSelector
local BTSelector = prism.BehaviorTree.Node:extend("BTSelector")

--- Creates a new BTSelector.
--- @param children BTNode[]
function BTSelector:__new(children)
   self.children = children
end

--- Runs the selector node.
--- @param level Level
--- @param actor Actor
--- @param controller ControllerComponent
--- @return boolean|Action
function BTSelector:run(level, actor, controller)
   for i = 1, #self.children do
      local child = self.children[i]
      local result = child:run(level, actor, controller)
      if result then
         return result
      end
   end
   return false
end

return BTSelector
