
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
(method) Object:__new(...any)
```

 The default constructor for the class. Subclasses should override this.

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### afterAction


```lua
(method) System:afterAction(level: Level, actor: Actor, action: Action)
```

 This method is called after an actor has taken an action.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that has taken an action.

@*param* `action` — The Action object that the Actor has executed.

### afterActions


```lua
table<Action, fun(level: Level, actor: Actor, action: Action)>
```

A table mapping specific actions to event hooks.

### afterOpacityChanged


```lua
(method) System:afterOpacityChanged(level: Level, x: number, y: number)
```

 Called when an actor or tile has its opacity changed.

@*param* `level` — The Level object this System is attached to.

@*param* `x` — The x coordinate of the tile.

@*param* `y` — The y coordinate of the tile.

### beforeAction


```lua
(method) System:beforeAction(level: Level, actor: Actor, action: Action)
```

 This method is called after an actor has selected an action, but before it is executed.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that has selected an action.

@*param* `action` — The Action object that the Actor has selected to execute.

### beforeActions


```lua
table<Action, fun(level: Level, actor: Actor, action: Action)>
```

A table mapping specific actions to event hooks.

### beforeMove


```lua
(method) System:beforeMove(level: Level, actor: Actor, from: Vector2, to: Vector2)
```

 This method is called before an actor moves.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that is moving.

@*param* `from` — The position the Actor is moving from.

@*param* `to` — The position the Actor is moving to.

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

### global


```lua
boolean
```

A system defined global can only be attached to the Game object. It will see all events from all levels.

### initialize


```lua
(method) System:initialize(level: Level)
```

 This method is called when the Level is initialized. It is called after all of the Systems have been attached.

@*param* `level` — The Level object this System is attached to.

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

### name


```lua
string
```

A system must define a name that is unique to the System.

### onActorAdded


```lua
(method) System:onActorAdded(level: Level, actor: Actor)
```

 This method is called after an actor has been added to the Level.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that has been added.

### onActorRemoved


```lua
(method) System:onActorRemoved(level: Level, actor: Actor)
```

 This method is called after an actor has been removed from the Level.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that has been removed.

### onDescend


```lua
(method) System:onDescend(level: Level)
```

 This method is called when descending to a lower level.

@*param* `level` — The Level object this System is attached to.

### onMove


```lua
(method) System:onMove(level: Level, actor: Actor, from: Vector2, to: Vector2)
```

 This method is called after an actor has moved.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that has moved.

@*param* `from` — The position the Actor moved from.

@*param* `to` — The position the Actor moved to.

### onTick


```lua
(method) System:onTick(level: Level)
```

 This method is called every 100 units of time, a second, and can be used for mechanics such as hunger and fire spreading.

@*param* `level` — The Level object this System is attached to.

### onTurn


```lua
(method) System:onTurn(level: Level, actor: Actor)
```

 This method is called when a new turn begins. The actor is the actor that is about to take their turn.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that is about to take its turn.

### onTurnEnd


```lua
(method) System:onTurnEnd(level: Level, actor: Actor)
```

 This method is called when a new turn ends.

@*param* `level` — The Level object this System is attached to.

@*param* `actor` — The Actor object that is about to take its turn.

### onYield


```lua
(method) System:onYield(level: Level, event: Message)
```

 This method is called whenever the level yields back to the interface.
 The most common usage for this right now is updating the sight component of any
 input controlled actors in the Sight system.

@*param* `level` — The Level object this System is attached to.

@*param* `event` — The event data that caused the yield.

### owner


```lua
Level?
```

The level that holds this system.

### postInitialize


```lua
(method) System:postInitialize(level: Level)
```

 This method is called after the Level is initialized. It is called after all of the Systems have been initialized.

@*param* `level` — The Level object this System is attached to.

### prettyprint


```lua
function Object.prettyprint(obj: table, indent: string, visited: table)
  -> string
```

 Pretty-prints an object for debugging or visualization.

@*param* `obj` — The object to pretty-print.

@*param* `indent` — The current indentation level (used for recursion).

@*param* `visited` — A table of visited objects to prevent circular references.

### requirements


```lua
string[]
```

A table of requirements that must be met for the System to be attached to a Level.

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### softRequirements


```lua
string[]
```

A table of optional requirements that ensure proper order if both Systems are attached.

### stripName


```lua
boolean
```


---

