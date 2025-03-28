
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
(method) MapBuilder:__new(initialValue: Cell)
```

 The constructor for the 'MapBuilder' class.
 Initializes the map with an empty data table and actors list.

@*param* `initialValue` — The initial value to fill the map with.

### _serializationBlacklist


```lua
table
```

### actors


```lua
ActorStorage
```

A list of actors present in the map.

### addActor


```lua
(method) MapBuilder:addActor(actor: table, x?: number, y?: number)
```

 Adds an actor to the map at the specified coordinates.

@*param* `actor` — The actor to add.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

### addPadding


```lua
(method) MapBuilder:addPadding(width: number, cell: Cell)
```

 Adds padding around the map with a specified width and cell value.

@*param* `width` — The width of the padding to add.

@*param* `cell` — The cell value to use for padding.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### blit


```lua
(method) MapBuilder:blit(source: MapBuilder, destX: number, destY: number, maskFn: fun(x: integer, y: integer, source: Cell, dest: Cell)|nil)
```

 Blits the source MapBuilder onto this MapBuilder at the specified coordinates.

@*param* `source` — The source MapBuilder to copy from.

@*param* `destX` — The x-coordinate of the top-left corner in the destination MapBuilder.

@*param* `destY` — The y-coordinate of the top-left corner in the destination MapBuilder.

@*param* `maskFn` — A callback function for masking. Should return true if the cell should be copied, false otherwise.

### build


```lua
(method) MapBuilder:build()
  -> Map
  2. actors: table
```

 Builds the map and returns the map and list of actors.
 Converts the sparse grid to a contiguous grid.

@*return* `actors` — map and the list of actors.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### clear


```lua
(method) SparseGrid:clear()
```

 Clears all values in the sparse grid.

### data


```lua
table
```

### debug


```lua
boolean
```

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### drawEllipse


```lua
(method) MapBuilder:drawEllipse(cx: number, cy: number, rx: number, ry: number, cell: Cell)
```

 Draws an ellipse on the map.

@*param* `cx` — The x-coordinate of the center.

@*param* `cy` — The y-coordinate of the center.

@*param* `rx` — The radius along the x-axis.

@*param* `ry` — The radius along the y-axis.

@*param* `cell` — The cell to fill the ellipse with.

### drawLine


```lua
(method) MapBuilder:drawLine(x1: number, y1: number, x2: number, y2: number, cell: Cell)
```

 Draws a line on the map using Bresenham's line algorithm.

@*param* `x1` — The x-coordinate of the starting point.

@*param* `y1` — The y-coordinate of the starting point.

@*param* `x2` — The x-coordinate of the ending point.

@*param* `y2` — The y-coordinate of the ending point.

@*param* `cell` — The cell to draw the line with.

### drawRectangle


```lua
(method) MapBuilder:drawRectangle(x1: number, y1: number, x2: number, y2: number, cell: Cell)
```

 Draws a rectangle on the map.

@*param* `x1` — The x-coordinate of the top-left corner.

@*param* `y1` — The y-coordinate of the top-left corner.

@*param* `x2` — The x-coordinate of the bottom-right corner.

@*param* `y2` — The y-coordinate of the bottom-right corner.

@*param* `cell` — The cell to fill the rectangle with.

### each


```lua
(method) SparseGrid:each()
  -> iter: fun(x: integer, y: integer, V: any)
```

 Iterator function for the SparseGrid.
 Iterates over all entries in the sparse grid, returning the coordinates and value for each entry.

@*return* `iter` — An iterator function that returns the x-coordinate, y-coordinate, and value for each entry.

### eachActor


```lua
(method) MapBuilder:eachActor(...any)
  -> function
```

### eachActorAt


```lua
(method) MapBuilder:eachActorAt(x: any, y: any)
  -> function
```

### eachCell


```lua
(method) MapBuilder:eachCell()
  -> fun(x: integer, y: integer, V: any)
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
(method) MapBuilder:get(x: number, y: number)
  -> value: any
```

 Gets the value at the specified coordinates, or the initialValue if not set.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*return* `value` — The value at the specified coordinates, or the initialValue if not set.

### getActorsAt


```lua
fun(self: any, x: integer, y: integer)
```

### getCell


```lua
(method) MapBuilder:getCell(x: any, y: any)
  -> unknown
```

### inBounds


```lua
(method) MapBuilder:inBounds(x: any, y: any)
  -> boolean
```

### initialValue


```lua
Cell
```

The initial value to fill the map with.

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
(method) MapBuilder:removeActor(actor: table)
```

 Removes an actor from the map.

@*param* `actor` — The actor to remove.

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
(method) MapBuilder:set(x: number, y: number, value: any)
```

 Sets the value at the specified coordinates.

@*param* `x` — The x-coordinate.

@*param* `y` — The y-coordinate.

@*param* `value` — The value to set.

### setCell


```lua
(method) MapBuilder:setCell(x: any, y: any, value: any)
```

 Mirror set.

### stripName


```lua
boolean
```


---

