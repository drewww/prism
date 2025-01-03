local Inky = require "geometer.inky"
local Button = require "geometer.button"

---@class ToolsProps : Inky.Props
---@field selected Button
---@field geometer Geometer

---@class Tools : Inky.Element

---@param self Tools
---@param scene any
---@return function
local function Tools(self, scene)
   local atlas = spectrum.SpriteAtlas.fromGrid("geometer/assets/tools.png", 8, 10)

   ---@param button Button
   ---@param tool Tool
   local function onPress(button, tool)
      return function()
         self.props.selected.props.pressed = false
         self.props.selected = button
         self.props.geometer.tool = tool()
      end
   end

   local paintButton = Button(scene)
   paintButton.props.unpressedQuad = atlas:getQuadByIndex(1)
   paintButton.props.pressedQuad = atlas:getQuadByIndex(2)
   paintButton.props.tileset = atlas.image
   paintButton.props.toggle = true
   paintButton.props.onPress = onPress(paintButton, geometer.PenTool)
   paintButton.props.pressed = true

   self.props.selected = paintButton

   local deleteButton = Button(scene)
   deleteButton.props.unpressedQuad = atlas:getQuadByIndex(3)
   deleteButton.props.pressedQuad = atlas:getQuadByIndex(4)
   deleteButton.props.tileset = atlas.image
   deleteButton.props.toggle = true
   deleteButton.props.onPress = onPress(deleteButton)

   local rectButton = Button(scene)
   rectButton.props.unpressedQuad = atlas:getQuadByIndex(5)
   rectButton.props.pressedQuad = atlas:getQuadByIndex(6)
   rectButton.props.tileset = atlas.image
   rectButton.props.toggle = true
   rectButton.props.onPress = onPress(rectButton, geometer.RectTool)

   local ovalButton = Button(scene)
   ovalButton.props.unpressedQuad = atlas:getQuadByIndex(7)
   ovalButton.props.pressedQuad = atlas:getQuadByIndex(8)
   ovalButton.props.tileset = atlas.image
   ovalButton.props.toggle = true
   ovalButton.props.onPress = onPress(ovalButton)

   local lineButton = Button(scene)
   lineButton.props.unpressedQuad = atlas:getQuadByIndex(9)
   lineButton.props.pressedQuad = atlas:getQuadByIndex(10)
   lineButton.props.tileset = atlas.image
   lineButton.props.toggle = true
   lineButton.props.onPress = onPress(lineButton)

   local fillButton = Button(scene)
   fillButton.props.unpressedQuad = atlas:getQuadByIndex(11)
   fillButton.props.pressedQuad = atlas:getQuadByIndex(12)
   fillButton.props.tileset = atlas.image
   fillButton.props.toggle = true
   fillButton.props.onPress = onPress(fillButton)

   local selectButton = Button(scene)
   selectButton.props.unpressedQuad = atlas:getQuadByIndex(13)
   selectButton.props.pressedQuad = atlas:getQuadByIndex(14)
   selectButton.props.tileset = atlas.image
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
