---@class PasteModification : Modification
---@field cells prism.SparseGrid
---@field actors prism.SparseMap
---@field topLeft prism.Vector2
---@overload fun(cells: prism.SparseGrid, actors: prism.SparseMap, topLeft: prism.Vector2): PasteModification
local PasteModification = geometer.Modification:extend "PasteModification"

---@param cells prism.SparseGrid
---@param actors prism.SparseMap
---@param topLeft prism.Vector2
function PasteModification:__new(cells, actors, topLeft)
   self.cells = cells
   self.actors = actors
   self.topLeft = topLeft
end

function PasteModification:execute(attachable, editor)
   for x, y, cell in self.cells:each() do
      self:placeCell(attachable, x + self.topLeft.x - 1, y + self.topLeft.y - 1, cell)
   end
end

return PasteModification
