local Inky = require("geometer.inky")

---@class ButtonProps : Inky.Props
---@field pressed boolean
---@field pressedQuad love.Quad
---@field unpressedQuad love.Quad
---@field tileset love.Image
---@field onRelease? function

---@class Button : Inky.Element
---@field props ButtonProps

---@param self Button
---@return function
local function Button(self)
   self.props.pressed = false

   self:onPointer("release", function()
      self.props.pressed = false
      if self.props.onRelease then
         self.props.onRelease()
      end
   end)

   self:onPointer("press", function()
      self.props.pressed = true
   end)

   return function(_, x, y, w, h, depth)
      local toDraw = self.props.unpressedQuad
      if self.props.pressed then
         toDraw = self.props.pressedQuad
      end
      love.graphics.draw(self.props.tileset, toDraw, x, y)
   end
end

return Inky.defineElement(Button)
