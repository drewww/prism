local Inky = require "geometer.inky"

---@class EditorGridProps : Inky.Props
---@field offset Vector2
---@field map Map
---@field actors ActorStorage
---@field display Display
---@field scale Vector2

---@class EditorGrid : Inky.Element
---@field props EditorGridProps

---@param self EditorGrid
---@param scene Inky.Scene
---@return function
local function EditorGrid(self, scene)
   self:onPointer("drag", function(_, pointer, dx, dy)
      local camera = self.props.display.camera
      local dx, dy = dx * (1/camera.scale.x), dy * (1/camera.scale.y)
      camera.position.x = camera.position.x - dx
      camera.position.y = camera.position.y - dy
   end)

   self:onPointer("press", function(_, pointer)
      local x, y = pointer:getPosition()
   end)

   return function(_, x, y, w, h)
      if not self.props.map then
         return
      end

      local r, g, b, a = love.graphics.getColor()
      self.props.display:drawWizard()
      love.graphics.setColor(r, g, b, a)
   end
end

return Inky.defineElement(EditorGrid)
