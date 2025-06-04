--- @class IQueryable
--- @field query fun(self, ...:Component): Query

--- Represents a query over actors in an `ActorStorage`, filtering by required components and optionally by position.
--- Supports fluent chaining via `with()` and `at()` methods.
--- Provides `iter()`, `each()`, and `gather()` for iteration and retrieval.
--- @class Query : Object
--- @field private requiredComponents table<Component, boolean> A set of required component types.
--- @field private requiredComponentsList Component[] Ordered list of required component types.
--- @field private requiredComponentsCount integer The number of required component types.
--- @field private requiredPosition Vector2? Optional position filter.
local Query = prism.Object:extend "Query"

--- @param storage ActorStorage The storage system to query from.
--- @param ... Component A variable number of component types to require.
function Query:__new(storage, ...)
   self.storage = storage

   self.requiredComponents = {}
   self.requiredComponentsList = {}
   self.requiredComponentsCount = 0

   self:with(...)
   self.requiredPosition = nil
end

--- Adds required component types to the query.
--- Can be called multiple times to accumulate components.
--- @param ... Component A variable number of component types.
--- @return Query query Returns self to allow method chaining.
function Query:with(...)
   local req = { ... }

   for _, component in ipairs(req) do
      assert(
         not self.requiredComponents[component],
         "Multiple component of the same type added to query!"
      )

      self.requiredComponentsCount = self.requiredComponentsCount + 1
      table.insert(self.requiredComponentsList, component)

      self.requiredComponents[component] = true
   end

   return self
end

--- Restricts the query to actors at a specific position.
--- @param x integer The x-coordinate.
--- @param y integer The y-coordinate.
--- @return Query query Returns self to allow method chaining.
function Query:at(x, y)
   self.requiredPosition = prism.Vector2(x, y)

   return self
end

local components = {}

-- Helper function to check all required components for an actor
local function hasRequired(actor, storage, requiredComponents)
   for component in pairs(requiredComponents) do
      local cache = storage:getComponentCache(component)
      if not cache or not cache[actor] then return false end
   end
   return true
end

-- Helper function to get components for an actor
--- @param actor Actor
--- @param requiredComponentsList Component[]
--- @return ...:Component
local function getComponents(actor, requiredComponentsList)
   local n = 0
   for _, component in ipairs(requiredComponentsList) do
      n = n + 1
      components[n] = actor:get(component)
   end
   return unpack(components, 1, n)
end
--- Returns an iterator function over all matching actors.
--- The iterator yields `(actor, ...components)` for each match.
--- Selection is optimized depending on number of required components and presence of position.
--- @return fun(): Actor?, ...:Component?
function Query:iter()
   local positionCache = self.storage:getSparseMap()
   local actors = self.storage:getAllActors()
   local requiredPosition = self.requiredPosition

   --- @type table<Component, boolean>
   local requiredComponents = self.requiredComponents

   -- Case 1: Position-based query
   if requiredPosition then
      local actors = positionCache:get(self.requiredPosition:decompose())
      if not actors then return function()
         return nil
      end end

      local iter, state, actor = pairs(actors)
      return function()
         while true do
            actor = iter(state, actor)
            if not actor then return nil end
            if hasRequired(actor, self.storage, requiredComponents) then
               return actor, getComponents(actor, self.requiredComponentsList)
            end
         end
      end
   end

   -- Case 2: Single component query — directly iterate over componentCache
   if self.requiredComponentsCount == 1 then
      local component = self.requiredComponentsList[1]
      local cache = self.storage:getComponentCache(component)
      if not cache then return function()
         return nil
      end end

      local actor = nil
      return function()
         actor = next(cache, actor)
         if not actor then return nil end
         if hasRequired(actor, self.storage, requiredComponents) then
            return actor, actor:get(component)
         end
      end
   end

   -- Case 3: Component-only query — use smallest component set
   local smallestCache = nil
   local smallestCount = math.huge
   for component in pairs(requiredComponents) do
      local cache = self.storage:getComponentCache(component)
      if
         cache and (not smallestCache or self.storage:getComponentCount(component) < smallestCount)
      then
         smallestCache = cache
         smallestCount = self.storage:getComponentCount(component)
      end
   end

   if not smallestCache then
      local i = 1
      return function()
         local actor = actors[i]
         i = i + 1
         return actor
      end
   end

   local actor = nil
   return function()
      while true do
         actor, _ = next(smallestCache, actor)
         if not actor then return nil end
         if hasRequired(actor, self.storage, requiredComponents) then
            return actor, getComponents(actor, self.requiredComponentsList)
         end
      end
   end
end

--- Gathers all matching results into a list.
--- @param results? Actor[] Optional table to insert results into.
--- @return Actor[] actors The populated list of results.
function Query:gather(results)
   local results = results or {}

   local iterator = self:iter()

   while true do
      local result = iterator()
      if not result then break end

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
--- @param fn fun(actor: Actor, ...:Component) The function to apply to each result.
function Query:each(fn)
   local iter = self:iter()
   while eachBody(fn, iter()) do
   end
end

--- Returns the first matching actor and its components.
--- @return Actor? actor The first matching actor, or nil if no actor matches.
function Query:first()
   local iterator = self:iter()
   local actor = iterator() -- Get the first result from the iterator
   if actor then return actor end

   return nil -- Return nil if no actor was found
end

return Query
