
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
(method) Keybinding:__new(schema: table)
```

 Constructor for the Keybinding class.
 Initializes the keymap and modes with a predefined schema and defaults.

@*param* `schema` — A list of predefined keybindings with their schema and defaults.

### _serializationBlacklist


```lua
table
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

### clear


```lua
(method) Keybinding:clear(mode: string|nil)
```

 Resets keybindings for a specific mode or all modes to their defaults.

@*param* `mode` — The mode to reset. If nil, resets all modes.

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

### keymap


```lua
table
```

 Stores modifications

### keypressed


```lua
(method) Keybinding:keypressed(key: string, mode: string|nil)
  -> The: string|nil
```

 Handles key press events and retrieves the associated action if a binding exists.
 Falls back to the schema if no modification is found.

@*param* `key` — The key that was pressed.

@*param* `mode` — The mode to use for the keybinding.

@*return* `The` — action associated with the key, or nil if no binding exists.

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

### schema


```lua
table
```

 Holds the schema for all modes, including "default"

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
(method) Keybinding:set(key: string, action: string, mode: string|nil)
```

 Sets or updates a keybinding, validating it exists in the schema.

@*param* `key` — The key to bind.

@*param* `action` — The new action to associate with the key.

@*param* `mode` — An optional mode for the binding (defaults to "default").

### stripName


```lua
boolean
```


---

