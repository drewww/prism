
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

### addActor


```lua
fun(self: any, actor: Actor)
```

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

### debug


```lua
boolean
```

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### eachActor


```lua
fun(self: any):fun()
```

### eachActorAt


```lua
fun(self: any, x: integer, y: integer):fun()
```

### eachCell


```lua
fun(self: any):fun()
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

### getActorsAt


```lua
fun(self: any, x: integer, y: integer)
```

### getCell


```lua
fun(self: any, x: integer, y: integer):Cell
```

### inBounds


```lua
fun(self: any, x: integer, y: integer)
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
fun(self: any, actor: Actor)
```

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### setCell


```lua
fun(self: any, x: integer, y: integer, cell: Cell|nil)
```

### stripName


```lua
boolean
```


---

