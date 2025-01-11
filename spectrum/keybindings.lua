---@class Keybinding : Object
local Keybinding = prism.Object:extend("Keybinding")

--- Constructor for the Keybinding class.
--- Initializes the keymap and an optional mode system for contextual bindings.
function Keybinding:__new()
   self.keymap = {} -- Maps keys to strings
   self.modes = {} -- Optional modes for contextual bindings
   self.currentMode = nil -- Current mode, if any
end

--- Adds a new keybinding to the keymap.
--- @param key string The key to bind.
--- @param value string The string to map the key to.
--- @param mode string|nil An optional mode for the binding.
function Keybinding:add(key, value, mode)
   assert(type(key) == "string", "Key must be a string.")
   assert(type(value) == "string", "Value must be a string.")

   if mode then
      self.modes[mode] = self.modes[mode] or {}
      self.modes[mode][key] = value
   else
      self.keymap[key] = value
   end
end

--- Removes a keybinding from the keymap.
--- @param key string The key to unbind.
--- @param mode string|nil An optional mode for the binding.
function Keybinding:remove(key, mode)
   if mode and self.modes[mode] then
      self.modes[mode][key] = nil
   else
      self.keymap[key] = nil
   end
end

--- Sets the current mode for keybindings.
--- @param mode string|nil The mode to set. Use nil to disable modes.
function Keybinding:setMode(mode)
   assert(mode == nil or self.modes[mode], "Mode does not exist.")
   self.currentMode = mode
end

--- Handles key press events and retrieves the associated string if a binding exists.
--- @param key string The key that was pressed.
--- @return string|nil The string associated with the key, or nil if no binding exists.
function Keybinding:handleKeyPress(key)
   local value = nil

   if self.currentMode and self.modes[self.currentMode] then
      value = self.modes[self.currentMode][key]
   end

   if not value then
      value = self.keymap[key]
   end

   return value
end

--- Clears all keybindings, optionally for a specific mode.
--- @param mode string|nil The mode to clear. If nil, clears all bindings.
function Keybinding:clear(mode)
   if mode then
      self.modes[mode] = nil
   else
      self.keymap = {}
      self.modes = {}
      self.currentMode = nil
   end
end

return Keybinding