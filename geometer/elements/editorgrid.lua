local Inky = geometer.require "inky"

local function createSpringSolver(mass, k, damping)
   -- Initial conditions
   local velocity = prism.Vector2()

   ---@param pos prism.Vector2
   ---@param vel prism.Vector2
   local function computeAcceleration(pos, vel)
      local springForce = prism.Vector2(-k * pos.x, -k * pos.y) -- F = -kx
      local dampingForce = prism.Vector2(-damping * vel.x, -damping * vel.y) -- F = -b*v
      local netForce = springForce + dampingForce
      return prism.Vector2(netForce.x / mass, netForce.y / mass) -- a = F/m
   end

   return function(dt, position, goal)
      local delta = position - goal
      local acceleration = computeAcceleration(delta, velocity)

      velocity = velocity + acceleration * dt
      position = position + velocity * dt

      return position, velocity
   end
end

---@class EditorGridProps : Inky.Props
---@field offset prism.Vector2
---@field display Display
---@field scale prism.Vector2
---@field editor Editor
---@field attachable SpectrumAttachable

---@class EditorGrid : Inky.Element
---@field props EditorGridProps

---@param self EditorGrid
---@param scene Inky.Scene
---@return function
local function EditorGrid(self, scene)
   local springSolver = createSpringSolver(0.5, 110, 12)
   local camDestination = self.props.display.camera.position

   self:onPointer("drag", function(_, pointer, dx, dy)
      local camera = self.props.display.camera
      local dx, dy = dx * camera.scale.x, dy * camera.scale.y
      camDestination.x = camDestination.x - dx
      camDestination.y = camDestination.y - dy
   end)

   self:onPointer("press", function(_, pointer)
      local display = self.props.display
      local cx, cy = display:getCellUnderMouse()

      local tool = self.props.editor.tool

      tool:mouseclicked(self.props.editor, self.props.attachable, cx, cy)
      pointer:captureElement(self, true)
   end)

   self:onPointer("release", function(_, pointer)
      local tool = self.props.editor.tool
      local display = self.props.display
      local cx, cy = display:getCellUnderMouse()

      if tool then tool:mousereleased(self.props.editor, self.props.attachable, cx, cy) end

      pointer:captureElement(self, false)
   end)

   self:onPointer("scroll", function(_, pointer, dx, dy)
      local camera = self.props.display.camera

      local dy = -dy
      local x, y = love.mouse.getPosition() -- we should be using events or something here?
      camera:scaleAroundPoint(dy / 8, dy / 8, x, y)
      camDestination = camera.position
   end)

   self:on("update", function(_, dt)
      self.props.display.camera.position = springSolver(dt, self.props.display.camera.position, camDestination)
   end)

   return function(_, x, y, w, h)
      love.graphics.setScissor(x, y, w, h)
      local r, g, b, a = love.graphics.getColor()
      self.props.display:draw()
      love.graphics.setColor(r, g, b, a)

      self.props.display.camera:push()
      self.props.editor.tool:draw(self.props.editor, self.props.display)
      self.props.display.camera:pop()

      love.graphics.setScissor()
   end
end

---@alias EditorGridInit fun(scene: Inky.Scene): EditorGrid
---@type EditorGridInit
local EditorGridElement = Inky.defineElement(EditorGrid)
return EditorGridElement
