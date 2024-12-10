local GameState = require "example.gamestates.gamestate"

local SpriteAtlas = require "spectrum.spriteatlas"
local spriteAtlas = SpriteAtlas.fromGrid("example/display/wanderlust_16x16.png", 16, 16)

local Spectrum = require "spectrum.spectrum"
local ActionHandlers = require "example.display.actionhandlers"

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
      print(level:hasActor(actor))
      if not level:hasActor(actor) then break end

      local action = controller:act(level, actor)
      ---@cast action SRDAction

      if action:is(prism.actions.EndTurn) then break end
      -- we make sure we got an action back from the controller for sanity's sake
      assert(action, "Actor " .. actor.name .. " returned nil from act()")
      assert(action:canPerform(level))

      SRDStatsComponent.curMovePoints = SRDStatsComponent.curMovePoints - action:movePointCost(level, actor)

      local slot = action:actionSlot(level, actor)
      if slot then
         SRDStatsComponent.actionSlots[slot] = false
      end

      level:performAction(action)
   end
end

local waitPathConstant = 0.2

--- @class LevelState : GameState
--- @field decision Decision
--- @field level Level
--- @field waiting boolean
--- @field path table<Vector2>
--- @field decidedPath table<Vector2>
--- @field targetActor Actor
--- @field spectrum Spectrum
local LevelState = GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
function LevelState:__new(level)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.waitPathTime = 0
   self.spectrum = Spectrum(spriteAtlas, level)

   self.spectrum.beforeDrawCells = self:drawBeforeCellsCallback()
   
   for action, func in pairs(ActionHandlers) do
      self.spectrum:registerActionHandlers(action, func)   
   end

   self:advanceCoroutine()
end

function LevelState:update(dt)
   if self.decidedPath then
      self.waitPathTime = self.waitPathTime + dt
   end

   if self.decision and self.decision:is(prism.decisions.ActionDecision) then
      local actionDecision = self.decision
      ---@cast actionDecision ActionDecision
      --- @diagnostic disable-next-line  
      local curActor = self.decision.actor

      if curActor then
         self.spectrum:update(dt, curActor)

         -- get path
         local wx, wy = self.spectrum:getCellUnderMouse()

         self.path = prism.astar(curActor:getPosition(), prism.Vector2(wx, wy), self.spectrum.sensesTracker:passableCallback())
         if self.path then table.remove(self.path, #self.path) end

         local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
         if SRDStatsComponent then
            if SRDStatsComponent.curMovePoints == 0 then
               self.decidedPath = nil
            end
         end

         local actorBucket = self.spectrum:getActorsSensedByCurActorOnTile(curActor, wx, wy)
         if #actorBucket > 0 then
            self.targetActor = actorBucket[1]
         else
            self.targetActor = nil
         end
      end

      if self.spectrum:isAnimating() then return end
      if not self.decision:validateResponse() then
         if self.decidedPath and self.waitPathTime > waitPathConstant then
            self.waitPathTime = 0

            ---@type Vector2
            local nextPos = table.remove(self.decidedPath, #self.decidedPath)

            if #self.decidedPath == 0 then
               self.decidedPath = nil
            end
            
            ---@type MoveAction
            local moveAction = curActor:getAction(prism.actions.Move)
            if nextPos and moveAction then
               actionDecision:setAction(moveAction(curActor, { nextPos }))
            end
         end

         if self.decidedTarget then
            local attackAction = curActor:getAction(prism.actions.Attack)

            if attackAction and attackAction:validateTarget(1, curActor, self.decidedTarget) then
               local attackAction = attackAction(curActor, {self.decidedTarget})
               if attackAction:canPerform(self.level) then
                  actionDecision:setAction(attackAction)
               end
            end
            self.decidedTarget = nil
         end
      end

      -- we're waiting and there's no input so stop advancing
      if not self.decision:validateResponse() then return end
      self:advanceCoroutine()
   end
end

function LevelState:advanceCoroutine()
   local curActor
   ---@diagnostic disable-next-line
   if self.decision and self.decision:is(prism.decisions.ActionDecision) then curActor = self.decision.actor end

   while true do
      local success, ret = coroutine.resume(self.updateCoroutine, self.level, self.decision)
      self.decision = nil

      if not success then
         error(ret .. "\n" .. debug.traceback(self.updateCoroutine))
      end

      local coroutine_status = coroutine.status(self.updateCoroutine)
      if coroutine_status == "suspended" and ret.is and ret:is(prism.Decision) then
         if curActor ~= ret.actor then
            self.path = nil
            self.decidedPath = nil
         end
         self.decision = ret
         return
      elseif ret then
         self.spectrum:queueMessage(ret)
      elseif coroutine_status == "dead" then
         self.manager:pop()
      end
   end
end

function LevelState:drawBeforeCellsCallback()
   return function()
      if not self.decision then return end
      if not self.decision:is(prism.decisions.ActionDecision) then return end

      local actionDecision = self.decision
      ---@cast actionDecision ActionDecision
      local curActor = actionDecision.actor
      local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
      if SRDStatsComponent then
         if self.decidedPath then
            love.graphics.setColor(0, 1, 0, 0.3)
            for i, v in ipairs(self.decidedPath) do
               if #self.decidedPath - i < SRDStatsComponent.curMovePoints then
                  love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
               end
            end
         elseif self.path then
            for i, v in ipairs(self.path) do
               if #self.path - i + 1 > SRDStatsComponent.curMovePoints then
                  love.graphics.setColor(1, 0, 0, 0.3)
               else
                  love.graphics.setColor(0, 1, 0, 0.3)
               end

               love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
            end
         end
      end

      love.graphics.setColor(1, 1, 0, math.sin(self.spectrum.time * 4) * 0.1 + 0.3)
      ---@diagnostic disable-next-line
      love.graphics.rectangle("fill", curActor.position.x * 16, curActor.position.y * 16, 16, 16)   
   end
end

function LevelState:draw()
   if not self.decision then return end
   if not self.decision:is(prism.decisions.ActionDecision) then return end

   local actionDecision = self.decision
   ---@cast actionDecision ActionDecision
   local curActor = actionDecision.actor
   self.spectrum:draw(curActor)

   local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
   love.graphics.print("Frame Time: " .. love.timer.getAverageDelta(), 10, 10)
   love.graphics.print("HP: " .. SRDStatsComponent.HP, 10, 20)
end

function LevelState:keypressed(key, scancode)
   if not self.decision then return end
   if not self.decision:is(prism.decisions.ActionDecision) then return end

   local actionDecision = self.decision
   ---@cast actionDecision ActionDecision
   local curActor = actionDecision.actor
   if key == "space" then
      local endturn = curActor:getAction(prism.actions.EndTurn)
      actionDecision.action = endturn(curActor)
   end
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
