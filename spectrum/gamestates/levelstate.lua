--- @class LevelState : GameState
--- Represents the state for running a level, including managing the game loop, 
--- handling decisions, messages, and drawing the interface.
--- @field decision Decision The current decision being processed, if any.
--- @field level Level The level object representing the game environment.
--- @field display Display The display object used for rendering.
--- @field message ActionMessage The most recent action message.
--- @field geometer EditorState An editor state for debugging or managing geometry.
local LevelState = spectrum.GameState:extend("LevelState")

--- Constructs a new LevelState.
--- Sets up the game loop, initializes decision handlers, and binds custom callbacks for drawing.
--- @param level Level The level object to be managed by this state.
--- @param display Display The display object for rendering the level.
--- @param actionHandlers table<fun():fun()> A table of callback generators for handling actions.
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

--- Determines if the coroutine should proceed to the next step.
--- @return boolean|nil shouldAdvance True if the coroutine should advance; false otherwise.
function LevelState:shouldAdvance()
   local hasDecision = self.decision ~= nil
   local decisionDone = hasDecision and self.decision:validateResponse()

   if self.display.override then
      return false
   end

   return not hasDecision or decisionDone
end

--- Updates the state of the level.
--- Advances the coroutine and processes decisions or messages if necessary.
--- @param dt number The time delta since the last update.
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

--- Handles incoming messages from the coroutine.
--- Processes decisions, action messages, and debug messages as appropriate.
--- @param message any The message to handle.
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

--- Handles an action message by determining visibility and setting display overrides.
--- @param message ActionMessage The action message to handle.
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

--- Draws the current state of the level, including the perspective of relevant actors.
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

--- This method is invoked each update when a decision exists 
--- and its response is not yet valid.. Override this method in subclasses to implement 
--- custom decision-handling logic. 
--- @param dt number The time delta since the last update.
--- @param actor Actor The actor responsible for making the decision.
--- @param decision ActionDecision The decision being updated.
function LevelState:updateDecision(dt, actor, decision)
   -- override in subclasses
end


--- Draws content before rendering cells. Override in subclasses for custom behavior.
--- @param display Display The display object used for drawing.
function LevelState:drawBeforeCells(display)
   -- override in subclasses
end

return LevelState
