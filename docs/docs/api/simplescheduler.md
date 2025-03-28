
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
(method) SimpleScheduler:__new()
```

 Constructor for the SimpleScheduler class.
 Initializes an empty queue and sets the round count to 0.

### _serializationBlacklist


```lua
table
```

### add


```lua
(method) SimpleScheduler:add(actor: string|Actor)
```

 Adds an actor to the scheduler.

@*param* `actor` — The actor, or special tick, to add.

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

### currentQueue


```lua
Queue
```

 A basic FIFO (First In, First Out) queue implementation.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### empty


```lua
(method) SimpleScheduler:empty()
  -> boolean
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

### has


```lua
(method) SimpleScheduler:has(actor: Actor)
  -> True: boolean
```

 Checks if an actor is in the scheduler.

@*param* `actor` — The actor to check.

@*return* `True` — if the actor is in the scheduler, false otherwise.

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

### next


```lua
(method) SimpleScheduler:next()
  -> The: Actor
```

 Returns the next actor to act.
 Moves the actor to the next queue and returns the actor.
 If the current queue is empty, it swaps the current and next queues and increments the round count.

@*return* `The` — actor who is next to act.

### nextQueue


```lua
Queue
```

 A basic FIFO (First In, First Out) queue implementation.

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
(method) SimpleScheduler:remove(actor: Actor)
```

 Removes an actor from the scheduler.

@*param* `actor` — The actor to remove.

### roundCount


```lua
integer
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

### stripName


```lua
boolean
```

### swapQueues


```lua
(method) SimpleScheduler:swapQueues()
```

 Swaps the current and next queues.

### timestamp


```lua
(method) SimpleScheduler:timestamp()
  -> The: number
```

 Returns the current round count as a timestamp.

@*return* `The` — current round count.


---

