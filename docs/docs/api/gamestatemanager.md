
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
(method) GameStateManager:__new()
```

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
(method) GameStateManager:draw()
```

 Called each draw, calls draw on top state in stack.

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

### keypressed


```lua
(method) GameStateManager:keypressed(key: any, scancode: any)
```

 Called on keypress, calls keypressed on top state in stack

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
(method) GameStateManager:mousemoved(x: any, y: any, dx: any, dy: any, istouch: any)
```

### mousepressed


```lua
(method) GameStateManager:mousepressed(x: any, y: any, button: any, istouch: any, presses: any)
```

### mousereleased


```lua
(method) GameStateManager:mousereleased(x: any, y: any, button: any)
```

### pop


```lua
(method) GameStateManager:pop()
  -> unknown
```

 Pops the state from the top of the stack.

### prettyprint


```lua
function Object.prettyprint(obj: table, indent: string, visited: table)
  -> string
```

 Pretty-prints an object for debugging or visualization.

@*param* `obj` — The object to pretty-print.

@*param* `indent` — The current indentation level (used for recursion).

@*param* `visited` — A table of visited objects to prevent circular references.

### push


```lua
(method) GameStateManager:push(state: GameState)
```

@*param* `state` — State to push to the top of the stack.

### replace


```lua
(method) GameStateManager:replace(state: GameState)
```

@*param* `state` — Swap the top of the stack with this state.

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### stateStack


```lua
table
```

### stripName


```lua
boolean
```

### textinput


```lua
(method) GameStateManager:textinput(text: any)
```

### update


```lua
(method) GameStateManager:update(dt: any)
```

 Called each update, calls update on top state in stack.

### wheelmoved


```lua
(method) GameStateManager:wheelmoved(dx: any, dy: any)
```


---

