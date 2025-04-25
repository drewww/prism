--- The SensesTracker class is responsible for managing the sensed cells and actors by Actors with a PlayerController within a level,
--- distinguishing between explored cells, those sensed by other actors, and the total set of actors and cells sensed.
---@class SensesTracker : Object
---@field exploredCells SparseGrid -- A grid tracking cells that have been explored by any actor with a PlayerController.
---@field otherSensedCells SparseGrid -- A grid tracking cells sensed by other actors (excluding the current actor).
---@field totalSensedActors SparseMap -- A map tracking all actors sensed by the current actor or others.
---@field otherSensedActors SparseMap -- A map tracking actors sensed by other actors (excluding the current actor).
local SensesTracker = prism.Object:extend("SensesTracker")

function SensesTracker:__new()
   self.exploredCells = prism.SparseGrid()
   self.otherSensedActors = prism.SparseMap()
   self.otherSensedCells = prism.SparseGrid()
   self.totalSensedActors = prism.SparseMap()
end

---@param level Level
---@param curActor Actor|nil
function SensesTracker:createSensedMaps(level, curActor)
   self.exploredCells = prism.SparseGrid()
   self.otherSensedActors = prism.SparseMap()
   self.otherSensedCells = prism.SparseGrid()
   self.totalSensedActors = prism.SparseMap()

   local actorSet = {}

   -- Collect explored cells
   for actor in level:eachActor(prism.components.PlayerController) do
      local sensesComponent = actor:getComponent(prism.components.Senses)
      for x, y, cell in sensesComponent.explored:each() do
         self.exploredCells:set(x, y, cell)
      end
   end

   for actor in level:eachActor(prism.components.PlayerController) do
      if actor ~= curActor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for x, y, cell in sensesComponent.cells:each() do
            self.otherSensedCells:set(x, y, cell)
         end
      end
   end

   -- Collect other sensed actors
   for actor in level:eachActor(prism.components.PlayerController) do
      if actor ~= curActor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for actorInSight in sensesComponent.actors:eachActor() do
            actorSet[actorInSight] = true
            self.otherSensedActors:insert(actorInSight.position.x, actorInSight.position.y, actorInSight)
         end
      end
   end

   if curActor then
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      if sensesComponent then
         for actor in sensesComponent.actors:eachActor() do
            actorSet[actor] = true
            ---@diagnostic disable-next-line
            self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
         end
      end
   end

   for actor, _ in pairs(actorSet) do
      self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
   end
end

function SensesTracker:passableCallback()
   return function(x, y, mask)
      local passable = false
      --- @type Cell
      local cell = self.exploredCells:get(x, y)

      if cell then
         passable = prism.Collision.checkBitmaskOverlap(mask, cell.collisionMask)
      end

      for actor, _ in pairs(self.totalSensedActors:get(x, y)) do
         ---@cast actor Actor
         local collider = actor:getComponent(prism.components.Collider)
         if collider then
            passable = prism.Collision.checkBitmaskOverlap(mask, collider.mask)
         end
      end

      return passable
   end
end

return SensesTracker
