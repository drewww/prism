local EllipseModification = require "geometer.modifications.ellipse"

---@class EllipseTool : Tool
---@field center Vector2
Ellipse = geometer.Tool:extend "PenTool"
geometer.EllipseTool = Ellipse

function Ellipse:mouseclicked(geometer, level, x, y)
   if x < 1 or x > level.map.w then return end
   if y < 1 or y > level.map.h then return end
   self.geometer = geometer
   self.center = prism.Vector2(x, y)
end

function Ellipse:draw(display)
   if not self.center then return end

   local csx, csy = display.cellSize.x, display.cellSize.y
   local mx, my = display:getCellUnderMouse()

   local rx, ry = math.abs(self.center.x - mx), math.abs(self.center.y - my)

   prism.Ellipse(self.center, rx, ry, function (x, y)
      if self.geometer.attachable:inBounds(x, y) then
         love.graphics.rectangle("fill", x * csx, y * csy, csx, csy)
      end
   end)
end

function Ellipse:mousereleased(geometer, level, x, y)
   if not self.center then return end

   local rx, ry = math.abs(self.center.x - x), math.abs(self.center.y - y)
   geometer:execute(EllipseModification(geometer.placeable, self.center, rx, ry))
   self.center = nil
end