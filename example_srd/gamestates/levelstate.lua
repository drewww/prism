local GameState = require "example_srd.gamestates.gamestate"

-- Set up our turn logic.
require "example_srd.turn"

local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
local actionHandlers = require "example_srd.display.actionhandlers"
local waitPathConstant = 0.2

--- @class LevelState : GameState
--- @field decision Decision
--- @field level Level
--- @field waiting boolean
--- @field path Path
--- @field decidedPath Path
--- @field targetActor Actor
--- @field display Display
--- @field lastActor Actor
--- @field geometer Geometer
local LevelState = GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
function LevelState:__new(level)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.waitPathTime = 0
   self.display = spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level)
   self.lastActor = nil
   self.geometer = geometer.Geometer(self.level, self.display)

   self.display.beforeDrawCells = self:drawBeforeCellsCallback()

   for action, func in pairs(actionHandlers) do
      self.display:registerActionHandlers(action, func)
   end
end

function LevelState:advanceCoroutine()

end

function LevelState:shouldAdvance()
   local hasDecision = self.decision ~= nil
   local animating = self.display:isAnimating()
   local decisionDone = hasDecision and self.decision:validateResponse()
   
   if animating then return false end
   if not hasDecision then return true end
   if decisionDone then return true end
end

function LevelState:checkPath(actor)
   if self.lastActor ~= actor then
      self.path = nil
      self.decidedPath = nil
   end
end

function LevelState:update(dt)
   if self.geometer:isActive() then
      self.geometer:update(dt)
      return
   end

   self.waitPathTime = self.waitPathTime + dt
   while self:shouldAdvance() do
      local message = prism.advanceCoroutine(self.updateCoroutine, self.level, self.decision)
      if message then
         if message:is(prism.Decision) then
            ---@cast message Decision
            self.decision = message
            self:checkPath(self.decision.actor)
         elseif message:is(prism.messages.ActionMessage) then
            ---@cast message ActionMessage
            self.display:queueMessage(message)
            self:checkPath(message.action.owner)
         end
      end
   end

   local curActor
   if self.decision and self.decision:instanceOf(prism.decisions.ActionDecision) then
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

   self.display:update(dt, curActor)
end

function LevelState:updatePath()
   local curActor = self.decision.actor
   -- get path
   local wx, wy = self.display:getCellUnderMouse()

   self.path = prism.astar(curActor:getPosition(), prism.Vector2(wx, wy), self.display.sensesTracker:passableCallback())

   local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
   if SRDStatsComponent then
      if SRDStatsComponent.curMovePoints == 0 then
         self.decidedPath = nil
      end
   end

   local actorBucket = self.display:getActorsSensedByCurActorOnTile(curActor, wx, wy)
   if #actorBucket > 0 then
      self.targetActor = actorBucket[1]
   else
      self.targetActor = nil
   end
end


function LevelState:drawBeforeCellsCallback()
   ---@param display Display
   ---@param curActor Actor
   return function(display, curActor)
      local cSx, cSy = display.cellSize.x, display.cellSize.y
      if not curActor then curActor = self.lastActor end
      if not curActor then return end

      local SRDStatsComponent = curActor:getComponent(prism.components.SRDStats)
      if SRDStatsComponent then
         if self.decidedPath then
            love.graphics.setColor(0, 1, 0, 0.3)
            for i, v in ipairs(self.decidedPath.path) do
               if self.decidedPath:totalCostAt(i) <= SRDStatsComponent.curMovePoints then
                  love.graphics.rectangle("fill", v.x * cSx, v.y * cSy, cSx, cSy)
               end
            end
         elseif self.path then
            for i, v in ipairs(self.path.path) do
               if self.path:totalCostAt(i) > SRDStatsComponent.curMovePoints then
                  love.graphics.setColor(1, 0, 0, 0.3)
               else
                  love.graphics.setColor(0, 1, 0, 0.3)
               end

               love.graphics.rectangle("fill", v.x * cSx, v.y * cSy, cSx, cSy)
            end
         end
      end

      love.graphics.setColor(1, 1, 0, math.sin(self.display.time * 4) * 0.1 + 0.3)
      ---@diagnostic disable-next-line
      love.graphics.rectangle("fill", curActor.position.x * cSx, curActor.position.y * cSy, cSx, cSy)   
   end
end

function LevelState:draw()
   if self.geometer:isActive() then
      self.geometer:draw()
      return
   end

   local curActor
   if self.decision then
      local actionDecision = self.decision
      ---@cast actionDecision ActionDecision
      curActor = actionDecision.actor
   end

   self.display:draw(curActor)

   love.graphics.setColor(1, 1, 1, 1)
   if curActor then -- TODO: What was I doing here?
      local SRDStatsComponent = self.lastActor:getComponent(prism.components.SRDStats)
      love.graphics.print("HP: " .. SRDStatsComponent.HP, 10, 20)
   end
   
   love.graphics.print("Frame Time: " .. love.timer.getAverageDelta(), 10, 10)

   if curActor then
      love.graphics.print("Current Actor ID:" .. self.level:getID(curActor), 10, 20)
   end
end

function LevelState:keypressed(key, scancode)
   if self.geometer:isActive() then
      self.geometer:keypressed(key, scancode)
      return
   end

   if not self.decision then return end
   if not self.decision:is(prism.decisions.ActionDecision) then return end

   local actionDecision = self.decision
   ---@cast actionDecision ActionDecision
   local curActor = actionDecision.actor
   if key == "space" then
      local endturn = curActor:getAction(prism.actions.EndTurn)
      actionDecision.action = endturn(curActor)
   end

   if key == "`" then
      self.geometer:startEditing()
   end
end

function LevelState:mousepressed(x, y, button, istouch, presses)
   if self.geometer:isActive() then
      self.geometer:mousepressed(x, y, button, istouch, presses)
      return
   end

   if self.path then
      self.decidedPath = self.path
   end

   if self.targetActor then
      self.decidedTarget = self.targetActor
   end
end

function LevelState:mousereleased(x, y, button)
   if self.geometer:isActive() then
      self.geometer:mousereleased(x, y, button)
   end
end

return LevelState
