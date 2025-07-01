Descending into the depths
==========================

In this chapter we're going to add stairs and create a new ``Level`` when the player uses our new
``Descend`` action on the stairs.

Adding a stair component
------------------------

Navigate to ``modules/MyGame/components/`` and create a new file called ``stair.lua``. This
will be a simple tag component to indicate the actor can be descended.

.. code:: lua

   --- @class Stair : Component
   local Stair = prism.Component:extend("Stair")

   return Stair

Creating the stairs actor
-------------------------

Next we'll register a ``Stairs`` actor.

.. code:: lua

   prism.registerActor("Stairs", function()
      return prism.Actor.fromComponents {
         prism.components.Position(),
         prism.components.Drawable(">"),
         prism.components.Stair(),
         prism.components.Remembered(),
      }
   end)

Placing the stairs on the map
-----------------------------

Okay we've got our stairs created, it's time to place them on the map. Navigate to
``levelgen.lua`` and head to the bottom of the function right above return.

.. code:: lua

   --- @type Rectangle[]
   local availableRooms = {}
   for _, room in pairs(rooms) do
      if room ~= startRoom then
         table.insert(availableRooms, room)
      end
   end

   local stairRoom = availableRooms[rng:getUniformInt(1, #availableRooms)]
   local corners = stairRoom:toCorners()
   local randCorner = corners[rng:getUniformInt(1, #corners)]

   builder:addActor(prism.actors.Stairs(), randCorner.x, randCorner.y)

We collect all the rooms the player didn't spawn in into a table, and then choose a random
room. We place the stairs in a random corner of that room for now.

The descend message
-------------------

Navigate to ``moudles/game/messages`` and create a new file ``descend.lua``.

.. code:: lua

   --- @class DescendMessage : Message
   --- @overload fun(): DescendMessage
   local DescendMessage = prism.Object:extend("DescendMessage")

   return DescendMessage

For now we don't need anything inside of ``Descend``.

The descend action
------------------

.. code:: lua

   local DescendTarget = prism.Target()
      :with(prism.components.Stair)
      :range(1)

   ---@class Descend : Action
   ---@overload fun(owner: Actor, stairs: Actor): Descend
   local Descend = prism.Action:extend("Descend")
   Descend.targets = { DescendTarget }

   function Descend:perform(level)
      level:removeActor(self.owner)
      level:yield(prism.messages.Descend())
   end

   return Descend

First we create a target that targets actors with the ``Stair`` component within range 1. Then we create
our ``Descend`` action, which is similar to ``Die`` but yields a different message.

Now let's add some code to ``GameLevelState:keypressed``. After we figure out which direction the user
just pressed we'll add the following.

.. code:: lua

   if keybindOffsets[action] then
      local destination = owner:getPosition() + keybindOffsets[action]

      -- add this
      local descendTarget = self.level:query(prism.components.Stairs)
         :at(destination:decompose())
         :first()

      local descend = prism.actions.Descend(owner, descendTarget)
      if self.level:canPerform(descend) then
         decision:setAction(descend)
         return
      end

Creating the next floor
-----------------------

Now that we've got everything set up we need to actually handle the ``Descend`` message. In
``MyGameLevelState:handleMessage`` we'll add the following message handling.

.. code:: lua

   if prism.messages.Descend:is(message) then
      self.manager:enter(GameLevelState(self.display))
   end

If we run the game and find ourselves a staircase we'll be able to go down
to a new floor!

There are a couple of problems, though. The new level has a completely new player on it and we're not
tracking depth anywhere.

In the next chapter
-------------------

We'll set up a ``Game`` object that tracks what depth we're on and manages level generation. We'll
pass the player to the new level so that we're playing as the same actor all the way down.
