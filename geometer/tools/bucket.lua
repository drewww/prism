local PenModification = require "geometer.modifications.pen"
---@class Bucket : Tool
---@field locations SparseGrid
---Represents a tool with update, draw, and mouse interaction functionalities.
---Tools can respond to user inputs and render visual elements.
local Bucket = prism.Object:extend("Tool")
geometer.BucketTool = Bucket

--- Begins a paint drag.
---@param geometer Geometer
---@param level Level
---@param cellx number The x-coordinate of the cell clicked.
---@param celly number The y-coordinate of the cell clicked.
function Bucket:mouseclicked(geometer, level, cellx, celly)
   if geometer.placeable:is(prism.Actor) then return end
   if cellx < 1 or cellx > level.map.w then return end
   if celly < 1 or celly > level.map.h then return end

   self.locations = prism.SparseGrid()
   self:bucket(level, cellx, celly)
end

--- @param attachable GeometerAttachable
---@param x any
---@param y any
function Bucket:bucket(attachable, x, y)
   local cellPrototype = attachable:getCell(x, y)
   prism.BredthFirstSearch(prism.Vector2(x, y),
      function(x, y)
         return attachable:getCell(x, y) == cellPrototype
      end,
      function(x, y)
         self.locations:set(x, y, true)
      end
   )
end

---Updates the tool state.
---@param dt number The time delta since the last update.
---@param geometer Geometer
function Bucket:update(dt, geometer)
   if not self.locations then return end

   local x, y = geometer.display:getCellUnderMouse()
   if not geometer.attachable:inBounds(x, y) then return end

   self:bucket(geometer.attachable, x, y)
end

function Bucket:draw(geometer, display)
   if not self.locations then return end

   local csx, csy = display.cellSize.x, display.cellSize.y

   for x, y in self.locations:each() do
      love.graphics.rectangle("fill", x * csx, y * csy, csx, csy)
   end
end

---Handles mouse release events.
---@param geometer Geometer
---@param cellx number The x-coordinate of the cell release.
---@param celly number The y-coordinate of the cell release.
function Bucket:mousereleased(geometer, level, cellx, celly)
   if not self.locations then return end

   geometer:execute(PenModification(geometer.placeable, self.locations))
   self.locations = nil
end
