--- A sequence node in the behavior tree.
--- @class BTSequence : BTNode
--- @overload fun(children: BTNode[]): BTSequence
--- @type BTSequence
local BTSequence = prism.BehaviorTree.Node:extend("BTSequence")

--- Creates a new BTSequence.
--- @param children BTNode[]
function BTSequence:__new(children)
   self.children = children
end

--- Runs the sequence node.
--- @param level Level
--- @param actor Actor
--- @param controller ControllerComponent
--- @return boolean|Action
function BTSequence:run(level, actor, controller)
   for i, child in ipairs(self.children) do
      local result = child:run(level, actor, controller)
      if result == false then
         return false
      end
      if type(result) == "table" then
         return result
      end
   end
   return true
end

return BTSequence
