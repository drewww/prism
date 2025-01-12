-- TODO: Actually test and use this is an example.
local EraseModification = require "geometer/modifications/erase"

--- @class EraseTool : Tool
--- @field origin Vector2
Erase = geometer.Tool:extend "EraseTool"
geometer.EraseTool = Erase

function Erase:__new()
   self.origin = nil
end

--- @param geometer Geometer
--- @param attached GeometerAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Erase:mouseclicked(geometer, attached, x, y)
   if not attached:inBounds(x, y) then
      return
   end

   self.origin = prism.Vector2(x, y)
end


--- @param geometer Geometer
--- @param attached GeometerAttachable
--- @param x integer The cell coordinate clicked.
--- @param y integer The cell coordinate clicked.
function Erase:mousereleased(geometer, attached, x, y)
   if not self.origin or not self.second then
      return nil
   end

   local lx, ly, rx, ry = self:getCurrentRect()
   local modification = EraseModification(geometer.placeable, prism.Vector2(lx, ly), prism.Vector2(rx, ry))
   geometer:execute(modification)

   self.origin = nil
end

--- Returns the four corners of the current rect.
--- @return number? topleftx
--- @return number? toplefy
--- @return number? bottomrightx
--- @return number? bottomrighty
function Erase:getCurrentRect()
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
function Erase:draw(geometer, display)
   if not self.origin then
      return
   end

   local csx, csy = display.cellSize.x, display.cellSize.y
   local lx, ly, rx, ry = self:getCurrentRect()

   -- Calculate width and height
   local w = (rx - lx + 1) * csx
   local h = (ry - ly + 1) * csy

   -- Draw the rectangle
   love.graphics.rectangle("fill", lx * csx, ly * csy, w, h)
end

function Erase:update(dt, geometer)
   local x, y = geometer.display:getCellUnderMouse()
   if not geometer.attachable:inBounds(x, y) then return end

   self.second = prism.Vector2(x, y)
end
