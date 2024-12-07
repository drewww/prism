---@class FloorCell : Cell
local Floor = prism.Cell:extend("FloorCell")
Floor.name = "Floor"
Floor.passable = true
Floor.opaque = false
Floor.char = "."

return Floor
