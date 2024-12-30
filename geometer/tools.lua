local Inky = require("geometer.inky")
local Button = require("geometer.button")

---@class ToolsProps : Inky.Props
---@field selected Button

---@class Tools : Inky.Element

---@param self Tools
---@param scene any
---@return function
local function Tools(self, scene)
   local image = love.graphics.newImage("geometer/tools.png")
   local paintButtonUnpressed = love.graphics.newQuad(0, 0, 8, 10, image)
   local paintButtonPressed = love.graphics.newQuad(8, 0, 8, 10, image)
   local deleteButtonUnpressed = love.graphics.newQuad(8 * 2, 0, 8, 10, image)
   local deleteButtonPressed = love.graphics.newQuad(8 * 3, 0, 8, 10, image)
   local rectButtonUnpressed = love.graphics.newQuad(8 * 4, 0, 8, 10, image)
   local rectButtonPressed = love.graphics.newQuad(8 * 5, 0, 8, 10, image)
   local ovalButtonUnpressed = love.graphics.newQuad(8 * 6, 0, 8, 10, image)
   local ovalButtonPressed = love.graphics.newQuad(8 * 7, 0, 8, 10, image)
   local lineButtonUnpressed = love.graphics.newQuad(8 * 8, 0, 8, 10, image)
   local lineButtonPressed = love.graphics.newQuad(8 * 9, 0, 8, 10, image)
   local fillButtonUnpressed = love.graphics.newQuad(8 * 10, 0, 8, 10, image)
   local fillButtonPressed = love.graphics.newQuad(8 * 11, 0, 8, 10, image)
   local selectButtonUnpressed = love.graphics.newQuad(8 * 12, 0, 8, 10, image)
   local selectButtonPressed = love.graphics.newQuad(8 * 13, 0, 8, 10, image)

   ---@param button Button
   local function onPress(button)
      return function()
         self.props.selected.props.pressed = false
         self.props.selected = button
      end
   end

   local paintButton = Button(scene)
   paintButton.props.unpressedQuad = paintButtonUnpressed
   paintButton.props.pressedQuad = paintButtonPressed
   paintButton.props.tileset = image
   paintButton.props.toggle = true
   paintButton.props.onPress = onPress(paintButton)
   paintButton.props.pressed = true

   self.props.selected = paintButton

   local deleteButton = Button(scene)
   deleteButton.props.unpressedQuad = deleteButtonUnpressed
   deleteButton.props.pressedQuad = deleteButtonPressed
   deleteButton.props.tileset = image
   deleteButton.props.toggle = true
   deleteButton.props.onPress = onPress(deleteButton)

   local rectButton = Button(scene)
   rectButton.props.unpressedQuad = rectButtonUnpressed
   rectButton.props.pressedQuad = rectButtonPressed
   rectButton.props.tileset = image
   rectButton.props.toggle = true
   rectButton.props.onPress = onPress(rectButton)

   local ovalButton = Button(scene)
   ovalButton.props.unpressedQuad = ovalButtonUnpressed
   ovalButton.props.pressedQuad = ovalButtonPressed
   ovalButton.props.tileset = image
   ovalButton.props.toggle = true
   ovalButton.props.onPress = onPress(ovalButton)

   local lineButton = Button(scene)
   lineButton.props.unpressedQuad = lineButtonUnpressed
   lineButton.props.pressedQuad = lineButtonPressed
   lineButton.props.tileset = image
   lineButton.props.toggle = true
   lineButton.props.onPress = onPress(lineButton)

   local fillButton = Button(scene)
   fillButton.props.unpressedQuad = fillButtonUnpressed
   fillButton.props.pressedQuad = fillButtonPressed
   fillButton.props.tileset = image
   fillButton.props.toggle = true
   fillButton.props.onPress = onPress(fillButton)

   local selectButton = Button(scene)
   selectButton.props.unpressedQuad = selectButtonUnpressed
   selectButton.props.pressedQuad = selectButtonPressed
   selectButton.props.tileset = image
   selectButton.props.toggle = true
   selectButton.props.onPress = onPress(selectButton)

   return function(_, x, y, w, h)
      paintButton:render(x, y, 8, 10)
      deleteButton:render(x + 8 * 2, y, 8, 10)
      rectButton:render(x + 8 * 4, y, 8, 10)
      ovalButton:render(x + 8 * 6, y, 8, 10)
      lineButton:render(x + 8 * 8, y, 8, 10)
      fillButton:render(x + 8 * 10, y, 8, 10)
      selectButton:render(x + 8 * 12, y, 8, 10)
   end
end

---@type fun(scene: Inky.Scene): Tools
local ToolsElement = Inky.defineElement(Tools)
return ToolsElement
