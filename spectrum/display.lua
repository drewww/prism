---@class Display : Object
---@field level Level
---@field spriteAtlas SpriteAtlas
---@field sensesTracker SensesTracker
---@field messageQueue Queue
---@field currentMessage ActionMessage|nil
---@field currentActionHandler fun(dt): boolean
---@field camera Camera
---@field time number
---@field dt number
local Display = prism.Object:extend("Display")

---@param spriteAtlas SpriteAtlas
---@param cellSize Vector2
---@param level Level
function Display:__new(spriteAtlas, cellSize, level)
   self.cellSize = cellSize
   self.level = level
   self.spriteAtlas = spriteAtlas
   self.sensesTracker = spectrum.SensesTracker()
   self.camera = spectrum.Camera()
   self.actionHandlers = {}
   self.messageQueue = prism.Queue()
   self.currentMessage = nil
   self.currentActionHandler = nil
   self.time = 0
   self.dt = 0
   self.drawnSet = {}

   self.sensesTracker:createSensedMaps(level)
end

function Display:update(dt, curActor)
   self.time = self.time + dt
   self.dt = dt

   self.sensesTracker:createSensedMaps(self.level, curActor)

   local actorsInvolved = {}

   if not curActor and not self:isAnimating() then
      error("No decision and no messages recieved, but updating!")
   end

   self:updateAnimations()

   --- align camera
   local w, h = love.graphics.getDimensions()
   local hw, hh = math.floor(w / 2) * self.camera.scale.x, math.floor(h / 2) * self.camera.scale.y

   local cx, cy = self.camera:getPosition()
   local camVec = prism.Vector2(cx, cy)

   local cSx, cSy = self.cellSize.x, self.cellSize.y
   ---@diagnostic disable-next-line
   local goalVec

   if curActor then
      goalVec = prism.Vector2(curActor.position.x * cSx - hw, curActor.position.y * cSy - hh)
   elseif self.currentMessage then
      local center = prism.Vector2(0, 0)

      table.insert(actorsInvolved, self.currentMessage.action.owner)
      center = center + self.currentMessage.action.owner:getPosition()

      for i = 1, self.currentMessage.action:getNumTargets() do
         local target = self.currentMessage.action:getTarget(i)

         if target:is(prism.Actor) then
            table.insert(actorsInvolved, target)
            center = center + target:getPosition()
         end
      end

      local averaged = center
      averaged.x = averaged.x / #actorsInvolved
      averaged.y = averaged.y / #actorsInvolved
      goalVec = prism.Vector2(averaged.x * cSx - hw, averaged.y * cSy - hh)
   end

   local lerpedPos = camVec:lerp(goalVec or camVec, 5 * dt)
   self.camera:setPosition(lerpedPos.x, lerpedPos.y)
end

function Display:updateAnimations()
   if not self.currentMessage then
      self.currentMessage = self.messageQueue:pop()

      if self.currentMessage then
         if self.sensesTracker.totalSensedActors:contains(self.currentMessage.action.owner) then
            local actionPrototype = getmetatable(self.currentMessage.action)
            self.currentActionHandler = self.actionHandlers[actionPrototype](self, self.currentMessage)
         else
            self.currentMessage = nil
         end
      end
   end
end

function Display:isAnimating()
   return self.currentMessage ~= nil
end

--- @param actionPrototype Action
--- @param handleFunc fun(Display: Display, message: ActionMessage)
function Display:registerActionHandlers(actionPrototype, handleFunc)
   self.actionHandlers[actionPrototype] = handleFunc
end

--- @param message Message
function Display:queueMessage(message)
   self.messageQueue:push(message)
   self:updateAnimations()
end

function Display:draw(curActor)
   love.graphics.setBackgroundColor(0, 0, 0, 1)
   self.camera:push()
   self:beforeDrawCells(curActor)
   self:drawCells(curActor)
   self:beforeDrawActors(curActor)
   self:drawActors(curActor)
   self.camera:pop()
end

function Display:drawWizard()
   love.graphics.push("all")
   self.camera:push()

   local cSx, cSy = self.cellSize.x, self.cellSize.y
   local map = self.level.map
   for x = 1, map.w do
      for y = 1, map.h do
         local cell = map:get(x, y)
         ---@diagnostic disable-next-line
         local spriteQuad = self.spriteAtlas:getQuadByName(cell.drawable.index)
         ---@diagnostic disable-next-line
         spriteQuad = spriteQuad or self.spriteAtlas:getQuadByIndex(cell.drawable.index)
         love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
      end
   end

   for actor in self.level:eachActor() do
      self:drawActor(actor, 1, nil, nil, nil, true)
   end
   self.camera:pop()
   love.graphics.pop()
end

function Display:beforeDrawCells(curActor)
   -- override this method in your subclass!
end

function Display:drawCells(curActor)
   local drawnCells = prism.Grid(self.level.map.w, self.level.map.h, false)

   local cSx, cSy = self.cellSize.x, self.cellSize.y

   if curActor then
      love.graphics.setColor(1, 1, 1, 1) -- Color for the main actor's sensed cells
      -- Collect the main actor's sensed cells
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      for x, y, cell in sensesComponent.cells:each() do
         local spriteQuad = self.spriteAtlas:getQuadByIndex(cell.drawable.index)
         love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
         drawnCells:set(x, y, true)
      end
   end

   if curActor then
      love.graphics.setColor(1, 1, 1, 0.7) -- Color for explored cells
   else
      love.graphics.setColor(1, 1, 1, 1)
   end
   if not curActor then
      love.graphics.setColor(1, 1, 1, 1)
   end
   for x, y, cell in self.sensesTracker.otherSensedCells:each() do
      if not drawnCells:get(x, y) then
         local spriteQuad = self.spriteAtlas:getQuadByIndex(cell.drawable.index)
         if spriteQuad then
            love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
            drawnCells:set(x, y, true)
         end
      end
   end
   -- Set colors and draw the cells in one loop
   love.graphics.setColor(1, 1, 1, 0.3) -- Color for explored cells
   for x, y, cell in self.sensesTracker.exploredCells:each() do
      if not drawnCells:get(x, y) then
         local spriteQuad = self.spriteAtlas:getQuadByIndex(cell.drawable.index)
         if spriteQuad then
            love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
            drawnCells:set(x, y, true)
         end
      end
   end
end

function Display:beforeDrawActors(curActor)
   -- override this method in your subclass!
end

---@return love.Quad|nil
function Display:getQuad(actor)
   local drawable = actor:getComponent(prism.components.Drawable)
   if not drawable then
      return
   end

   --- @cast drawable DrawableComponent

   if type(drawable.index) == "number" then
      local index = drawable.index
      --- @cast index integer

      return self.spriteAtlas:getQuadByIndex(index)
   else
      local index = drawable.index
      --- @cast index string

      return self.spriteAtlas:getQuadByName(index)
   end
end

function Display:getActorColor(actor)
   local drawable = actor:getComponent(prism.components.Drawable)
   if not drawable then
      return
   end
   --- @cast drawable DrawableComponent

   return drawable.color
end

---@param actor Actor
---@param alpha number?
---@param x number?
---@param y number?
---@param color Color4?
function Display:drawActor(actor, alpha, x, y, color, ignoreDrawset)
   if self.drawnSet[actor] and not ignoreDrawset then
      return
   end

   local quad = self:getQuad(actor)
   color = color or self:getActorColor(actor)
   ---@cast color Color4
   local r, g, b, a = color:decompose()
   local cSx, cSy = self.cellSize.x, self.cellSize.y
   if not ignoreDrawset then
      self.drawnSet[actor] = true
   end
   love.graphics.setColor(r, g, b, a * alpha)

   --- @diagnostic disable-next-line
   local x, y = x or actor.position.x, y or actor.position.y
   love.graphics.draw(self.spriteAtlas.image, quad, x * cSx, y * cSy)
end

function Display:drawActors(curActor)
   self.drawnSet = {}

   love.graphics.setColor(1, 1, 1, 1) -- Color for the main actor's sensed cells
   if self.currentMessage then
      local finished, drawnActors = self.currentActionHandler(self.dt)
      for _, drawn in ipairs(drawnActors) do
         self.drawnSet[drawn] = true
      end

      if finished then
         self.currentActionHandler = nil
         self.currentMessage = nil
      end
   end

   if curActor then
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      for actor in sensesComponent.actors:eachActor() do
         self:drawActor(actor, 1)
      end
   end

   local alpha = 0.5
   if not curActor then
      alpha = 1
   end
   for x, y, actor in self.sensesTracker.otherSensedActors:each() do
      self:drawActor(actor, alpha)
   end
end

function Display:afterDrawActors(curActor)
   -- override this method in your subclass!
end

function Display:getCellUnderMouse()
   local cSx, cSy = self.cellSize.x, self.cellSize.y
   local mx, my = love.mouse.getPosition()
   local wx, wy = self.camera:toWorldSpace(mx, my)
   local tileX = math.floor(wx / cSx)
   local tileY = math.floor(wy / cSy)
   return tileX, tileY
end

function Display:getActorsSensedByCurActorOnTile(curActor, tileX, tileY)
   local actors = {}
   local sensesComponent = curActor:getComponent(prism.components.Senses)
   for actor in sensesComponent.actors:eachActor() do
      if actor.position.x == tileX and actor.position.y == tileY then
         table.insert(actors, actor)
      end
   end
   return actors
end

return Display
