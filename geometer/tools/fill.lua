local PenModification = geometer.require "modifications.pen"
---@class Fill : Tool
---@field locations SparseGrid
---Represents a tool with update, draw, and mouse interaction functionalities.
---Tools can respond to user inputs and render visual elements.
local Fill = geometer.Tool:extend("FillTool")

--- Begins a paint drag.
---@param editor Editor
---@param level Level
---@param cellx number The x-coordinate of the cell clicked.
---@param celly number The y-coordinate of the cell clicked.
function Fill:mouseclicked(editor, level, cellx, celly)
   if editor.placeable:is(prism.Actor) then return end
   if cellx < 1 or cellx > level.map.w then return end
   if celly < 1 or celly > level.map.h then return end

   self.locations = prism.SparseGrid()
   self:bucket(level, cellx, celly)
   editor:execute(PenModification(editor.placeable, self.locations))
end

--- @param attachable SpectrumAttachable
---@param x any
---@param y any
function Fill:bucket(attachable, x, y)
   local cellPrototype = attachable:getCell(x, y)
   prism.BredthFirstSearch(prism.Vector2(x, y), function(x, y)
      return attachable:getCell(x, y) == cellPrototype
   end, function(x, y)
      self.locations:set(x, y, true)
   end)
end

---Updates the tool state.
---@param dt number The time delta since the last update.
---@param editor Editor
function Fill:update(dt, editor)
   if not self.locations then return end

   local x, y = editor.display:getCellUnderMouse()
   if not editor.attachable:inBounds(x, y) then return end

   self:bucket(editor.attachable, x, y)
end

return Fill
