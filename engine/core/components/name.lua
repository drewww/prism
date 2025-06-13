--- A display name for an entity.
--- @class Name : Component
--- @overload fun(name: string): Name
local Name = prism.Component:extend "Name"

function Name:__new(name)
   self.name = name
end

function Name.get(actor)
   local name = actor:get(prism.components.Name)
   return name and name.name or "Actor"
end

function Name.lower(actor)
   return string.lower(Name.get(actor))
end

return Name
