--- Entities in the game, including the player, enemies, and items.
--- Actors are composed of Components that define their state and behavior.
--- For example, an actor may have a Sight component that determines their field of vision, explored tiles,
--- and other related aspects.
--- @class Actor : Entity
--- @field level? Level The level the actor is on.
--- @overload fun(): Actor
local Actor = prism.Entity:extend("Actor")

--- @alias ActorFactory fun(...): Actor

--- Constructor for an actor.
--- Initializes and copies the actor's fields from its prototype.
--- @param self Actor
function Actor:__new()
   prism.Entity.__new(self)
end

--
--- Components
--

--- Adds a component to the entity. This function will check if the component's
--- prerequisites are met and will throw an error if they are not.
--- @param component Component The component to add to the entity.
--- @return Entity
function Actor:give(component)
   prism.Entity.give(self, component)
   if self.level then
      ---@diagnostic disable-next-line
      self.level:__addComponent(self, component)
   end

   return self
end

--- Removes a component from the actor. This function will throw an error if the
--- component is not present on the actor.
--- @param component Component The component to remove from the actor.
--- @return Entity
function Actor:remove(component)
   prism.Entity.remove(self, component)
   if self.level then
      ---@diagnostic disable-next-line
      self.level:__removeComponent(self, component)
   end

   return self
end

--- Creates the components for the actor. Override this.
--- @return Component[]
function Actor:initialize()
   return {}
end

--- Initializes an actor from a list of components.
--- @param components Component[] A list of components to give to the new actor.
--- @return Actor actor The new actor.
function Actor.fromComponents(components)
   local actor = Actor()
   for _, component in ipairs(components) do
      actor:give(component)
   end
   return actor
end

--
--- Actions
--

--- Get a list of actions that the actor can perform.
--- @return Action[] totalActions A table of all actions.
function Actor:getActions()
   local totalActions = {}

   for _, action in pairs(prism.actions) do
      if action:hasRequisiteComponents(self) then table.insert(totalActions, action) end
   end

   return totalActions
end

--
-- Utility
--

--- Returns the current position of the actor
--- @param out Vector2? An optional out parameter. A new Vector2 will be allocated in its absence.
--- @return Vector2? position Returns a copy of the actor's current position.
function Actor:getPosition(out)
   local comp = self:get(prism.components.Position)

   if comp then return comp:getVector():copy(out) end
end

--- @private
function Actor:_setPosition(vec)
   --- @diagnostic disable-next-line
   self:expect(prism.components.Position)._position = vec:copy()
end

function Actor:expectPosition(out)
   return self:expect(prism.components.Position):getVector():copy(out)
end

--- Get the range from this actor to another actor.
--- @param actor Actor The other actor to get the range to.
--- @param type? DistanceType Optional distance type.
--- @return number The calculated range.
function Actor:getRange(actor, type)
   local collider = self:get(prism.components.Collider)
   local otherCollider = actor:get(prism.components.Collider)

   if not collider or not otherCollider then
      return self:expectPosition():getRange(actor:expectPosition(), type)
   end

   local pos1 = self:expectPosition()
   local size1 = collider:getSize()
   local pos2 = actor:expectPosition()
   local size2 = otherCollider:getSize()

   local x1Min, x1Max = pos1.x, pos1.x + size1 - 1
   local y1Min, y1Max = pos1.y, pos1.y + size1 - 1
   local x2Min, x2Max = pos2.x, pos2.x + size2 - 1
   local y2Min, y2Max = pos2.y, pos2.y + size2 - 1

   local point1 = prism.Vector2(
      math.max(x2Min, math.min(x1Min, x2Max)),
      math.max(y2Min, math.min(y1Min, y2Max))
   )

   local point2 = prism.Vector2(
      math.max(x1Min, math.min(x2Min, x1Max)),
      math.max(y1Min, math.min(y2Min, y1Max))
   )

   return point1:getRange(point2, type)
end


--- Get the range from this actor to a given vector.
--- @param vector Vector2 The vector to get the range to.
--- @param type? DistanceType The type of range calculation to use.
--- @return number -- The calculated range.
function Actor:getRangeVec(vector, type)
   return self:expectPosition():getRange(vector, type)
end

return Actor
