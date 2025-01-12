local PenModification = require "geometer.modifications.pen"

---@class SelectTool : Tool
---@field locations SparseGrid
local Pen = geometer.Tool:extend "PenTool"
geometer.PenTool = Pen

Pen.dragging = false

function Pen:mouseclicked(geometer, level, x, y)
end

---@param dt number
---@param geometer Geometer
function Pen:update(dt, geometer)
end

function Pen:draw(geometer, display)
end

function Pen:mousereleased(geometer, level, x, y)
end