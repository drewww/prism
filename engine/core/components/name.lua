--- A display name for an entity.
--- @class Name : Component
--- @overload fun(name: string): Name
local Name = prism.Component:extend "Name"

function Name:__new(name)
   self.name = name
end

return Name
