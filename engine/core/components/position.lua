--- A display name for an entity.
--- @class Position : Component
--- @field private _position Vector2
--- @overload fun(pos: Vector2?): Position
local Position = prism.Component:extend "Position"

function Position:__new(pos)
   self._position = pos or prism.Vector2(1, 1)
end

function Position:getVector()
    return self._position
end

return Position
