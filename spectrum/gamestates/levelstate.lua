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
function LevelState:__new(level, display)
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
   if message:is(prism.Decision) then
      ---@cast message Decision
      self.decision = message
   elseif message:is(prism.messages.DebugMessage) then
      self.manager:push(self.geometer)
   end
end

--- Draws the current state of the level, including the perspective of relevant actors.
function LevelState:draw()
   local startTime = love.timer.getTime() -- Start timing

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

   self.display:clear()
   self:_draw(curActor, primary, secondary)
   self.display:draw()

   local elapsedTime = (love.timer.getTime() - startTime) * 1000 -- Convert to milliseconds

   local color = prism.Color4(love.graphics.getColor())
   love.graphics.setColor(1, 0, 0)
   love.graphics.print(string.format("Draw time: %.2f ms", elapsedTime))
   love.graphics.setColor(color:decompose())
end

function LevelState:_draw()
   error("Your custom level state should overwrite this man!")
end

function LevelState:keypressed(key, scancode) 
   if key == "`" then
      self.manager:push(self.geometer)
   end
end

function LevelState:terminalDraw()
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
