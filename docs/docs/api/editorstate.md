
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
(method) EditorState:__new(attachable: SpectrumAttachable, display: any, fileEnabled: any)
```

 Create a new Editor managing gamestate, attached to a
 SpectrumAttachable, this is a Level|MapBuilder interface.

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

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### draw


```lua
(method) EditorState:draw()
```

### editor


```lua
Editor
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

### getManager


```lua
(method) GameState:getManager()
  -> GameStateManager
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

### keypressed


```lua
(method) EditorState:keypressed(key: any, scancode: any)
```

### load


```lua
(method) EditorState:load()
```

### manager


```lua
GameStateManager
```

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### mousemoved


```lua
(method) EditorState:mousemoved(x: any, y: any, dx: any, dy: any, istouch: any)
```

### mousepressed


```lua
(method) EditorState:mousepressed(x: any, y: any, button: any)
```

### mousereleased


```lua
(method) EditorState:mousereleased(x: any, y: any, button: any)
```

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

### textinput


```lua
(method) EditorState:textinput(text: any)
```

### unload


```lua
(method) GameState:unload()
```

 Calls when the gamestate is stopped.

### update


```lua
(method) EditorState:update(dt: any)
```

### wheelmoved


```lua
(method) EditorState:wheelmoved(dx: any, dy: any)
```


---

