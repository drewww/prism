--- @class MoveComponent : Component
local Move = prism.Component:extend( "MoveComponent" )
Move.name = "Move"

Move.actions = {
   prism.actions.Move
}

function Move:__new(options)
   self.movePoints = options.movePoints
   self.curMovePoints = options.movePoints
end

return Move
