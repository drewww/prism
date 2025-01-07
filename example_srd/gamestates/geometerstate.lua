local GameState = require "example_srd.gamestates.gamestate"

--- @class GeometerState : GameState
--- @field geometer Geometer
local GeometerState = GameState:extend "GeometerState"

--- Create a new Geometer managing gamestate, attached to a
--- GeometerAttachable, this is a Level|MapBuilder interface.
--- @param attachable GeometerAttachable
function GeometerState:__new(attachable, display)
   self.geometer = geometer.Geometer(attachable, display)
end

function GeometerState:load()
   self.geometer:startEditing()
end

function GeometerState:update(dt)
   if not self.geometer.active then
      print "YA"
      self.manager:pop()
   end

   self.geometer:update(dt)
end

function GeometerState:draw()
   self.geometer:draw()
end

function GeometerState:mousemoved(x, y, dx, dy, istouch)
   self.geometer:mousemoved(x, y, dx, dy, istouch)
end

function GeometerState:wheelmoved(dx, dy)
   self.geometer:wheelmoved(dx, dy)
end

function GeometerState:mousepressed(x, y, button)
   self.geometer:mousepressed(x, y, button)
end

function GeometerState:mousereleased(x, y, button)
   self.geometer:mousereleased(x, y, button)
end

function GeometerState:keypressed(key, scancode)
   self.geometer:keypressed(key, scancode)
end

return GeometerState