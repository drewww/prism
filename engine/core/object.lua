--- A simple class system for Lua. This is the base class for all other classes in PRISM.
---@class Object
---@field className string A unique name for this class. By convention this should match the annotation name you use.
local Object = {}
Object.className = "Object"
Object.stripName = true

--- Creates a new class and sets its metatable to the extended class.
--- @generic T
--- @param self T
--- @param className string
--- @return T prototype The new class prototype extended from this one.
function Object:extend(className)
    assert(className, "You must supply a class name when extending Objects!")
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.__call = self.__call or Object.__call
    o.className = className
    return o
end

--- Creates a new instance of the class. Calls the __new method.
--- @generic T
--- @param self T
--- @param ... any
--- @return T newInstance The new instance.
function Object:__call(...)
   local o = {}
   
   -- we hard cast self to a table
   --- @diagnostic disable-next-line
   --- @cast self Object
   setmetatable(o, self)
   self.__index = self

   o:__new(...)
   return o
end

--- The default constructor for the class. Subclasses should override this.
--- @param ... any
function Object:__new(...) end

--- Checks if o is in the inheritance chain of self.
--- @param self any
--- @param o table The class to check.
--- @return boolean is True if o is in the inheritance chain of self, false otherwise.
function Object:is(o)
   if self == o then return true end

   local parent = getmetatable(self)
   while parent do
      if parent == o then return true end

      parent = getmetatable(parent)
   end

   return false
end

--- Checks if o is the first class in the inheritance chain of self.
--- @param o table The class to check.
--- @return boolean extends True if o is the first class in the inheritance chain of self, false otherwise.
function Object:instanceOf(o)
   if getmetatable(self) == o then return true end

   return false
end

--- List of metamethods to block from mixins
local unmixed = {
   __index = true,
   __newindex = true,
   __call = true,
}

--- Mixes in methods and properties from another table, excluding blacklisted metamethods.
--- THis does not deep copy or merge tables, currently. It's a shallow mixin.
--- @param mixin table The table containing methods and properties to mix in.
--- @return self
function Object:mixin(mixin)
   for k, v in pairs(mixin) do
      if not unmixed[k] then
         self[k] = v
      end
   end

   return self
end

--- @type Object
local ret = Object:__call()
return ret