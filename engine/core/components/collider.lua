--- Gives an actor collision, preventing other actors from moving into its cell.
--- @class Collider : Component
--- @field mask CollisionMask The mask to use when testing collision. Defaults to zero, blocking everything.
--- @field size integer The size of the collider. Defaults to 1.
--- @overload fun(options: ColliderOptions?): Collider
local Collider = prism.Component:extend "Collider"
Collider.mask = 0

--- @class ColliderOptions
--- @field allowedMovetypes string[]?
--- @field size number? The size of the collider.

--- @param options ColliderOptions?
function Collider:__new(options)
   if not options then return end

   -- Set mask if allowedMovetypes is provided
   if options.allowedMovetypes then
      self.mask = prism.Collision.createBitmaskFromMovetypes(options.allowedMovetypes)
   end

   self.size = options.size or 1

   self.shape = shape
end

return Collider
