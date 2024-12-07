local GameState = require "example.gamestates.gamestate"

local SpriteAtlas = require "example.display.spriteatlas"
local spriteAtlas = SpriteAtlas.fromGrid("example/display/wanderlust_16x16.png", 16, 16)

local Camera = require "example.display.camera"

--- @class LevelState : GameState
--- @field action Action|nil
--- @field actor Actor|nil
--- @field camera Camera
--- @field level Level
--- @field waiting boolean
--- @field dt number
local LevelState = GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
function LevelState:__new(level)
   self.camera = Camera()
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.actor = nil
   self.action = nil
   self.waiting = false
   self.dt = 0
   self.time = 0
end

--- This is the core turn logic, and if you need to use a different scheduler or want a different turn structure you should override this.
--- There is a version of this provided for time-based 
---@param level Level
---@param actor Actor
---@param controller ControllerComponent
---@diagnostic disable-next-line
function prism.turn(level, actor, controller)
   local moveComponent = actor:getComponent(prism.components.Move)
   if not moveComponent then return end

   moveComponent.curMovePoints = moveComponent.movePoints
   
   while moveComponent.curMovePoints > 0 do
      local action = controller:act(level, actor)

      -- we make sure we got an action back from the controller for sanity's sake
      assert(action, "Actor " .. actor.name .. " returned nil from act()")

      level:performAction(action)
   end
end

function LevelState:update(dt)
   self.dt = dt
   self.time = (self.time + dt) % 4

   if self.actor then
      --- align camera
      local w, h = love.graphics.getDimensions()
      local hw, hh = math.floor(w/2), math.floor(h/2)

      local cx, cy = self.camera:getPosition()
      local camVec = prism.Vector2(cx, cy)

      ---@diagnostic disable-next-line
      local goalVec = prism.Vector2(self.actor.position.x * 16 - hw, self.actor.position.y * 16 - hh)
      local lerpedPos = camVec:lerp(goalVec, 5*dt)
      self.camera:setPosition(lerpedPos.x, lerpedPos.y)

      -- get path
      local x, y = love.mouse.getPosition()
      local wx, wy = self.camera:toWorldSpace(x, y)
      local wx, wy = math.floor(wx/16), math.floor(wy/16)
      self.path = self.level:findPath(self.actor:getPosition(), prism.Vector2(wx, wy))
   end

   -- we're waiting and there's no input so stop advancing
   if not self.action and self.waiting then return end

   local success, ret = coroutine.resume(self.updateCoroutine, self.level, self.action)
   self.action = nil

   if not success then
      error(ret .. "\n" .. debug.traceback(self.updateCoroutine))
   end

   local coroutine_status = coroutine.status(self.updateCoroutine)
   if coroutine_status == "suspended" and ret.is and ret:is(prism.Actor) then
      self.waiting = true
      self.actor = ret
   elseif coroutine_status == "dead" then
      self.manager:pop()
   end
end

function LevelState:draw()
   self.camera:push()

   -- Create SparseGrids to store different sets of cells
   ---@type SparseGrid
   local exploredCells = prism.SparseGrid()
   ---@type SparseMap
   local otherSensedActors = prism.SparseMap()
   ---@type SparseGrid
   local otherSensedCells = prism.SparseGrid()
   ---@type SparseGrid

   -- Collect explored cells
   for actor in self.level:eachActor(prism.components.PlayerController) do
      local sensesComponent = actor:getComponent(prism.components.Senses)
      for x, y, cell in sensesComponent.explored:each() do
         exploredCells:set(x, y, cell)
      end
   end

   -- Collect other sensed actors
   for actor in self.level:eachActor(prism.components.PlayerController) do
      if actor ~= self.actor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for actorInSight in sensesComponent.actors:eachActor() do
            otherSensedActors:insert(actorInSight.position.x, actorInSight.position.y, actorInSight)
         end
      end
   end

   for actor in self.level:eachActor(prism.components.PlayerController) do
      if actor ~= self.actor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for x, y, cell in sensesComponent.cells:each() do
            otherSensedCells:set(x, y, cell)
         end
      end
   end

   -- Set colors and draw the cells in one loop
   love.graphics.setColor(0.3, 0.3, 0.3, 1) -- Color for explored cells
   for x, y, cell in exploredCells:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
      if spriteQuad then
         love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
      end
   end

   love.graphics.setColor(0.7, 0.7, 0.7, 1) -- Color for other sensed cells
   for x, y, cell in otherSensedCells:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
      if spriteQuad then
         love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
      end
   end

   for x, y, actor in otherSensedActors:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(actor.char) + 1)
      if spriteQuad then
         love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
      end
   end

   love.graphics.setColor(1, 1, 1, 1) -- Color for the main actor's sensed cells
   -- Collect the main actor's sensed cells
   local sensesComponent = self.actor:getComponent(prism.components.Senses)
   for x, y, cell in sensesComponent.cells:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
      love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
   end

   if self.path then
      love.graphics.setColor(0, 1, 0, 0.3)
      for i, v in ipairs(self.path) do
         love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
      end
   end

   love.graphics.setColor(1, 1, 0, math.sin(self.time * 4) * 0.1 + 0.3)
   ---@diagnostic disable-next-line
   love.graphics.rectangle("fill", self.actor.position.x * 16, self.actor.position.y * 16, 16, 16)

   love.graphics.setColor(1, 1, 1, 1)
   for actor in sensesComponent.actors:eachActor() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(actor.char) + 1)
      love.graphics.draw(spriteAtlas.image, spriteQuad, actor.position.x * 16, actor.position.y * 16)
   end

   self.camera:pop()

   love.graphics.print("Frame Time: " .. love.timer.getAverageDelta(), 10, 10)
end

local keysToVectors = {
   q = prism.Vector2.UP_LEFT,
   e = prism.Vector2.UP_RIGHT,
   w = prism.Vector2.UP,
   a = prism.Vector2.LEFT,
   d = prism.Vector2.RIGHT,
   z = prism.Vector2.DOWN_LEFT,
   c = prism.Vector2.DOWN_RIGHT,
   s = prism.Vector2.DOWN
}

function LevelState:generateMovement(key)
   if not keysToVectors[key] then return end

   local move = self.actor:getAction(prism.actions.Move)
   if not move then return end

   return move(self.actor, {self.actor:getPosition() + keysToVectors[key]})
end

function LevelState:keypressed(key, scancode)
   if not self.waiting then return end

   local movement = self:generateMovement(key)
   if movement then self.action = movement return end
end

return LevelState
