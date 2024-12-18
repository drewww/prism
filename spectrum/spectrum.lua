local SensesTracker = require "spectrum.sensestracker"
local Camera = require "spectrum.camera"

---@class Spectrum : Object
---@field level Level
---@field spriteAtlas SpriteAtlas
---@field sensesTracker SensesTracker
---@field messageQueue Queue
---@field currentMessage ActionMessage|nil
---@field currentActionHandler fun(dt): boolean
---@field camera Camera
---@field time number
---@field dt number
local Spectrum = prism.Object:extend("Spectrum")

---@param spriteAtlas SpriteAtlas
---@param cellSize Vector2
---@param level Level
function Spectrum:__new(spriteAtlas, cellSize, level)
   self.cellSize = cellSize
   self.level = level
   self.spriteAtlas = spriteAtlas
   self.sensesTracker = SensesTracker()
   self.camera = Camera()
   self.actionHandlers = {}
   self.messageQueue = prism.Queue()
   self.currentMessage = nil
   self.currentActionHandler = nil
   self.time = 0
   self.dt = 0

   self.sensesTracker:createSensedMaps(level)
end

function Spectrum:update(dt, curActor)
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
   local hw, hh = math.floor(w/2) * self.camera.scale.x, math.floor(h/2) * self.camera.scale.y

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

   local lerpedPos = camVec:lerp(goalVec or camVec, 5*dt)
   self.camera:setPosition(lerpedPos.x, lerpedPos.y)
end

function Spectrum:updateAnimations()
   if not self.currentMessage then
      self.currentMessage = self.messageQueue:pop()

      if self.currentMessage then
         print "YERT"
         if self.sensesTracker.totalSensedActors:contains(self.currentMessage.action.owner) then
            local actionPrototype = getmetatable(self.currentMessage.action)
            self.currentActionHandler = self.actionHandlers[actionPrototype](self, self.currentMessage)
            print "SKERT"
         else
            self.currentMessage = nil
         end
      end
   end
end

function Spectrum:isAnimating()
   return self.currentMessage ~= nil
end

--- @param actionPrototype Action
--- @param handleFunc fun(spectrum: Spectrum, message: ActionMessage)
function Spectrum:registerActionHandlers(actionPrototype, handleFunc)
   self.actionHandlers[actionPrototype] = handleFunc
end

--- @param message Message
function Spectrum:queueMessage(message)
   self.messageQueue:push(message)
   self:updateAnimations()
end

function Spectrum:draw(curActor)
   self.camera:push()
   self:beforeDrawCells(curActor)
   self:drawCells(curActor)
   self:beforeDrawActors(curActor)
   self:drawActors(curActor)
   self.camera:pop()
end

function Spectrum:beforeDrawCells(curActor)
   -- override this method in your subclass!
end

function Spectrum:drawCells(curActor)
   local drawnCells = prism.Grid(self.level.map.w, self.level.map.h, false)

   local cSx, cSy = self.cellSize.x, self.cellSize.y

   if curActor then
      love.graphics.setColor(1, 1, 1, 1) -- Color for the main actor's sensed cells
      -- Collect the main actor's sensed cells
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      for x, y, cell in sensesComponent.cells:each() do
         local spriteQuad = self.spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
         love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
         drawnCells:set(x, y, true)
      end
   end

   if curActor then
      love.graphics.setColor(1, 1, 1, 0.7) -- Color for explored cells
   else
      love.graphics.setColor(1, 1, 1, 1)
   end
   if not curActor then love.graphics.setColor(1, 1, 1, 1) end
   for x, y, cell in self.sensesTracker.otherSensedCells:each() do
      if not drawnCells:get(x, y) then
         local spriteQuad = self.spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
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
         local spriteQuad = self.spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
         if spriteQuad then
            love.graphics.draw(self.spriteAtlas.image, spriteQuad, x * cSx, y * cSy)
            drawnCells:set(x, y, true)
         end
      end
   end
end

function Spectrum:beforeDrawActors(curActor)
   -- override this method in your subclass!
end

function Spectrum:drawActor(actor, drawnSet)
   if drawnSet[actor] then return end

   local cSx, cSy = self.cellSize.x, self.cellSize.y
   drawnSet[actor] = true
   local spriteQuad = self.spriteAtlas:getQuadByIndex(string.byte(actor.char) + 1)
   love.graphics.draw(self.spriteAtlas.image, spriteQuad, actor.position.x * cSx, actor.position.y * cSy)
end

function Spectrum:drawActors(curActor)
   ---@type table<ActionMessage>
   local drawnSet = {}

   love.graphics.setColor(1, 1, 1, 1) -- Color for the main actor's sensed cells
   if self.currentMessage then
      local finished, drawnActors = self.currentActionHandler(self.dt)
      print(finished, drawnActors)
      for _, drawn in ipairs(drawnActors) do
         drawnSet[drawn] = true
      end

      if finished then 
         self.currentActionHandler = nil
         self.currentMessage = nil
      end
   end

   if curActor then
      local sensesComponent = curActor:getComponent(prism.components.Senses)
      love.graphics.setColor(1, 1, 1, 1)
      for actor in sensesComponent.actors:eachActor() do
         self:drawActor(actor, drawnSet)
      end
   end
   
   love.graphics.setColor(0.5, 0.5, 0.5, 1) -- Color for the main actor's sensed cells
   if not curActor then love.graphics.setColor(1, 1, 1, 1) end
   for x, y, actor in self.sensesTracker.otherSensedActors:each() do
      self:drawActor(actor, drawnSet)
   end
end

function Spectrum:afterDrawActors(curActor)
   -- override this method in your subclass!
end

function Spectrum:getCellUnderMouse()
   local cSx, cSy = self.cellSize.x, self.cellSize.y
   local mx, my = love.mouse.getPosition()
   local wx, wy = self.camera:toWorldSpace(mx, my)
   local tileX = math.floor(wx / cSx)
   local tileY = math.floor(wy / cSy)
   return tileX, tileY
end

function Spectrum:getActorsSensedByCurActorOnTile(curActor, tileX, tileY)
   local actors = {}
   local sensesComponent = curActor:getComponent(prism.components.Senses)
   for actor in sensesComponent.actors:eachActor() do
      if actor.position.x == tileX and actor.position.y == tileY then
         table.insert(actors, actor)
      end
   end
   return actors
end

return Spectrum
