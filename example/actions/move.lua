local PointTarget = prism.Target:extend("PointTarget")
PointTarget.typesAllowed = { Point = true }
PointTarget.range = 1

local Move = prism.Action:extend("MoveAction")
Move.name = "move"
Move.silent = true
Move.targets = { PointTarget }

function Move:perform(level)
   --- @type Vector2
   local destination = self:getTarget(1)

   if level:getCellPassable(destination.x, destination.y) then
      local moveComponent = self.owner:getComponent(prism.components.Move)
      moveComponent.curMovePoints = moveComponent.curMovePoints - 1
      level:moveActor(self.owner, destination, false)
   end
end

return Move
