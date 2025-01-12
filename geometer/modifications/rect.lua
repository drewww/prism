--- @class RectModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field topleft Vector2
--- @field bottomright Vector2
local RectModification = geometer.Modification:extend "RectModification"

---@param placeable Placeable
---@param topleft Vector2
---@param bottomright Vector2
function RectModification:__new(placeable, topleft, bottomright, fillMode)
   self.placeable = placeable
   self.topleft = topleft
   self.bottomright = bottomright
   self.fillMode = fillMode
end

--- @param attachable GeometerAttachable
function RectModification:execute(attachable)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   if self.fillMode then
      -- Fill the rectangle
      for x = i, k do
         for y = j, l do
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
   else
      -- Draw only the outline of the rectangle
      for x = i, k do
         self:placeBoundaryCell(attachable, x, j) -- Top edge
         self:placeBoundaryCell(attachable, x, l) -- Bottom edge
      end
      for y = j + 1, l - 1 do
         self:placeBoundaryCell(attachable, i, y) -- Left edge
         self:placeBoundaryCell(attachable, k, y) -- Right edge
      end
   end
end

--- Helper function to place a cell on the boundary
---@param attachable GeometerAttachable
---@param x number
---@param y number
function RectModification:placeBoundaryCell(attachable, x, y)
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

return RectModification
