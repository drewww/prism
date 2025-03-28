
### _internal


```lua
Inky.Props.Internal
```


### display


```lua
Display
```

### editor


```lua
Editor
```

### filtered


```lua
number[]
```

### overlay


```lua
love.Canvas
```


A Canvas is used for off-screen rendering. Think of it as an invisible screen that you can draw to, but that will not be visible until you draw it to the actual visible screen. It is also known as "render to texture".

By drawing things that do not change position often (such as background items) to the Canvas, and then drawing the entire Canvas instead of each item,  you can reduce the number of draw operations performed each frame.

In versions prior to love.graphics.isSupported("canvas") could be used to check for support at runtime.


[Open in Browser](https://love2d.org/wiki/love.graphics)


### placeables


```lua
Actor|Cell[]
```

### selected


```lua
Actor|Cell
```

 An 'Actor' represents entities in the game, including the player, enemies, and items.
 Actors are composed of Components that define their state and behavior.
 For example, an actor may have a Sight component that determines their field of vision, explored tiles,
 and other related aspects.

### selectedText


```lua
love.Text
```


Drawable text.


[Open in Browser](https://love2d.org/wiki/love.graphics)


### size


```lua
Vector2
```


---

