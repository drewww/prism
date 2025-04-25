--- @alias TargetType
--- | "Actor"
--- | "Cell"
--- | "Point"
--- | "Any"

--- @class Target : Object
--- @field typesAllowed table<TargetType, true>
--- @field range number The distance in tiles this actor can be away from the Action's owner. If nil this check is skipped.
--- @field unique boolean If true this will make sure this target is unique, and not one of the targets already selected.
--- @field rangeType "chebyshev"|"manhattan"
--- @field distanceType DistanceType
--- @overload fun(range: integer, distanceType: DistanceType): Target
local Target = prism.Object:extend("Target")
Target.range = nil
Target.rangeLastTarget = nil
Target.unique = false
Target.distanceType = "chebyshev"
Target.typesAllowed = {
   -- Actor = true,
   -- Cell = true,
   -- Point = true,
   -- Any = true,
}

local typeValidators = {
   Actor = function(object) return object:is(prism.Actor) end,
   Cell = function(object) return object:is(prism.Cell) end,
   Point = function(object) return object:is(prism.Vector2) end,
   Any = function(object) return true end,
}

---@param owner Actor The owner of the action.
---@param targetObject any The target object of the action.
---@param targets? Object[] A list of the previous targets.
function Target:_validate(owner, targetObject, targets)
   assert(targetObject.className, "Target must be a prism Object!")
   local isValid
   for t, _ in pairs(self.typesAllowed) do
      if typeValidators[t](targetObject) then
         isValid = true
      end
   end

   local targetPosition = nil
   if typeValidators.Point(targetObject) then targetPosition = targetObject end
   if typeValidators.Actor(targetObject) then targetPosition = targetObject.position end

   local range = true
   if self.range then
      range = owner:getPosition():getRange(self.distanceType, targetPosition) <= self.range
   end

   return isValid and self:validate(owner, targetObject, targets or {}) and range
end

--- The inner validate for the target. This is what you override with your own
--- custom logic.
--- @param owner Actor The actor performing the action.
--- @param targetObject Actor|Cell|Vector2 The target to validate.
--- @param targets Object[] A list of the previous targets.
function Target:validate(owner, targetObject, targets)
   return true
end

return Target
