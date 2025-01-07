local GeometerState = require "example_srd.gamestates.geometerstate"

local PrefabEditorState = GeometerState:extend "PrefabEditorState"

function PrefabEditorState:__new()
   local attachable = prism.MapBuilder()
   local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
   local display = spectrum.Display(spriteAtlas, prism.Vector2(16, 16), attachable)
   
   GeometerState.__new(self, attachable, display)
end

function PrefabEditorState:update(dt)
   self.geometer.active = true
   self.geometer:update(dt)
end

return PrefabEditorState