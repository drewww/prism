---@class Camera : Object
---@field position Vector2
---@field scale Vector2
---@field rotation number
local Camera = prism.Object:extend("Camera")

function Camera:__new(x, y)
   self.position = prism.Vector2(x or 0, y or 0)
   self.scale = prism.Vector2(1, 1)
   self.rotation = 0
end

function Camera:getPosition()
   return self.position.x, self.position.y
end

function Camera:setPosition(x, y)
   self.position.x = x or self.position.x
   self.position.y = y or self.position.y
end

function Camera:move(dx, dy)
   self.position = self.position + prism.Vector2(dx or 0, dy or 0)
end

function Camera:setScale(scaleX, scaleY)
   if scaleX and not scaleY then scaleY = scaleX end
   self.scale.x = scaleX or self.scale.x
   self.scale.y = scaleY or self.scale.y
end

function Camera:setRotation(rotation)
   self.rotation = rotation or self.rotation
end

function Camera:toWorldSpace(x, y)
   -- Reverse the translation (subtract position)
   local tx = x + self.position.x
   local ty = y + self.position.y
   
   return tx, ty
end

function Camera:push()
   love.graphics.push()
   love.graphics.rotate(-self.rotation)
   love.graphics.scale(1 / self.scale.x, 1 / self.scale.y)
   love.graphics.translate(-self.position.x, -self.position.y)
end

function Camera:pop()
   love.graphics.pop()
end

return Camera
