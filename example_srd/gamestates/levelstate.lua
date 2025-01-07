local GameState = require "example_srd.gamestates.gamestate"
local GeometerState = require "example_srd.gamestates.geometerstate"

-- Set up our turn logic.
require "example_srd.turn"

love.graphics.setDefaultFilter("nearest", "nearest")
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
local actionHandlers = require "example_srd.display.actionhandlers"

--- @class LevelState : GameState
--- @field decision Decision
--- @field level Level
--- @field waiting boolean
--- @field path Path
--- @field display Display
--- @field message ActionMessage
--- @field lastActor Actor
--- @field geometer GeometerState
local LevelState = GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
function LevelState:__new(level)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.message = nil
   self.display = spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level)
   self.geometer = GeometerState(self.level, self.display)
   self.time = 0

   self.display.beforeDrawCells = self:drawBeforeCellsCallback()
end

--- Checks whether the coroutine should advance.
function LevelState:shouldAdvance()
   local hasDecision = self.decision ~= nil
   local decisionDone = hasDecision and self.decision:validateResponse()

   if self.display.override then
      return false
   end

   return not hasDecision or decisionDone
end

function LevelState:update(dt)
   self.time = self.time + dt
   while self:shouldAdvance() do
      local message = prism.advanceCoroutine(self.updateCoroutine, self.level, self.decision)
      self.decision = nil
      self.message = nil
      if message then
         if message:is(prism.Decision) then
            ---@cast message Decision
            self.decision = message
         elseif message:is(prism.messages.ActionMessage) and not self.level.debug then
            ---@cast message ActionMessage
            local actionproto = getmetatable(message.action)
            local seen = false
            
            for _, senses, _ in self.level:eachActor(prism.components.Senses, prism.components.PlayerController) do
               ---@cast senses SensesComponent
               if senses.actors:hasActor(message.action.owner) then
                  seen = true
               end
            end

            if seen then
               self.display:setOverride(actionHandlers[actionproto], message)
            end

            self.message = message
         elseif message:is(prism.messages.DebugMessage) then
            self.manager:push(self.geometer)
            return
         end
      end
   end

   if self.decision and self.decision:instanceOf(prism.decisions.ActionDecision) then
      local decision = self.decision
      ---@cast decision ActionDecision

      if not self.decision:validateResponse() then
         self:updateDecision(dt, self.decision.actor, decision)
      end
   end

   self.display:update(dt)
end

--- @param dt number
---@param actor Actor
---@param decision ActionDecision
function LevelState:updateDecision(dt, actor, decision)
   if self.path then
      ---@type Vector2|nil
      local nextPos = self.path:pop()

      ---@type MoveAction
      local moveAction = actor:getAction(prism.actions.Move)
      if nextPos and moveAction then
         --- @type MoveAction
         local action = moveAction(actor, { nextPos })
         if action:canPerform(self.level) then
            decision:setAction(action)
         else
            self.path = nil
         end
      else
         self.path = nil
      end
   end
end

function LevelState:calculatePath(actor)
   local passableCallback = function (x, y)
      local sensesComponent = actor:getComponent(prism.components.Senses)
      if not sensesComponent then return false end

      return sensesComponent.explored:get(x, y) and self.level:getCellPassable(x, y) or false
   end

   local x, y = self.display:getCellUnderMouse()
   return prism.astar(actor:getPosition(), prism.Vector2(x, y), passableCallback)
end

function LevelState:drawBeforeCellsCallback()
   ---@param display Display
   return function(display)
      local cSx, cSy = display.cellSize.x, display.cellSize.y
      if not self.decision then
         return
      end

      local SRDStatsComponent = self.decision.actor:getComponent(prism.components.SRDStats)
      if SRDStatsComponent then
         if self.path then
            love.graphics.setColor(0, 1, 0, 0.3)
            for i, v in ipairs(self.path.path) do
               if self.path:totalCostAt(i) <= SRDStatsComponent.curMovePoints then
                  love.graphics.rectangle("fill", v.x * cSx, v.y * cSy, cSx, cSy)
               end
            end
         else
            local path = self:calculatePath(self.decision.actor)
            if path then
               for i, v in ipairs(path.path) do
                  if path:totalCostAt(i) > SRDStatsComponent.curMovePoints then
                     love.graphics.setColor(1, 0, 0, 0.3)
                  else
                     love.graphics.setColor(0, 1, 0, 0.3)
                  end

                  love.graphics.rectangle("fill", v.x * cSx, v.y * cSy, cSx, cSy)
               end
            end
         end
      end

      love.graphics.setColor(1, 1, 0, math.sin(self.time * 4) * 0.1 + 0.3)
      ---@diagnostic disable-next-line
      love.graphics.rectangle("fill", self.decision.actor.position.x * cSx, self.decision.actor.position.y * cSy, cSx, cSy)
   end
end

function LevelState:draw()
   local curActor
   if self.decision then
      local actionDecision = self.decision
      ---@cast actionDecision ActionDecision
      curActor = actionDecision.actor
   elseif self.message then
      if self.message.action.owner:hasComponent(prism.components.PlayerController) then
         curActor = self.message.action.owner
      end
   end

   local sensesComponent = curActor and curActor:getComponent(prism.components.Senses) 
   local primary = { sensesComponent }
   local secondary = {}

   for _, _, senses in self.level:eachActor(prism.components.PlayerController, prism.components.Senses) do
      table.insert(secondary, senses)
   end

   if #primary == 0 then
      primary = secondary
      secondary = {}
   end

   self.display:drawPerspective(primary, secondary)
end

function LevelState:keypressed(key, scancode)
   if not self.decision then
      return
   end
   if not self.decision:is(prism.decisions.ActionDecision) then
      return
   end

   local actionDecision = self.decision
   ---@cast actionDecision ActionDecision
   local curActor = actionDecision.actor
   if key == "space" then
      local endturn = curActor:getAction(prism.actions.EndTurn)
      actionDecision.action = endturn(curActor)
   end

   if key == "`" then
      self.manager:push(self.geometer)
   end
end

function LevelState:mousepressed(x, y, button, istouch, presses)
   if not self.decision and self.decision.actor then return end

   self.path = self:calculatePath(self.decision.actor)
end

return LevelState
