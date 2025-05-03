--- An 'Actor' represents entities in the game, including the player, enemies, and items.
--- Actors are composed of Components that define their state and behavior.
--- For example, an actor may have a Sight component that determines their field of vision, explored tiles,
--- and other related aspects.
--- @class Actor : Entity
--- @field private position Vector2 An actor's position in the game world.
--- @field level? Level The level the actor is on.
--- @overload fun(): Actor
local Actor = prism.Entity:extend("Actor")
Actor.position = nil
Actor.name = "actor"

--- Constructor for an actor.
--- Initializes and copies the actor's fields from its prototype.
--- @param self Actor
function Actor:__new()
   prism.Entity.__new(self)
   self.position = prism.Vector2(1, 1)
end

--
--- Components
--

--- Adds a component to the entity. This function will check if the component's
--- prerequisites are met and will throw an error if they are not.
--- @param component Component The component to add to the entity.
function Actor:addComponent(component)
   prism.Entity.addComponent(self, component)
   if self.level then
      ---@diagnostic disable-next-line
      self.level:__addComponent(self, component)
   end
end

--- Removes a component from the actor. This function will throw an error if the
--- component is not present on the actor.
--- @param component Component The component to remove from the actor.
function Actor:removeComponent(component)
   prism.Entity.removeComponent(self, component)
   if self.level then
      ---@diagnostic disable-next-line
      self.level:__removeComponent(self, component)
   end
end

--- Creates the components for the actor. Override this.
--- @return Component[]
function Actor:initialize()
   return {}
end

--
--- Actions
--

--- Get a list of actions that the actor can perform.
--- @return Action[] totalActions A table of all actions.
function Actor:getActions()
   local totalActions = {}

   for _, action in pairs(prism.actions) do
      if action:hasRequisiteComponents(self) then
         table.insert(totalActions, action)
      end
   end

   return totalActions
end

--
-- Utility
--

--- Returns the current position of the actor.
--- @return Vector2 position Returns a copy of the actor's current position.
function Actor:getPosition() return self.position:copy() end

--- Get the range from this actor to another actor.
--- @param actor Actor The other actor to get the range to.
--- @param type? DistanceType
--- @return number -- The calculated range.
function Actor:getRange(actor, type)
   return self.position:getRange(actor.position, type)
end

--- Get the range from this actor to a given vector.
--- @param vector Vector2 The vector to get the range to.
--- @param type? DistanceType The type of range calculation to use.
--- @return number -- The calculated range.
function Actor:getRangeVec(vector, type) return self.position:getRange(vector, type) end

return Actor
