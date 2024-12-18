--- A map manager class that extends the Grid class to handle map-specific functionalities.
--- @class Map : Grid
--- @field opacityCache BooleanBuffer Caches the opaciy of the cell + actors in each tile for faster fov calculation.
--- @field passableCache BooleanBuffer
--- @overload fun(): Map
--- @type Map
local Map = prism.Grid:extend("Map")

--- The constructor for the 'Map' class.
--- Initializes the map with the specified dimensions and initial value, and sets up the opacity caches.
--- @param w number The width of the map.
--- @param h number The height of the map.
--- @param initialValue Cell The initial value to fill the map with.
function Map:__new(w, h, initialValue)
   prism.Grid.__new(self, w, h, initialValue)
   self.opacityCache = prism.BooleanBuffer(w, h)
   self.passableCache = prism.BooleanBuffer(w, h)
end

--- Sets the cell at the specified coordinates to the given value.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @param cell Cell The cell to set.
function Map:setCell(x, y, cell)
   self:set(x, y, cell)
   self:updateCaches(x, y)
end

--- Gets the cell at the specified coordinates.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @return Cell cell The cell at the specified coordinates.
function Map:getCell(x, y)
   return self:get(x, y)
end

--- Updates the opacity cache at the specified coordinates.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
function Map:updateCaches(x, y)
   local cell = self:get(x, y)
   self.opacityCache:set(x, y, cell.opaque)
   self.passableCache:set(x, y, cell.passable)
end

--- Returns true if the cell at the specified coordinates is passable, false otherwise.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @return boolean True if the cell is passable, false otherwise.
function Map:getCellPassable(x, y)
   return self.passableCache:get(x, y)
end

--- Returns true if the cell at the specified coordinates is opaque, false otherwise.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @return boolean True if the cell is opaque, false otherwise.
function Map:getCellOpaque(x, y)
   return self.opacityCache:get(x, y)
end

return Map
