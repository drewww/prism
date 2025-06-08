--- @alias TargetFactory fun(...): Target

--- @class Target : Object
--- @overload fun(): Target
local Target = prism.Object:extend("Target")

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

function Target:validator(func)
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

function Target:outsideLevel()
   self.inLevel = false
   return self
end

function Target:range(range)
   self.range = range

   --- @param owner Actor
   --- @param target any
   self.validators["range"] = function (level, owner, target)
      if prism.Actor:is(target) then
         return owner:getRange(target:getPosition()) <= self.range
      end

      if prism.Vector2:is(target) then
         return owner:getRangeVec(target) <= self.range
      end

      return false
   end

   return self
end

function Target:isPrototype(type)
   assert(prism.Object:is(type), "Prototype must be a prism.Object!")

   self.type = type

   self.validators["type"] = function (level, owner, target)
      return self.type:is(target)
   end

   return self
end

function Target:sensed()
   self.validators["sensed"] = function (level, owner, target)
      local senses = owner:get(prism.components.Senses)

      if not senses then return false end

      if prism.Actor:is(target) then
         return senses.actors:hasActor(target)
      end

      if prism.Vector2:is(target) then
         return senses.cells:get(target.x, target.y) ~= nil
      end

      -- TODO: add cell handling by giving cells a position

      return false
   end

   return self
end

-- TODO: UNTESTED
function Target:los(mask)
   --- @param level Level
   --- @param owner Actor
   self.validators["los"] = function(level, owner, target)
      if not prism.Actor:is(target) and not prism.Vector2:is(target) then return false end
      
      local i, j = owner:getPosition():decompose()
      local k, l = target.getPosition and target:getPosition():decompose() or target:decompose()
      local points = prism.Bresenham(i, j, k, l)

      for _, point in ipairs(points) do
         local x, y = point[1], point[2]
         if not level:getCellPassable(x, y, mask) then
            return false
         end
      end
   end
end

return Target
