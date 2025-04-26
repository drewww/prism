--- @class Target : Object
--- @overload fun(range: integer, distanceType: DistanceType): Target
local Target = prism.Object:extend("Target")

--- The inner validate for the target. This is what you override with your own
--- custom logic.
--- @param owner Actor The actor performing the action.
--- @param targetObject any
--- @param targets Object[]? A list of the previous targets.
function Target:validate(owner, targetObject, targets)
   return true
end

return Target
