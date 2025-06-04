--- The superclass of entitys and cells, holding their components.
--- @class Entity : Object
--- @field components Component[] A table containing all of the entity's component instances. Generated at runtime.
--- @field componentCache table<Component, Component> This is a cache of prototype -> component for component queries, reducing most queries to a hashmap lookup.
--- @overload fun(): Entity
local Entity = prism.Object:extend("Entity")

--- Constructor for an entity.
--- Initializes and copies the entity's fields from its prototype.
--- @param self Entity
function Entity:__new()
   self.position = prism.Vector2(1, 1)

   local components = self:initialize()
   self.components = {}
   self.componentCache = {}
   if components then
      for _, component in ipairs(components) do
         component.owner = self
         self:give(component)
      end
   end
end

--
--- Components
--

--- Creates the components for the entity. Override this.
--- @return Component[]
function Entity:initialize()
   return {}
end

--- Adds a component to the entity, replacing any existing component of the same type. Will check if the component's
--- prerequisites are met and will throw an error if they are not.
--- @param component Component The component to add to the entity.
--- @return Entity -- The entity, for chaining purposes.
function Entity:give(component)
   -- stylua: ignore start
   assert(component:isInstance(), "Expected an instance of a Component!")

   local requirementsMet, missingComponent = component:checkRequirements(self)
   if not requirementsMet then
      --- @cast missingComponent Component
      local err = "%s was missing requirement %s for %s"
      error(err:format(self.name, missingComponent.name, component.name))
   end

   -- Set the component for all sub-classes
   for _, v in pairs(prism.components) do
      if v:is(component) then
         self.componentCache[v] = component
      end
   end
   -- stylua: ignore end

   component.owner = self
   table.insert(self.components, component)
   return self
end

--- Removes a component from the entity.
--- @param component Component The component to remove from the entity.
--- @return Entity -- The entity, for chaining purposes.
function Entity:remove(component)
   if component:isInstance() then component = getmetatable(component) end

   if not self:has(component) then
      -- stylua: ignore
      prism.logger.warn("Tried to remove " .. component.name .. " from " .. self.name .. " but they didn't have it.")
      return self
   end

   -- Remove all of the sub-classes from the cache
   for _, componentPrototype in pairs(prism.components) do
      if componentPrototype:is(component) then
         for cachedComponent, _ in pairs(self.componentCache) do
            if componentPrototype:is(cachedComponent) then
               self.componentCache[cachedComponent] = nil
            end
         end
      end
   end

   for i = 1, #self.components do
      if component:is(self.components[i]) then
         local componentInstance = table.remove(self.components, i)
         componentInstance.owner = nil
         return self
      end
   end

   return self
end

--- Gives the component, but only if the entity doesn't already have it.
--- @param component Component The component to ensure.
--- @return Entity -- The entity, for chaining.
function Entity:ensure(component)
   assert(component:isInstance(), "Expected an instance of a Component!")

   if not self:has(getmetatable(component)) then self:give(component) end

   return self
end

--- Checks whether the entity has all of the components given.
--- @param ... Component The list of component prototypes.
--- @return boolean hass True if the entity has all of the components given.
function Entity:has(...)
   for _, prototype in ipairs({ ... }) do
      -- stylua: ignore
      prism.Object.assertType(prototype, prism.Component)
      if not self.componentCache[prototype] then return false end
   end

   return true
end

--- Returns the components for the prototypes given, or nil if the entity does not have it.
--- @generic T
--- @param prototype T The type of the component to return.
--- @return T?
--- @return Component? ...
function Entity:get(prototype, ...)
   if prototype == nil then return nil end

   return self.componentCache[prototype], self:get(...)
end

--- Expects a component, returning it or erroring if the entity does not have the component.
--- @generic T
--- @param prototype T The type of the component to return.
--- @return T
function Entity:expect(prototype)
   prism.Object.assertType(prototype, prism.Component)
   --- @cast prototype Object
   return self.componentCache[prototype]
      or error("Expected component " .. prototype.className .. " but it was not present!")
end

return Entity
