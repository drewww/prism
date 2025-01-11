--- @class LevelState : GameState
--- @field decision Decision
--- @field level Level
--- @field display Display
--- @field message ActionMessage
--- @field geometer GeometerState
local LevelState = spectrum.GameState:extend("LevelState")

--- This state is passed a Level object and sets up the interface and main loop for
--- the level.
--- @param level Level
---@param display Display
---@param actionHandlers table<fun():fun()>
function LevelState:__new(level, display, actionHandlers)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.message = nil
   self.display = display
   self.geometer = geometer.EditorState(self.level, self.display)
   self.time = 0
   self.actionHandlers = actionHandlers

   local callbackGenerator = function(callback)
      return function(display)
         callback(self, display)
      end
   end

   self.display.beforeDrawCells = callbackGenerator(self.drawBeforeCells)
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

---@param dt number
function LevelState:update(dt)
   self.time = self.time + dt
   while self:shouldAdvance() do
      local message = prism.advanceCoroutine(self.updateCoroutine, self.level, self.decision)
      self.decision, self.message = nil, nil
      if message then self:handleMessage(message) end
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

--- @param message any
function LevelState:handleMessage(message)
   if message:is(prism.Decision) then
      ---@cast message Decision
      self.decision = message
   elseif message:is(prism.messages.ActionMessage) and not self.level.debug then
      self:handleActionMessage(message)
   elseif message:is(prism.messages.DebugMessage) then
      self.manager:push(self.geometer)
   end
end

function LevelState:handleActionMessage(message)
   ---@cast message ActionMessage
   local actionproto = getmetatable(message.action)
   local seen = false
   for _, senses, _ in self.level:eachActor(prism.components.Senses, prism.components.PlayerController) do
      ---@cast senses SensesComponent
      if senses.actors:hasActor(message.action.owner) then
         seen = true
         break
      end
   end
   if seen then
      self.display:setOverride(self.actionHandlers[actionproto], message)
   end
   self.message = message
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

--- @param dt number
---@param actor Actor
---@param decision ActionDecision
function LevelState:updateDecision(dt, actor, decision)
end

--- @param display Display
function LevelState:drawBeforeCells(display)
end

return LevelState
