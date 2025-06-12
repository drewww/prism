Starting Fights
===============

Kicking kobolds is fun. Let's make it so you can kick them to death!

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

Giving the Kobolds HP
---------------------

Let's go ahead and add the Health component to  our kobold. I'm going to trust that you
know where to put these by this point in the tutorial.

.. code:: lua  

   -- kobold.lua
   prism.components.Health(3),

Implementing the Die Action
---------------------------

Before we get to the Kick action doing damage we're gonna need one more ingredient, a Die action. 
Let's turn the act of dying into it's own action so that we can centralize the logic.

.. code:: lua

   ---@class Die : Action
   local Die = prism.Action:extend("Die")

   function Die:perform(level)
      level:removeActor(self.owner)
   end

   return Die

Die is a really simple action, pretty much just a wrapper for removing an actor from the level.

Making Fall Use Die
----------------------

Now that we've got the Die action, let's test it by changing the Fall action to use it instead of just removing
the actor from the level.

Navigate to ``modules/MyGame/actions/fall.lua`` and replace the single line in it's perform with the following:

.. code:: lua

   level:perform(prism.actions.Die(self.owner))

Doing Damage
------------

Next we're going to add the Damage action. This accepts a single target, the amount of damage to be taken.
It modifies the health of the target and if it's at or below zero we trigger the Die action we just added.

.. code:: lua

   local DamageTarget = prism.Target()
      :filter(function(_, _, target)
         return type(target) == "number"
      end)

   local Damage = prism.Action:extend("Damage")
   Damage.name = "Damage"
   Damage.targets = { DamageTarget }

   function Damage:getRequirements()
      return prism.components.Health
   end

   function Damage:perform(level, damage)
      local health = self.owner:expect(prism.components.Health)
      health.hp = health.hp - damage

      if health.hp <= 0 then
         level:perform(prism.actions.Die(self.owner))
      end
   end

   return Damage

Making Kick do Damage
---------------------

Let's head back to ``modules/MyGame/actions/kick.lua`` and at the end of Kick:perform we're going to add the
following:

.. code:: lua

   function Kick:perform(level, kicked)
      ...

      local damage = prism.actions.Damage(kicked, 1)
      if level:canPerform(damage) then
         level:perform(damage)
      end
   end

That's All for Now
------------------

In the next chapter we'll implement the player health, make kobolds dangerous by giving them the attack action,
and implement the required logic for the player dying.