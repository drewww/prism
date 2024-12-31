if not spectrum then
   error("Geometer depends on spectrum!")
end

geometer = {}

require "geometer.tool"
require "geometer.panel"
require "geometer.modification"

--- @alias Placeable Actor|Cell

---@class Geometer : Object
---@field level Level
---@field display Display
---@field active boolean
---@field editor Editor
---@field undoStack Modification[]
---@field redoStack Modification[]
---@field selected Placeable|nil
---@field tool Tool|nil -- TODO: Default to a tool!
local Geometer = prism.Object:extend("Geometer")
geometer.Geometer = Geometer

function Geometer:__new(level, display)
   self.level = level
   self.display = display
   self.active = false
   self.selected = prism.cells.Wall
end

local Inky = require("geometer.inky")
local Editor = require("geometer.editorelement")

local scene = Inky.scene()
local pointer = Inky.pointer(scene)

local scale = prism.Vector2(love.graphics.getWidth() / 320, love.graphics.getHeight() / 200)

function Geometer:isActive()
   return self.active
end

function Geometer:startEditing()
   self.active = true
   self.editor = Editor(scene)
   self.editor.props.display = self.display
   self.editor.props.level = self.level
   self.editor.props.scale = scale
   self.editor.props.geometer = self

   self.undoStack = {}
   self.redoStack = {}
end

function Geometer:update(dt)
   local mx, my = love.mouse.getX(), love.mouse.getY()
   pointer:setPosition(mx / scale.x, my / scale.y)

   if self.editor.props.quit then
      self.active = false
   end

   scene:raise("update", dt)
   
   if self.tool then -- TODO: Remove when default added.
      self.tool:update(dt)
   end
end

--- @param modification Modification
function Geometer:execute(modification)
   modification:execute(self.level)
   table.insert(self.undoStack, modification)
end

function Geometer:undo()
   local modification = table.remove(self.undoStack, #self.undoStack)
   modification:undo(self.level)
   table.insert(self.redoStack, modification)
end

function Geometer:redo()
   local modification = table.remove(self.redoStack, #self.redoStack)
   modification:undo(self.level)
   table.insert(self.undoStack, modification)
end

function Geometer:draw()
   scene:beginFrame()

   self.editor:render(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

   scene:finishFrame()
end

function Geometer:mousereleased(x, y, button)
   if button == 1 then
      pointer:raise("release")
   end
end

function Geometer:mousepressed(x, y, button)
   if button == 1 then
      pointer:raise("press")
   end
end

function love.mousemoved(x, y, dx, dy, istouch)
   if love.mouse.isDown(2) then
      pointer:setPosition(x, y)
      pointer:raise("drag", dx, dy)
   end
end

function Geometer:keypressed(key, scancode) end

function Geometer:wheelmoved(dx, dy)
   pointer:raise("scroll", dx, dy)
end