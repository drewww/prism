--- Represents the visual for an actor. Used by Spectrum and Geometer to render actors.
--- @class Drawable : Component
--- @field index string|integer an index into a SpriteAtlas
--- @field color Color4
--- @field background Color4
--- @field size integer
--- @overload fun(index: string|integer, color: Color4?, size:integer?, background: Color4?, layer: number?): Drawable
local Drawable = prism.Component:extend "Drawable"

--- Index needs to be a string associated with a sprite in the SpriteAtlas, or
--- an integer index associated with a sprite.
--- @param index string|integer
--- @param size integer?
--- @param color Color4?
--- @param background Color4?
--- @param layer integer?
function Drawable:__new(index, color, size, background, layer)
   self.index = index
   self.color = color or prism.Color4.WHITE
   self.background = background or prism.Color4.TRANSPARENT
   self.layer = layer or 1
   self.size = size or 1
end

return Drawable
