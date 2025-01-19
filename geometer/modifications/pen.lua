--- @class PenModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field locations SparseGrid
local PenModification = geometer.Modification:extend "PenModification"

---@param placeable Placeable
---@param locations SparseGrid
function PenModification:__new(placeable, locations)
   self.placeable = placeable
   self.locations = locations
end

--- @param attachable SpectrumAttachable
function PenModification:execute(attachable)
   for x, y in self.locations:each() do
      if self.placeable:is(prism.Actor) then
         local actorPrototype = self.placeable
         --- @cast actorPrototype Actor
         self:placeActor(attachable, x, y, actorPrototype)
      else
         local cell = self.placeable
         --- @cast cell Cell
         self:placeCell(attachable, x, y, cell)
      end
   end
end

return PenModification
