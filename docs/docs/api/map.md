
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
(method) Map:__new(w: number, h: number, initialValue: Cell)
```

 The constructor for the 'Map' class.
 Initializes the map with the specified dimensions and initial value, and sets up the opacity caches.

@*param* `w` — The width of the map.

@*param* `h` — The height of the map.

@*param* `initialValue` — The initial value to fill the map with.

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

### data


```lua
any[]
```

The data stored in the grid.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### each


```lua
(method) Grid:each()
  -> An: fun():number, number, <T>
```

 Iterates over each cell in the grid, yielding x, y, and the value.

@*return* `An` — iterator returning x, y, and value for each cell.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### fill


```lua
(method) Grid:fill(value: <T>)
```

 Fills the entire grid with the specified value.

@*param* `value` — The value to fill the grid with.

### fromData


```lua
(method) Grid:fromData(w: integer, h: integer, data: <T>[])
  -> The: Grid<<T>>
```

 Initializes the grid with the specified dimensions and data.

@*param* `w` — The width of the grid.

@*param* `h` — The height of the grid.

@*param* `data` — The data to fill the grid with.

@*return* `The` — initialized grid.

### get


```lua
(method) Map:get(x: number, y: number)
  -> cell: Cell
```

 Gets the cell at the specified coordinates.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*return* `cell` — The cell at the specified coordinates.

### getCellOpaque


```lua
(method) Map:getCellOpaque(x: number, y: number)
  -> True: boolean
```

 Returns true if the cell at the specified coordinates is opaque, false otherwise.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*return* `True` — if the cell is opaque, false otherwise.

### getCellPassable


```lua
(method) Map:getCellPassable(x: number, y: number, mask: any)
  -> True: boolean
```

 Returns true if the cell at the specified coordinates is passable, false otherwise.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*return* `True` — if the cell is passable, false otherwise.

### getIndex


```lua
(method) Grid:getIndex(x: integer, y: integer)
  -> The: number?
```

 Gets the index in the data array for the specified coordinates.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*return* `The` — index in the data array, or nil if out of bounds.

### h


```lua
integer
```

The height of the grid.

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

### onDeserialize


```lua
(method) Map:onDeserialize()
```

### opacityCache


```lua
BooleanBuffer
```

Caches the opaciy of the cell + actors in each tile for faster fov calculation.

### passableCache


```lua
BitmaskBuffer
```

 A class representing a 2D bitmask buffer using 16-bit integers.

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
table
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### set


```lua
(method) Map:set(x: number, y: number, cell: Cell)
```

 Sets the cell at the specified coordinates to the given value.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*param* `cell` — The cell to set.

### stripName


```lua
boolean
```

### updateCaches


```lua
(method) Map:updateCaches(x: number, y: number)
```

 Updates the opacity cache at the specified coordinates.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

### w


```lua
integer
```

The width of the grid.


---

