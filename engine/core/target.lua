--- @alias TargetFactory fun(...): Target

--- @class Target : Object
--- @overload fun(...: Component): Target
local Target = prism.Object:extend("Target")

--- Creates a new Target and accepts components and sends them to with().
function Target:__new(...)
   self.validators = {}
   self.reqcomponents = {}
   self.inLevel = true
   self.hint = nil -- A string hint that can be set to let the UI know how to handle the target.

   self:with(...)
end

--- @param level Level 
--- @param owner Actor The actor performing the action.
--- @param targetObject any
--- @param targets Object[]? A list of the previous targets.
function Target:validate(level, owner, targetObject, targets)
   if self.inLevel and prism.Actor:is(targetObject) and not level:hasActor(targetObject) then
      return false
   end

   for _, validator in pairs(self.validators) do
      if not validator(level, owner, targetObject, targets) then
         return false
      end
   end

   return true
end

--- Adds a filter to the target, order of filters is not gaurunteed! This
--- is where you're put custom logic like only targetting enemies with low
--- health, etc.
--- @param func fun(level: Level, owner: Actor, targetObject: any, targets: any[])
function Target:filter(func)
   table.insert(self.validators, func)
end

--- @param ... Component
function Target:with(...)
   for _, comp in pairs({...}) do
      self.reqcomponents[comp] = true
   end

   --- @param target Entity
   self.validators["with"] = function (level, owner, target)
      if not next(self.reqcomponents) then return true end
      
      if not prism.Entity:is(target) then
         return false
      end

      for comp, _ in pairs(self.reqcomponents) do
         if not target:has(comp) then return false end
      end

      return true
   end

   return self
end

--- Disables the default check for if the target is in the level, you'll want to set
--- this when your target lies outside the level like inventory or equipment.
function Target:outsideLevel()
   self.inLevel = false
   return self
end

--- Checks if the target is within the specified range, and if it's an Actor or Vector2.
--- @param range integer
function Target:range(range)
   self.range = range

   --- @param owner Actor
   --- @param target any
   self.validators["range"] = function (level, owner, target)
      if prism.Actor:is(target) then
         --- @cast target Actor
         return owner:getRange(target) <= self.range
      end

      if prism.Vector2:is(target) then
         --- @cast target Vector2
         return owner:getRangeVec(target) <= self.range
      end

      return false
   end

   return self
end

--- Calls prototype:is() on the target.
--- @param type Object The prototype to check is.
function Target:isPrototype(type)
   assert(prism.Object:is(type), "Prototype must be a prism.Object!")

   self.type = type

   self.validators["type"] = function (level, owner, target)
      return self.type:is(target)
   end

   return self
end

--- Checks if the target is an Actor or Vector2 and if the owner can sense that target.
function Target:sensed()
   self.validators["sensed"] = function (level, owner, target)
      local senses = owner:get(prism.components.Senses)

      if not senses then return false end

      if prism.Actor:is(target) then
         --- @cast target Actor
         return senses.actors:hasActor(target)
      end

      if prism.Vector2:is(target) then
         --- @cast target Vector2
         return senses.cells:get(target.x, target.y) ~= nil
      end

      -- TODO: add cell handling by giving cells a position

      return false
   end

   return self
end

-- TODO: UNTESTED
--- Walks a bresenham line between the owner and the target and checks if each tile
--- is passable by the given mask. Fails if it can't reach the target.
--- @param mask Bitmask
function Target:los(mask)
   --- @param level Level
   --- @param owner Actor
   self.validators["los"] = function(level, owner, target)
      if not prism.Actor:is(target) and not prism.Vector2:is(target) then return false end
      
      local i, j = owner:getPosition():decompose()
      --- @diagnostic disable-next-line
      local k, l = target.getPosition and target:getPosition():decompose() or target:decompose()
      local points = prism.Bresenham(i, j, k, l)

      for _, point in ipairs(points) do
         local x, y = point[1], point[2]
         if not level:getCellPassable(x, y, mask) then
            return false
         end
      end
   end

   return self
end

--- Sets a string hint for the target, useful for UI handling.
--- @param hint string
function Target:setHint(hint)
   self.hint = hint
   return self
end

return Target
