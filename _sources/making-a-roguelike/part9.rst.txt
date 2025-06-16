Creating continuity
===================

In this chapter we'll create a Game object and put it into a GAME global that will track the overall
state of the game. This includes managing an RNG we'll use to seed the levelgen and each of levels, and
tracking the depth of the dungeon the player is currently in.

Getting the message
-------------------

First we're going to update our Descend message to include the actor that's descending in it.

.. code:: lua

   --- @class DescendMessage : Message
   --- @overload fun(descender: Actor): DescendMessage
   local DescendMessage = prism.Object:extend("DescendMessage")

   --- @param descender Actor
   function DescendMessage:__new(descender)
      self.descender = descender
   end

   return DescendMessage

Let's also change our Descend action so that we populate the message with the descending actor.

.. code:: lua

   function Descend:perform(level)
      level:removeActor(self.owner)
      level:yield(prism.messages.Descend(self.owner))
   end

Creating the game
-----------------

We're gonna create a new class Game, and we're gonna include levelgen at the top.

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

This is going to be where we track everything we need for the overall game in the future. Having one centralized
RNG we use for generating seeds for levelgen and levels means that our game will be repeatable given the same seed.

Making it global
----------------

Head over to ``main.lua`` and right below where we're loading all our modules we're going to create our GAME global
and seed our game.

.. code:: lua

   ...
   prism.loadModule("modules/MyGame")

   --- @module "game"
   local Game = require("game")
   GAME = Game(tostring(os.time()))

Now our ``GAME`` will be accessible all over our codebase.

Modifying the levelstate
------------------------

The first thing we're going to want to do is remove our require on levelgen.

.. code:: diff

   -local levelgen = require "levelgen"

Then we're going to change ``MyGameLevelState``'s constructor. 

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
      self.manager:enter(MyGameLevelState(self.display, GAME:generateNextFloor(message.descender). GAME:))
   end

Now we're going to change our handler for the message to pass the player into the next level.

Moving along
------------

We've got descending through the levels working, and now we've got everything tied together with our Game class.
In the next section we'll work on getting our inventory and a couple items working.