--- @class Query : Object
--- @field private requiredComponents table<Component, boolean> Hashset of required components
--- @field private requiredComponentsList Component[]
--- @field private requiredPosition Vector2? The position to filter for.
local Query = prism.Object:extend "Query"

--- @param storage ActorStorage
function Query:__new(storage, ...)
   self.storage = storage

   self.requiredComponents = {}
   self.requiredComponentsList = {}
   self.requiredComponentsCount = 0

   self:with(...)
   self.requiredPosition = nil
end

--- @param ... Component
function Query:with(...)
   local req = { ... }

   for _, component in ipairs(req) do
      if not self.requiredComponents[component] then
         self.requiredComponentsCount = self.requiredComponentsCount + 1
         table.insert(self.requiredComponentsList, component)
      end

      self.requiredComponents[component] = true
   end

   return self
end

--- @param x integer
--- @param y integer
function Query:at(x, y)
   self.requiredPosition = prism.Vector2(x, y)

   return self
end


local components = {}

-- Helper function to check all required components for an actor
local function hasRequired(actor, storage, requiredComponents)
   for component in pairs(requiredComponents) do
      local cache = storage:getComponentCache(component)
      if not cache or not cache[actor] then
         return false
      end
   end
   return true
end

-- Helper function to get components for an actor
--- @param actor Actor
--- @param requiredComponents table<Component, boolean>
--- @return ...:Component 
local function getComponents(actor, requiredComponents)
   local n = 0
   for component, _ in pairs(requiredComponents) do
      n = n + 1
      components[n] = actor:getComponent(component)
   end
   return unpack(components, 1, n)
end

--- @return fun(): Actor?, ...:Component?
function Query:iter()
   local positionCache = self.storage:getSparseMap()
   local actors = self.storage:getAllActors()
   local componentCounts = self.storage.componentCounts
   local requiredPosition = self.requiredPosition

   --- @type table<Component, boolean>
   local requiredComponents = self.requiredComponents

   -- Case 1: Position-based query
   if requiredPosition then
      local actors = positionCache:get(self.requiredPosition:decompose())
      if not actors then
         return function() return nil end
      end

      local iter, state, actor = pairs(actors)
      return function()
         while true do
            actor = iter(state, actor)
            if not actor then return nil end
            if hasRequired(actor, self.storage, requiredComponents) then
               print "DABA"
               return actor, getComponents(actor, requiredComponents)
            end
         end
      end
   end

   print(self.requiredComponentsCount)
   print "YER"
   -- Case 2: Single component query — directly iterate over componentCache
   if self.requiredComponentsCount == 1 then
      local component = self.requiredComponentsList[1]
      local cache = self.storage:getComponentCache(component)
      if not cache then
         return function() return nil end
      end

      local actor = nil
      return function()
         actor = next(cache, actor)
         if not actor then return nil end
         if hasRequired(actor, self.storage, requiredComponents) then
            print(actor, actor:getComponent(component))
            return actor, actor:getComponent(component)
         end
      end
   end

   -- Case 3: Component-only query — use smallest component set
   local smallestCache = nil
   local smallestCount = math.huge
   for component in pairs(requiredComponents) do
      local cache = self.storage:getComponentCache(component)
      if cache and (not smallestCache or componentCounts[component] < smallestCount) then
         smallestCache = cache
         smallestCount = componentCounts[component]
      end
   end

   print "YUR"
   if not smallestCache then
      local i = 1
      return function()
         local actor = actors[i]
         i = i + 1
         return actor
      end
   end

   local actor = nil
   print "DUR"
   return function()
      while true do
         actor, _ = next(smallestCache, actor)
         if not actor then return nil end
         if hasRequired(actor, self.storage, requiredComponents) then
            return actor, getComponents(actor, requiredComponents)
         end
      end
   end
end


function Query:gather(results)
   local results = results or {}

   local iterator = self:iter()

   while true do
      local result = iterator()
      if not result then
         break
      end

      table.insert(results, result)
   end

   return results
end

local function eachBody(fn, ...)
   local first = ...
   if not first then return false end

   fn(...)
   return true
end

--- Applies a function to each matching actor and its components.
--- @param fn fun(actor: Actor, ...:Component)
function Query:each(fn)
   local iter = self:iter()
   while eachBody(fn, iter()) do end
end

return Query