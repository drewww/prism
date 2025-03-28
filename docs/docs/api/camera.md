
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
(method) Camera:__new(x: any, y: any)
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

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getPosition


```lua
(method) Camera:getPosition()
  -> x: number
  2. y: number
```

@*return* `x` — The x position.

@*return* `y` — The y position.

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

### move


```lua
(method) Camera:move(dx: number, dy: number)
```

### pop


```lua
(method) Camera:pop()
```

 Pops the camera's transform. Call this after drawing.

### position


```lua
Vector2
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

### push


```lua
(method) Camera:push()
```

 Pushes the camera's transform. Call this before drawing.

### rotation


```lua
number
```

### scale


```lua
Vector2
```

### scaleAroundPoint


```lua
(method) Camera:scaleAroundPoint(factorX: number, factorY: number, pointX: number, pointY: number)
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

### setPosition


```lua
(method) Camera:setPosition(x: number, y: number)
```

### setRotation


```lua
(method) Camera:setRotation(rotation: number)
```

### setScale


```lua
(method) Camera:setScale(scaleX: number, scaleY: number)
```

### stripName


```lua
boolean
```

### toWorldSpace


```lua
(method) Camera:toWorldSpace(x: number, y: number)
  -> number
  2. number
```


---

