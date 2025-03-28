
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

### actors


```lua
ActorStorage
```

An actor storage with the actors the player is aware of.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### cells


```lua
SparseGrid
```

A sparse grid of cells representing the portion of the map the actor's senses reveal.

### checkRequirements


```lua
(method) Component:checkRequirements(actor: Actor)
  -> meetsRequirements: boolean
```

 Checks whether an actor has the required components to attach this component.

@*param* `actor` — The actor to check the requirements against.

@*return* `meetsRequirements` — the actor meets all requirements, false otherwise.

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

### explored


```lua
SparseGrid
```

A sparse grid of cells the actor's senses have previously revealed.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### initialize


```lua
(method) SensesComponent:initialize(actor: Actor)
```

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

Each component prototype MUST have a unique name!

### owner


```lua
Actor
```

The Actor this component is composing. This is set by Actor when a component is added or removed.

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
table
```

A list of component prototypes the actor must first have, before this can be applied.

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

### unknown


```lua
SparseMap<Vector2>
```

Unkown actors are things the player is aware of the location of, but not the components.


---

