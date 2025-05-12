Taking Flight
=============

Unfortunately for kobolds, they can't fly. In this section of the tutorial we're going to 
create a :lua:class:`System` that listens for the end of an actor's turn, and sends things
falling into the void below if they're on a pit but unable to fly.

Creating the Fall System
------------------------

We'll create a new system called ``FallSystem``. Its job is to run at the end of every actor's turn and check whether they're floating over something they can't stand on.

First, make sure your file is in the correct place:

1. Navigate to the ``modules/MyGame/actions`` directory.
2. Create a new file called ``fall.lua``.

Write the following into ``fall.lua``:

.. code:: lua

   local Fall = prism.Action:extend "Fall"

   local flyMask = prism.Collision.createBitmaskFromMovetypes({"fly"})
   --- @param level Level
   function Fall:_canPerform(level)
      local x, y = self.owner:getPosition():decompose()
      local cellMask = level:getCell(x, y):getCollisionMask()
      local mover = self.owner:getComponent(prism.components.Mover)
      local mask = mover and mover.mask or 0 -- default to the immovable mask

      local isCellFlying = prism.Collision.checkBitmaskOverlap(flyMask, cellMask)
      local canActorMoveHere = prism.Collision.checkBitmaskOverlap(cellMask, mask)
      return isCellFlying and not canActorMoveHere
   end

   --- @param level Level
   function Fall:_perform(level)
      level:removeActor(self.owner) -- into the depths with you!
   end

   return Fall

Let's break it down.

.. code:: lua  

   local Fall = prism.Action:extend "Fall"

   local flyMask = prism.Collision.createBitmaskFromMovetypes({"fly"})

We create a Fall action, and build a bitmask of just the "fly" movetype.

.. code:: lua 

   function Fall:_canPerform(level)
      local x, y = self.owner:getPosition():decompose()
      local cellMask = level:getCell(x, y):getCollisionMask()
      local mover = self.owner:getComponent(prism.components.Mover)
      local mask = mover and mover.mask or 0 -- default to the immovable mask

We define Fall's ``_canPerform`` this is the inner private function to canPerform which you've
used for controlling kobolds and the player. We're grabbing the mask of the actor and the cell
here to see if the conditions are right for falling.

.. code:: lua
      local isCellFlying = prism.Collision.checkBitmaskOverlap(flyMask, cellMask)
      local canActorMoveHere = prism.Collision.checkBitmaskOverlap(cellMask, mask)
      return isCellFlying and not canActorMoveHere
   end

First we see if the cell allows flying movement. Then we check if the actor can move to the tile
they're standing on. If the cell allows flying and the actor has no movetypes that are allowed on
the cell then they can fall.

With all that out the way let's add the Fall action's _perform.

.. code:: lua
   --- @param level Level
   function Fall:_perform(level)
      level:removeActor(self.owner) -- into the depths with you!
   end

This ones simple, we remove the floating actor from the level.

Triggering Fall With a System
-----------------------------

Okay so we've got the call fction done, but this isn't exactly something
most actors are doing willingly. I doubt the kobold is going to fall by itself.

Let's create a System to listen in and make sure things fall when they aught to.

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