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
   self.props.gridPosition = prism.Vector2(24, 24)

   love.graphics.setDefaultFilter("nearest", "nearest")
   local image = love.graphics.newImage("geometer/gui.png")
   local fileButtonUnpressed = love.graphics.newQuad(0, 0, 24, 12, image)
   local fileButtonPressed = love.graphics.newQuad(24, 0, 24, 12, image)
   local actorButtonUnpressed = love.graphics.newQuad(24 * 2, 0, 24, 12, image)
   local actorButtonPressed = love.graphics.newQuad(24 * 3, 0, 24, 12, image)
   local cellButtonUnpressed = love.graphics.newQuad(24 * 4, 0, 24, 12, image)
   local cellButtonPressed = love.graphics.newQuad(24 * 5, 0, 24, 12, image)
   local playButtonUnpressed = love.graphics.newQuad(24 * 6, 0, 24, 12, image)
   local playButtonPressed = love.graphics.newQuad(24 * 7, 0, 24, 12, image)

   local canvas = love.graphics.newCanvas(320, 200)
   local frame = love.graphics.newImage("geometer/frame.png")
   love.graphics.setCanvas(canvas)
   love.graphics.draw(frame)
   love.graphics.setCanvas()

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
      love.graphics.setColor(1, 1, 1, 1)

      love.graphics.setCanvas(canvas)
      fileButton:render(8, 184, 24, 12)
      playButton:render(8 * 2 + 24, 184, 24, 12)
      love.graphics.setCanvas()

      love.graphics.scale(self.props.scale:decompose())
      --grid:render(self.props.gridPosition.x, self.props.gridPosition.y, 648, 528)
      --local y = (love.graphics.getHeight() - (200 * self.props.scale.y)) / 2
      love.graphics.draw(canvas, 0, 0)

      love.graphics.pop()
   end
end

return Inky.defineElement(Editor)
