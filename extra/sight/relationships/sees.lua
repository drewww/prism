--- @class Sees : Relationship
--- @overload fun(): Sees
local Sees = prism.Relationship:extend "Sees"

function Sees:generateInverse()
   return prism.relationships.SeenBy
end

return Sees