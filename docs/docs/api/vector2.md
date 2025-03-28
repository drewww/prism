
### DOWN


```lua
Vector2
```

 The static DOWN vector.

### DOWN_LEFT


```lua
Vector2
```

 The static DOWN_LEFT vector.

### DOWN_RIGHT


```lua
Vector2
```

 The static DOWN_RIGHT vector.

### LEFT


```lua
Vector2
```

 The static LEFT vector.

### RIGHT


```lua
Vector2
```

 The static RIGHT vector.

### UP


```lua
Vector2
```

 The static UP vector.

### UP_LEFT


```lua
Vector2
```

 The static UP_LEFT vector.

### UP_RIGHT


```lua
Vector2
```

 The static UP_RIGHT vector.

### __add


```lua
function Vector2.__add(a: Vector2, b: Vector2)
  -> Vector2
```

 Adds two vectors together.

@*param* `a` — The first vector.

@*param* `b` — The second vector.

@*return* — The sum of the two vectors.

### __call


```lua
function
```

### __eq


```lua
function Vector2.__eq(a: Vector2, b: Vector2)
  -> boolean
```

 Checks the equality of two vectors.

@*param* `a` — The first vector.

@*param* `b` — The second vector.

@*return* — True if the vectors are equal, false otherwise.

### __index


```lua
Object
```

 A simple class system for Lua. This is the base class for all other classes in PRISM.

### __mul


```lua
function Vector2.__mul(a: Vector2, b: number)
  -> Vector2
```

 Multiplies a vector by a scalar.

@*param* `a` — The vector.

@*param* `b` — The scalar.

@*return* — The product of the vector and the scalar.

### __new


```lua
(method) Vector2:__new(x: number, y: number)
```

 Constructor for Vector2 accepts two numbers, x and y.

@*param* `x` — The x component of the vector.

@*param* `y` — The y component of the vector.

### __sub


```lua
function Vector2.__sub(a: Vector2, b: Vector2)
  -> Vector2
```

 Subtracts vector b from vector a.

@*param* `a` — The first vector.

@*param* `b` — The second vector.

@*return* — The difference of the two vectors.

### __tostring


```lua
(method) Vector2:__tostring()
  -> string
```

 Creates a string representation of the vector.

@*return* — The string representation of the vector.

### __unm


```lua
function Vector2.__unm(a: Vector2)
  -> Vector2
```

 Negates the vector.

@*param* `a` — The vector to negate.

@*return* — The negated vector.

### _hash


```lua
function Vector2._hash(x: integer, y: integer)
  -> integer
```

### _serializationBlacklist


```lua
table
```

### _unhash


```lua
function Vector2._unhash(hash: number)
  -> number
  2. integer
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

### copy


```lua
(method) Vector2:copy()
  -> Vector2
```

 Returns a copy of the vector.

@*return* — A copy of the vector.

### decompose


```lua
(method) Vector2:decompose()
  -> x: number
  2. y: number
```

@*return* `x` — The x component of the vector.

@*return* `y` — The y component of the vector.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### distance


```lua
(method) Vector2:distance(vec: Vector2)
  -> distance: number
```

 Euclidian distance from another point.

### distanceChebyshev


```lua
(method) Vector2:distanceChebyshev(vec: Vector2)
  -> distance: number
```

 Chebyshev distance from another point.

### distanceManhattan


```lua
(method) Vector2:distanceManhattan(vec: Vector2)
  -> distance: number
```

 Manhattan distance from another point.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getRange


```lua
(method) Vector2:getRange(type: "4way"|"8way"|"chebyshev"|"euclidean"|"manhattan", vec: Vector2)
  -> number
```

 Gets the range, a ciel'd integer representing the number of tiles away the other vector is

```lua
type:
    | "euclidean"
    | "chebyshev"
    | "manhattan"
    | "4way"
    | "8way"
```

### hash


```lua
(method) Vector2:hash()
  -> hash: number
```

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

### length


```lua
(method) Vector2:length()
  -> number
```

 Returns the length of the vector.

@*return* — The length of the vector.

### lerp


```lua
(method) Vector2:lerp(vec: Vector2, t: number)
  -> Vector2
```

 Linearly interpolates between two vectors.

@*param* `self` — The starting vector (A).

@*param* `vec` — The ending vector (B).

@*param* `t` — The interpolation factor (0 <= t <= 1).

@*return* — The interpolated vector.

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### neighborhood4


```lua
Vector2[]
```

### neighborhood8


```lua
Vector2[]
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

### rotateClockwise


```lua
(method) Vector2:rotateClockwise()
  -> The: Vector2
```

 Rotates the vector clockwise.

@*return* `The` — rotated vector.

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

### unhash


```lua
function Vector2.unhash(hash: any)
  -> Vector2
```

### x


```lua
number
```

The x component of the vector.

### y


```lua
number
```

The y component of the vector.


---

