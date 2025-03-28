
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
(method) Queue:__new()
```

 Initializes a new Queue instance.

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

### clear


```lua
(method) Queue:clear()
```

 Removes all elements from the queue.

### contains


```lua
(method) Queue:contains(value: any)
  -> True: boolean
```

 Checks if the queue contains a specific value.

@*param* `value` — The value to check for.

@*return* `True` — if the value is in the queue, false otherwise.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### empty


```lua
(method) Queue:empty()
  -> True: boolean
```

 Checks if the queue is empty.

@*return* `True` — if the queue is empty, false otherwise.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### first


```lua
integer
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

### last


```lua
integer
```

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### peek


```lua
(method) Queue:peek()
  -> The: any
```

 Returns the element at the start of the queue without removing it.

@*return* `The` — value at the start of the queue.

### pop


```lua
(method) Queue:pop()
  -> The: any
```

 Removes and returns the element from the start of the queue.

@*return* `The` — value at the start of the queue.

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
(method) Queue:push(value: any)
```

 Adds an element to the end of the queue.

@*param* `value` — The value to be added to the queue.

### queue


```lua
table
```

### remove


```lua
(method) Queue:remove(value: any)
  -> True: boolean
```

 Removes the first occurrence of the specified value from the queue.

@*param* `value` — The value to be removed from the queue.

@*return* `True` — if the value was removed, false otherwise.

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### size


```lua
(method) Queue:size()
  -> The: number
```

 Returns the number of elements in the queue.

@*return* `The` — size of the queue.

### stripName


```lua
boolean
```


---

