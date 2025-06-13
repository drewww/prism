Losing the game
===============

Right now we've got the game simply quitting when we hit zero hit points, but that's
a bit unusual to say the least. In this chapter we're going to get into gamestates and
make a very simple game over screen. This is gonna be a short chapter where we learn how
to create a new gamestate.

Making a gamestate
------------------

Navigate to the ``gamestates`` folder and create a new file there callled ``gameoverstate.lua``

.. code:: lua

   --- @class GameOverState : GameState
   --- @field display Display
   --- @overload fun(display: Display): GameOverState
   local GameOverState = spectrum.GameState:extend("GameOverState")

   function GameOverState:__new(display)
      self.display = display
   end

   function GameOverState:draw()
      local midpoint = math.floor(self.display.height / 2)

      self.display:clear()
      self.display:putString(
         1, midpoint,
         "Game Over!",
         nil, nil, nil,
         "center", self.display.width
      )
      self.display:draw()
   end

   return GameOverState

This is pretty simple. We're taking a display, the same one we've been using in ``MyGameLevelState``
and we draw "Game Over" centered on the screen.

Replacing the exit
------------------

Let's head over to ``MyGameLevelState``. First we're going to need to require our new GameState at
the top of the file.

.. code:: lua

   local GameOverState = require "gamestates.gameoverstate"

Then we'll head back to the handleMessage function. We're gonna replace our current handling of
the lose message with the following.

.. code:: lua

   if prism.messages.Lose:is(message) then
      self.manager:enter(GameOverState(self.display))
   end

Alright now let's boot up the game and spawn in a few kobolds. Move around for a bit
and we'll die and you show see our new Game Over screen!

Next up
-------

In the next chapter we'll be getting into map generation, and finally turn this into a real
roguelike. The following chapters will take you through generating a map and descending through the dungeon.
