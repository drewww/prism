--- The SensesTracker class is responsible for managing the sensed cells and actors by Actors with a PlayerController within a level,
--- distinguishing between explored cells, those sensed by other actors, and the total set of actors and cells sensed.
---@class SensesTracker : prism.Object
---@field exploredCells prism.SparseGrid -- A grid tracking cells that have been explored by any actor with a PlayerController.
---@field otherSensedCells prism.SparseGrid -- A grid tracking cells sensed by other actors (excluding the current actor).
---@field totalSensedActors prism.SparseMap -- A map tracking all actors sensed by the current actor or others.
---@field otherSensedActors prism.SparseMap -- A map tracking actors sensed by other actors (excluding the current actor).
local SensesTracker = prism.Object:extend("SensesTracker")

function SensesTracker:__new()
   self.exploredCells = prism.SparseGrid()
   self.otherSensedActors = prism.SparseMap()
   self.otherSensedCells = prism.SparseGrid()
   self.totalSensedActors = prism.SparseMap()
end

---@param level prism.Level
---@param curActor prism.Actor|nil
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
            self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
         end
      end
   end

   for actor, _ in pairs(actorSet) do
      self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
   end
end

return SensesTracker
