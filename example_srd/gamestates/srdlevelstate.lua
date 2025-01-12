-- Set up our turn logic.
require "example_srd.turn"

local keybindings = require "example_srd.keybindingschema"

--- @class SRDLevelState : LevelState
--- @field path Path
local SRDLevelState = spectrum.LevelState:extend "SRDLevelState"

love.graphics.setDefaultFilter("nearest", "nearest")

function SRDLevelState:__new(level, display, actionHandlers)
   spectrum.LevelState.__new(self, level, display, actionHandlers)
   self.path = nil
end

function SRDLevelState:updateDecision(dt, actor, decision)
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

function  SRDLevelState:calculatePath(actor)
   local passableCallback = function (x, y)
      local sensesComponent = actor:getComponent(prism.components.Senses)
      if not sensesComponent then return false end

      return sensesComponent.explored:get(x, y) and self.level:getCellPassable(x, y) or false
   end

   local x, y = self.display:getCellUnderMouse()
   return prism.astar(actor:getPosition(), prism.Vector2(x, y), passableCallback)
end

function SRDLevelState:drawBeforeCells(display)
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

function SRDLevelState:keypressed(key, scancode)
   if not self.decision then
      return
   end
   if not self.decision:is(prism.decisions.ActionDecision) then
      return
   end

   local action = keybindings:keypressed(key)

   local actionDecision = self.decision
   ---@cast actionDecision ActionDecision
   local curActor = actionDecision.actor
   if action == "end turn" then
      local endturn = curActor:getAction(prism.actions.EndTurn)
      actionDecision.action = endturn(curActor)
   end

   if action == "open editor" then
      self.manager:push(self.geometer)
   end
end

function SRDLevelState:mousepressed(x, y, button, istouch, presses)
   if self.path then return end
   if not self.decision and self.decision.actor then return end

   self.path = self:calculatePath(self.decision.actor)
end

return SRDLevelState
