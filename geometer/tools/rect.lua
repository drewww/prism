-- TODO: Actually test and use this is an example.
local RectModification = require "geometer/modifications/rect"

--- @class RectTool : Tool
--- @field origin Vector2
RectTool = geometer.Tool:extend "RectTool"
geometer.RectTool = RectTool

function RectTool:__new()
   self.topleft = nil
end

--- @param geometer Geometer
---@param level Level
---@param x integer The cell coordinate clicked.
---@param y integer The cell coordinate clicked.
function RectTool:mouseclicked(geometer, level, x, y)
   if x < 0 or x > level.map.w then return end
   if y < 0 or y > level.map.h then return end

   self.topleft = prism.Vector2(x, y)
end

function RectTool:mousereleased(geometer, level, x, y)
   local x = math.min(level.map.w, math.max(0, x))
   local y = math.min(level.map.h, math.max(0, y))

   local lx, ly, rx, ry = self:getCurrentRect(x, y)
   local modification = RectModification(prism.cells.Wall, prism.Vector2(lx, ly), prism.Vector2(rx, ry))
   geometer:execute(modification)

   self.topleft = nil
end

function RectTool:getCurrentRect(x2, y2)
   if not self.topleft then return nil end

   local x, y = self.topleft.x, self.topleft.y

   local lx, ly = math.min(x, x2), math.min(y, y2)
   local rx, ry = math.max(x, x2), math.max(y, y2)

   return lx, ly, rx, ry
end

--- @param display Display
function RectTool:draw(display)
   if not self.topleft then return end
   
   local csx, csy = display.cellSize.x, display.cellSize.y
   local rx, ry = display:getCellUnderMouse()
   local lx, ly, rx, ry = self:getCurrentRect(rx, ry)
   
   local mw, mh = display.level.map.w, display.level.map.h
   lx, ly = math.min(mw, math.max(1, lx)), math.min(mh, math.max(0, ly))
   rx, ry = math.min(mw, math.max(1, rx)), math.min(mh, math.max(0, ry))
   -- Calculate width and height
   local w = (rx - lx + 1) * csx
   local h = (ry - ly + 1) * csy

   -- Draw the rectangle
   love.graphics.rectangle("fill", lx * csx, ly * csy, w, h)
end