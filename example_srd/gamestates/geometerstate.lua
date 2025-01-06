local GeometerState = GameState:extend "GeometerState"

--- Create a new Geometer managing gamestate, attached to a
--- GeometerAttachable, this is a Level|MapBuilder interface.
--- @param attachable GeometerAttachable
function GeometerState:__new(attachable)
   self.geometer = geometer.Geometer(attachable)
end

function GeometerState.load()
   self.geometer:startEditing()
end

function GeometerState.update()
   
end