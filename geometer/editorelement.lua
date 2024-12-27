local Inky = require "geometer.inky"

local Button = require("geometer.button")
local EditorGrid = require("geometer.gridelement")

---@class EditorProps : Inky.Props
---@field gridPosition Vector2
---@field display Display
---@field level Level
---@field scale Vector2

---@class Editor : Inky.Element
---@field props EditorProps

---@param self Editor
---@param scene Inky.Scene
---@return function
local function Editor(self, scene)
	self.props.gridPosition = prism.Vector2(64, 64)
	self.props.scale = prism.Vector2(2, 2)

	love.graphics.setDefaultFilter("nearest", "nearest")
	local image = love.graphics.newImage("geometer/gui.png")
	local fileButtonUnpressed = love.graphics.newQuad(0, 0, 72, 36, image)
	local fileButtonPressed = love.graphics.newQuad(72, 0, 72, 36, image)
	local actorButtonUnpressed = love.graphics.newQuad(72 * 2, 0, 72, 36, image)
	local actorButtonPressed = love.graphics.newQuad(72 * 3, 0, 72, 36, image)
	local cellButtonUnpressed = love.graphics.newQuad(72 * 4, 0, 72, 36, image)
	local cellButtonPressed = love.graphics.newQuad(72 * 5, 0, 72, 36, image)

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

	local grid = EditorGrid(scene)
	grid.props.scale = prism.Vector2(3, 3)
	self:useEffect(function()
		grid.props.map = self.props.level.map
		grid.props.actors = self.props.level.actorStorage
		grid.props.display = self.props.display
	end, "level", "display")

	return function(_, x, y, w, h)
		love.graphics.push()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.scale(self.props.scale:decompose())

		grid:render(self.props.gridPosition.x, self.props.gridPosition.y, 1600, 900)
		fileButton:render(24, 0, 72, 36)
		actorButton:render(24 * 2 + 72, 0, 72, 36)
		cellButton:render(24 * 3 + (72 * 2), 0, 72, 36)

		love.graphics.pop()
	end
end

return Inky.defineElement(Editor)
