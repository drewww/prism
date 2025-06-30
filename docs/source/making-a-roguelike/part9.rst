Creating continuity
===================

In this chapter, we'll create a Game object and store it in a global called GAME to track
the overall state of the game. This includes managing a random number generator (RNG) that
we'll use to seed level generation, as well as keeping track of the dungeon depth the player
is currently exploring.

Getting the message
-------------------

First, let's update our ``Descend`` message to include the actor that's descending.

.. code:: lua

   --- @class DescendMessage : Message
   --- @overload fun(descender: Actor): DescendMessage
   local DescendMessage = prism.Object:extend("DescendMessage")

   --- @param descender Actor
   function DescendMessage:__new(descender)
      self.descender = descender
   end

   return DescendMessage

Next, let's modify the ``Descend`` action so that it populates the message with the descending actor.

.. code:: lua

   function Descend:perform(level)
      level:removeActor(self.owner)
      level:yield(prism.messages.Descend(self.owner))
   end

Creating the game
-----------------

Now we'll create a new class Game and include levelgen at the top:

.. code:: lua

   local levelgen = require "levelgen"

   --- @class Game : Object
   --- @overload fun(seed: string): Game
   local Game = prism.Object:extend("Game")

   --- @param seed string
   function Game:__new(seed)
      self.depth = 0
      self.rng = prism.RNG(seed)
   end

   --- @return string
   function Game:getLevelSeed()
      return tostring(self.rng:getUniform())
   end

   --- @param player Actor
   --- @return MapBuilder builder
   function Game:generateNextFloor(player)
      self.depth = self.depth + 1

      local genRNG = prism.RNG(self:getLevelSeed())
      return levelgen(genRNG, player, 60, 30)
   end

   return Game

This class will eventually track everything we need for the overall game. Having a single centralized RNG 
for generating seeds for level generation ensures that the game will be repeatable given the same seed.

Making it global
----------------

Head over to main.lua. Right below where we’re loading all our modules, let’s create our global
GAME instance and seed the game:

.. code:: lua

   ...
   prism.loadModule("modules/MyGame")

   --- @module "game"
   local Game = require("game")
   GAME = Game(tostring(os.time()))

Now our ``GAME`` will be accessible all over our codebase.

Modifying the levelstate
------------------------

The first thing we’ll do is remove the levelgen require:

.. code:: diff

   -local levelgen = require "levelgen"

Next we'll change ``MyGameLevelState``'s constructor. 

.. code:: lua

   --- @param display Display
   --- @param builder MapBuilder
   --- @param seed string
   function MyGameLevelState:__new(display, builder, seed)
      -- Build the map and instantiate the level with systems
      local map, actors = builder:build()
      local level = prism.Level(map, actors, {
         prism.systems.Senses(),
         prism.systems.Sight(),
         prism.systems.Fall(),
      }, nil, seed)

      -- Initialize with the created level and display, the heavy lifting is done by
      -- the parent class.
      spectrum.LevelState.__new(self, level, display)
   end

This sets up our Level with the map we build and the seed we'll get from our GAME global. 

.. code:: lua

   --- @overload fun(display: Display, builder: MapBuilder, seed: string): MyGameLevelState
   local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

Let's change our overload here as well to reflect the new arguments.

.. code:: lua

   if prism.messages.Descend:is(message) then
      --- @cast message DescendMessage
      self.manager:enter(MyGameLevelState(self.display, GAME:generateNextFloor(message.descender). GAME:getLevelSeed()))
   end

Finally, let's modify our message handler so it passes the player into the next level:

Moving along
------------

We’ve now got descending through levels working and everything tied together via our Game class. In the next section, we'll
start working on getting our inventory system up and running, along with a few items.