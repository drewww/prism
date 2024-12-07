--- The root node of a behavior tree.
--- @class BTRoot : BTNode
--- @overload fun(children: BTNode[]): BTRoot
--- @type BTRoot
local BTRoot = prism.BehaviorTree.Node:extend("BTRoot")

--- Creates a new BTRoot.
--- @param children BTNode[]
function BTRoot:__new(children) 
   self.children = children 
end

--- Runs the behavior tree starting from this root node.
--- @param level Level
--- @param actor Actor
--- @return Action
function BTRoot:run(level, actor)
   for i = 1, #self.children do
      local child = self.children[i]
      local result = child:run(level, actor)
      if result and type(result) ~= "boolean" and result:is(prism.Action) then 
         --- @type Action
         return result 
      end
   end

   error "Root node must return an action"
end

return BTRoot
