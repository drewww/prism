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

function LineModification:execute(level)
   local i, j = self.topleft.x, self.topleft.y
   local k, l = self.bottomright.x, self.bottomright.y

   local points = prism.Bresenham(i, j, k, l)

   for _, point in ipairs(points) do
      local x, y = point[1], point[2]
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

--- @param level Level
---@param x integer
---@param y integer
---@param actorPrototype Actor
function LineModification:placeActor(level, x, y, actorPrototype)
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
function LineModification:placeCell(level, x, y, cellPrototype)
   if not self.replaced then self.replaced = prism.SparseGrid() end
   
   self.replaced:set(x, y, level:getCell(x, y))
   level:setCell(x, y, cellPrototype())
end

function LineModification:undo(level)
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

return LineModification