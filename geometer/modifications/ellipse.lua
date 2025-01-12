--- @class EllipseModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field topleft Vector2
--- @field bottomright Vector2
local EllipseModification = geometer.Modification:extend "EllipseModification"

---@param placeable Placeable
function EllipseModification:__new(placeable, center, rx, ry)
   self.placeable = placeable
   self.center = center
   self.rx, self.ry = rx, ry
end

--- @param attachable SpectrumAttachable
function EllipseModification:execute(attachable)
   local cellSet = prism.SparseGrid()

   prism.Ellipse(self.center, self.rx, self.ry, function (x, y)
      if not attachable:inBounds(x, y) then return end

      if cellSet:get(x, y) then
         return
      end

      cellSet:set(x, y, true)
      if self.placeable:is(prism.Actor) then
         ---@diagnostic disable-next-line
         self:placeActor(attachable, x, y, self.placeable)
      else
         ---@diagnostic disable-next-line
         self:placeCell(attachable, x, y, self.placeable)
      end
   end)
end

return EllipseModification