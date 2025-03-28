
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
(method) SystemManager:__new(owner: Level)
```

### _serializationBlacklist


```lua
table
```

### addSystem


```lua
(method) SystemManager:addSystem(system: System)
```

 Adds a system to the manager.

@*param* `system` — The system to add.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### afterAction


```lua
(method) SystemManager:afterAction(level: Level, actor: Actor, action: Action)
```

 Calls the afterAction method for all systems.

@*param* `level` — The level to call afterAction for.

@*param* `actor` — The actor that has taken an action.

@*param* `action` — The action the actor has executed.

### afterOpacityChanged


```lua
(method) SystemManager:afterOpacityChanged(level: Level, x: number, y: number)
```

 Calls the afterOpacityChanged method for all systems.

@*param* `level` — The level to call afterOpacityChanged for.

@*param* `x` — The x coordinate of the tile.

@*param* `y` — The y coordinate of the tile.

### beforeAction


```lua
(method) SystemManager:beforeAction(level: Level, actor: Actor, action: Action)
```

 Calls the beforeAction method for all systems.

@*param* `level` — The level to call beforeAction for.

@*param* `actor` — The actor that has selected an action.

@*param* `action` — The action the actor has selected.

### beforeMove


```lua
(method) SystemManager:beforeMove(level: Level, actor: Actor, from: Vector2, to: Vector2)
```

 Calls the beforeMove method for all systems.

@*param* `level` — The level to call beforeMove for.

@*param* `actor` — The actor that is moving.

@*param* `from` — The position the actor is moving from.

@*param* `to` — The position the actor is moving to.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
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

### getSystem


```lua
(method) SystemManager:getSystem(systemName: string)
  -> The: System?
```

 Gets a system by name.

@*param* `systemName` — The name of the system to get.

@*return* `The` — system with the given name, or nil if not found.

### initialize


```lua
(method) SystemManager:initialize(level: Level)
```

 Initializes all systems attached to the manager.

@*param* `level` — The level to initialize the systems for.

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

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### onActorAdded


```lua
(method) SystemManager:onActorAdded(level: Level, actor: Actor)
```

 Calls the onActorAdded method for all systems.

@*param* `level` — The level to call onActorAdded for.

@*param* `actor` — The actor that has been added.

### onActorRemoved


```lua
(method) SystemManager:onActorRemoved(level: Level, actor: Actor)
```

 Calls the onActorRemoved method for all systems.

@*param* `level` — The level to call onActorRemoved for.

@*param* `actor` — The actor that has been removed.

### onMove


```lua
(method) SystemManager:onMove(level: Level, actor: Actor, from: Vector2, to: Vector2)
```

 Calls the onMove method for all systems.

@*param* `level` — The level to call onMove for.

@*param* `actor` — The actor that has moved.

@*param* `from` — The position the actor moved from.

@*param* `to` — The position the actor moved to.

### onTick


```lua
(method) SystemManager:onTick(level: Level)
```

 Calls the onTick method for all systems.

@*param* `level` — The level to call onTick for.

### onTurn


```lua
(method) SystemManager:onTurn(level: Level, actor: Actor)
```

 Calls the onTurn method for all systems.

@*param* `level` — The level to call onTurn for.

@*param* `actor` — The actor taking its turn.

### onTurnEnd


```lua
(method) SystemManager:onTurnEnd(level: Level, actor: Actor)
```

 Calls the onTurn method for all systems.

@*param* `level` — The level to call onTurn for.

@*param* `actor` — The actor taking its turn.

### onYield


```lua
(method) SystemManager:onYield(level: Level, event: Message)
```

 Calls the on yield method for each system right before
 the level hands a Decision back to the interface. Used by the Sight
 system to ensure that the player's fov is always updated when we yield
 even if it's not their turn.

@*param* `level` — The level to call onYield for.

@*param* `event` — The event data that caused the yield.

### owner


```lua
Level
```

 The 'Level' holds all of the actors and systems, and runs the game loop. Through the ActorStorage and SystemManager


### postInitialize


```lua
(method) SystemManager:postInitialize(level: Level)
```

 Post-initializes all systems after the level has been populated.

@*param* `level` — The level to post-initialize the systems for.

### prettyprint


```lua
function Object.prettyprint(obj: table, indent: string, visited: table)
  -> string
```

 Pretty-prints an object for debugging or visualization.

@*param* `obj` — The object to pretty-print.

@*param* `indent` — The current indentation level (used for recursion).

@*param* `visited` — A table of visited objects to prevent circular references.

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### stripName


```lua
boolean
```

### systems


```lua
System[]
```

### trigger


```lua
(method) SystemManager:trigger(eventString: string, ...any)
```

 This is useful for calling custom events you define in your Actions, Systems, etc.
 An example usage of this can be found in the Sight system.

@*param* `eventString` — The key of the event handler method into the system.

@*param* `...` — The arguments to be passed to the event handler method.


---

