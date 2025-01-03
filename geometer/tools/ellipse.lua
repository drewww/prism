local EllipseModification = require "geometer.modifications.ellipse"

---@class EllipseTool : Tool
---@field center Vector2
Ellipse = geometer.Tool:extend "PenTool"
geometer.EllipseTool = Ellipse

function Ellipse:mouseclicked(_, level, x, y)
   if x < 1 or x > level.map.w then return end
   if y < 1 or y > level.map.h then return end
   self.center = prism.Vector2(x, y)
end

function Ellipse:draw(display)
   if not self.center then return end

   local csx, csy = display.cellSize.x, display.cellSize.y
   local mx, my = display:getCellUnderMouse()

   local rx, ry = math.abs(self.center.x - mx), math.abs(self.center.y - my)
   rx = math.max(1, rx)
   ry = math.max(1, ry)

   prism.Ellipse(self.center, rx, ry, function (x, y)
      x = math.min(display.level.map.w, math.max(1, x))
      y = math.min(display.level.map.h, math.max(1, y))
      love.graphics.rectangle("fill", x * csx, y * csy, csx, csy)
   end)
end

function Ellipse:mousereleased(geometer, level, x, y)
   if not self.center then return end

   local rx, ry = math.abs(self.center.x - x), math.abs(self.center.y - y)
   rx = math.max(1, rx)
   ry = math.max(1, ry)
   geometer:execute(EllipseModification(geometer.placeable, self.center, rx, ry))
   self.center = nil
end