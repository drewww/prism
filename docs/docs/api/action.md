
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
(method) Action:__new(owner: Actor, targets?: [Object], source?: Actor)
```

 Constructor for the Action class.

@*param* `owner` — The actor that is performing the action.

@*param* `targets` — An optional list of target actors. Not all actions require targets.

@*param* `source` — An optional actor indicating the source of that action, for stuff like a wand or scroll.

### _canPerform


```lua
(method) Action:_canPerform(level: Level, ...any)
  -> canPerform: boolean
```

 This method should be overriden by subclasses. This is called to make
 sure an action is valid for the actor. This would be useful for

### _perform


```lua
(method) Action:_perform(level: Level, ...any)
```

 Performs the action. This should be overriden on all subclasses

@*param* `level` — The level the action is being performed in.

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### canPerform


```lua
(method) Action:canPerform(level: Level)
  -> canPerform: boolean
```

 Call this function to check if the action is valid and can be executed in
 the given level. This calls the inner overrideable _canPerform, and
 unpacks the target objects.

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

### getNumTargets


```lua
(method) Action:getNumTargets()
  -> numTargets: number
```

 Returns the number of targets associated with this action.

@*return* `numTargets` — The number of targets associated with this action.

### getTarget


```lua
(method) Action:getTarget(n: number)
  -> target: any
```

 Returns the target actor at the specified index.

@*param* `n` — The index of the target actor to retrieve.

@*return* `target` — The target actor at the specified index.

### getTargetObject


```lua
(method) Action:getTargetObject(index: any)
  -> targetObject: Target|nil
```

 Returns the target object at the specified index.
 @tparam number index The index of the target object to retrieve.

### hasRequisiteComponents


```lua
(method) Action:hasRequisiteComponents(actor: Actor)
  -> hasRequisiteComponents: boolean
```

### hasTarget


```lua
(method) Action:hasTarget(actor: any)
  -> boolean
```

 Determines if the specified actor is a target of this action.
 @tparam Actor actor The actor to check if they are a target of this action.
 @treturn boolean true if the specified actor is a target of this action, false otherwise.

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

### name


```lua
string
```

### owner


```lua
Actor
```

The actor taking the action.

### perform


```lua
(method) Action:perform(level: any)
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

### requiredComponents


```lua
Component[]
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

### silent


```lua
boolean
```

A silent action doesn't generate messages

### source


```lua
Actor?
```

An object granting the owner of the action this action. A wand's zap action is a good example.

### stripName


```lua
boolean
```

### targetObjects


```lua
[Object]
```

### targets


```lua
[Target]
```

### time


```lua
number
```

The time it takes to perform this action. Lower is better.

### validateTarget


```lua
(method) Action:validateTarget(n: number, owner: Actor, toValidate: Actor, targets: [any])
  -> true: boolean
```

 _validates the specified target for this action.

@*param* `n` — The index of the target object to _validate.

@*param* `owner` — The actor that is performing the action.

@*param* `toValidate` — The target actor to _validate.

@*param* `targets` — The previously selected targets.

@*return* `true` — if the specified target actor is valid for this action, false otherwise.


---

