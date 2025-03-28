
### RNG


```lua
RNG
```

The level's local random number generator, use this for randomness within the level like attack rolls.

### __call


```lua
function
```

### __index


```lua
Object
```

 A simple class system for Lua. This is the base class for all other classes in PRISM.

### __new


```lua
(method) Level:__new(map: Map, actors: [Actor], systems: [System], scheduler: any, seed: any)
```

 Constructor for the Level class.

@*param* `map` — The map to use for the level.

@*param* `actors` — A list of actors to

### _serializationBlacklist


```lua
table
```

### actorStorage


```lua
ActorStorage
```

The main actor storage containing all of the level's actors.

### addActor


```lua
(method) Level:addActor(actor: Actor)
```

 Adds an actor to the level. Handles updating the component cache and
 inserting the actor into the sparse map. It will also add the actor to the
 scheduler if it has a controller.

@*param* `actor` — The actor to add.

### addComponent


```lua
(method) Level:addComponent(actor: Actor, component: Component)
```

 Adds a component to an actor. It handles updating
 the component cache and the opacity cache. You can do this manually, but
 it's easier to use this function.

@*param* `actor` — The actor to add the component to.

@*param* `component` — The component to add.

### addSystem


```lua
(method) Level:addSystem(system: System)
```

 Attaches a system to the level. This function will error if the system
 doesn't have a name or if a system with the same name already exists, or if
 the system has a requirement that hasn't been attached yet.

@*param* `system` — The system to add.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### computeFOV


```lua
(method) Level:computeFOV(origin: any, maxDepth: any, callback: any)
```

### debug


```lua
boolean
```

### debugYield


```lua
(method) Level:debugYield(stringMessage: any)
```

### decision


```lua
ActionDecision
```

Used during deserialization to resume.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### eachActor


```lua
(method) Level:eachActor(...Component)
  -> An: function
```

 This method returns an iterator that will return all actors in the level
 that have the given components. If no components are given it iterate over
 all actors. A thin wrapper over the inner ActorStorage.

@*param* `...` — The components to filter by.

@*return* `An` — iterator that returns the next actor that matches the given components.

### eachActorAt


```lua
(method) Level:eachActorAt(x: number, y: number)
  -> iter: function
```

 Returns an iterator that will return all actors at the given position.

@*param* `x` — The x component of the position to check.

@*param* `y` — The y component of the position to check.

@*return* `iter` — An iterator that returns the next actor at the given position.

### eachCell


```lua
(method) Level:eachCell()
  -> fun():number, number, <T>
```

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### findPath


```lua
(method) Level:findPath(startPos: Vector2, goalPos: Vector2, minDistance: any, mask: any)
  -> Path|nil
```

 Finds a path from startpos to endpos

### getAOE


```lua
(method) Level:getAOE(type: "box"|"fov", position: Vector2, range: number)
  -> actors: table?
  2. fov: table?
```

 Returns a list of all actors that are within the given range of the given
 position. The type parameter determines the type of range to use. Currently
 only "fov" and "box" are supported. The fov type uses a field of view
 algorithm to determine what actors are visible from the given position. The
 box type uses a simple box around the given position.

@*param* `type` — The type of range to use.

@*param* `position` — The position to check from.

@*param* `range` — The range to check.

@*return* `actors`

@*return* `fov` — A list of actors within the given range.

```lua
type:
    | "box"
    | "fov"
```

### getActorByType


```lua
(method) Level:getActorByType(prototype: Actor)
  -> The: Actor|nil
```

 Returns the first actor that extends the given prototype, or nil if no actor
 is found. Useful for one offs like stairs in some games.

@*param* `prototype` — The prototype to check for.

@*return* `The` — first actor that extends the given prototype, or nil if no actor is found.

### getActorController


```lua
(method) Level:getActorController(actor: Actor)
  -> controller: ControllerComponent
```

 Gets the actor's controller. This is a utility function that checks the
 actor's conditions for an override controller and returns it if it exists.
 Otherwise it returns the actor's normal controller.

@*param* `actor` — The actor to get the controller for.

@*return* `controller` — The actor's controller.

### getActorsAt


```lua
(method) Level:getActorsAt(x: number, y: number)
  -> A: table
```

 Returns a list of all actors at the given position. A thin wrapper over
 the inner ActorStorage.

@*param* `x` — The x component of the position to check.

@*param* `y` — The y component of the position to check.

@*return* `A` — list of all actors at the given position.

### getCell


```lua
(method) Level:getCell(x: number, y: number)
  -> The: Cell
```

 Gets the cell at the given position.

@*param* `x` — The x component of the position to get.

@*param* `y` — The y component of the position to get.

@*return* `The` — cell at the given position.

### getCellOpaque


```lua
(method) Level:getCellOpaque(x: number, y: number)
  -> True: boolean
```

 Returns true if the cell at the given position is opaque, false otherwise.

@*param* `x` — The x component of the position to check.

@*param* `y` — The y component of the position to check.

@*return* `True` — if the cell is opaque, false otherwise.

### getCellPassable


```lua
(method) Level:getCellPassable(x: number, y: number, mask: integer)
  -> True: boolean
```

 Returns true if the cell at the given position is passable, false otherwise. Considers
 actors in the sparse map as well as the cell's passable property.

@*param* `x` — The x component of the position to check.

@*param* `y` — The y component of the position to check.

@*return* `True` — if the cell is passable, false otherwise.

### getID


```lua
(method) Level:getID(actor: Actor)
  -> The: integer?
```

 Retrieves the unique ID associated with the specified actor.
 Note: IDs are unique to actors within the Level but may be reused 
 when indices are freed.

@*param* `actor` — The actor whose ID is to be retrieved.

@*return* `The` — unique ID of the actor, or nil if the actor is not found.

### getOpacityCache


```lua
(method) Level:getOpacityCache()
  -> map: BooleanBuffer
```

 Returns the opacity cache for the level. This generally shouldn't be used
 outside of systems that need to know about opacity.

@*return* `map` — The opacity cache for the level.

### getSystem


```lua
(method) Level:getSystem(className: string)
  -> system: System?
```

 Gets a system by name.

@*param* `className` — The name of the system to get.

@*return* `system` — The system with the given name.

### hasActor


```lua
(method) Level:hasActor(actor: Actor)
  -> hasActor: boolean
```

 Returns true if the level contains the given actor, false otherwise. A thin wrapper
 over the inner ActorStorage.

@*param* `actor` — The actor to check for.

@*return* `hasActor` — True if the level contains the given actor, false otherwise.

### inBounds


```lua
(method) Level:inBounds(x: integer, y: integer)
  -> boolean
```

 Is there a cell at this x, y? Part of the interface with MapBuilder

@*param* `x` — The x component to check if in bounds.

### initialize


```lua
(method) Level:initialize(actors: [Actor], systems: [System])
```

### initializeOpacityCache


```lua
(method) Level:initializeOpacityCache()
```

 Initialize the opacity cache. This should be called after the level is
 created and before the game loop starts. It will initialize the opacity
 cache with the cell opacity cache. This is handled automatically by the
 Level class.

### initializePassabilityCache


```lua
(method) Level:initializePassabilityCache()
```

 Initialize the passable cache. This should be called after the level is
 created and before the game loop starts. It will initialize the passable
 cache with the cell passable cache. This is handled automatically by the
 Level class.

### instanceOf


```lua
(method) Object:instanceOf(o: table)
  -> extends: boolean
```

 Checks if o is the first class in the inheritance chain of self.

@*param* `o` — The class to check.

@*return* `extends` — True if o is the first class in the inheritance chain of self, false otherwise.

### is


```lua
(method) Object:is(o: table)
  -> is: boolean
```

 Checks if o is in the inheritance chain of self.

@*param* `o` — The class to check.

@*return* `is` — True if o is in the inheritance chain of self, false otherwise.

### map


```lua
Map
```

The level's map.

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### moveActor


```lua
(method) Level:moveActor(actor: Actor, pos: Vector2, skipSparseMap: boolean)
```

 Moves an actor to the given position. This function doesn't do any checking
 for overlaps or collisions. It's used by the moveActorChecked function, you should
 generally not invoke this yourself using moveActorChecked instead.

@*param* `actor` — The actor to move.

@*param* `pos` — The position to move the actor to.

@*param* `skipSparseMap` — If true the sparse map won't be updated.

### onDeserialize


```lua
(method) Level:onDeserialize()
```

### opacityCache


```lua
BooleanBuffer
```

A cache of cell opacity || actor opacity for each cell. Used to speed up fov/lighting calculations.

### passableCache


```lua
BitmaskBuffer
```

A cache of cell passability || actor passability for each cell. Used to speed up pathfinding.

### performAction


```lua
(method) Level:performAction(action: Action, silent?: boolean)
```

 Executes an Action, updating the level's state and triggering any events through the systems
 attached to the Actor or Level respectively. It also updates the 'Scheduler' if the action isn't
 a reaction or free action. Lastly, it calls the 'onAction' method on the 'Cell' that the 'Actor' is
 standing on.

@*param* `action` — The action to perform.

@*param* `silent` — If true this action emits no events.

### prettyprint


```lua
function Object.prettyprint(obj: table, indent: string, visited: table)
  -> string
```

 Pretty-prints an object for debugging or visualization.

@*param* `obj` — The object to pretty-print.

@*param* `indent` — The current indentation level (used for recursion).

@*param* `visited` — A table of visited objects to prevent circular references.

### removeActor


```lua
(method) Level:removeActor(actor: Actor)
```

 Removes an actor from the level. Handles updating the component cache and
 removing the actor from the sparse map. It will also remove the actor from
 the scheduler if it has a controller.

@*param* `actor` — The actor to remove.

### removeComponent


```lua
(method) Level:removeComponent(actor: Actor, component: Component)
```

 Removes a component from an actor. It handles
 updating the component cache and the opacity cache.

@*param* `actor` — The actor to remove the component from.

@*param* `component` — The component to remove.

### run


```lua
(method) Level:run()
```

 Initializes the level,
 Update is the main game loop for a level. It's a coroutine that yields
 back to the main thread when it needs to wait for input from the player.
 This function is the heart of the game loop.

### scheduler


```lua
Scheduler
```

The main scheduler driving the loop of the game.

### serializationBlacklist


```lua
table
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### setCell


```lua
(method) Level:setCell(x: number, y: number, cell: Cell)
```

 Sets the cell at the given position to the given cell.

@*param* `x` — The x component of the position to set.

@*param* `y` — The y component of the position to set.

@*param* `cell` — The cell to set.

### sparseMapCallback


```lua
(method) Level:sparseMapCallback()
  -> function
```

### step


```lua
(method) Level:step()
```

### stripName


```lua
boolean
```

### systemManager


```lua
SystemManager
```

A table containing all of the systems active in the level, set in the constructor.

### trigger


```lua
(method) Level:trigger(eventName: any, ...any)
```

### updateCaches


```lua
(method) Level:updateCaches(x: any, y: any)
```

### updateOpacityCache


```lua
(method) Level:updateOpacityCache(x: number, y: number)
```

 Updates the opacity cache at the given position. This should be called
 whenever an actor moves or a cell's opacity changes. This is handled
 automatically by the Level class.

@*param* `x` — The x component of the position to update.

@*param* `y` — The y component of the position to update.

### updatePassabilityCache


```lua
(method) Level:updatePassabilityCache(x: number, y: number)
```

 Updates the passability cache at the given position. This should be called
 whenever an actor moves or a cell's passability changes. This is handled
 automatically by the Level class.

@*param* `x` — The x component of the position to update.

@*param* `y` — The y component of the position to update.

### yield


```lua
(method) Level:yield(message: Message)
  -> Decision|nil
```

 Yields to the main 'thread', a coroutine in this case. This is called in run, and a few systems. Any time you want
 the interface to update you should call this. Avoid calling coroutine.yield directly,
 as this function will call the onYield method on all systems.


---

