--- A 'Cell' is a single tile on the map.
--- It defines the properties of the tile and has a few callbacks.
--- Like actors, they hold components that can be used to modify their behaviour.
--- Cells are required to have a ColliderComponent.
--- @class Cell : Entity
--- @field name string Displayed in the user interface.
--- @overload fun(): Cell
local Cell = prism.Entity:extend("Cell")

--- Constructor for the Cell class.
function Cell:__new()
   prism.Entity.__new(self)
end

--- Called when an actor enters the cell.
--- @param level Level The level where the actor entered the cell.
--- @param actor Actor The actor that entered the cell.
function Cell:onEnter(level, actor) end

--- Called when an actor leaves the cell.
--- @param level Level The level where the actor left the cell.
--- @param actor Actor The actor that left the cell.
function Cell:onLeave(level, actor) end

--- Called right before an action takes place on this cell.
--- @param level Level
--- @param actor Actor
--- @param action Action
function Cell:beforeAction(level, actor, action) end

--- Called right after an action is taken on the cell.
--- @param level Level The level where the action took place.
--- @param actor Actor The actor that took the action.
--- @param action Action The action that was taken.
function Cell:afterAction(level, actor, action) end

--- @return Bitmask mask The collision mask of the cell.
function Cell:getCollisionMask()
   return self:expectComponent(prism.components.Collider).mask
end

return Cell
