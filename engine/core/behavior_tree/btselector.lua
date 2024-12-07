--- A selector node in the behavior tree.
--- @class BTSelector : BTNode
--- @overload fun(children: BTNode[]): BTSelector
--- @type BTSelector
local BTSelector = prism.BehaviorTree.Node:extend("BTSelector")

--- Creates a new BTSelector.
--- @param children BTNode[]
function BTSelector:__new(children) 
    self.children = children 
end

--- Runs the selector node.
--- @param level Level
--- @param actor Actor
--- @return boolean|Action
function BTSelector:run(level, actor)
   for i = 1, #self.children do
      local child = self.children[i]
      local result = child:run(level, actor)
      if result then 
          return result 
      end
   end
   return false
end

return BTSelector
