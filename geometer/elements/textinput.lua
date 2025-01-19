local Inky = geometer.require "inky"

---@class TextInputProps : Inky.Props
---@field font love.Font
---@field content string
---@field overlay love.Canvas
---@field size Vector2
---@field focused boolean
---@field onEdit function?

---@class TextInput : Inky.Element
---@field props TextInputProps

---@param self TextInput
---@param scene Inky.Scene
local function TextInput(self, scene)
   self.props.content = ""
   self.props.focused = false

   self:useEffect(function()
      self.props.onEdit(self.props.content)
   end, "content")

   self:onPointer("press", function(_, pointer)
      local focused = pointer:doesOverlapElement(self)
      self.props.focused = focused
      pointer:captureElement(self, focused)
   end)

   self:onPointer("textinput", function(_, pointer, text)
      if self.props.focused then self.props.content = self.props.content .. text end
   end)

   local blink = true
   local timer = 0
   self:on("update", function(_, dt)
      timer = timer + dt
      if timer >= 0.5 then
         timer = 0
         blink = not blink
      end
   end)

   self:on("backspace", function()
      local content = self.props.content
      if string.len(content) > 0 then content = string.sub(content, 1, string.len(content) - 1) end
      self.props.content = content
   end)

   return function(_, x, y, w, h)
      x = (x / 8) * self.props.size.x
      y = (y / 8) * self.props.size.y
      local length = self.props.content:len()
      local offset = length > 11 and (length - 11) * self.props.font:getHeight() or 0

      love.graphics.push("all")
      love.graphics.setScissor(x, y, (w / 8) * self.props.size.x, (h / 8) * self.props.size.y)
      love.graphics.translate(-offset, 0)
      love.graphics.setFont(self.props.font)
      love.graphics.setCanvas(self.props.overlay)
      love.graphics.scale(1, 1)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.print(
         self.props.content .. ((blink and self.props.focused) and "Σ" or ""),
         x,
         y + self.props.size.y / 8
      )
      love.graphics.pop()
   end
end

---@alias TextInputInit fun(scene: Inky.Scene): TextInput
---@type TextInputInit
local TextInputElement = Inky.defineElement(TextInput)
return TextInputElement
