
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
(method) SparseArray:__new()
```

 Constructor for SparseArray.

### _serializationBlacklist


```lua
table
```

### add


```lua
(method) SparseArray:add(item: any)
  -> index: number
```

 Adds an item to the sparse array.

@*param* `item` — The item to add.

@*return* `index` — The index where the item was added.

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### bake


```lua
(method) SparseArray:bake()
  -> The: table
```

 Bakes the sparse array into a dense array.
 This removes all nil values and reassigns indices.

@*return* `The` — new dense array.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### clear


```lua
(method) SparseArray:clear()
```

 Clears the sparse array.

### data


```lua
table
```

 Holds the actual values

### debugPrint


```lua
(method) SparseArray:debugPrint()
```

 Prints the sparse array for debugging purposes.

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

### freeIndices


```lua
table
```

 Tracks free indices

### get


```lua
(method) SparseArray:get(index: number)
  -> The: any
```

 Gets an item from the sparse array.

@*param* `index` — The index of the item.

@*return* `The` — item at the specified index, or nil if none exists.

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

### remove


```lua
(method) SparseArray:remove(index: number)
```

 Removes an item from the sparse array.

@*param* `index` — The index to remove the item from.

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

