
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
(method) PasteModification:__new(cells: SparseGrid, actors: SparseMap, topLeft: Vector2)
```

### _serializationBlacklist


```lua
table
```

### actors


```lua
SparseMap
```

 A sparse grid of buckets that objects can be placed into. Used for
 tracking actors by x,y position in Level.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### cells


```lua
SparseGrid
```

 A sparse grid class that stores data using hashed coordinates. Similar to a SparseMap
 except here there is only one entry per grid coordinate. This is suitable for stuff like Cells.

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

### execute


```lua
(method) PasteModification:execute(attachable: SpectrumAttachable, editor: Editor)
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

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### placeActor


```lua
(method) Modification:placeActor(attachable: SpectrumAttachable, x: integer, y: integer, actorPrototype: Actor)
```

### placeCell


```lua
(method) Modification:placeCell(attachable: SpectrumAttachable, x: integer, y: integer, cellPrototype: Cell|nil)
```

### placed


```lua
table
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

### removeActor


```lua
(method) Modification:removeActor(level: any, actor: any)
```

### removed


```lua
table
```

### replaced


```lua
SparseGrid
```

 A sparse grid class that stores data using hashed coordinates. Similar to a SparseMap
 except here there is only one entry per grid coordinate. This is suitable for stuff like Cells.

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

### topLeft


```lua
Vector2
```

### undo


```lua
(method) Modification:undo(attachable: SpectrumAttachable)
```

Undoes the modification.
Override this method in subclasses to define how the modification is undone.


---

