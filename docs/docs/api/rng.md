
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
(method) RNG:__new(seed: any)
```

 Initializes a new RNG instance.

@*param* `seed` — The seed for the RNG (optional).

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### carrier


```lua
integer
```

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### clone


```lua
(method) RNG:clone()
  -> The: RNG
```

 Clones the RNG.

@*return* `The` — cloned RNG.

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

### getNormal


```lua
(method) RNG:getNormal(mean: number, stddev: number)
  -> normal: number
```

 Gets a normally distributed random number with the given mean and standard deviation.

@*param* `mean` — The mean (optional, default is 0).

@*param* `stddev` — The standard deviation (optional, default is 1).

@*return* `normal` — A normally distributed random number.

### getPercentage


```lua
(method) RNG:getPercentage()
  -> percentage: number
```

 Gets a random percentage between 1 and 100.

@*return* `percentage` — A random percentage.

### getSeed


```lua
(method) RNG:getSeed()
  -> seed: any
```

 Gets the current seed.

@*return* `seed` — The current seed.

### getState


```lua
(method) RNG:getState()
  -> The: table
```

 Gets the current state of the RNG.

@*return* `The` — current state.

### getUniform


```lua
(method) RNG:getUniform()
  -> uniform: number
```

 Gets a uniform random number between 0 and 1.

@*return* `uniform` — A uniform random number.

### getUniformInt


```lua
(method) RNG:getUniformInt(lowerBound: number, upperBound: number)
  -> uniformInteger: number
```

 Gets a uniform random integer between lowerBound and upperBound.

@*param* `lowerBound` — The lower bound.

@*param* `upperBound` — The upper bound.

@*return* `uniformInteger` — A uniform random integer.

### getWeightedValue


```lua
(method) RNG:getWeightedValue(tbl: table<<K>, <V>>)
  -> value: <V>
```

 Gets a random value from a weighted table.

@*param* `tbl` — The weighted table.

@*return* `value` — The selected value.

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

### random


```lua
(method) RNG:random(a: number, b: number)
  -> A: number
```

 Gets a random number.

@*param* `a` — The lower threshold (optional).

@*param* `b` — The upper threshold (optional).

@*return* `A` — random number.

### randomseed


```lua
function
```

### seed


```lua
string
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

### setSeed


```lua
(method) RNG:setSeed(seed: string)
```

 Sets the seed for the RNG.

@*param* `seed` — The seed to set (optional).

### setState


```lua
(method) RNG:setState(stateTable: table)
```

 Sets the state of the RNG.

@*param* `stateTable` — The state to set.

### state0


```lua
integer
```

### state1


```lua
integer
```

### state2


```lua
integer
```

### stripName


```lua
boolean
```


---

