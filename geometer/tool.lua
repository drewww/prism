---@class Tool : Object
---Represents a tool with update, draw, and mouse interaction functionalities.
---Tools can respond to user inputs and render visual elements.
local Tool = prism.Object:extend("Tool")
geometer.Tool = Tool

---Updates the tool state.
---@param dt number The time delta since the last update.
function Tool:update(dt, geometer)
   -- Update logic.
end

---Draws the tool visuals.
---@param display Display
function Tool:draw(display)
   -- Draw visuals.
end

---Handles mouse click events.
---@param geometer Geometer
---@param cellx number The x-coordinate of the cell clicked.
---@param celly number The y-coordinate of the cell clicked.
function Tool:mouseclicked(geometer, level, cellx, celly)
   -- Handle mouse clicks.
end

---Handles mouse release events.
---@param geometer Geometer
---@param cellx number The x-coordinate of the cell release.
---@param celly number The y-coordinate of the cell release.
function Tool:mousereleased(geometer, level, cellx, celly)
end

--- @param geometer Geometer
---@param level Level
---@param cellx integer
---@param celly integer
function Tool:overrideCellDraw(geometer, level, cellx, celly)
end
