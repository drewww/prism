--- @class Target : Object
--- @field range number The distance in tiles this actor can be away from the Action's owner. If nil this check is skipped.
--- @field distanceType DistanceType
--- @overload fun(range: integer, distanceType: DistanceType): Target
local Target = prism.Object:extend("Target")
Target.range = nil
Target.distanceType = "chebyshev"

---@param owner Actor The owner of the action.
---@param targetObject any The target object of the action.
---@param targets? Object[] A list of the previous targets.
function Target:_validate(owner, targetObject, targets)
   assert(targetObject.className, "Target must be a prism Object!")

   local targetPosition = nil
   if targetObject:is(prism.Vector2) then targetPosition = targetObject end
   if targetObject:is(prism.Actor) then targetPosition = targetObject.position end

   local range = true
   if self.range and targetPosition then
      range = owner:getPosition():getRange(self.distanceType, targetPosition) <= self.range
   end

   return self:validate(owner, targetObject, targets or {}) and range
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
