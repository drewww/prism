local EllipseModification = geometer.require "modifications.ellipse"

---@class EllipseTool : Tool
---@field center Vector2
local Ellipse = geometer.Tool:extend "EllipseTool"

function Ellipse:mouseclicked(editor, attachable, x, y)
   if not attachable:inBounds(x, y) then return end

   self.editor = editor
   self.center = prism.Vector2(x, y)
end

function Ellipse:draw(editor, display)
   if not self.center then return end

   local csx, csy = display.cellSize.x, display.cellSize.y
   local mx, my = display:getCellUnderMouse()

   local rx, ry = math.abs(self.center.x - mx), math.abs(self.center.y - my)

   prism.Ellipse(self.center, rx, ry, function(x, y)
      if self.editor.attachable:inBounds(x, y) then love.graphics.rectangle("fill", x * csx, y * csy, csx, csy) end
   end)
end

function Ellipse:mousereleased(editor, level, x, y)
   if not self.center then return end

   local rx, ry = math.abs(self.center.x - x), math.abs(self.center.y - y)
   editor:execute(EllipseModification(editor.placeable, self.center, rx, ry))
   self.center = nil
end

return Ellipse
