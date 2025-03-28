
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
(method) Cell:__new()
```

 Constructor for the Cell class.

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
(method) Cell:afterAction(level: Level, actor: Actor, action: Action)
```

 Called right after an action is taken on the cell.

@*param* `level` — The level where the action took place.

@*param* `actor` — The actor that took the action.

@*param* `action` — The action that was taken.

### allowedMovetypes


```lua
string[]?
```

### beforeAction


```lua
(method) Cell:beforeAction(level: Level, actor: Actor, action: Action)
```

 Called right before an action takes place on this cell.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### collisionMask


```lua
integer
```

Defines whether a cell can moved through.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### drawable


```lua
DrawableComponent
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

### getComponent


```lua
(method) Cell:getComponent(component: any)
  -> DrawableComponent
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

Displayed in the user interface.

### onEnter


```lua
(method) Cell:onEnter(level: Level, actor: Actor)
```

 Called when an actor enters the cell.

@*param* `level` — The level where the actor entered the cell.

@*param* `actor` — The actor that entered the cell.

### onLeave


```lua
(method) Cell:onLeave(level: Level, actor: Actor)
```

 Called when an actor leaves the cell.

@*param* `level` — The level where the actor left the cell.

@*param* `actor` — The actor that left the cell.

### opaque


```lua
boolean
```

Defines whether a cell can be seen through.

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


---

