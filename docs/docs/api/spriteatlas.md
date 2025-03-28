
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
(method) SpriteAtlas:__new(imagePath: string, spriteData: table, names: string[])
```

 The constructor for the SpriteAtlas class

@*param* `imagePath` — The path to the texture atlas image

@*param* `spriteData` — A table containing sprite names and their respective quads

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

### drawByIndex


```lua
(method) SpriteAtlas:drawByIndex(index: number, x: number, y: number)
```

 Draws a sprite by index at the given position

@*param* `index` — The index of the sprite

@*param* `x` — The x coordinate to draw the sprite

@*param* `y` — The y coordinate to draw the sprite

### drawByName


```lua
(method) SpriteAtlas:drawByName(name: string, x: number, y: number)
```

 Draws a sprite by name at the given position

@*param* `name` — The name of the sprite

@*param* `x` — The x coordinate to draw the sprite

@*param* `y` — The y coordinate to draw the sprite

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### fromAtlased


```lua
function SpriteAtlas.fromAtlased(imagePath: string, jsonPath: string)
  -> The: SpriteAtlas
```

 Creates a SpriteAtlas from an Atlased JSON and PNG file

@*param* `imagePath` — The path to the texture atlas image

@*param* `jsonPath` — The path to the Atlased JSON file

@*return* `The` — created SpriteAtlas instance

### fromGrid


```lua
function SpriteAtlas.fromGrid(imagePath: string, cellWidth: number, cellHeight: number, names?: table)
  -> The: SpriteAtlas
```

 Creates a SpriteAtlas from a grid of cells

@*param* `imagePath` — The path to the texture atlas image

@*param* `cellWidth` — The width of each cell in the grid

@*param* `cellHeight` — The height of each cell in the grid

@*param* `names` — The names of the sprites, mapping left to right, top to bottom. If not supplied the quads will be sorted by index not name.

@*return* `The` — created SpriteAtlas instance

### getQuadByIndex


```lua
(method) SpriteAtlas:getQuadByIndex(index: number)
  -> quad: any
```

 Gets a quad by index

@*param* `index` — The index of the sprite

@*return* `quad` — The love quad associated with the sprite index

### getQuadByName


```lua
(method) SpriteAtlas:getQuadByName(name: string)
  -> quad: any
```

 Gets a quad by name

@*param* `name` — The name of the sprite

@*return* `quad` — The love quad associated with the sprite name

### image


```lua
any
```

The texture atlas love image

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

### quadsByIndex


```lua
table<number, any>
```

A table of quads indexed by sprite indices

### quadsByName


```lua
table<string, any>
```

A table of quads indexed by sprite names

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


---

