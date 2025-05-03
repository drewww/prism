Getting started
===============

In this tutorial, we'll start with a project template and create an enemy that follows
the player. And we'll add the ability to kick them.


.. video:: ../_static/output.mp4
   :caption: Kicking a kobold
   :align: center

The following sections will expand this into a complete game.

Installation
------------

To begin, download and install LÖVE. Prism technically supports LÖVE version 12.0, which is still
in pre-release but very stable.

Latest downloads, as of April 2025:

- `Windows <https://github.com/love2d/love/actions/runs/14505101389/artifacts/2960592718>`_
- `Linux AppImage <https://github.com/love2d/love/actions/runs/14505101389/artifacts/2960587520>`_
- `macOS <https://github.com/love2d/love/actions/runs/14505101389/artifacts/2960597108>`_

.. note::

   Prism makes heavy use of Lua type annotations to improve autocomplete, so we recommend
   installing the `Lua language server <https://luals.github.io/>`_ for your editor.

Next, clone the template project:

.. code:: sh

   git clone --recursive https://github.com/PrismRL/prism-template.git

You can start the game by running ``love .`` in the terminal from the root directory,
or dragging the root folder onto the LÖVE executable.

Upon launching, you should see an ``@`` symbol on the screen. You can
move this character using the following default keys:

* ``WASD`` for movement
* ``QEZC`` for diagonal movement

--------------

Creating an enemy
-----------------

To make the game more engaging, let’s introduce an enemy: the
**Kobold**.

1. Navigate to the ``/modules/MyGame/actors/`` directory.
2. Create a new file named ``kobold.lua``.
3. Add the following code to define the Kobold actor:

.. code:: lua

   --- @class Kobold : Actor
   local Kobold = prism.Actor:extend("Kobold")
   Kobold.name = "Kobold"

   function Kobold:initialize()
      return {
         prism.components.Drawable(string.byte("k") + 1, prism.Color4.RED),
      }
   end

   return Kobold

Let’s run the game again, and press ``~``. This opens Geometer, the editor.
Click on the k on the right hand side and use the pen tool to draw a
kobold in. Press the green button to resume the game.

You might notice that you can walk right through the kobold. We fix that by giving it a
:lua:class:`ColliderComponent`:

.. code:: lua

   prism.components.ColliderComponent()

.. note::

   See :doc:`../how-tos/collision` for more information on the collision system.

If we restart the game and spawn in another kobold, we shouldn't be able to walk
through kobolds anymore. We're also going to give the kobold a few more core components: a
:lua:class:`SensesComponent`, ``SightComponent``, and ``MoverComponent``, so it can see and move:

.. code:: lua

   prism.components.Senses(),
   prism.components.Sight{ range = 12, fov = true },
   prism.components.Mover{ "walk" }


The kobold controller
---------------------

Now that the kobold exists in the world, you might notice something—it’s
not moving! To give it behavior, we need to implement a :lua:class:`ControllerComponent`.

A :lua:class:`ControllerComponent` (or one of its derivatives) defines the :lua:func:`ControllerComponent.act`
function, which takes the :lua:class:`Level` and the :lua:class:`Actor` as arguments and
returns a valid action.

.. caution::

   The ``act`` function **should not modify the level directly**--it should only use it to validate actions.

1. Navigate to ``modules/MyGame/components/``.
2. Create a new file named ``koboldcontroller.lua``.
3. Add the following code:

.. code:: lua

   --- @class KoboldControllerComponent : ControllerComponent
   --- @overload fun(): KoboldControllerComponent
   local KoboldController = prism.components.Controller:extend("KoboldControllerComponent")
   KoboldController.name = "KoboldController"

   function KoboldController:act(level, actor)
      local destination = actor:getPosition() + prism.Vector2.RIGHT
      local move = prism.actions.Move(actor, { destination })
      if move:canPerform(level) then
         return move
      end

      return prism.actions.Wait()
   end

   return KoboldController

.. tip::

   Always provide a default action to take in a controller.

Back in ``kobold.lua``, give it our new controller component:

.. code:: lua

   prism.components.KoboldController()

Our kobold should move right until they hit a wall now, but this
behaviour doesn't make for a great game. Let's make them follow the player around.

Pathfinding
-----------
To make our kobold follow the player, we need to do a few things:

1. See if the player is within range of the kobold.
2. Find a valid path to the player.
3. Move the kobold along that path.

We can find the player by grabbing the :lua:class:`SensesComponent` from the kobold and
seeing if it contains the player.

.. code:: lua

   local senses = actor:getComponent(prism.components.Senses)
   local player = senses.actors:getActorByType(prism.actors.Player)
   if not player then return prism.actions.Wait() end

We can get a path to the player by using the :lua:func:`Level.findPath` method, passing the
positions and the kobold's collision mask.

.. code:: lua

   local mover = actor:getComponent(prism.components.Mover)
   local path = level:findPath(actor:getPosition(), player:getPosition(), 1, mover.mask)

Then we check if there's a path and move the kobold along it, using :lua:func:`Path.pop` to get the first
position.

.. code:: lua

   if path then
      local move = prism.actions.Move(actor, { path:pop() })
      if move:canPerform(level) then
         return move
      end
   end

Kicking kobolds
---------------

In this section we’ll give you something to do to these kobolds: kick them!
We’ll need to create our first action. Head over to ``/modules/MyGame/actions`` and add kick.lua.

Let’s first create a target for our kick. Put this at the top of
kick.lua:

.. code:: lua

   --- @class KickTarget : Target
   local KickTarget = prism.Target:extend("KickTarget")

   function KickTarget:validate(owner, actor, targets)
      ---@cast actor Actor
      return actor:is(prism.Actor)
         and actor:hasComponent(prism.components.Collider)
         and owner:getRange("8way", actor) == 1
   end

With this target we’re saying you can only kick actors at range one with a collider 
component. Then we can define the kick action, including our target. We will also require
that any actor trying to perform the kick action have a controller.

.. code:: lua

   ---@class KickAction : Action
   local Kick = prism.Action:extend("KickAction")
   Kick.name = "Kick"
   Kick.targets = { KickTarget }
   Kick.requiredComponents = {
      prism.components.Controller
   }

   return Kick

For the logic, we'll define methods that validate and perform the kick. We don't have any
special conditions for kicking, so from :lua:func:`Action._canPerform` we'll just return true.
For the kick itself, we get the direction from the player to the target (kobold), and check passability
for three tiles in the direction before finally moving them. We also give the kobold flying movement by
checking passability with a custom collision mask.

.. code:: lua

   function Kick:_canPerform(level)
      return true
   end

   --- @param level Level
   --- @param kicked Actor
   function Kick:_perform(level, kicked)
      local direction = (kicked:getPosition() - self.owner:getPosition())

      local mask = prism.Collision.createBitmaskFromMovetypes{ "fly" }

      local nextpos = kicked:getPosition()
      local finalpos = nextpos
      for _ = 1, 3 do
         nextpos = finalpos + direction
         if level:getCellPassable(nextpos.x, nextpos.y, mask) then
            finalpos = nextpos
         else
            break
         end
      end

      level:moveActor(kicked, finalpos)
   end

Kicking kobolds, for real this time
-----------------------------------

We've added the kick action, but we don't use it anywhere. Let's fix that by performing the kick
when we bump into a kobold. Head over to ``gamestates/MyGamelevelstate.lua`` and find where the move action
is called. If the player doesn't move, we want to check if there's a valid actor to kick in front of us,
and then perform the kick action on them:

.. code:: lua

   if move:canPerform(self.level) then
   ...

   local target = self.level:getActorsAt(position:decompose())[1]
   local kick = prism.actions.Kick(owner, { target })
   if kick:canPerform(self.level) then
      decision:setAction(kick)
   end

.. note::

   :lua:func:`Action.canPerform` will validate all targets in the action.

That's a wrap
-------------

That's all for part one. In conclusion, we've accomplished the following:

1. Added a kobold enemy with basic pathfinding.
2. Implemented a kick action to shove kobolds around.
3. Integrated the kick by performing it when bumping into a valid target.

You can find the code for this part at https://github.com/prismrl/prism-tutorial on the ``part-1`` branch. In the 
:doc:`next section <part2>`, we'll do some work with components and systems to flesh out the combat system.
