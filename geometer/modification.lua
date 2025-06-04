---@class Modification : Object
---Represents a reversible modification that can be executed and undone.
---This class provides a base structure for implementing modifications with
---custom behavior for execution and undoing actions.
local Modification = prism.Object:extend "Modification"

---Executes the modification.
---Override this method in subclasses to define the behavior of the modification.
---@param attachable SpectrumAttachable
---@param editor Editor
function Modification:execute(attachable, editor)
   -- Perform the modification.
end

---Undoes the modification.
---Override this method in subclasses to define how the modification is undone.
---@param attachable SpectrumAttachable
function Modification:undo(attachable)
   if self.placed then
      for _, actor in pairs(self.placed) do
         attachable:removeActor(actor)
      end
   end

   if self.replaced then
      for x, y, cell in self.replaced:each() do
         if cell == false then
            attachable:setCell(x, y, nil)
         else
            attachable:setCell(x, y, cell)
         end
      end
   end

   if self.removed then
      for _, removedActor in ipairs(self.removed) do
         attachable:addActor(removedActor)
      end
   end
end

function Modification:removeActor(level, actor)
   if not self.removed then self.removed = {} end

   table.insert(self.removed, actor)
   level:removeActor(actor)
end

--- @param attachable SpectrumAttachable
--- @param x integer
--- @param y integer
--- @param entityPrototype Entity
function Modification:place(attachable, x, y, entityPrototype)
   if prism.Actor:is(entityPrototype) then
      --- @cast entityPrototype Actor
      self:placeActor(attachable, x, y, entityPrototype)
   else
      --- @cast entityPrototype Cell
      self:placeCell(attachable, x, y, entityPrototype)
   end
end

--- @param attachable SpectrumAttachable
--- @param x integer
--- @param y integer
--- @param actorPrototype Actor
function Modification:placeActor(attachable, x, y, actorPrototype)
   if not self.placed then self.placed = {} end

   local instance = actorPrototype()

   --- @diagnostic disable-next-line
   instance.position = prism.Vector2(x, y)

   attachable:addActor(instance)
   table.insert(self.placed, instance)
end

---@param attachable SpectrumAttachable
---@param x integer
---@param y integer
---@param cellPrototype Cell|nil
function Modification:placeCell(attachable, x, y, cellPrototype)
   if not self.replaced then self.replaced = prism.SparseGrid() end
   local instance = cellPrototype
   if cellPrototype then instance = cellPrototype() end

   self.replaced:set(x, y, attachable:getCell(x, y) or false)
   attachable:setCell(x, y, instance)
end

return Modification
