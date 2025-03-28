
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
(method) BooleanBuffer:__new(w: integer, h: integer)
```

 Constructor for the BooleanBuffer class.

@*param* `w` — The width of the buffer.

@*param* `h` — The height of the buffer.

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### buffer


```lua
ffi.cdata*
```

 Initialize the buffer with false values

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### clear


```lua
(method) BooleanBuffer:clear()
```

 Clear the buffer, setting all values to false.

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

### get


```lua
(method) BooleanBuffer:get(x: integer, y: integer)
  -> value: boolean
```

 Get the value at the given coordinates.

@*param* `x` — The x-coordinate (1-based).

@*param* `y` — The y-coordinate (1-based).

@*return* `value` — The value at the given coordinates.

### getIndex


```lua
(method) BooleanBuffer:getIndex(x: integer, y: integer)
  -> index: integer
```

 Calculate the index in the buffer array for the given coordinates.

@*param* `x` — The x-coordinate (1-based).

@*param* `y` — The y-coordinate (1-based).

@*return* `index` — The corresponding index in the buffer array.

### h


```lua
integer
```

The height of the buffer.

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

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### set


```lua
(method) BooleanBuffer:set(x: integer, y: integer, v: boolean)
```

 Set the value at the given coordinates.

@*param* `x` — The x-coordinate (1-based).

@*param* `y` — The y-coordinate (1-based).

@*param* `v` — The value to set.

### stripName


```lua
boolean
```

### w


```lua
integer
```

The width of the buffer.


---

