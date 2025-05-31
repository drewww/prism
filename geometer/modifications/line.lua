--- @class LineModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field topleft Vector2
--- @field bottomright Vector2
local LineModification = geometer.Modification:extend "LineModification"

---@param placeable Placeable
---@param topleft Vector2
---@param bottomright Vector2
function LineModification:__new(placeable, topleft, bottomright)
   self.placeable = placeable
   self.topleft = topleft
   self.bottomright = bottomright
end

--- @param attachable SpectrumAttachable
function LineModification:execute(attachable)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   local points = prism.Bresenham(i, j, k, l)

   for _, point in ipairs(points) do
      local x, y = point[1], point[2]
      self:place(attachable, x, y, self.placeable)
   end
end

return LineModification
