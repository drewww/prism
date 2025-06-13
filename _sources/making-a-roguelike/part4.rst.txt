Taking licks
============

It's time to make kobolds a little dangerous! In this chapter we're going
to give the player health and have the kobolds attack them!

Giving the player HP
--------------------

The first thing we're going to want to do is go ahead and give the player a Health
component.

.. code:: lua

    -- player.lua
    prism.components.Health(10)

Creating the attack component
-----------------------------

We need a component to hold information about attackers, for now just damage. 

.. code:: lua

    --- @class Attacker : Component
    --- @field damage integer
    --- @overload fun(damage: integer)
    local Attacker = prism.Component:extend("Attacker")

    --- @param damage integer
    function Attacker:__new(damage)
        self.damage = damage
    end

    return Attacker

Giving kobold the attack component
----------------------------------

Go ahead and navigate to ``modules/MyGame/actors/kobold.lua`` and add the attack component:

.. code:: lua

   prism.components.Attacker(1)


The attack action
-----------------

Now let's make an attack action that the Kobolds can use to attack the player. This is
pretty straightforward. Anything with health is attackable, and we apply damage. If we wanted
something more like a classic hit chance we could use level's RNG field to get a random
number.

.. code:: lua

   local AttackTarget = prism.Target()
      :isPrototype(prism.Actor)
      :with(prism.components.Health)

   ---@class Attack : Action
   ---@overload fun(owner: Actor, attacked: Actor): Attack
   local Attack = prism.Action:extend("Attack")
   Attack.name = "Attack"
   Attack.targets = { AttackTarget }
   Attack.requiredComponents = {prism.components.Attacker}

   --- @param level Level
   --- @param attacked Actor
   function Attack:perform(level, attacked)
      local attacker = self.owner:expect(prism.components.Attacker)

      local damage = prism.actions.Damage(attacked, attacker.damage)
      if level:canPerform(damage) then
         level:perform(damage)
      end
   end

   return Attack


Modifying the kobold's controller
---------------------------------

Next we need to make the Kobold actually use the attack action. Navigate to ``modules/MyGame/components/koboldcontroller.lua``
and right above the final return we're going to add the following:

.. code:: lua

   function KoboldController:act(level, actor)
      ...

      local attack = prism.actions.Attack(actor, player)
      if level:canPerform(attack) then
         level:perform(attack)
      end

      return prism.actions.Wait(actor)
   end

Sending a message
-----------------

If you play the game now and slap down a few kobolds with geometer you'll find something unfortunate;
the game crashes when you die! To solve this we'll have to have the Level yield to the user interface
when the last player controlled actor dies. We do this through a Message.

1. Create a new folder in ``modules/MyGame/`` called ``messages``.
2. Create a new file called ``lose.lua``

.. code:: lua

   --- @class LoseMessage : Message
   --- @overload fun(): LoseMessage
   local LoseMessage = prism.Object:extend("LoseMessage")
   return LoseMessage


This is the message we'll wrap around the 'baton' that we're gonna pass back to the user interface. Next
head back over to the Die action. Let's change it's perform to the following:

.. code:: lua

   function Die:perform(level)
      level:removeActor(self.owner)

      if not level:query(prism.components.PlayerController):first() then
         level:yield(prism.messages.Lose())
      end
   end

And finally we're gonna have to handle this message back in the user interface. Head back over to
``gamestates/MyGamelevelstate.lua`` and let's modify ``MyGameLevelState:handleMessage``.

.. code:: lua

   function MyGameLevelState:handleMessage(message)
      spectrum.LevelState.handleMessage(self, message)

      if prism.messages.Lose:is(message) then
         self.manager:pop()
         love.event.quit()
      end
   end

Now when we die the game will exit to desktop which is an improvement, but not exactly what we're looking for.

Gussying things up
------------------

That's it for this chapter, in the next one we'll focus on some user interface stuff like
adding a game over screen and a message log.