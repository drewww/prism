local Inky = require("geometer.inky")

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
      local dx, dy = dx * camera.scale.x, dy * camera.scale.y
      camera.position.x = camera.position.x - dx
      camera.position.y = camera.position.y - dy
   end)

   self:onPointer("press", function(_, pointer)
      local x, y = pointer:getPosition()
   end)

   self:onPointer("scroll", function(_, pointer, dx, dy)
      local camera = self.props.display.camera

      local dy = -dy
      local x, y = love.mouse.getPosition() -- we should be using events or something here?
      camera:scaleAroundPoint(dy / 8, dy / 8, x, y)
   end)

   return function(_, x, y, w, h)
      if not self.props.map then
         return
      end

      love.graphics.setScissor(x, y, w, h)
      local r, g, b, a = love.graphics.getColor()
      self.props.display:drawWizard()
      love.graphics.setColor(r, g, b, a)
      love.graphics.setScissor()
   end
end

---@type fun(scene: Inky.Scene): EditorGrid
local EditorGridElement = Inky.defineElement(EditorGrid)
return EditorGridElement
