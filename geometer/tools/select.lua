---@class SelectTool : Tool
---@field locations SparseGrid
local Select = geometer.Tool:extend "SelectTool"
geometer.SelectTool = Select

Select.dragging = false

function Select:mouseclicked(geometer, level, x, y) end

---@param dt number
---@param geometer Geometer
function Select:update(dt, geometer) end

function Select:draw(geometer, display) end

function Select:mousereleased(geometer, level, x, y) end

