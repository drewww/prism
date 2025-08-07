--- @class SeenBy : Relationship
--- @overload fun(): SeenBy
local SeenBy = prism.Relationship:extend "SeenBy"

function SeenBy:generateInverse()
   return prism.relationships.Sees
end

return SeenBy