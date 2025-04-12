--- A conditional node in the behavior tree.
--- @class BTConditional : BTNode
--- @overload fun(conditionFunc: fun(level: Level, actor: Actor)): BTConditional
--- @type BTConditional
local BTConditional = prism.BehaviorTree.Node:extend("BTConditional")

--- Creates a new BTConditional.
--- @param conditionFunc fun(self, level: Level, actor: Actor): boolean
function BTConditional:__new(conditionFunc)
   self.conditionFunc = conditionFunc
end

--- Runs the conditional node.
--- @param level Level
--- @param actor Actor
--- @param controller ControllerComponent
--- @return boolean|Action
function BTConditional:run(level, actor, controller)
   return self:conditionFunc(level, actor)
end

return BTConditional
