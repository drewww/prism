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

function EllipseModification:execute(level)
   local cellSet = prism.SparseGrid()

   prism.Ellipse(self.center, self.rx, self.ry, function (x, y)
      x = math.min(level.map.w, math.max(1, x))
      y = math.min(level.map.h, math.max(1, y))

      if cellSet:get(x, y) then
         return
      end

      cellSet:set(x, y, true)
      if self.placeable:is(prism.Actor) then
         self:placeActor(level, x, y, self.placeable)
      else
         self:placeCell(level, x, y, self.placeable)
      end
   end)
end

return EllipseModification