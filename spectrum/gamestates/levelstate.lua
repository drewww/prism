--- @class LevelState : GameState
--- Represents the state for running a level, including managing the game loop,
--- handling decisions, messages, and drawing the interface.
--- @field decision ActionDecision The current decision being processed, if any.
--- @field level Level The level object representing the game environment.
--- @field display Display The display object used for rendering.
--- @field message ActionMessage The most recent action message.
--- @field geometer EditorState An editor state for debugging or managing geometry.
local LevelState = spectrum.GameState:extend("LevelState")

--- Constructs a new LevelState.
--- Sets up the game loop, initializes decision handlers, and binds custom callbacks for drawing.
--- @param level Level The level object to be managed by this state.
--- @param display Display The display object for rendering the level.
function LevelState:__new(level, display)
   assert(level and display)
   self.level = level
   self.updateCoroutine = coroutine.create(level.run)
   self.decision = nil
   self.message = nil
   self.display = display
   self.geometer = geometer.EditorState(self.level, self.display)
   self.time = 0
end

--- Determines if the coroutine should proceed to the next step.
--- @return boolean|nil shouldAdvance True if the coroutine should advance; false otherwise.
function LevelState:shouldAdvance()
   local hasDecision = self.decision ~= nil
   local decisionDone = hasDecision and self.decision:validateResponse()

   --- @diagnostic disable-next-line
   if not self.manager or self.manager.states[#self.manager.states] ~= self then return false end

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
end

--- Handles incoming messages from the coroutine.
--- Processes decisions, action messages, and debug messages as appropriate.
--- @param message any The message to handle.
function LevelState:handleMessage(message)
   if message:is(prism.decisions.ActionDecision) then
      ---@cast message ActionDecision
      self.decision = message
   elseif message:is(prism.messages.DebugMessage) then
      self.manager:push(self.geometer)
   end
end

--- Collects and returns all player controlled senses into a group of
--- primary (active turn) and secondary (other player controlled actors).
--- @return Senses[] primary, Senses[] secondary
function LevelState:getSenses()
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

   local query = self.level:query(prism.components.PlayerController, prism.components.Senses)
   for _, _, senses in query:iter() do
      table.insert(secondary, senses)
   end

   if #primary == 0 then
      primary = secondary
      secondary = {}
   end

   return primary, secondary
end

--- Draws the current state of the level, including the perspective of relevant actors.
function LevelState:draw()
   self.display:clear()
   local primary, secondary = self:getSenses()
   -- Render the level using the actor’s senses
   self.display:putSenses(primary, secondary)
   self.display:draw()
end

function LevelState:keypressed(key, scancode)
   if key == "`" then self.manager:push(self.geometer) end
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

return LevelState
