---@class Modification : Object
---Represents a reversible modification that can be executed and undone.
---This class provides a base structure for implementing modifications with
---custom behavior for execution and undoing actions.
local Modification = prism.Object:extend "Modification"
geometer.Modification = Modification

---Executes the modification.
---Override this method in subclasses to define the behavior of the modification.
---@param level Level
function Modification:execute(level)
   -- Perform the modification.
end

---Undoes the modification.
---Override this method in subclasses to define how the modification is undone.
function Modification:undo(level)
   if self.placed then
      for _, actor in pairs(self.placed) do
         level:removeActor(actor)
      end
   end

   if self.replaced then
      for x, y, cell in self.replaced:each() do
         level:setCell(x, y, cell)
      end
   end

   if self.removed then
      for _, removedActor in ipairs(self.removed) do
         level:addActor(removedActor)
      end
   end
end

function Modification:removeActor(level, actor)
   if not self.removed then self.removed = {} end

   table.insert(self.removed, actor)
   level:removeActor(actor)
end

--- @param level Level
---@param x integer
---@param y integer
---@param actorPrototype Actor
function Modification:placeActor(level, x, y, actorPrototype)
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
function Modification:placeCell(level, x, y, cellPrototype)
   if not self.replaced then self.replaced = prism.SparseGrid() end
   
   self.replaced:set(x, y, level:getCell(x, y))
   level:setCell(x, y, cellPrototype)
end