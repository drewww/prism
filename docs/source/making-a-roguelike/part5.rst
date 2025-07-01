Writing things down
===================

In this chapter we're going to focus on exposing information to the player like their HP and
the most recent actions that happened to them to make the flow of the game more clear.

Keeping tabs on your health
---------------------------

Head on over to ``gamelevelstate.lua`` and in draw replace the following line:

.. code:: lua

   self.display:putString(1, 1, "Hello prism!")

with:

.. code:: lua

   local currentActor = self:getCurrentActor()
   local health = currentActor and currentActor:get(prism.components.Health)
   if health then
      self.display:putString(1, 1, "HP:" .. health.hp .. "/" .. health.maxHP)
   end

Great! Now we've got a really primitive HP display. We'll come back to this in a little while and spruce this up.

Logging messages
----------------

Fortunately, prism provides a :lua:class:`Log` component in an optional module. Load it before the ``game``
module in ``main.lua``:

.. code-block:: lua
   :emphasize-lines: 3

   prism.loadModule("prism/spectrum")
   prism.loadModule("prism/extra/sight")
   prism.loadModule("prism/extra/log")
   prism.loadModule("modules/game")

Now head over to ``player.lua`` and give them a log component.

.. code:: lua

   prism.components.Log()

..
   TODO: #136 Write a how-to on logging and link it here

Logging kick
------------

Head to ``modules/game/actions/kick.lua`` and at the top of the file insert these lines.

.. code:: lua

   local Log = prism.components.Log
   local Name = prism.components.Name
   local sf = string.format

These are mainly for convenience and brevity. Now head to the bottom of ``perform``
and add the following.

.. code:: lua

   local kickName = Name.lower(kicked)
   local ownerName = Name.lower(self.owner)
   Log.addMessage(self.owner, sf("You kick the %s.", kickName))
   Log.addMessage(kicked, sf("The %s kicks you!", ownerName))
   Log.addMessageSensed(level, self, sf("The %s kicks the %s.", ownerName, kickName))

We use the convenience methods :lua:func:`Log.addMessage` and :lua:func:`Log.addMessageSensed` to add messages to the 
affected and nearby actors.

Drawing logs
------------

Okay so logging is set up and it's time to make our way back to ``gamelevelstate.lua`` to get our log drawing.
Below where we're drawing HP insert the following.

.. code:: lua

   local log = currentActor and currentActor:get(prism.components.Log)
   if log then
      local offset = 0
      for line in log:iterLast(5) do
         self.display:putString(1, self.display.height - offset, line)
         offset = offset + 1
      end
   end

This gives us a really basic message log at the bottom of the screen. 

Adding damage
-------------

The kick message is nice, but wouldn't it be better if we could see how much damage we're doing?
Let's head back over to ``modules/game/actions/damage.lua`` and make a small change.

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

Giving attack the same treatment
--------------------------------

Head over to ``modules/game/actions/attack.lua``

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

In the next section
-------------------

We'll add a game over screen so that the game doesn't simply quit when we lose. We'll come back to
our user interface and make it prettier in a later section of the tutorial.
