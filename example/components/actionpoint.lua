--- @class ActionPointComponent : Component
local ActionPoint = prism.Component:extend( "ActionPointComponent" )
ActionPoint.name = "Move"

ActionPoint.actions = { prism.actions.EndTurn }

function ActionPoint:__new(options)
   self.actionPoints = options.actionPoints
   self.curActionPoints = options.actionPoints
end

return ActionPoint
