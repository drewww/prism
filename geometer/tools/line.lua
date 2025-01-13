-- TODO: Actually test and use this is an example.
local LineModification = require "geometer/modifications/line"

--- @class LineTool : Tool
--- @field origin Vector2
--- @field to Vector2
Line = geometer.Tool:extend "LineTool"
geometer.LineTool = Line

function Line:__new()
   self.origin = nil
end

--- @param geometer Geometer
--- @param attachable SpectrumAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Line:mouseclicked(geometer, attachable, x, y)
   if not attachable:inBounds(x, y) then return end
   self.origin = prism.Vector2(x, y)
end

--- @param geometer Geometer
--- @param attachable SpectrumAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Line:mousereleased(geometer, attachable, x, y)
   if not self.origin or not self.to then
      self.origin, self.to = nil, nil
      return
   end

   local fx, fy = self.origin.x, self.origin.y
   local x, y = self.to.x, self.to.y
   local modification = LineModification(geometer.placeable, prism.Vector2(fx, fy), prism.Vector2(x, y))
   geometer:execute(modification)

   self.origin = nil
end

--- @param dt number
---@param geometer Geometer
function Line:update(dt, geometer)
   local x, y = geometer.display:getCellUnderMouse()
   if not geometer.attachable:inBounds(x, y) then return end

   self.to = prism.Vector2(x, y)
end

--- @param display Display
function Line:draw(geometer, display)
   if not self.origin or not self.to then return end
   local csx, csy = display.cellSize.x, display.cellSize.y

   local points = prism.Bresenham(self.origin.x, self.origin.y, self.to.x, self.to.y)
   for _, point in ipairs(points) do
      love.graphics.rectangle("fill", point[1] * csx, point[2] * csy, csx, csy)
   end
end

