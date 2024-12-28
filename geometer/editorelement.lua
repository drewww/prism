local Inky = require("geometer.inky")

local Button = require("geometer.button")
local EditorGrid = require("geometer.gridelement")

---@class EditorProps : Inky.Props
---@field gridPosition Vector2
---@field display Display
---@field level Level
---@field scale Vector2
---@field quit boolean

---@class Editor : Inky.Element
---@field props EditorProps

---@param self Editor
---@param scene Inky.Scene
---@return function
local function Editor(self, scene)
   self.props.gridPosition = prism.Vector2(64, 64)

   love.graphics.setDefaultFilter("nearest", "nearest")
   local image = love.graphics.newImage("geometer/gui.png")
   local fileButtonUnpressed = love.graphics.newQuad(0, 0, 72, 36, image)
   local fileButtonPressed = love.graphics.newQuad(72, 0, 72, 36, image)
   local actorButtonUnpressed = love.graphics.newQuad(72 * 2, 0, 72, 36, image)
   local actorButtonPressed = love.graphics.newQuad(72 * 3, 0, 72, 36, image)
   local cellButtonUnpressed = love.graphics.newQuad(72 * 4, 0, 72, 36, image)
   local cellButtonPressed = love.graphics.newQuad(72 * 5, 0, 72, 36, image)
   local playButtonUnpressed = love.graphics.newQuad(72 * 6, 0, 72, 36, image)
   local playButtonPressed = love.graphics.newQuad(72 * 7, 0, 72, 36, image)

   local fileButton = Button(scene)
   fileButton.props.tileset = image
   fileButton.props.pressedQuad = fileButtonPressed
   fileButton.props.unpressedQuad = fileButtonUnpressed

   local actorButton = Button(scene)
   actorButton.props.tileset = image
   actorButton.props.pressedQuad = actorButtonPressed
   actorButton.props.unpressedQuad = actorButtonUnpressed

   local cellButton = Button(scene)
   cellButton.props.tileset = image
   cellButton.props.pressedQuad = cellButtonPressed
   cellButton.props.unpressedQuad = cellButtonUnpressed

   ---@type Button
   local playButton = Button(scene)
   playButton.props.tileset = image
   playButton.props.pressedQuad = playButtonPressed
   playButton.props.unpressedQuad = playButtonUnpressed
   playButton.props.onRelease = function()
      self.props.quit = true
   end

   local grid = EditorGrid(scene)
   grid.props.scale = prism.Vector2(2, 2)
   self:useEffect(function()
      grid.props.map = self.props.level.map
      grid.props.actors = self.props.level.actorStorage
      grid.props.display = self.props.display
   end, "level", "display")

   local background = prism.Color4.fromHex(0x181425)
   return function(_, x, y, w, h)
      love.graphics.setBackgroundColor(background:decompose())
      love.graphics.push("all")
      love.graphics.scale(self.props.scale:decompose())
      love.graphics.setColor(1, 1, 1, 1)

      grid:render(self.props.gridPosition.x, self.props.gridPosition.y, 1600, 900)
      fileButton:render(24, 0, 72, 36)
      actorButton:render(24 * 2 + 72, 0, 72, 36)
      cellButton:render(24 * 3 + (72 * 2), 0, 72, 36)
      playButton:render(24, 402, 72, 36)

      love.graphics.pop()
   end
end

return Inky.defineElement(Editor)
