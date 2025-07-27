Having a snack
==============

.. note::

   This section hasn't had a second pass! Eat at your own peril! Beware food poisoning!

In this section of the tutorial we're going to add an Eat action that works on inventory items and a user interface
to let us actually choose to eat the items in our inventory.

Modifying health
----------------

Let's head over to ``module/game/components/health.lua`` and make a small addition.

.. code:: lua

   --- @param amount integer
   function Health:heal(amount)
      self.hp = math.min(self.hp + amount, self.maxHP)
   end

This should only be called from actions because it modifies the component! This will make it easy for us to apply healing
without going over max HP.

Making it edible
----------------

Let's create a new component to define what's edible. We'll take a single integer in
and set that to the component's healing field. Head over to ``module/game/components`` and
create a new file ``edible.lua``.

.. code:: lua

   --- @class Edible : Component
   --- @field healing integer
   --- @overload fun(healing: integer)
   local Edible = prism.Component:extend("Edible")

   --- @param healing integer
   function Edible:__new(healing)
      self.healing = healing
   end

   return Edible

Now we'll create an action to use on the edible actor. Head to ``module/game/actions`` and
create a new file ``eat.lua``.

.. code:: lua

   local EatTarget = prism.InventoryTarget(prism.components.Edible)
      :inInventory()

The inventory module injects a new subclass of Target into the prism namespace as a convenience.
This saves us from having to write our own filter to figure out if something is in the actor's inventory.

   
.. code:: lua

   ---@class Eat : Action
   ---@overload fun(owner: Actor, food: Actor): Eat
   local Eat = prism.Action:extend("Eat")

   Eat.requiredComponents = {
      prism.components.Health
   }

   Eat.targets = {
      EatTarget
   }

Now we create our eat action. You need a health component to eat, and the target has to be something edible in your inventory
as we defined above.

.. code:: lua

   --- @param level Level
   --- @param food Actor
   function Eat:perform(level, food)
      local edible = food:expect(prism.components.Edible)
      local health = self.owner:expect(prism.components.Health)
      health:heal(edible.healing)

      local inventory = self.owner:expect(prism.components.Inventory)
      inventory:removeQuantity(food, 1)

      Log.addMessage(self.owner, sf("You eat the %s", Name.get(food)))
      Log.addMessageSensed(level, self, sf("%s eats the %s", Name.get(self.owner), Name.get(food)))
   end

   return Eat

And for the perform function we just add to the eater's health the amount of the edible's healing. Now let's head back over to
``modules/game/actors/meat.lua`` and add the edible component to the meat actor.

.. code:: lua

   prism.components.Edible(1)

Modifying the interface
-----------------------

Okay with the actual mechanics out of the way it's time for us to flesh out our inventory menu a little more. Create a new file at
``gamestates/inventoryactionstate.lua`` and let's create a new GameState.

.. code:: lua

   local keybindings = require "keybindingschema"
   local Name = prism.components.Name

First we're going to require our keybinding schema, and then we're going to alias the name component for the sake of brevity.

.. code:: lua

   --- @class InventoryActionState : GameState
   --- @field decision ActionDecision
   --- @field previousState GameState
   --- @overload fun(display: Display, decision: ActionDecision, level: Level, item: Actor)
   local InventoryActionState = spectrum.GameState:extend "InventoryActionState"

   --- @param display Display
   --- @param decision ActionDecision
   --- @param level Level
   --- @param item Actor
   function InventoryActionState:__new(display, decision, level, item)
      self.display = display
      self.decision = decision
      self.level = level
      self.item = item

      self.actions = {}

      for _, Action in ipairs(self.decision.actor:getActions()) do
         local action = Action(self.decision.actor, self.item)
         if self.level:canPerform(action) then
            table.insert(self.actions, action)
         end
      end
   end

Next we'll create a new GameState and in the constructor we'll loop through all the actions the active actor can do, and assign those
to a letter if the actor can take that action with the inventory item as the first target.

.. code:: lua

   function InventoryActionState:load(previous)
      --- @cast previous InventoryState
      self.previousState = previous.previousState
   end

Then we're going to store the LevelState in our previousState field so that we can draw the level under this menu.

.. code:: lua

   function InventoryActionState:draw()
      self.previousState:draw()
      self.display:clear()
      self.display:putString(1, 1, Name.get(self.item), nil, nil, 2, "right")

      for i, action in ipairs(self.actions) do
         local letter = string.char(96 + i)
         local name = string.gsub(action.className, "Action", "")
         self.display:putString(1, 1 + i, string.format("[%s] %s", letter, name), nil, nil, nil, "right")
      end

      self.display:draw()
   end

Then we can set up our draw function to loop through all of the possible actions and enumerate them to the user, drawing the letter used to take that
action next to the item name.

.. code:: lua

   function InventoryActionState:keypressed(key)
      for i, action in ipairs(self.actions) do
         print(key, string.char(i + 96))
         if key == string.char(i + 96) then
            self.decision:setAction(action)
            self.manager:pop()
         end
      end

      local binding = keybindings:keypressed(key)
      if binding == "inventory" or binding == "return" then self.manager:pop() end
   end

Then we'll handle the user selecting the action. If the user hits the letter that matches an action we set the decision to that action. Now we'll need to head over to ``gamestates/inventorystate.lua`` and let's push this new InventoryActionState onto the stack when a user selects an item instead of dropping it. Let's modify our
``InventoryState:keypressed`` to look like this.

.. code:: lua

   function InventoryState:keypressed(key)
      for i, letter in ipairs(self.letters) do
         if key == letter then
            self.manager:push(InventoryActionState(self.display, self.decision, self.level, self.items[i]))
            return
         end
      end

      local binding = keybindings:keypressed(key)
      if binding == "inventory" or binding == "return" then self.manager:pop() end
   end

We've got one last thing to handle. When we press a letter right now we just go back to the inventory screen and nothing happens until we leave that screen.
A little strange to say the least! The next thing we need to do is get the inventory menu to get out of the way when a decision is set.

.. code:: lua

   function InventoryState:resume()
      if self.decision:validateResponse() then
         self.manager:pop()
      end
   end

In the next chapter
-------------------

In the next chapter we'll go over drop tables and containers like chests, populating the dungeon for delicious meat and shiny trinkets!