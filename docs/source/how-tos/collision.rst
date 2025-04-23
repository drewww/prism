Collision
=========

Most roguelikes require some kind of collision, so we've provided a collision system
built in to Prism. Here's how it works:

First, register any "layers" or types of movement you want to use:

.. code:: lua

   prism.Collision.assignNextAvailableMovetype("walk")
   prism.Collision.assignNextAvailableMovetype("fly")

These are just strings, so it's recommended to use constants to identify them. Then, for every 
:lua:class:`Cell` in your game, define which movement types are allowed through:

.. code:: lua

   Floor.allowedMovetypes = { "walk" }

   Pit.allowedMovetypes = { "fly" }

For actors, the :lua:class:`ColliderComponent` is provided. Use it to define which movement types
the actor blocks:

.. code:: lua

   prism.components.Collider{ allowedMovetypes = { "fly" } }

For movement, you can define a component yourself with a collision mask. Here's an example:

.. code:: lua

   --- @class MoverComponent : Component
   --- @field mask integer
   local Mover = prism.Component:extend( "MoverComponent" )
   Mover.name = "Mover"

   --- @param movetypes string[]
   function Mover:__new(movetypes)
      self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
   end

   return Mover

   ...

   prism.components.Mover{ "walk" }

Then you can use it whenever a function expects a mask, like in :lua:func:`Level.findPath` or
:lua:func:`Level.getCellPassable`. You might also want to use a custom mask for a specific action, 
such as throwing an item. 
