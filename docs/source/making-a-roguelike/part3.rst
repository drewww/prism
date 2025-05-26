Starting Fights
===============

Kobolds are dangerous creatures, but right now our Kobold is pretty harmless. Let's add a Health component
and an Attack action to support combat.

Getting Healthy
---------------

1. Navigate to ``modules/MyGame/components``
2. Create a new file named ``health.lua``

.. code:: lua  

   --- @class Health : Component
   --- @field maxHP : integer
   --- @field hp : integer
   local Health = prism.Component:extend("Health")

   function Health:__new(maxHP)
      self.maxHP = maxHP
      self.hp = maxHP
   end

   return Health

The Health component is really simple, it tracks the actor's hp and maxHP.

Giving the Player and Kobold HP
-------------------------------

Let's go ahead and add the Health component to both our kobold and the player. I'm going to trust that you
know where to put these by this point in the tutorial.

.. code:: lua  

   -- kobold.lua
   prism.components.Health(3),

   -- player.lua
   prism.components.Health(10),

Great, let's run the game. We've got HP and so does the Kobold but it's kind of hard to tell! Let's show
the player their health.

Adding HP to the User Interface
-------------------------------

Navigate to ``gamestates/MyGamelevelstate.lua`` and replace the following line
in MyGameLevelState:draw.

.. code:: lua

   self.display:putString(1, 1, "Hello prism!")

You're going to replace this with the following.

.. code:: lua  

   local health = self.decision.actor:getComponent(prism.components.Health)
   if health then
      self.display:putString(1, 1, "HP: " .. health.hp)
   end

Implementing the Attacker Component
-----------------------------------

Okay so our actors have some health now, we need to get attacking going.

1. Navigate to ``modules/MyGame/components``
2. Create a new file named ``attacker.lua``

.. code:: lua  

   --- @class Attacker : Component
   local Attacker = prism.Component:extend("Attacker")

   function Attacker:__new(damage)
      self.damage = damage
   end

   return Attacker

For now the Attacker component is really simple, just tracking the damage the actor does. In the future
we'll add a to hit bonus, and ways to override or modify these base values for equipment, potions, etc.

Implementing the Die Action
---------------------------

Before we get to the Attack action we're gonna need one more ingredient, a Die action. In the previous chapter
when an actor fell down the pit we simply removed them from the level, but we're gonna want to be able to listen
for actors dying in a system by the end of this chapter. So let's turn the act of dying into it's own action.

.. code:: lua

   ---@class Die : Action
   local Die = prism.Action:extend("Die")

   function Die:perform(level)
      level:removeActor(self.owner)
   end

   return Die

Die is a really simple action, pretty much just a wrapper for removing an actor from the level. We're only
doing this so that we can see if the player dies and send a "game over" message to the user interface near
the end of this chapter.

Making Fall Use Die
----------------------

Now that we've got the Die action, let's test it by changing the Fall action to use it instead of just removing
the actor from the level.

Navigate to ``modules/MyGame/actions/fall.lua`` and replace the single line in it's perform with the following:

.. code:: lua

   level:performAction(prism.actions.Die(self.owner))

Implementing the Attack Action
------------------------------

Okay, finally! We're going to make the attack action!

1. Navigate to ``modules/MyGame/actons``
2. Create a new file named ``attack.lua``

.. code:: lua  

   local AttackTarget = prism.Target:extend("AttackTarget")

   --- @param owner Actor
   --- @param targetObject any
   function AttackTarget:validate(owner, targetObject)
      return 
         targetObject:is(prism.Actor) and
         targetObject:getComponent(prism.components.Health) and
         owner:getRange(targetObject) == 1
   end

   ---@class Attack : Action
   local Attack = prism.Action:extend("Attack")
   Attack.name = "attack"
   Attack.targets = { AttackTarget }
   Attack.requiredComponents = {
         prism.components.Controller,
         prism.components.Attacker
   }

   --- @param level Level
   --- @param target Actor
   function Attack:perform(level, target)
      local health = target:expectComponent(prism.components.Health)
      local attacker = self.owner:expectComponent(prism.components.Attacker)
      health.hp = health.hp - attacker.damage

      if health.hp <= 0 then
         level:performAction(prism.actions.Die(target))
      end
   end

   return Attack

We set up an Attack target which checks if the target is an actor, at range 1, with a health component.

Our perform action subtracts the Attacker's damage from the target's health. In most Roguelikes you'd have
some kind of to-hit or armor calculation, and we'll get there. For now though we want to get Attack working.

Making Kobolds Dangerous
------------------------

First let's give the kobold a new component, the Attacker component.

.. code:: lua  

   prism.components.Attacker(1) -- deals 1 damage

Now we make our way over to koboldcontroller.lua and add the attack action.

.. code:: lua
   -- in KoboldController:act()
   ...

   if not mover then return prism.actions.Wait() end

   if player:getRange(actor) == 1 then
      local attack = prism.actions.Attack(actor, player)
      if level:canPerform(attack) then
         return attack
      end
   end
   
   ...

Now let's head back into the game and spawn a kobold with geometer. Let it attack you a few times and you'll
see your health decreasing. Let that kobold get you to zero hit points.

Uh Oh!
------

You died and the window froze. What happened? The Level logic runs on a Lua couroutine, you can think of it
kind of like a cooperative thread. The Level runs then it passes the baton with a note around it called a Message.

Let's create a simple stub message called GameOver.

1. Navigate to ``modules/MyGame``
2. Create a new folder called ``messages``
3. In ``modules/MyGame/messages`` create a new file named ``gameover.lua``

.. code:: lua  

   ---@class GameOverMessage : Message
   local GameOverMessage = prism.Message:extend("GameOverMessage")

   return GameOverMessage

This doesn't really need any additional information in it, it's only sent to let the UI know that the game has
ended.

In this case the last actor with a PlayerController dies and the Level just keeps on going! This is because Level
stops passing any messages. We need to pass a message to the UI that tells it the player has died and to show a 
game over screen.

1. Navigate to ``modules/MyGame/systems``
2. Create a new file called ``losecondition.lua``

.. code:: lua  

   --- @class LoseCondition : System
   local LoseCondition = prism.System:extend "LoseCondition"


   function LoseCondition:afterAction(level, actor, action)
      if not actor:hasComponent(prism.components.PlayerController) then return end
      if not action:is(prism.actions.Die) then return end

      -- It's the player and they're dying. Time to let the user interface know the game is
      -- over.
      level:yield(prism.messages.GameOver())
   end

   return LoseCondition

We hook into afterAction and check if the actor had a PlayerController and the action they just finished
was die. If both of these are true the player lost the game.

Game Over Screen
----------------

We're going to want to create a new GameState for the game over screen. I'm going to leave making
it pretty an exercise for the reader, and we're going to keep it really simple.

1. Navigate to ``gamestates``.
2. Create a new file called ``gameoverstate.lua``

.. code:: lua

   --- @class GameOverState : GameState
   --- @field display Display
   --- @overload fun(display: Display): GameOverState
   local GameOverState = spectrum.GameState:extend "GameOverState"

   function GameOverState:__new(display)
      self.display = display
   end

   function GameOverState:draw()
      self.display:clear()
      self.display:putString(1, 1, "Game Over!")
      self.display:draw()
   end

   return GameOverState

Nothing too crazy, we create a new gamestate that takes a display and draws "Game Over!" in the top left using it.
Now, finally, we're going to handle the GameOverMessage in MyGameLevelState.

.. code:: lua

   function MyGameLevelState:handleMessage(message)
      spectrum.LevelState.handleMessage(self, message)

      if message:is(prism.messages.GameOver) then
         self.manager:enter(GameOverState(self.display))
      end
   end

Our handleMessage function listens for messages from the Level, and in this case when it gets the GameOver message we know
it's time to trash this levelstate and show the GameOverState instead!

Wrapping Up
-----------

The last thing we've got to do now is give the Player the attacker component, and change some of the keypressed handling.

Head over to the player file and add the following:

.. code:: lua  

   prism.components.Attacker(1)

Now let's make our way to MyGameLevelState and add in some logic for making attacks.

.. code:: lua  

   -- MyGamelevelstate.lua
   -- keypressed()

   -- line 127
   local target = self.level:query() -- grab a query object
      :at(destination:decompose()) -- restrict the query to the destination
      :first() -- grab one of the kickable things, or nil

   if love.keyboard.isDown("lshift") then
      local kick = prism.actions.Kick(owner, target)
      if self.level:canPerform(kick) then
         decision:setAction(kick)
      end
   else
      local attack = prism.actions.Attack(owner, target)
      if self.level:canPerform(attack) then
         decision:setAction(attack)
      end
   end

Okay and we're finally done! Now the player can attack, but if they hold shift they can still
kick. 

In the Next Section
-------------------

We've got attacking working now and we can lose hp and die and so can the kobolds! There's a little
bit of a problem, though. It's hard to tell what's going on! In the next section of the tutorial we'll
be adding a message log.
