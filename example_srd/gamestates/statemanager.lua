local GameState = require "example_srd.gamestates.gamestate"

---@class GameStateManager : Object
local StateManager = prism.Object:extend("GameStateManager")

function StateManager:__new()
   self.stateStack = {}
end

--- @param state GameState State to push to the top of the stack.
function StateManager:push(state)
   assert(state:is(GameState), "state must be a subclass of GameState")
   state.manager = self
   table.insert(self.stateStack, state)
   if state.load then
      state:load()
   end
end

--- Pops the state from the top of the stack.
function StateManager:pop()
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.unload then
      topState:unload()
   end
   return table.remove(self.stateStack, #self.stateStack)
end

--- @param state GameState Swap the top of the stack with this state.
function StateManager:replace(state)
   assert(state:is(GameState), "state must be a subclass of GameState")

   local state = self:pop()
   state:unload()

   self:push(state)
end

--- Called each update, calls update on top state in stack.
function StateManager:update(dt)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.update then
      topState:update(dt)
   end
end

--- Called each draw, calls draw on top state in stack.
function StateManager:draw()
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.draw then
      topState:draw()
   end
end

--- Called on keypress, calls keypressed on top state in stack
function StateManager:keypressed(key, scancode)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.keypressed then
      topState:keypressed(key, scancode)
   end
end

function StateManager:mousepressed(x, y, button, istouch, presses)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.mousepressed then
      topState:mousepressed(x, y, button, istouch, presses)
   end
end

function StateManager:mousereleased(x, y, button)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.mousereleased then
      topState:mousereleased(x, y, button)
   end
end

function StateManager:mousemoved(x, y, dx, dy, istouch)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.mousemoved then
      topState:mousemoved(x, y, dx, dy, istouch)
   end
end

function StateManager:wheelmoved(dx, dy)
   local topState = self.stateStack[#self.stateStack]
   if topState and topState.wheelmoved then
      topState:wheelmoved(dx, dy)
   end
end

return StateManager
