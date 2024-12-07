--- @class ColliderComponent : Component
--- @overload fun(): ColliderComponent
--- @type ColliderComponent
local Collider = prism.Component:extend("Collider")
Collider.name = "Collideable"

return Collider
