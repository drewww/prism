-- TODO: Actually test and use this is an example.
local LineModification = require "geometer/modifications/line"

--- @class LineTool : Tool
--- @field origin Vector2
Line = geometer.Tool:extend "Line"
geometer.LineTool = Line

function Line:__new()
   self.topleft = nil
end

--- @param geometer Geometer
--- @param level Level
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Line:mouseclicked(geometer, level, x, y)
   if x < 1 or x > level.map.w then
      return
   end
   if y < 1 or y > level.map.h then
      return
   end

   self.topleft = prism.Vector2(x, y)
end

--- @param geometer Geometer
--- @param level Level
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Line:mousereleased(geometer, level, x, y)
   if not self.topleft then
      return nil
   end

   local x = math.min(level.map.w, math.max(1, x))
   local y = math.min(level.map.h, math.max(1, y))

   local fx, fy = self.topleft.x, self.topleft.y
   local modification = LineModification(geometer.placeable, prism.Vector2(fx, fy), prism.Vector2(x, y))
   geometer:execute(modification)

   self.topleft = nil
end

--- @param display Display
function Line:draw(display)
   if not self.topleft then return end

   local csx, csy = display.cellSize.x, display.cellSize.y

   local x, y = display:getCellUnderMouse()
   x = math.min(display.level.map.w, math.max(1, x))
   y = math.min(display.level.map.h, math.max(1, y))

   local points = prism.Bresenham(self.topleft.x, self.topleft.y, x, y)

   for _, point in ipairs(points) do
      love.graphics.rectangle("fill", point[1] * csx, point[2] * csy, csx, csy)
   end
end

