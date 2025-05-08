--- Gives an actor collision, preventing other actors from moving into its cell.
--- @class Collider : Component
--- @field mask CollisionMask The mask to use when testing collision. Defaults to zero, blocking everything.
--- @overload fun(options: ColliderOptions?): Collider
local Collider = prism.Component:extend "Collider"
Collider.mask = 0

--- @class ColliderOptions
--- @field allowedMovetypes string[]

--- @param options ColliderOptions?
function Collider:__new(options)
   if not options then return end
   if not options.allowedMovetypes then return end

   self.mask = prism.Collision.createBitmaskFromMovetypes(options.allowedMovetypes)
end

return Collider
