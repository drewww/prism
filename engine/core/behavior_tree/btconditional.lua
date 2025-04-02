--- A conditional node in the behavior tree.
--- @class BTConditional : BTNode
--- @overload fun(conditionFunc: fun(level: prism.Level, actor: prism.Actor)): BTConditional
--- @type BTConditional
local BTConditional = prism.BehaviorTree.Node:extend("BTConditional")

--- Creates a new BTConditional.
--- @param conditionFunc fun(self, level: prism.Level, actor: prism.Actor): boolean
function BTConditional:__new(conditionFunc)
   self.conditionFunc = conditionFunc
end

--- Runs the conditional node.
--- @param level prism.Level
--- @param actor prism.Actor
--- @param controller ControllerComponent
--- @return boolean|prism.Action
function BTConditional:run(level, actor, controller)
   return self:conditionFunc(level, actor)
end

return BTConditional
