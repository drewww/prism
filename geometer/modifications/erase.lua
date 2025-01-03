--- @class EraseModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field topleft Vector2
--- @field bottomright Vector2
local EraseModification = geometer.Modification:extend "EraseModification"

---@param placeable Placeable
---@param topleft Vector2
---@param bottomright Vector2
function EraseModification:__new(placeable, topleft, bottomright)
   self.placeable = placeable
   self.topleft = topleft
   self.bottomright = bottomright
end

--- @param level Level
function EraseModification:execute(level)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   for x = i, k do
      for y = j, l do
         for actor in level:eachActorAt(x, y) do
            self:removeActor(level, actor)
         end
      end
   end
end

return EraseModification