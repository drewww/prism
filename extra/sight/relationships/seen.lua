--- @class Seen : Relationship
--- @overload fun(): Seen
local Seen = prism.Relationship:extend "Seen"

function Seen:generateInverse()
   return prism.relationships.SeenBy
end

return Seen