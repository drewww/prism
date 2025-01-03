--- @class PenModification : Modification
--- @field placeable Placeable
--- @field placed Placeable[]|nil
--- @field replaced SparseGrid
--- @field locations SparseGrid
local PenModification = geometer.Modification:extend "RectModification"

---@param placeable Placeable
---@param locations SparseGrid
function PenModification:__new(placeable, locations)
   self.placeable = placeable
   self.locations = locations
end

function PenModification:execute(level)
   for x, y in self.locations:each() do
      if self.placeable:is(prism.Actor) then
         local actorPrototype = self.placeable
         --- @cast actorPrototype Actor
         self:placeActor(level, x, y, actorPrototype)
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
function PenModification:placeActor(level, x, y, actorPrototype)
   if not self.placed then
      self.placed = {}
   end

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
function PenModification:placeCell(level, x, y, cellPrototype)
   if not self.replaced then
      self.replaced = prism.SparseGrid()
   end

   self.replaced:set(x, y, level:getCell(x, y))
   level:setCell(x, y, cellPrototype())
end

function PenModification:undo(level)
   if self.placed then
      for _, actor in pairs(self.placed) do
         level:removeActor(actor)
      end
   elseif self.replaced then
      for x, y, cell in self.replaced:each() do
         level:setCell(x, y, cell)
      end
   end
end

return PenModification

