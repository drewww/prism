local PenModification = require "geometer.modifications.pen"

---@class PenTool : Tool
---@field locations SparseGrid
local Pen = geometer.Tool:extend "PenTool"
geometer.PenTool = Pen

Pen.dragging = false

function Pen:mouseclicked(geometer, level, x, y)
   self.dragging = true
   self.locations = prism.SparseGrid()

   if not geometer.attachable:inBounds(x, y) then return end
   self.locations:set(x, y, true)
end

---@param dt number
---@param geometer Geometer
function Pen:update(dt, geometer)
   if not self.locations then return end

   local x, y = geometer.display:getCellUnderMouse()
   if not geometer.attachable:inBounds(x, y) then return end

   self.locations:set(x, y, true)
end

function Pen:draw(geometer, display)
   if not self.locations then return end

   local csx, csy = display.cellSize.x, display.cellSize.y

   for x, y in self.locations:each() do
      love.graphics.rectangle("fill", x * csx, y * csy, csx, csy)
   end
end

function Pen:mousereleased(geometer, level, x, y)
   if not self.locations then return end

   local modification = PenModification(geometer.placeable, self.locations)
   geometer:execute(modification)

   self.locations = nil
end