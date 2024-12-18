---@class PathfindNode : BTNode
---@field destinationDistance integer The distance from the goal we should stop pathfinding.
---@field destinationFunc fun(level: Level, actor: Actor, controller: BTControllerComponent): Vector2
local PathfindNode = prism.BehaviorTree.Node:extend("PathfindNode")

---@param destinationFunc fun(level: Level, actor: Actor, controller: BTControllerComponent): Vector2
---@param destinationDist integer
function PathfindNode:__new(destinationFunc, destinationDist)
   self.destinationFunc = destinationFunc
   self.destinationDistance = destinationDist or math.huge
end

function PathfindNode:run(level, actor, controller)
   local destination = self.destinationFunc(level, actor, controller)

   if actor:getRangeVec(prism._defaultDistance, destination) <= self.destinationDistance then return true end
   local stats = actor:getComponent(prism.components.SRDStats)

   local path = level:findPath(actor:getPosition(), destination, self.destinationDistance)
   if not path then return false end

   if path:getTotalCost() >= stats.curMovePoints then return false end

   if not stats then return false end
   if stats.curMovePoints < path:getTotalCost() then
      return false
   end

   local moveAction = actor:getAction(prism.actions.Move)
   if moveAction then
      local nextCell = path:pop()
      
      ---@type MoveAction
      local actionInstance = moveAction(actor, { nextCell })
      if actionInstance:canPerform(level) then
         return actionInstance
      end
   end

   return false
end

return PathfindNode