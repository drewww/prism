Taking Flight
=============

Unfortunately for kobolds, they can't fly. In this section of the tutorial we're going to 
create a :lua:class:`System` that listens for the end of an actor's turn, and sends things
falling into the void below if they're on a pit but unable to fly.

Creating the Void component
---------------------------

1. Navigate to ``modules/MyGame/components```
2. Create a new file called ``void.lua``

Put the following into ``void.lua``:

.. code:: lua

   --- @class Void : Component
   local Void = prism.Component:extend("Void")
   Void.name = "Void"

   return Void

This is a simple tag component that we'll put on cells to indicate that
an actor can fall here if they don't have an allowed movetype while standing
on the cell.

Adding Void to Our Pit
----------------------

1. Navigate to ``modules/MyGame/cells/pit.lua``

Add the following line to it's components:

.. code:: lua  

   prism.components.Void()

Creating the Fall System
------------------------

We'll create a new system called ``FallSystem``. Its job is to run at the end of every actor's turn and check whether they're floating over something they can't stand on.

First, make sure your file is in the correct place:

1. Navigate to the ``modules/MyGame/actions`` directory.
2. Create a new file called ``fall.lua``.

Write the following into ``fall.lua``:

.. code:: lua

   --- @class Fall : Action
   local Fall = prism.Action:extend "Fall"

   --- @param level Level
   function Fall:_canPerform(level)
      local x, y = self.owner:getPosition():decompose()
      local cell = level:getCell(x, y)

      -- We can only fall on cells that are voids.
      if not cell:hasComponent(prism.components.Void) then return false end

      local cellMask = cell:getCollisionMask()
      local mover = self.owner:getComponent(prism.components.Mover)
      local mask = mover and mover.mask or 0 -- default to the immovable mask

      -- We have a Void component on the cell. If the actor CAN'T move here
      -- then they fall.
      return not prism.Collision.checkBitmaskOverlap(cellMask, mask)
   end

   --- @param level Level
   function Fall:_perform(level)
      level:removeActor(self.owner) -- into the depths with you!
   end

   return Fall

Let's break it down.

.. code:: lua  

   local Fall = prism.Action:extend "Fall"

We create a Fall action.

.. code:: lua 

   function Fall:_canPerform(level)
      local x, y = self.owner:getPosition():decompose()
      local cell = level:getCell(x, y)

      -- We can only fall on cells that are voids.
      if not cell:hasComponent(prism.components.Void) then return false end

We define Fall's ``_canPerform`` this is the inner private function to canPerform which you've
used for controlling kobolds and the player. We check if the cell the actor is standing on
has the void component, and if it doesn't the actor can't fall.

.. code:: lua  

      local cellMask = cell:getCollisionMask()
      local mover = self.owner:getComponent(prism.components.Mover)
      local mask = mover and mover.mask or 0 -- default to the immovable mask

      -- We have a Void component on the cell. If the actor CAN'T move here
      -- then they fall.
      return not prism.Collision.checkBitmaskOverlap(cellMask, mask)
   end

Now that we've checked if the cell is a void we check if the actor can stands there.
If the cell is a void, and the actor can't stand there off to depths they go!

With all that out the way let's add the Fall action's _perform.

.. code:: lua  

   --- @param level Level
   function Fall:_perform(level)
      level:removeActor(self.owner) -- into the depths with you!
   end

This ones simple, we remove the floating actor from the level.

Triggering Fall With a System
-----------------------------

Okay so we've got the fall action done, but this isn't exactly something
most actors are doing willingly. I doubt the kobold is going to opt to fall by itself.

Let's create a System to listen in and make sure things fall when they ought to.

1. Navigate to the ``modules/MyGame/`` directory.
2. Create a new folder called ``systems``.
3. Create a new file in that folder named ``fallsystem.lua``

Add the following code:

.. code:: lua

   --- @class FallSystem : System
   local FallSystem = prism.System:extend "FallSystem"


   --- @param level Level
   --- @param actor Actor
   function FallSystem:onMove(level, actor)
      local fall = prism.actions.Fall(actor)

      if fall:canPerform(level) then
         level:performAction(fall)
      end
   end

   return FallSystem

When an actor moves we check if it should fall when it reaches it's destination. We're
hooking into :lua:func:`System.onMove` which is trigged by Level whenever :lua:func:`Level:moveActor`
is called.

See :lua:class:`System` for a listing of events you can hook into!

With our FallSystem in place, kobolds and other unfortunate creatures will now tumble 
into the void if they end their turn standing on a pit they can’t fly over.
We’ve used components to tag dangerous tiles, actions to represent involuntary movement,
and systems to enforce game logic based on actor movement.

In the next section of the tutorial, we’ll dive into something a little more active:
combat. We’ll set up a health component, and teach actors how to attack.