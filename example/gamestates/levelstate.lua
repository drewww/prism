local GameState = require "example.gamestates.gamestate"

local SpriteAtlas = require "example.display.spriteatlas"
local spriteAtlas = SpriteAtlas.fromGrid("example/display/wanderlust_16x16.png", 16, 16)

local Camera = require "example.display.camera"

--- This is the core turn logic, and if you need to use a different scheduler or want a different turn structure you should override this.
--- There is a version of this provided for time-based 
---@param level Level
---@param actor Actor
---@param controller ControllerComponent
---@diagnostic disable-next-line
function prism.turn(level, actor, controller)
   local moveComponent = actor:getComponent(prism.components.Move)
   if moveComponent then
      moveComponent.curMovePoints = moveComponent.movePoints
   end

   local actionPointComponent = actor:getComponent(prism.components.ActionPoint)
   if actionPointComponent then
      actionPointComponent.curActionPoints = actionPointComponent.actionPoints
   end

   while true do -- no brakes baby
      local action = controller:act(level, actor)

      if action:is(prism.actions.EndTurn) then break end
      -- we make sure we got an action back from the controller for sanity's sake
      assert(action, "Actor " .. actor.name .. " returned nil from act()")
      assert(action.canPerform(actor))

      level:performAction(action)
   end
end

---@class SensesTracker : Object
---@field exploredCells SparseGrid
---@field otherSensedCells SparseGrid
---@field totalSensedActors SparseMap
---@field otherSensedActors SparseMap
local SensesTracker = prism.Object:extend("SensesTracker")

---@param level Level
---@param curActor Actor
function SensesTracker:createSensedMaps(level, curActor)
   self.exploredCells = prism.SparseGrid() 
   self.otherSensedActors = prism.SparseMap()
   self.otherSensedCells = prism.SparseGrid()
   self.totalSensedActors = prism.SparseMap()

   local actorSet = {}

   -- Collect explored cells
   for actor in level:eachActor(prism.components.PlayerController) do
      local sensesComponent = actor:getComponent(prism.components.Senses)
      for x, y, cell in sensesComponent.explored:each() do
         self.exploredCells:set(x, y, cell)
      end
   end

   for actor in level:eachActor(prism.components.PlayerController) do
      if actor ~= curActor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for x, y, cell in sensesComponent.cells:each() do
            self.otherSensedCells:set(x, y, cell)
         end
      end
   end

   -- Collect other sensed actors
   for actor in level:eachActor(prism.components.PlayerController) do
      if actor ~= curActor then
         local sensesComponent = actor:getComponent(prism.components.Senses)
         for actorInSight in sensesComponent.actors:eachActor() do
            actorSet[actorInSight] = true
            self.otherSensedActors:insert(actorInSight.position.x, actorInSight.position.y, actorInSight)
         end
      end
   end

   local sensesComponent = curActor:getComponent(prism.components.Senses)
   if sensesComponent then
      for actor in sensesComponent.actors:eachActor() do
         actorSet[actor] = true
         self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
      end
   end

   for actor, _ in pairs(actorSet) do
      print(actor.name)
      self.totalSensedActors:insert(actor.position.x, actor.position.y, actor)
   end
end

function SensesTracker:passableCallback()
   return function(x, y)
      local passable = false
      --- @type Cell
      local cell = self.exploredCells:get(x, y)

      if cell then 
         passable = cell.passable
      end

      for actor, _ in pairs(self.totalSensedActors:get(x, y)) do
         if actor:getComponent(prism.components.Collider) ~= nil then
            passable = false
         end
      end

      return passable
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

      local moveComponent = self.actor:getComponent(prism.components.Move)
      if moveComponent then
         if moveComponent.curMovePoints == 0 then
            self.decidedPath = nil
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

   local moveComponent = self.actor:getComponent(prism.components.Move)
   if moveComponent then
      if self.decidedPath then
         love.graphics.setColor(0, 1, 0, 0.3)
         for i, v in ipairs(self.decidedPath) do
            if #self.decidedPath - i < moveComponent.curMovePoints then 
               love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
            end
         end
      elseif self.path then
         love.graphics.setColor(0, 1, 0, 0.3)
         for i, v in ipairs(self.path) do
            if #self.path - i < moveComponent.curMovePoints then 
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
end

return LevelState
