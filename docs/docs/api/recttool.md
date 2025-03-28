
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
(method) RectTool:__new()
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
(method) RectTool:draw(editor: Editor, display: Display)
```

### drawCell


```lua
(method) Tool:drawCell(display: Display, drawable: DrawableComponent, x: number, y: number)
```

Draws a cell at the given coordinates.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getCurrentRect


```lua
(method) RectTool:getCurrentRect()
  -> topleftx: number?
  2. toplefty: number?
  3. bottomrightx: number?
  4. bottomrighty: number?
```

 Returns the four corners of the current rect.

### getDrawable


```lua
(method) Tool:getDrawable(placeable: Actor|Cell)
  -> DrawableComponent
```

Returns the DrawableComponent from placeable

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

### mouseclicked


```lua
(method) RectTool:mouseclicked(editor: Editor, attachable: SpectrumAttachable, x: integer, y: integer)
```

@*param* `x` — The cell coordinate clicked.

@*param* `y` — The cell coordinate clicked.

### mousereleased


```lua
(method) RectTool:mousereleased(editor: Editor, attachable: SpectrumAttachable, x: integer, y: integer)
```

@*param* `x` — The cell coordinate clicked.

@*param* `y` — The cell coordinate clicked.

### origin


```lua
Vector2
```

### overrideCellDraw


```lua
(method) Tool:overrideCellDraw(editor: Editor, level: Level, cellx: integer, celly: integer)
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

### second


```lua
Vector2
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

### stripName


```lua
boolean
```

### update


```lua
(method) RectTool:update(dt: number, editor: Editor)
```


---

