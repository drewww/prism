---@class Tool : Object
---Represents a tool with update, draw, and mouse interaction functionalities.
---Tools can respond to user inputs and render visual elements.
local Tool = prism.Object:extend("Tool")
geometer.Tool = Tool

---Updates the tool state.
---@param dt number The time delta since the last update.
function Tool:update(dt)
   -- Update logic.
end

---Draws the tool visuals.
function Tool:draw()
   -- Draw visuals.
end

---Handles mouse click events.
---@param geometer Geometer
---@param cellx number The x-coordinate of the cell clicked.
---@param celly number The y-coordinate of the cell clicked.
function Tool:mouseclicked(geometer, cellx, celly)
   -- Handle mouse clicks.
end
