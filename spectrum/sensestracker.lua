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

   for actor in level:query(prism.components.PlayerController):iter() do
      local sensesComponent = actor:getComponent(prism.components.Senses)

      -- Always collect explored cells
      for x, y, cell in sensesComponent.explored:each() do
         self.exploredCells:set(x, y, cell)
      end

      -- Skip self for other sensed data
      if actor ~= curActor then
         -- Collect other sensed cells
         for x, y, cell in sensesComponent.cells:each() do
            self.otherSensedCells:set(x, y, cell)
         end

         -- Collect other sensed actors
         for actorInSight in sensesComponent:query():iter() do
            actorSet[actorInSight] = true
            self.otherSensedActors:insert(
               actorInSight.position.x,
               actorInSight.position.y,
               actorInSight
            )
         end
      end
   end

   if curActor then
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      if sensesComponent then
         for actor in sensesComponent:query():iter() do
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

      if cell then passable = prism.Collision.checkBitmaskOverlap(mask, cell:getCollisionMask()) end

      for actor, _ in pairs(self.totalSensedActors:get(x, y)) do
         ---@cast actor Actor
         local collider = actor:getComponent(prism.components.Collider)
         if collider then passable = prism.Collision.checkBitmaskOverlap(mask, collider.mask) end
      end

      return passable
   end
end

return SensesTracker
