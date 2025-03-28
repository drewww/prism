
### __getInternal


```lua
(method) Inky.Element:__getInternal()
  -> Inky.Element.Internal
```

Get the internal representation of the Element

For internal use\
Don't touch unless you know what you're doing

### _internal


```lua
Inky.Element.Internal
```


### constructor


```lua
(method) Inky.Element:constructor(scene: any, initializer: fun(self: Inky.Element, scene: Inky.Scene):fun(self: Inky.Element, x: number, y: number, w: number, h: number, depth?: number))
```

### getView


```lua
(method) Inky.Element:getView()
  -> x: number
  2. y: number
  3. w: number
  4. h: number
```

Return the x, y, w, h that the Element was last rendered at

### on


```lua
(method) Inky.Element:on(eventName: string, callback: fun(element: Inky.Element, ...any):nil)
  -> Inky.Element
```

Execute callback when Scene event is raised from the parent Scene
\

See: [Inky.Scene.raise](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/scene/init.lua#59#9)

### onDisable


```lua
(method) Inky.Element:onDisable(callback?: fun(element: Inky.Element):nil)
  -> Inky.Element
```

Execute callback when an Element isn't rendered, when it was rendered last frame

### onEnable


```lua
(method) Inky.Element:onEnable(callback?: fun(element: Inky.Element):nil)
  -> Inky.Element
```

Execute callback when an Element is rendered, when it wasn't rendered last frame

### onPointer


```lua
(method) Inky.Element:onPointer(eventName: string, callback: fun(element: Inky.Element, pointer: Inky.Pointer, ...any):nil)
  -> Inky.Element
```

Execute callback when a Pointer event is raised from an overlapping/capturing Pointer
\

See:
  * [Inky.Pointer.raise](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/pointer/init.lua#115#9)
  * [Inky.Pointer.captureElement](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/pointer/init.lua#127#9)

### onPointerEnter


```lua
(method) Inky.Element:onPointerEnter(callback: fun(element: Inky.Element, pointer: Inky.Pointer):nil)
  -> Inky.Element
```

Execute callback when a Pointer enters the bounding box of the Element

### onPointerExit


```lua
(method) Inky.Element:onPointerExit(callback: fun(element: Inky.Element, pointer: Inky.Pointer):nil)
  -> Inky.Element
```

Execute callback when a Pointer exits the bounding box of the Element

### onPointerInHierarchy


```lua
(method) Inky.Element:onPointerInHierarchy(eventName: string, callback: fun(element: Inky.Element, pointer: Inky.Pointer, ...any):nil)
  -> Inky.Element
```

Execute callback when a Pointer event was accepted by a child Element
\

See:
  * [Inky.Pointer.raise](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/pointer/init.lua#115#9)
  * [Inky.Element.onPointer](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/element/init.lua#71#9)

### props


```lua
EditorGridProps
```

### render


```lua
(method) Inky.Element:render(x: number, y: number, w: number, h: number, depth?: number)
  -> Inky.Element
```

Render the Element, setting up all the hooks and drawing the Element

Note: The parent Scene's frame must have been begun to be able to render\


See: [Inky.Scene.beginFrame](file:///home/bleezus/Documents/GitHub/prism2/geometer/inky/core/scene/init.lua#30#9)

### useEffect


```lua
(method) Inky.Element:useEffect(effect: fun(element: Inky.Element):nil, ...any)
  -> Inky.Element
```

Execute a side effect when any specified Element's prop changes

Note: The effect is ran right before a render

### useOverlapCheck


```lua
(method) Inky.Element:useOverlapCheck(predicate: fun(pointerX: number, pointerY: number, x: number, y: number, w: number, h: number):boolean)
  -> Inky.Element
```

Use an additional check to determine if a Pointer is overlapping an Element

Note: Check is performed after a bounding box check


---

