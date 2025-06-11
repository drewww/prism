Inventory
=========

Many roguelikes require players to pick up and drop items. Prism provides a flexible inventory system using components and actions. Here's how to set one up:

First, define which objects can be placed into an inventory using a simple tag component. This is a good place to add volume, weight, and other properties an item might have in the future.

.. code:: lua

    --- @class ItemComponent : Component, IQueryable
    local ItemComponent = prism.Component:extend("ItemComponent")
    ItemComponent.name = "Item"

    return ItemComponent

Next, define an Inventory component that uses an :lua:class:`ActorStorage` to track contained items. Items are removed from the level when picked up, and restored when dropped:

.. code:: lua

    --- @class InventoryComponent : Component, IQueryable
    local InventoryComponent = prism.Component:extend("InventoryComponent")
    InventoryComponent.name = "Inventory"

    function InventoryComponent:__new()
        self.inventory = prism.ActorStorage()
    end

    function InventoryComponent:query(...)
        return self.inventory:query(...)
    end

    function InventoryComponent:hasItem(actor)
        return self.inventory:hasActor(actor)
    end

    function InventoryComponent:addItem(actor)
        assert(actor:has(prism.components.Item))
        self.inventory:addActor(actor)
    end

    function InventoryComponent:removeItem(actor)
        self.inventory:removeActor(actor)
    end

    return InventoryComponent

.. note::

   You should only call ``addItem`` or ``removeItem`` from **inside an action**! Never mutate level state outside of actions!

Pickup and drop actions
-----------------------

Define a Pickup action that removes the item from the level and adds it to the actor's inventory:

.. code:: lua

    local PickupTarget = prism.Target:extend("PickupTarget")

    function PickupTarget:validate(owner, targetObject)
        return 
            prism.Actor:is(targetObject) and
            targetObject:has(prism.components.Item) and
            owner:getRange(targetObject) == 0 and
            not owner:expect(prism.components.Inventory):hasItem(targetObject)
    end

    --- @class PickupAction : Action
    --- @field name string
    --- @field targets Target[]
    local Pickup = prism.Action:extend("PickupAction")
    Pickup.name = "pickup"
    Pickup.targets = { PickupTarget }
    Pickup.requiredComponents = {
        prism.components.Controller,
        prism.components.Inventory,
    }

    function Pickup:canPerform(level, item)
        return true
    end

    function Pickup:perform(level, item)
        local inventory = self.owner:expect(prism.components.Inventory)
        level:removeActor(item)
        inventory:addItem(item)
    end

    return Pickup

Define a Drop action that removes the item from the inventory and places it into the level at the actor's location:

.. code:: lua

    local DropTarget = prism.Target:extend("DropTarget")

    function DropTarget:validate(owner, targetObject)
        return 
            prism.Actor:is(targetObject) and
            targetObject:has(prism.components.Item) and
            owner:expect(prism.components.Inventory):hasItem(targetObject)
    end

    --- @class DropAction : Action
    --- @field name string
    --- @field targets Target[]
    local Drop = prism.Action:extend("DropAction")
    Drop.name = "drop"
    Drop.targets = { DropTarget }
    Drop.requiredComponents = {
        prism.components.Controller,
        prism.components.Inventory,
    }

    function Drop:canPerform(level, item)
        return true
    end

    function Drop:perform(level, item)
        local inventory = self.owner:expect(prism.components.Inventory)
        inventory:removeItem(item)
        
        -- it's safe to change the position of an actor outside of a level!
        --- @diagnostic disable-next-line
        item.position = self.owner:getPosition()

        level:addActor(item)
    end

    return Drop


Keybindings
-----------

To allow players to interact with their inventory, add keybindings for pickup and inventory access in your ``keybindingschema.lua``:

.. code:: lua

   { key = "p", action = "pickup", description = "Pickup an item on the tile you're standing on." },
   { key = "tab", action = "inventory", description = "Open inventory." }

Handling pickup input
---------------------

Now that you've defined the keybinding and action, handle the ``pickup`` input inside your levelstate's keypressed function. This example queries for an item on the same tile as the player using the Senses component, creates a Pickup action, and sets it as the decision:

.. code:: lua

    if action == "pickup" then
        local senses = owner:get(prism.components.Senses)
        if senses then
            local query = senses:query(prism.components.Item)
                :at(owner:getPosition():decompose())

            local item = query:gather()[1]
            if item then
                local pickup = prism.actions.Pickup(owner, {item})
                if pickup:canPerform(self.level) then
                decision:setAction(pickup)
                end
            end
        end
    end

This approach ensures the action is only triggered when a valid item is on the player's current tile and the action can legally be performed.

Inventory state
---------------

Once players can pick up and drop items, they'll need a way to view and interact with their inventory. Below is a **very basic** example of a custom :lua:class:`GameState` that does just that.

.. note::

   This UI is intentionally primitive and meant only as a **minimal working example**. It supports letter-based selection and dropping, but lacks many usability features like scrolling, item descriptions, or a grid layout.

Here's the inventory state code:

.. code:: lua

    local keybindings = require "keybindingschema"

    --- @class InventoryState : GameState
    local InventoryState = spectrum.GameState:extend "InventoryState"

    --- @param decision ActionDecision
    --- @param level Level
    --- @param inventory InventoryComponent
    function InventoryState:__new(decision, level, inventory)
        self.decision = decision
        self.level = level
        self.items = inventory.inventory:getAllActors()
        self.letters = {}
        for i = 1, #self.items do
            self.letters[i] = string.char(96 + i) -- a, b, c, ...
        end
    end

    function InventoryState:draw()
        love.graphics.print("Inventory:", 20, 20)
        for i, item in ipairs(self.items) do
            local letter = self.letters[i]
            love.graphics.print(("[%s] %s"):format(letter, item.name), 40, 20 + i * 20)
        end
    end

    function InventoryState:keypressed(key)
        -- Convert pressed key to inventory index
        for i, letter in ipairs(self.letters) do
            if key == letter then
                local pressedItem = self.items[i]
                local drop = prism.actions.Drop(self.decision.actor, { pressedItem })
                if drop:canPerform(self.level) then
                self.decision:setAction(drop)
                end

                self.manager:pop()
                return
            end
        end

        if keybindings:keypressed(key) == "inventory" then
            self.manager:pop()
        end
    end

    return InventoryState


Pushing the inventory state
---------------------------

To trigger this state when the player presses the inventory key (like ``tab``), you can hook into your `LevelState:keypressed` handler and push the state:

.. code:: lua
   
   -- top of file
   local InventoryState = require "gamestates.MyGameinventorystate"

   ...

   if action == "inventory" then
      local inventory = owner:get(prism.components.Inventory)

      if inventory then
         self.manager:push(InventoryState(decision, self.level, inventory))
      end
   end

This approach uses the decision and current level to let the inventory state interact with the game world. Any selected item can be turned into a drop action from within the state.

Creating an item
----------------

Now that we have an inventory system and actions to interact with it, let's create a simple item to pick up and drop. Here's an example actor called ``Cheese`` that uses the Item component.

.. code:: lua

   --- @class CheeseActor : Actor
   local Cheese = prism.Actor:extend("CheeseActor")
   Cheese.name = "Cheese"

   function Cheese:initialize()
      return {
         prism.components.Drawable(string.byte(";") + 1, prism.Color4.WHITE),
         prism.components.Item()
      }
   end

   return Cheese

This actor has the ``Item`` component so it can be picked up and placed in inventories. This is a simple example, but you could throw items onto any Actor even NPCs!

You can spawn this actor into your level to test pickups and drops by pressing ``~`` and using geometer to paint it in.
