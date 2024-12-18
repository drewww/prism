local GameState = require "example_srd.gamestates.gamestate"

local SpriteAtlas = require "spectrum.spriteatlas"
local spriteAtlas = SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)

local Spectrum = require "spectrum.spectrum"
local ActionHandlers = require "example_srd.display.actionhandlers"

-- Set up our turn logic.
require "example_srd.turn"

local waitPathConstant = 0.2

--- @class LevelState : GameState
--- @field decision Decision
--- @field level Level
--- @field waiting boolean
--- @field path Path
--- @field decidedPath Path
--- @field targetActor Actor
--- @field spectrum Spectrum
--- @field lastActor Actor
local LevelState = GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
function LevelState:__new(level)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.waitPathTime = 0
   self.spectrum = Spectrum(spriteAtlas, level)
   self.lastActor = nil

   self.spectrum.beforeDrawCells = self:drawBeforeCellsCallback()
   
   for action, func in pairs(ActionHandlers) do
      self.spectrum:registerActionHandlers(action, func)   
   end

   self:advanceCoroutine()
end

function LevelState:advanceCoroutine()
   local curActor
   ---@diagnostic disable-next-line
   if self.decision and self.decision:is(prism.decisions.ActionDecision) then curActor = self.decision.actor end

   local success, ret = coroutine.resume(self.updateCoroutine, self.level, self.decision)
   self.decision = nil

   if not success then
      error(ret .. "\n" .. debug.traceback(self.updateCoroutine))
   end

   local coroutine_status = coroutine.status(self.updateCoroutine)
   if coroutine_status == "suspended" and ret.is and ret:is(prism.Decision) then
      if ret.actor and self.lastActor ~= ret.actor then
         self.path = nil
         self.decidedPath = nil
      end
      self.decision = ret
      return
   elseif ret then
      if ret.action and self.lastActor ~= ret.action.owner then
         self.path = nil
         self.decidedPath = nil
      end
      self.spectrum:queueMessage(ret)
   elseif coroutine_status == "dead" then
      self.manager:pop()
   end
end

function LevelState:shouldAdvance()
   local hasDecision = self.decision ~= nil
   local animating = self.spectrum:isAnimating()
   local decisionDone = hasDecision and self.decision:validateResponse()
   
   if animating then return false end
   if not hasDecision then return true end
   if decisionDone then return true end
end

function LevelState:update(dt)
   self.waitPathTime = self.waitPathTime + dt
   while self:shouldAdvance() do
      self:advanceCoroutine()
   end

   local curActor
   if self.decision and self.decision:is(prism.decisions.ActionDecision) then
      local decision = self.decision
      ---@cast decision ActionDecision
      
      curActor = self.decision.actor
      self.lastActor = curActor
      self:updatePath()

      if not self.decision:validateResponse() then
         if self.decidedPath and self.waitPathTime > waitPathConstant then
            self.waitPathTime = 0

            ---@type Vector2|nil
            local nextPos = self.decidedPath:pop()

            ---@type MoveAction
            local moveAction = curActor:getAction(prism.actions.Move)
            if nextPos and moveAction then
               decision:setAction(moveAction(curActor, { nextPos }))
            else
               self.decidedPath = nil
            end
         end

         if self.decidedTarget then
            local attackAction = curActor:getAction(prism.actions.Attack)

            if attackAction and attackAction:validateTarget(1, curActor, self.decidedTarget, {}) then
               local attackAction = attackAction(curActor, {self.decidedTarget})
               if attackAction:canPerform(self.level) then
                  decision:setAction(attackAction)
               end
            end
            self.decidedTarget = nil
         end
      end
   end

   self.spectrum:update(dt, curActor)
end

function LevelState:updatePath()
   local curActor = self.decision.actor
   -- get path
   local wx, wy = self.spectrum:getCellUnderMouse()

   self.path = prism.astar(curActor:getPosition(), prism.Vector2(wx, wy), self.spectrum.sensesTracker:passableCallback())

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


function LevelState:drawBeforeCellsCallback()
   return function(spectrum, curActor)
      if not curActor then curActor = self.lastActor end

      local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
      if SRDStatsComponent then
         if self.decidedPath then
            love.graphics.setColor(0, 1, 0, 0.3)
            for i, v in ipairs(self.decidedPath.path) do
               if self.decidedPath:totalCostAt(i) <= SRDStatsComponent.curMovePoints then
                  love.graphics.rectangle("fill", v.x * 16, v.y * 16, 16, 16)
               end
            end
         elseif self.path then
            for i, v in ipairs(self.path.path) do
               if self.path:totalCostAt(i) > SRDStatsComponent.curMovePoints then
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
   local curActor
   if self.decision then
      local actionDecision = self.decision
      ---@cast actionDecision ActionDecision
      curActor = actionDecision.actor
   end

   self.spectrum:draw(curActor)

   love.graphics.setColor(1, 1, 1, 1)
   if self.lastActor then
      local SRDStatsComponent = self.lastActor:getComponent(prism.components.SRDStats)
      love.graphics.print("HP: " .. SRDStatsComponent.HP, 10, 20)
   end
   
   love.graphics.print("Frame Time: " .. love.timer.getAverageDelta(), 10, 10)
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
