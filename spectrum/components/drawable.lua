--- @class DrawableComponent : prism.Component
local Drawable = prism.Component:extend "DrawableComponent"

--- Index needs to be a string associated with a sprite in the SpriteAtlas, or
--- an integer index associated with a sprite.
--- @param index string|integer
--- @param color prism.Color4
function Drawable:__new(index, color)
   self.index = index
   self.color = color or prism.Color4(1, 1, 1, 1)
end

return Drawable
