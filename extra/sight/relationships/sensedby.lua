--- @class SensedBy : Relationship
--- @overload fun(): SensedBy
local SensedBy = prism.Relationship:extend "SensedBy"

function SensedBy:generateInverse()
   return prism.relationships.Sees
end

return SensedBy