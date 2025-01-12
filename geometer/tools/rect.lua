-- TODO: Actually test and use this as an example.
local RectModification = require "geometer/modifications/rect"

--- @class RectTool : Tool
--- @field origin Vector2
--- @field second Vector2
RectTool = geometer.Tool:extend "RectTool"
geometer.RectTool = RectTool

function RectTool:__new()
   self.origin = nil
end

--- @param geometer Geometer
--- @param attachable SpectrumAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function RectTool:mouseclicked(geometer, attachable, x, y)
   if not attachable:inBounds(x, y) then return end

   self.origin = prism.Vector2(x, y)
end

function RectTool:update(dt, geometer)
   local x, y = geometer.display:getCellUnderMouse()
   if not geometer.attachable:inBounds(x, y) then return end

   self.second = prism.Vector2(x, y)
end

--- @param geometer Geometer
--- @param attachable SpectrumAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function RectTool:mousereleased(geometer, attachable, x, y)
   local lx, ly, rx, ry = self:getCurrentRect()
   if not lx then return end

   local modification = RectModification(geometer.placeable, prism.Vector2(lx, ly), prism.Vector2(rx, ry), geometer.fillMode)
   geometer:execute(modification)

   self.origin = nil
   self.second = nil
end

--- Returns the four corners of the current rect.
--- @return number? topleftx
--- @return number? toplefty
--- @return number? bottomrightx
--- @return number? bottomrighty
function RectTool:getCurrentRect()
   if not self.origin or not self.second then
      return
   end

   local x, y = self.origin.x, self.origin.y
   local sx, sy = self.second.x, self.second.y

   local lx, ly = math.min(x, sx), math.min(y, sy)
   local rx, ry = math.max(x, sx), math.max(y, sy)

   return lx, ly, rx, ry
end

--- @param display Display
function RectTool:draw(geometer, display)
   local csx, csy = display.cellSize.x, display.cellSize.y
   local lx, ly, rx, ry = self:getCurrentRect()
   if not lx then return end

   local w = (rx - lx + 1) * csx
   local h = (ry - ly + 1) * csy

   if geometer.fillMode then
      -- Draw filled rectangle
      love.graphics.rectangle("fill", lx * csx, ly * csy, w, h)
   else
      -- Draw four outlines to mimic an outline inside the rectangle
      love.graphics.rectangle("fill", lx * csx, ly * csy, csx, h) -- Left edge
      love.graphics.rectangle("fill", rx * csx, ly * csy, csx, h) -- Right edge
      love.graphics.rectangle("fill", lx * csx, ly * csy, w, csy) -- Top edge
      love.graphics.rectangle("fill", lx * csx, ry * csy, w, csy) -- Bottom edge
   end
end
