local PenModification = require "geometer.modifications.pen"

---@class PenTool : Tool
---@field locations SparseGrid
Pen = geometer.Tool:extend "PenTool"
geometer.PenTool = Pen

Pen.dragging = false

function Pen:mouseclicked(_, level, x, y)
   self.dragging = true
   self.locations = prism.SparseGrid()

   if x < 1 or x > level.map.w then return end
   if y < 1 or y > level.map.h then return end
   self.locations:set(x, y, true)
end

---@param dt number
---@param geometer Geometer
function Pen:update(dt, geometer)
   if not self.locations then return end

   local x, y = geometer.display:getCellUnderMouse()
   if x < 1 or x > geometer.level.map.w then return end
   if y < 1 or y > geometer.level.map.h then return end

   self.locations:set(x, y, true)
end

function Pen:draw(display)
   if not self.locations then return end

   local csx, csy = display.cellSize.x, display.cellSize.y

   for x, y in self.locations:each() do
      love.graphics.rectangle("fill", x * csx, y * csy, csx, csy)
   end
end

function Pen:mousereleased(geometer, level, x, y)
   if not self.locations then return end

   local modification = PenModification(prism.cells.Wall, self.locations)
   geometer:execute(modification)

   self.locations = nil
end