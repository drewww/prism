local GameState = require "example.gamestates.gamestate"

local SpriteAtlas = require "example.display.spriteatlas"
local spriteAtlas = SpriteAtlas.fromGrid("example/display/wanderlust_16x16.png", 16, 16)

local Camera = require "example.display.camera"

local SensesTracker = require "example.sensestracker"

--- This is the core turn logic, and if you need to use a different scheduler or want a different turn structure you should override this.
--- There is a version of this provided for time-based 
---@param level Level
---@param actor Actor
---@param controller ControllerComponent
---@diagnostic disable-next-line
function prism.turn(level, actor, controller)
   local SRDStatsComponent = actor:getComponent(prism.components.SRDStats)
   SRDStatsComponent:resetOnTurn()

   while true do -- no brakes baby
      local action = controller:act(level, actor)
      ---@cast action SRDAction

      if action:is(prism.actions.EndTurn) then break end
      -- we make sure we got an action back from the controller for sanity's sake
      assert(action, "Actor " .. actor.name .. " returned nil from act()")
      assert(action:canPerform(level, actor))

      SRDStatsComponent.curMovePoints = SRDStatsComponent.curMovePoints - action:movePointCost(level, actor)

      local slot = action:actionSlot(level, actor)
      if slot then
         SRDStatsComponent.actionSlots[slot] = false
      end

      print "PERFORM"
      level:performAction(action)
   end
end

local waitPathConstant = 0.2

--- @class LevelState : GameState
--- @field action Action|nil
--- @field actor Actor|nil
--- @field camera Camera
--- @field level Level
--- @field waiting boolean
--- @field dt number
--- @field sensesTracker SensesTracker
--- @field path table<Vector2>
--- @field decidedPath table<Vector2>
--- @field targetActor Actor
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
   self.waitPathTime = 0

   self.sensesTracker = SensesTracker()
end

function LevelState:update(dt)
   self.dt = dt
   self.time = (self.time + dt) % 4
   
   if self.decidedPath then
      self.waitPathTime = self.waitPathTime + dt
   end
   
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

      self.path = prism.astar(self.actor:getPosition(), prism.Vector2(wx, wy), self.sensesTracker:passableCallback())
      --self.path = self.level:findPath(self.actor:getPosition(), prism.Vector2(wx, wy))
      if self.path then table.remove(self.path, #self.path) end

      local SRDStatsComponent = self.actor:getComponent(prism.components.SRDStats)
      if SRDStatsComponent then
         if SRDStatsComponent.curMovePoints == 0 then
            self.decidedPath = nil
         end
      end

      local sensesComponent = self.actor:getComponent(prism.components.Senses)   
      if sensesComponent then
         local actorBucket = sensesComponent.actors:getActorsAt(wx, wy)

         if #actorBucket > 0 then
            self.targetActor = actorBucket[1]
         end
      end
   end

   if self.waiting and not self.action and self.decidedPath and self.waitPathTime > waitPathConstant then
      self.waitPathTime = 0

      ---@type Vector2
      local nextPos = table.remove(self.decidedPath, #self.decidedPath)

      if #self.decidedPath == 0 then
         self.decidedPath = nil
      end
      
      ---@type MoveAction
      local moveAction = self.actor:getAction(prism.actions.Move)
      if nextPos and moveAction then
         self.action = moveAction(self.actor, { nextPos })
      end
   end

   if self.waiting and not self.action and self.decidedTarget then
      print "ATTACK DECIDED"
      local attackAction = self.actor:getAction(prism.actions.Attack)

      print(attackAction, attackAction:validateTarget(1, self.actor, self.decidedTarget), attackAction:canPerform(self.level, self.decidedTarget))
      if 
         attackAction and attackAction:validateTarget(1, self.actor, self.decidedTarget)
         and attackAction:canPerform(self.level, self.decidedTarget)
      then
         print "YEET"
         self.action = attackAction(self.actor, {self.decidedTarget})
      end
      self.decidedTarget = nil
   end

   -- we're waiting and there's no input so stop advancing
   if not self.action and self.waiting then return end

   print(self.action and self.action.name)
   local success, ret = coroutine.resume(self.updateCoroutine, self.level, self.action)
   self.action = nil

   if not success then
      error(ret .. "\n" .. debug.traceback(self.updateCoroutine))
   end

   local coroutine_status = coroutine.status(self.updateCoroutine)
   if coroutine_status == "suspended" and ret.is and ret:is(prism.Actor) then
      self.waiting = true
      if self.actor ~= ret then
         self.path = nil
         self.decidedPath = nil
      end
      self.actor = ret
      self.sensesTracker:createSensedMaps(self.level, self.actor)
   elseif coroutine_status == "dead" then
      self.manager:pop()
   end
end

function LevelState:draw()
   if not self.actor then return end

   self.camera:push()

   -- Set colors and draw the cells in one loop
   love.graphics.setColor(0.3, 0.3, 0.3, 1) -- Color for explored cells
   for x, y, cell in self.sensesTracker.exploredCells:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
      if spriteQuad then
         love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
      end
   end

   love.graphics.setColor(0.7, 0.7, 0.7, 1) -- Color for other sensed cells
   for x, y, cell in self.sensesTracker.otherSensedCells:each() do
      local spriteQuad = spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
      if spriteQuad then
         love.graphics.draw(spriteAtlas.image, spriteQuad, x * 16, y * 16)
      end
   end

   for x, y, actor in self.sensesTracker.otherSensedActors:each() do
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

   local SRDStatsComponent = self.actor:getComponent(prism.components.SRDStats)
   if SRDStatsComponent then
      if self.decidedPath then
         love.graphics.setColor(0, 1, 0, 0.3)
         for i, v in ipairs(self.decidedPath) do
            if #self.decidedPath - i < SRDStatsComponent.curMovePoints then 
               love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
            end
         end
      elseif self.path then
         love.graphics.setColor(0, 1, 0, 0.3)
         for i, v in ipairs(self.path) do
            if #self.path - i < SRDStatsComponent.curMovePoints then 
               love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
            end
         end
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
   love.graphics.print("HP: " .. SRDStatsComponent.HP, 10, 20)
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

   if key == "space" then
      local endturn = self.actor:getAction(prism.actions.EndTurn)
      self.action = endturn(self.actor)
   end

   local movement = self:generateMovement(key)
   if movement then self.action = movement return end
end

function LevelState:mousepressed( x, y, button, istouch, presses )
   if self.path then
      self.decidedPath = self.path
   end

   if self.targetActor then
      self.decidedTarget = self.targetActor
   end
end

return LevelState
