---@class GameState : prism.Object
---@field manager GameStateManager
local GameState = prism.Object:extend("GameState")

--- Called when the gamestate is started.
function GameState:load()
   -- implement your own load logic here
end

--- Calls when the gamestate is stopped.
function GameState:unload()
   -- implement your own unload logic here
end

--- Called on each update.
function GameState:update(dt)
   -- implement your own update logic here
end

--- Called on each draw.
function GameState:draw()
   -- implement your own draw logic here
end

--- Called on each keypress.
function GameState:keypressed(key, scancode)
   -- handle keypresses here
end

function GameState:mousepressed( x, y, button, istouch, presses )
   -- handle mousepress here
end

--- Called when the mouse wheel is moved.
function GameState:wheelmoved(dx, dy)
   -- handle mouse wheel movement here
end

function GameState:getManager() return self.manager end

return GameState
