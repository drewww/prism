
### __addComponent


```lua
(method) Actor:__addComponent(component: Component)
```

 Adds a component to the actor. This function will check if the component's
 prerequisites are met and will throw an error if they are not.

@*param* `component` — The component to add to the actor.

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
(method) Actor:__new()
```

 Constructor for an actor.
 Initializes and copies the actor's fields from its prototype.

### __removeComponent


```lua
(method) Actor:__removeComponent(component: Component)
  -> unknown
```

 Removes a component from the actor. This function will throw an error if the
 component is not present on the actor.

@*param* `component` — The component to remove from the actor.

### _serializationBlacklist


```lua
table
```

### adopt


```lua
(method) Object:adopt(o: any)
  -> unknown
```

### char


```lua
string
```

The character to draw for this actor.

### className


```lua
string
```

A unique name for this class. By convention this should match the annotation name you use.

### componentCache


```lua
table
```

This is a cache for component queries, reducing most queries to a hashmap lookup.

### components


```lua
Component[]
```

A table containing all of the actor's component instances. Generated at runtime.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### expectComponent


```lua
(method) Actor:expectComponent(prototype: <T>)
  -> <T>
```

 Expects a component, returning it or erroring on nil.

@*param* `prototype` — The type of the component to return.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getActions


```lua
(method) Actor:getActions()
  -> totalActions: Action[]
```

 Get a list of actions that the actor can perform.

@*return* `totalActions` — Returns a table of all actions.

### getComponent


```lua
(method) Actor:getComponent(prototype: <T>)
  -> <T>?
```

 Searches for a component that inherits from the supplied prototype

@*param* `prototype` — The type of the component to return.

### getPosition


```lua
(method) Actor:getPosition()
  -> position: Vector2
```

 Returns the current position of the actor.

@*return* `position` — Returns a copy of the actor's current position.

### getRange


```lua
(method) Actor:getRange(type: "4way"|"8way"|"chebyshev"|"euclidean"|"manhattan", actor: Actor)
  -> Returns: number
```

 Get the range from this actor to another actor.

@*param* `actor` — The other actor to get the range to.

@*return* `Returns` — the calculated range.

```lua
type:
    | "euclidean"
    | "chebyshev"
    | "manhattan"
    | "4way"
    | "8way"
```

### getRangeVec


```lua
(method) Actor:getRangeVec(type: any, vector: any)
  -> number
```

 Get the range from this actor to a given vector.
 @function Actor:getRangeVec
 @tparam string type The type of range calculation to use.
 @tparam Vector2 vector The vector to get the range to.
 @treturn number Returns the calculated range.

### hasComponent


```lua
(method) Actor:hasComponent(prototype: Component)
  -> hasComponent: boolean
```

 Returns a bool indicating whether the actor has a component of the given type.

@*param* `prototype` — The prototype of the component to check for.

### initialize


```lua
(method) Actor:initialize()
  -> Component[]
```

 Creates the components for the actor. Override this.

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

The string name of the actor, used for display to the user.

### position


```lua
Vector2
```

An actor's position in the game world.

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

### stripName


```lua
boolean
```


---

