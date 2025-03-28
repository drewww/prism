
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
(method) SelectTool:__new()
```

### _serializationBlacklist


```lua
table
```

### actors


```lua
SparseMap
```

the copied actors from the attachable

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### cells


```lua
Grid
```

the copied cells from the attachable

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### copy


```lua
(method) SelectTool:copy(attachable: SpectrumAttachable)
```

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### dragOrigin


```lua
Vector2
```

where we started dragging from when moving a pasted selection

### dragging


```lua
boolean
```

whether we're dragging, either actively creating a selection or pasting one

### draw


```lua
(method) SelectTool:draw(editor: Editor, display: Display)
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
(method) SelectTool:getCurrentRect()
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
(method) SelectTool:mouseclicked(editor: Editor, attachable: SpectrumAttachable, x: integer, y: integer)
```

@*param* `x` — The cell coordinate clicked.

@*param* `y` — The cell coordinate clicked.

### mousereleased


```lua
(method) SelectTool:mousereleased(editor: Editor, attachable: SpectrumAttachable, x: integer, y: integer)
```

@*param* `x` — The cell coordinate clicked.

@*param* `y` — The cell coordinate clicked.

### origin


```lua
Vector2
```

location of the first point in a selection (creating or pasted)

### overrideCellDraw


```lua
(method) Tool:overrideCellDraw(editor: Editor, level: Level, cellx: integer, celly: integer)
```

### paste


```lua
(method) SelectTool:paste()
```

### pasted


```lua
boolean
```

whether a selection is currently pasted/active

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

location of the other point in a selection (creating or pasted)

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
(method) SelectTool:update(dt: number, editor: Editor)
```


---

