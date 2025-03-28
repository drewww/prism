
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
(method) LevelState:__new(level: Level, display: Display, actionHandlers: table<fun():fun()>)
```

 Constructs a new LevelState.
 Sets up the game loop, initializes decision handlers, and binds custom callbacks for drawing.

@*param* `level` — The level object to be managed by this state.

@*param* `display` — The display object for rendering the level.

@*param* `actionHandlers` — A table of callback generators for handling actions.

### _serializationBlacklist


```lua
table
```

### actionHandlers


```lua
table<fun():fun()>
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

### decision


```lua
Decision
```

The current decision being processed, if any.

### deserialize


```lua
function Object.deserialize(data: any)
  -> unknown
```

### display


```lua
Display
```

The display object used for rendering.

### draw


```lua
(method) LevelState:draw()
```

 Draws the current state of the level, including the perspective of relevant actors.

### drawBeforeCells


```lua
(method) LevelState:drawBeforeCells(display: Display)
```

 Draws content before rendering cells. Override in subclasses for custom behavior.

@*param* `display` — The display object used for drawing.

### extend


```lua
(method) Object:extend(className: string, ignoreclassName?: boolean)
  -> prototype: <T>
```

 Creates a new class and sets its metatable to the extended class.

@*param* `className` — name for the class

@*param* `ignoreclassName` — if true, skips the uniqueness check in prism's registry

@*return* `prototype` — The new class prototype extended from this one.

### geometer


```lua
EditorState
```

An editor state for debugging or managing geometry.

### getManager


```lua
(method) GameState:getManager()
  -> GameStateManager
```

### handleActionMessage


```lua
(method) LevelState:handleActionMessage(message: ActionMessage)
```

 Handles an action message by determining visibility and setting display overrides.

@*param* `message` — The action message to handle.

### handleMessage


```lua
(method) LevelState:handleMessage(message: any)
```

 Handles incoming messages from the coroutine.
 Processes decisions, action messages, and debug messages as appropriate.

@*param* `message` — The message to handle.

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

### keypressed


```lua
(method) GameState:keypressed(key: any, scancode: any)
```

 Called on each keypress.

### level


```lua
Level
```

The level object representing the game environment.

### load


```lua
(method) GameState:load()
```

 Called when the gamestate is started.

### manager


```lua
GameStateManager
```

### message


```lua
ActionMessage
```

The most recent action message.

### mixin


```lua
(method) Object:mixin(mixin: table)
  -> Object
```

 Mixes in methods and properties from another table, excluding blacklisted metamethods.
 THis does not deep copy or merge tables, currently. It's a shallow mixin.

@*param* `mixin` — The table containing methods and properties to mix in.

### mousepressed


```lua
(method) GameState:mousepressed(x: any, y: any, button: any, istouch: any, presses: any)
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

### serializationBlacklist


```lua
table<string, boolean>
```

### serialize


```lua
function Object.serialize(object: any)
  -> table
```

### shouldAdvance


```lua
(method) LevelState:shouldAdvance()
  -> shouldAdvance: boolean|nil
```

 Determines if the coroutine should proceed to the next step.

@*return* `shouldAdvance` — True if the coroutine should advance; false otherwise.

### stripName


```lua
boolean
```

### time


```lua
integer
```

### unload


```lua
(method) GameState:unload()
```

 Calls when the gamestate is stopped.

### update


```lua
(method) LevelState:update(dt: number)
```

 Updates the state of the level.
 Advances the coroutine and processes decisions or messages if necessary.

@*param* `dt` — The time delta since the last update.

### updateCoroutine


```lua
thread
```

### updateDecision


```lua
(method) LevelState:updateDecision(dt: number, actor: Actor, decision: ActionDecision)
```

 This method is invoked each update when a decision exists 
 and its response is not yet valid.. Override this method in subclasses to implement 
 custom decision-handling logic. 

@*param* `dt` — The time delta since the last update.

@*param* `actor` — The actor responsible for making the decision.

@*param* `decision` — The decision being updated.

### wheelmoved


```lua
(method) GameState:wheelmoved(dx: any, dy: any)
```

 Called when the mouse wheel is moved.


---

