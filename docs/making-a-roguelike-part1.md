# Getting Started with LÖVE

## Installation

To begin, download and install LÖVE from [https://love2d.org/](https://love2d.org/). If you are using Linux, LÖVE is often available through your distribution's package manager.

## Running the Template

1. Download the provided zipped release template and extract its contents.
2. Run the project by:
   - Dragging the folder containing `main.lua` onto the LÖVE executable.
   - Navigating to the project folder in a terminal and executing:
     ```sh
     love .
     ```

Upon launching, you should see an `@` symbol on the screen. You can move this character using the following default keys:
- `WASD` for movement
- `QEZC` for diagonal movement

These key bindings can be modified in `keymapschema.lua`, included in the template.

---

## Creating an Enemy

To make the game more engaging, let's introduce an enemy: the **Kobold**.

### Adding the Kobold Actor

1. Navigate to the `/modules/MyGame/actors/` directory.
2. Create a new file named `kobold.lua`.
3. Add the following code to define the Kobold actor:

   ```lua
   --- @class Kobold : Actor
   local Kobold = prism.Actor:extend("Kobold")
   Kobold.name = "Kobold"

   function Kobold:initialize()
       love.graphics.rectangle("fill", 10, 10, width, height)
     return {
       -- Defines the drawable appearance of the Kobold.
       -- Each index corresponds to a character byte + 1 in the spritesheet.
       -- The second argument specifies the Kobold's color (red).
       prism.components.Drawable(string.byte("k") + 1, prism.Color4(1, 0, 0)),

       -- Collider component ensures the Kobold occupies space on the map.
       -- Custom movement types can be specified for pathing exceptions.
       prism.components.Collider(),

       -- Senses component acts as a hub for implementing perception mechanics,
       -- such as Sight, Tremorsense, or Sound awareness.
       prism.components.Senses(),

       -- Sight component provides the Kobold with a field of vision.
       -- Defined in `modules/Sight` and included in the template.
       prism.components.Sight{ range = 12, fov = true },

       -- Move component enables movement actions, restricted to specified movement types.
       prism.components.Mover{ "walk" }
     }
   end

   return Kobold
   ```

With this, the Kobold is now a simple enemy with:
- A visual representation.
- A collider preventing overlap with other solid objects.
- A perception system to detect other actors.
- A line-of-sight system.
- A movement component allowing it to navigate the world.

Let's run the game again, and press "~". This open Geometer, the editor. Click on the k on the right hand side and use the pen tool to draw a kobold in. Press the green button to resume the game.

### The Kobold Controller

Now that the kobold exists in the world, you might notice something—it’s not moving! To give it behavior, we need to implement a **Controller** component.

A `Controller` (or one of its derivatives) defines an `act` function, which takes the **level** and the **actor** as arguments and returns a valid action. Importantly, the `act` function **should not modify the level directly**—it should only use it to validate actions.

1. Navigate to `modules/MyGame/components/`.
2. Create a new file named `koboldcontroller.lua`.
3. Add the following code:

```lua
--- @class KoboldController : Controller
--- @field blackboard table|nil
--- @overload fun(): KoboldController
--- @type KoboldController
local KoboldController = prism.Controller:extend("KoboldController")
KoboldController.name = "KoboldController"

---@return Action
function KoboldController:act(level, actor)
    -- Retrieve the senses component to detect nearby actors.
    local senses = self:getComponent(prism.components.Senses)

    -- Identify the closest sensed actor that has a Controller.
    local closest
    local closestDistance
    for sensedActor in senses.actors:eachActor(prism.components.Controller) do
        local dist = sensedActor:getRange(actor)
        if dist < closestDistance then
            closest = sensedActor
            closestDistance = dist
        end
    end

    -- If no valid target is found, wait.
    if not closest then return prism.actions.Wait() end

    -- Use Prism's pathfinding to determine a route to the closest actor.
    local path = level:findPath(actor:getPosition(), closest:getPosition(), nil, stats.mask)

    -- If a valid path is found, attempt to move along it.
    if path then
        local move = prism.actions.Move(actor, {path:pop()})
        if move:canPerform(level) then
            return move
        end
    end

    -- If no action can be taken, wait.
    return prism.actions.Wait()
end

return KoboldController
```

### Integrating the Controller

Now, open `kobold.lua` and add the new component:

```lua
prism.components.KoboldController()
```

### Testing the Kobold AI

Run the game and open **Geometer** by pressing `~`.  
1. Click on the **"k"** character.  
2. Click anywhere in the level to **spawn a kobold**.  
3. Resume the game using the **green button**.  

The kobold should now follow you when it sees you. However, if you spawn a second kobold, you’ll notice an issue—they can get stuck in a loop following each other!  

To fix this, we’ll ensure that kobolds only follow the **player**.

---

## Adding a Player Tag

To differentiate the player from other actors, we need a way to identify it. A full roguelike might implement a faction system, but for now, we’ll use a **simple tag component**.

### Creating the PlayerTag Component

1. Navigate to `modules/MyGame/components/`.
2. Create a new file named `player.lua`.
3. Add the following code:

```lua
local PlayerTag = prism.Component:extend("PlayerTagComponent")
PlayerTag.name = "PlayerTag"
```

### Assigning the PlayerTag

Next, modify `modules/MyGame/actors/player.lua` to add the new component:

```lua
prism.components.PlayerTag()
```

---

## Updating the Kobold AI

Now, we’ll modify `KoboldController` so kobolds only follow actors with the **PlayerTag**.

Replace the `act` function in `koboldcontroller.lua` with the following:

```lua
function KoboldController:act(level, actor)
    -- Retrieve the senses component to detect nearby actors.
    local senses = self:getComponent(prism.components.Senses)

    -- Identify the player from sensed actors.
    local player
    for sensedActor in senses.actors:eachActor(prism.components.Player) do
        player = sensedActor
    end

    if player then
        -- Use Prism's pathfinding to determine a route to the player.
        local path = level:findPath(actor:getPosition(), player:getPosition(), nil, stats.mask)

        -- If a valid path is found, attempt to move along it.
        if path then
            local move = prism.actions.Move(actor, {path:pop()})
            if move:canPerform(level) then
                return move
            end 
        end
    end

    -- If no action can be taken, wait.
    return prism.actions.Wait()
end
```

Now, kobolds will **only** track the player!

## Kicking Kobolds

In this section we'll give you something to do to these kobolds. Kick them! We'll need to create our first action. Head over
to /modules/MyGame/actions and add kick.lua.

Let's first create a target for our kick. Put this at the top of kick.lua.

```lua
local KickTarget = prism.Target:extend("KickTarget")
-- This can be Actor, Point, Cell, or Any. You can accept a union of these types and
-- differentiate in canPerform/perform
KickTarget.typesAllowed = { Actor = true }
-- Targets have built in range checking for brevity, we specify one here.
KickTarget.range = 1

function KickTarget:validate(owner, actor, targets)
   -- check if the actor has a collider
   return actor:hasComponent(prism.components.Collider)
end
```

So with this target we're saying you can only kick actors at range one with a collider component.

```lua
---@class KickAction : Action
---@field name string
---@field targets Target[]
---@field previousPosition Vector2
local Kick = prism.Action:extend("KickAction")
Kick.name = "move"
Kick.targets = { KickTarget }
Kick.requiredComponents = {
   prism.components.Controller,
   prism.components.Kicker,
}

--- @param level Level
--- @param kicked Actor
function Kick:_perform(level, kicked)
   local kicker = self.owner:expectComponent(prism.components.Kicker)
   
   local kx, ky = (kicked:getPosition() - self.owner:getPosition()):decompose()

   -- 'normalize' the kick direction
   if kx > 0 then kx = 1 elseif kx < 0 then kx = -1 end
   if ky > 0 then ky = 1 elseif ky < 0 then ky = -1 end

   -- recompose back into a vector
   local kickdir = prism.Vector2(kx, ky)

   -- our movetype mask for the kick, we'll give them the 'fly' movetype
   local mask = prism.Collision.createBitmaskFromMovetypes{ "fly" }

   -- now we loop and continue to try to move the kicked in the direction
   -- of the kick a number of tiles equal to the kicker's kick strength.
   for i = 1, kicker.strength do
      local nextpos = kicked:getPosition() + kickdir
      if level:getCellPassable(nextpos.x, nextpos.y, mask) then
         level:moveActor(kicked, nextpos)
      end
   end
end   

return Kick

```
