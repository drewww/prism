
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
(method) ActorStorage:__new(insertSparseMapCallback: any, removeSparseMapCallback: any)
```

 The constructor for the 'ActorStorage' class.
 Initializes the list, spatial map, and component cache.

### _serializationBlacklist


```lua
table
```

### actorToID


```lua
table<Actor, integer?>
```

A hashmap of actors to ids.

### actors


```lua
Actor[]
```

The list of actors in the storage.

### addActor


```lua
(method) ActorStorage:addActor(actor: Actor)
```

 Adds an actor to the storage, updating the spatial map and component cache.

@*param* `actor` — The actor to add.

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

### componentCache


```lua
table
```

The cache for storing actor components.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### eachActor


```lua
(method) ActorStorage:eachActor(...Component?)
  -> iter: function
```

 Returns an iterator over the actors in the storage. If a component is specified, only actors with that
 component will be returned.

@*param* `...` — The components to filter by.

@*return* `iter` — An iterator over the actors in the storage.

### eachActorAt


```lua
(method) ActorStorage:eachActorAt(x: number, y: number)
  -> iterator: function
```

 Returns an iterator over the actors in the storage at the given position.

@*param* `x` — The x-coordinate to check.

@*param* `y` — The y-coordinate to check.

@*return* `iterator` — An iterator over the actors at the given position.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### getActorByType


```lua
(method) ActorStorage:getActorByType(prototype: Actor)
  -> The: Actor|nil
```

 Returns an iterator over the actors in the storage that have the specified prototype.

@*param* `prototype` — The prototype to filter by.

@*return* `The` — first actor that matches the prototype, or nil if no actor matches.

### getActorsAt


```lua
(method) ActorStorage:getActorsAt(x: number, y: number)
  -> actors: Actor[]
```

 Returns a table of actors in the storage at the given position.
 TODO: Return an ActorStorage object instead of a table.

@*param* `x` — The x-coordinate to check.

@*param* `y` — The y-coordinate to check.

@*return* `actors` — A table of actors at the given position.

### getID


```lua
(method) ActorStorage:getID(actor: Actor)
  -> The: integer?
```

 Retrieves the unique ID associated with the specified actor.
 Note: IDs are unique to actors within the ActorStorage but may be reused 
 when indices are freed.

@*param* `actor` — The actor whose ID is to be retrieved.

@*return* `The` — unique ID of the actor, or nil if the actor is not found.

### hasActor


```lua
(method) ActorStorage:hasActor(actor: Actor)
  -> True: boolean
```

 Returns whether the storage contains the specified actor.

@*param* `actor` — The actor to check.

@*return* `True` — if the storage contains the actor, false otherwise.

### ids


```lua
SparseArray
```

A sparse array of references to the Actors in the storage. The ID is derived from this.

### insertSparseMapCallback


```lua
function
```

### insertSparseMapEntries


```lua
(method) ActorStorage:insertSparseMapEntries(actor: Actor)
```

 Inserts the specified actor into the spatial map.

@*param* `actor` — The actor to insert.

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

### merge


```lua
(method) ActorStorage:merge(other: ActorStorage)
```

 Merges another ActorStorage instance with this one.

@*param* `other` — The other ActorStorage instance to merge with this one.

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### onDeserialize


```lua
(method) ActorStorage:onDeserialize()
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
(method) ActorStorage:removeActor(actor: Actor)
```

 Removes an actor from the storage, updating the spatial map and component cache.

@*param* `actor` — The actor to remove.

### removeComponentCache


```lua
(method) ActorStorage:removeComponentCache(actor: Actor)
```

 Removes the specified actor from the component cache.

@*param* `actor` — The actor to remove from the component cache.

### removeSparseMapCallback


```lua
function
```

### removeSparseMapEntries


```lua
(method) ActorStorage:removeSparseMapEntries(actor: Actor)
```

 Removes the specified actor from the spatial map.

@*param* `actor` — The actor to remove.

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### setCallbacks


```lua
(method) ActorStorage:setCallbacks(insertCallback: any, removeCallback: any)
```

### sparseMap


```lua
SparseMap
```

The spatial map for storing actor positions.

### stripName


```lua
boolean
```

### updateComponentCache


```lua
(method) ActorStorage:updateComponentCache(actor: Actor)
```

 Updates the component cache for the specified actor.

@*param* `actor` — The actor to update the component cache for.


---

