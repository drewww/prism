local loveCallbacks = {
   'directorydropped',
   'draw',
   'filedropped',
   'focus',
   'gamepadaxis',
   'gamepadpressed',
   'gamepadreleased',
   'joystickaxis',
   'joystickhat',
   'joystickpressed',
   'joystickreleased',
   'joystickremoved',
   'keypressed',
   'keyreleased',
   'load',
   'lowmemory',
   'mousefocus',
   'mousemoved',
   'mousepressed',
   'mousereleased',
   'quit',
   'resize',
   'run',
   'textedited',
   'textinput',
   'threaderror',
   'touchmoved',
   'touchpressed',
   'touchreleased',
   'update',
   'visible',
   'wheelmoved',
   'joystickadded',
}

-- returns a list of all the items in t1 that aren't in t2
local function exclude(t1, t2)
   local set = {}
   for _, item in ipairs(t1) do set[item] = true end
   for _, item in ipairs(t2) do set[item] = nil end
   local t = {}
   for item, _ in pairs(set) do
      table.insert(t, item)
   end
   return t
end

--- A state manager that uses a stack to hold states. Implementation taken from https://github.com/tesselode/roomy.
--- @class GameStateManager : Object
--- @field private states GameState[]
--- @overload fun(): GameStateManager
local StateManager = prism.Object:extend("GameStateManager")

function StateManager:__new()
  self.states = {}
end

--- Emits an event to the current state, passing any extra parameters along to it.
--- @param event string The event to emit.
--- @param ... any Additional parameters to pass to the state.
function StateManager:emit(event, ...)
   local state = self.states[#self.states]
   if state and state[event] then state[event](state, ...) end
end

--- Changes the currently active state.
--- @param ... any Additional parameters to pass to the state.
function StateManager:enter(next, ...)
   local previous = self.states[#self.states]
   self:emit('unload', next, ...)
   previous.manager = nil
   self.states[#self.states] = next
   self:emit('load', previous, ...)
end

--- Pushes a new state onto the stack, making it the new active state.
--- @param next GameState The state to push.
--- @param ... any Additional parameters to pass to the state.
function StateManager:push(next, ...)
   local previous = self.states[#self.states]
   next.manager = self
   self:emit('pause', next, ...)
   self.states[#self.states + 1] = next
   self:emit('load', previous, ...)
end

--- Removes the active state from the stack and resumes the previous one.
--- @param ... any Additional parameters to pass to the state.
function StateManager:pop(...)
   local previous = self.states[#self.states]
   local next = self.states[#self.states - 1]
   self:emit('unload', next, ...)
   previous.manager = nil
   self.states[#self.states] = nil
   self:emit('resume', previous, ...)
end

--- Hooks the love callbacks into the manager's, overwriting the originals.
--- @param options? { include: string[], exclude: string[] } Lists of callbacks to include or exclude.
function StateManager:hook(options)
   options = options or {}
   local callbacks = options.include or loveCallbacks
   if options.exclude then
      callbacks = exclude(callbacks, options.exclude)
   end
   for _, callbackName in ipairs(callbacks) do
      local oldCallback = love[callbackName]
      love[callbackName] = function(...)
      if oldCallback then oldCallback(...) end
         self:emit(callbackName, ...)
      end
   end
end

return StateManager
