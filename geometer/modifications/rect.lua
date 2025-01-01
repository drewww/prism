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
function RectModification:__new(placeable, topleft, bottomright)
   self.placeable = placeable
   self.topleft = topleft
   self.bottomright = bottomright
end

function RectModification:execute(level)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   for x = i, k do
      for y = j, l do
         if self.placeable:is(prism.Actor) then
            local actor = self.placeable
            --- @cast actor Actor
            self:placeActor(level, x, y, actor)
         else
            local cell = self.placeable
            --- @cast cell Cell
            self:placeCell(level, x, y, cell)
         end
      end
   end
end

--- @param level Level
---@param x integer
---@param y integer
---@param actorPrototype Actor
function RectModification:placeActor(level, x, y, actorPrototype)
   if not self.placed then self.placed = {} end

   local instance = actorPrototype()

   --- @diagnostic disable-next-line
   instance.position = prism.Vector2(x, y)

   level:addActor(instance)
   table.insert(self.placed, instance)
end

---@param level Level
---@param x integer
---@param y integer
---@param cellPrototype Cell
function RectModification:placeCell(level, x, y, cellPrototype)
   if not self.replaced then self.replaced = prism.SparseGrid() end
   
   self.replaced:set(x, y, level:getCell(x, y))
   level:setCell(x, y, cellPrototype())
end

function RectModification:undo(level)
   if self.placed then
      for _, actor in pairs(self.placed) do
         level:removeActor(actor)
      end
   else
      for x, y, cell in self.replaced:each() do
         level:setCell(x, y, cell)
      end
   end
end

return RectModification