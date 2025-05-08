--- A 'Cell' is a single tile on the map.
--- It defines the properties of the tile and has a few callbacks.
--- Like actors, they hold components that can be used to modify their behaviour.
--- Cells are required to have a Collider.
--- @class Cell : Entity
--- @overload fun(): Cell
local Cell = prism.Entity:extend("Cell")

--- Constructor for the Cell class.
function Cell:__new()
   prism.Entity.__new(self)
end

--- @return Bitmask mask The collision mask of the cell.
function Cell:getCollisionMask()
   return self:expectComponent(prism.components.Collider).mask
end

return Cell
