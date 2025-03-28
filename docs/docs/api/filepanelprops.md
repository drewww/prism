
### _internal


```lua
Inky.Props.Internal
```


### editor


```lua
Editor
```

### name


```lua
string
```

### open


```lua
boolean
```

### overlay


```lua
love.Canvas
```


A Canvas is used for off-screen rendering. Think of it as an invisible screen that you can draw to, but that will not be visible until you draw it to the actual visible screen. It is also known as "render to texture".

By drawing things that do not change position often (such as background items) to the Canvas, and then drawing the entire Canvas instead of each item,  you can reduce the number of draw operations performed each frame.

In versions prior to love.graphics.isSupported("canvas") could be used to check for support at runtime.


[Open in Browser](https://love2d.org/wiki/love.graphics)


### scale


```lua
Vector2
```


---

