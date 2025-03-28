
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
(method) Display:__new(spriteAtlas: SpriteAtlas, cellSize: Vector2, attachable: SpectrumAttachable)
```

 Initializes a new Display instance.

@*param* `spriteAtlas` — The sprite atlas for rendering.

@*param* `cellSize` — Size of each cell in pixels.

@*param* `attachable` — Object containing cells and actors to render.

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### afterDrawActors


```lua
(method) Display:afterDrawActors()
```

 Hook for custom behavior after drawing actors.

### attachable


```lua
SpectrumAttachable
```

The current level being displayed.

### beforeDrawActors


```lua
(method) Display:beforeDrawActors()
```

 Hook for custom behavior before drawing actors.

### beforeDrawCells


```lua
(method) Display:beforeDrawCells()
```

 Hook for custom behavior before drawing cells.

### buildSenseInfo


```lua
function Display.buildSenseInfo(primary: SensesComponent[], secondary: SensesComponent[])
  -> SparseGrid
  2. SparseGrid
  3. table
  4. table
  5. SparseGrid
```

@*param* `primary` — List of primary senses.

@*param* `secondary` — List of secondary senses.

### camera


```lua
Camera
```

The camera used to render the display.

### cellSize


```lua
Vector2
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
(method) Display:draw()
```

 Renders the display.

### drawActor


```lua
(method) Display:drawActor(actor: Actor, alpha?: number, color?: Color4, drawnSet?: table, x: any, y: any)
```

 Draws an actor.

@*param* `actor` — The actor to draw.

@*param* `alpha` — Optional alpha transparency.

@*param* `color` — Optional color tint.

@*param* `drawnSet` — Optional set to track drawn actors.

### drawDrawable


```lua
function Display.drawDrawable(drawable: DrawableComponent, spriteAtlas: SpriteAtlas, cellSize: Vector2, x: integer, y: integer, color?: Color4, alpha?: number)
```

 Draws a drawable object.

@*param* `drawable` — Drawable to render.

@*param* `spriteAtlas` — Sprite atlas to use.

@*param* `cellSize` — Size of each cell.

@*param* `x` — X-coordinate.

@*param* `y` — Y-coordinate.

@*param* `color` — Optional color tint.

@*param* `alpha` — Optional alpha transparency.

### drawPerspective


```lua
(method) Display:drawPerspective(primary: SensesComponent[], secondary: SensesComponent[])
```

 Draws the perspective of primary and secondary senses.

@*param* `primary` — List of primary senses.

@*param* `secondary` — List of secondary senses.

### dt


```lua
number
```

Delta time for updates.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getCellUnderMouse


```lua
(method) Display:getCellUnderMouse()
  -> integer
  2. The: integer
```

 Gets the cell under the mouse cursor.

@*return* `The` — X and Y coordinates of the cell.

### getQuad


```lua
function Display.getQuad(spriteAtlas: SpriteAtlas, drawable: DrawableComponent)
  -> The: love.Quad|nil
```

 Retrieves the quad for a drawable.

@*param* `spriteAtlas` — The sprite atlas.

@*param* `drawable` — The drawable component.

@*return* `The` — quad used for rendering.

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

### message


```lua
nil
```

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### override


```lua
fun(dt: integer, drawnSet: table<Actor, boolean>)|nil
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

### setOverride


```lua
(method) Display:setOverride(functionFactory: fun(display: Display, message: any):fun(dt: number):boolean, message: any)
```

 Sets an override rendering function.

@*param* `functionFactory` — A factory for override functions.

@*param* `message` — Optional message to pass to the function.

### spriteAtlas


```lua
SpriteAtlas
```

The sprite atlas used for rendering graphics.

### stripName


```lua
boolean
```

### update


```lua
(method) Display:update(dt: number)
```

 Updates the display state.

@*param* `dt` — Delta time for updates.


---

