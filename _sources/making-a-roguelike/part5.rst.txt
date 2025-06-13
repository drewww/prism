Writing Things Down
===================

In this chapter we're going to focus on exposing information to the player like their HP and
the most recent actions that happened to them to make the flow of the game more clear.

Keeping Tabs on Your Health
---------------------------

Head on over to ``MyGamelevelstate.lua`` and in draw replace the following line:

.. code:: lua

   self.display:putString(1, 1, "Hello prism!")

with:

.. code:: lua

   local health = self.decision.actor:get(prism.components.Health)
   if health then
      self.display:putString(1, 1, "HP:" .. health.hp .. "/" .. health.maxHP)
   end

Great! Now we've got a really primitive HP display. We'll come back to this in a little while and spruce this up.

Logging Messages
----------------

Luckily enough prism provides a reasonable and simple implementation of a message log, not in
it's core files but in an optional module provided in prism/extra. The first thing we're going to
have to do is load that module.

Head to ``main.lua`` and insert this right above where we load the MyGame module like so:

.. code:: lua

   prism.loadModule("prism/spectrum")
   prism.loadModule("modules/Sight")
   prism.loadModule("prism/extra/Log")
   prism.loadModule("modules/MyGame")

Now we've got the Log module loading, let's head over to ``player.lua`` and give them a log component.

.. code:: lua

   prism.components.Log()

Okay we've got our log set up, let's start using it. If you're interested in how the Log component works
check out the how-to on writing a message log. (This is planned for the future.)

Logging Kick
------------

Head to ``modules/MyGame/actions/kick.lua`` and at the top of the file insert these lines.

.. code:: lua

   local Log = prism.components.Log
   local Name = prism.components.Name
   local sf = string.format

These are mainly for convenience and brevity. We're going to use them in perform. Now head to the bottom of perform
after everything else and add the following.

.. code:: lua

   local kickName = Name.lower(kicked)
   local ownerName = Name.lower(self.owner)
   Log.addMessage(self.owner, sf("You kick the %s.", kickName))
   Log.addMessage(kicked, sf("The %s kicks you!", ownerName))
   Log.addMessageSensed(level, self.owner, sf("The %s kicks the %s.", ownerName, kickName))

This code defines a couple log messages for the various parties involved with the action. Log.addMessage is a convenience
function provides by the log component that makes it so you don't have to check if the actor you're passing in has a log
component or manipulate the log directly, it does that for you. Similarly Log.addMessageSensed works roundabout the same way
except it defines what uninvolved actors who can see the action's owner get in their log.

Drawing Logs
------------

Okay so logging is set up and it's time to make our way back to ``MyGamelevelstate.lua`` to get our log drawing.
Below where we're drawing HP insert the following.

.. code:: lua

   local log = self.decision.actor:get(prism.components.Log)
   if log then
      local offset = 0
      for line in log:iterLast(5) do
         self.display:putString(1, self.display.height - offset, line)
         offset = offset + 1
      end
   end

This gives us a really basic message log at the bottom of the screen. 

Adding Damage
-------------

The kick message is nice, but wouldn't it be better if we could see how much damage we're doing?
Let's head back over to ``modules/MyGame/actions/damage.lua`` and make a small change.

.. code:: lua

   function Damage:perform(level, damage)
      local health = self.owner:expect(prism.components.Health)
      health.hp = health.hp - damage
      self.dealt = damage -- add this!

      ...
   end

We store the damage that was dealt in the Damage action so that we can inspect it in kick. Now heading back to
kick.

.. code:: lua

   function Kick:perform(level, kicked)
      ...

      local dmgstr = ""
      if damage.dealt then
         dmgstr = sf("Dealing %i damage.", damage.dealt)
      end
      
      local kickName = Name.lower(kicked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You kick the %s. %s", kickName, dmgstr))
      Log.addMessage(kicked, sf("The %s kicks you! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s kicks the %s. %s", ownerName, kickName, dmgstr))
   end

Giving our Enemies a Name
-------------------------

Okay we've got damage in the message now too, but you might notice something our message refers to the kobold
as "actor". We're going to have to give the Kobold a name component to fix this.

.. code:: lua
   
   -- kobold.lua
   prism.components.Name("Kobold")

Giving Attack the Same Treatment
--------------------------------

Head over to ``modules/MyGame/actions/attack.lua``

.. code:: lua

   local Log = prism.components.Log
   local Name = prism.components.Name
   local sf = string.format

We're going to put a few aliases at the top of the file to make things easier again. Then we need to
add the Log messages to the Attack's perform.

.. code:: lua

   function Attack:perform(level, attacked)
      ...

      local dmgstr = ""
      if damage.dealt then
         dmgstr = sf("Dealing %i damage.", damage.dealt)
      end
      
      local attackName = Name.lower(attacked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You attack the %s. %s", attackName, dmgstr))
      Log.addMessage(attacked, sf("The %s attacks you! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s attacks the %s. %s", ownerName, attackName, dmgstr))
   end

And we're done! Now you should see messages in your log when a kobold attacks you!

In the Next Section
-------------------

We'll add a game over screen so that the game doesn't simply quit when we lose. We'll come back to
our user interface and make it prettier in a later section of the tutorial.