
### BLACK


```lua
Color4
```

 Predefined colors

### BLUE


```lua
Color4
```

### GREEN


```lua
Color4
```

### RED


```lua
Color4
```

### TRANSPARENT


```lua
Color4
```

### WHITE


```lua
Color4
```

### __add


```lua
function Color4.__add(a: Color4, b: Color4)
  -> The: Color4
```

 Adds two colors together.

@*param* `a` — The first color.

@*param* `b` — The second color.

@*return* `The` — sum of the two colors.

### __call


```lua
function
```

### __eq


```lua
function Color4.__eq(a: Color4, b: Color4)
  -> True: boolean
```

 Checks equality between two colors.

@*param* `a` — The first color.

@*param* `b` — The second color.

@*return* `True` — if the colors are equal, false otherwise.

### __index


```lua
Object
```

 A simple class system for Lua. This is the base class for all other classes in PRISM.

### __mul


```lua
function Color4.__mul(self: Color4, scalar: number)
  -> The: Color4
```

 Multiplies the color's components by a scalar.

@*param* `scalar` — The scalar value.

@*return* `The` — scaled color.

### __new


```lua
(method) Color4:__new(r: number, g: number, b: number, a: number)
```

 Constructor for Color4 accepts red, green, blue, and alpha values.

@*param* `r` — The red component (0-1).

@*param* `g` — The green component (0-1).

@*param* `b` — The blue component (0-1).

@*param* `a` — The alpha component (0-1).

### __sub


```lua
function Color4.__sub(a: Color4, b: Color4)
  -> The: Color4
```

 Subtracts one color from another.

@*param* `a` — The first color.

@*param* `b` — The second color.

@*return* `The` — difference of the two colors.

### __tostring


```lua
(method) Color4:__tostring()
  -> The: string
```

 Creates a string representation of the color.

@*return* `The` — string representation.

### __unm


```lua
function Color4.__unm(self: Color4)
  -> The: Color4
```

 Negates the color's components.

@*return* `The` — negated color.

### _serializationBlacklist


```lua
table
```

### a


```lua
number
```

The alpha component (0-1).

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### b


```lua
number
```

The blue component (0-1).

### clamp


```lua
(method) Color4:clamp()
  -> The: Color4
```

 Clamps the components of the color between 0 and 1.

@*return* `The` — clamped color.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### copy


```lua
(method) Color4:copy()
  -> A: Color4
```

 Returns a copy of the color.

@*return* `A` — copy of the color.

### decompose


```lua
(method) Color4:decompose()
  -> r: number
  2. g: number
  3. b: number
  4. a: number
```

 Returns the components of the color as numbers.

@*return* `r,g,b,a` — The components of the color.

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

### fromHex


```lua
function Color4.fromHex(hex: number)
```

 Constructor for Color4 that accepts a hexadecimal number.

@*param* `hex` — A hex number representing a color, e.g. 0xFFFFFF. Alpha is optional and defaults to 1.

### g


```lua
number
```

The green component (0-1).

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

### lerp


```lua
(method) Color4:lerp(target: Color4, t: number)
  -> The: Color4
```

 Linearly interpolates between two colors.

@*param* `target` — The target color.

@*param* `t` — A value between 0 and 1, where 0 is this color and 1 is the target color.

@*return* `The` — interpolated color.

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

### r


```lua
number
```

The red component (0-1).

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

