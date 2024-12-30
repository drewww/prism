local Inky = require("geometer.inky")

---@class ButtonProps : Inky.Props
---@field pressed boolean whether the button is pressed
---@field pressedQuad love.Quad
---@field unpressedQuad love.Quad
---@field tileset love.Image
---@field onRelease? function a function called after releasing the button
---@field onPress? function a function called after pressing the button
---@field toggle boolean whether the button stays pressed after clicking

---@class Button : Inky.Element
---@field props ButtonProps

---@param self Button
---@return function
local function Button(self)
   self.props.pressed = self.props.pressed or false
   self.props.toggle = self.props.toggle or false

   self:onPointer("release", function()
      if not self.props.toggle then
         self.props.pressed = false
      end

      if self.props.onRelease then
         self.props.onRelease()
      end
   end)

   self:onPointer("press", function()
      if self.props.onPress then
         self.props.onPress()
      end

      self.props.pressed = true
   end)

   self:onPointerEnter(function()
      love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
   end)

   self:onPointerExit(function()
      love.mouse.setCursor()
   end)

   return function(_, x, y, w, h, depth)
      local toDraw = self.props.unpressedQuad
      if self.props.pressed then
         toDraw = self.props.pressedQuad
      end
      love.graphics.draw(self.props.tileset, toDraw, x, y)
   end
end

---@type fun(scene: Inky.Scene): Button
local ButtonElement = Inky.defineElement(Button)
return ButtonElement
