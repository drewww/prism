--- @class SeenBy : Relationship
--- @overload fun(): SeenBy
local SeenBy = prism.Relationship:extend "SeenBy"

function SeenBy:generateInverse()
   return prism.relationships.Seen
end

return SeenBy