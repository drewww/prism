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

--- @param attachable GeometerAttachable
function LineModification:execute(attachable)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   local points = prism.Bresenham(i, j, k, l)

   for _, point in ipairs(points) do
      local x, y = point[1], point[2]
      if self.placeable:is(prism.Actor) then
         local actor = self.placeable
         --- @cast actor Actor
         self:placeActor(attachable, x, y, actor)
      else
         local cell = self.placeable
         --- @cast cell Cell
         self:placeCell(attachable, x, y, cell)
      end
   end
end

return LineModification