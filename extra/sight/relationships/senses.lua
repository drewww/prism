--- @class Senses : Relationship
--- @overload fun(): Senses
local Senses = prism.Relationship:extend "Seen"

function Senses:generateInverse()
   return prism.relationships.SeenBy
end

return Senses