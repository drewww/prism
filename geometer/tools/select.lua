---@class SelectTool : Tool
---@field locations SparseGrid
local Select = geometer.Tool:extend "SelectTool"

Select.dragging = false

function Select:mouseclicked(editor, level, x, y) end

---@param dt number
---@param editor Editor
function Select:update(dt, editor) end

function Select:draw(editor, display) end

function Select:mousereleased(editor, level, x, y) end

return Select
