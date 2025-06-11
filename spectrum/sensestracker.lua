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

return SensesTracker
