
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

### bucket


```lua
(method) Fill:bucket(attachable: SpectrumAttachable, x: any, y: any)
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
(method) Tool:draw(editor: Editor, display: Display)
```

Draws the tool visuals.

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

### locations


```lua
SparseGrid
```

 A sparse grid class that stores data using hashed coordinates. Similar to a SparseMap
 except here there is only one entry per grid coordinate. This is suitable for stuff like Cells.

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
(method) Fill:mouseclicked(editor: Editor, level: Level, cellx: number, celly: number)
```

 Begins a paint drag.

@*param* `cellx` — The x-coordinate of the cell clicked.

@*param* `celly` — The y-coordinate of the cell clicked.

### mousereleased


```lua
(method) Tool:mousereleased(editor: Editor, level: any, cellx: number, celly: number)
```

Handles mouse release events.

@*param* `cellx` — The x-coordinate of the cell release.

@*param* `celly` — The y-coordinate of the cell release.

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
(method) Fill:update(dt: number, editor: Editor)
```

Updates the tool state.

@*param* `dt` — The time delta since the last update.


---

