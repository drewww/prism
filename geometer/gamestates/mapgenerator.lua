--- @class MapGeneratorState : GeometerState
local MapGeneratorState = geometer.EditorState:extend "MapGeneratorState"
geometer.MapGeneratorState = MapGeneratorState

---@param generator fun(mapbuilder: MapBuilder): fun()
function MapGeneratorState:__new(generator)
   local attachable = prism.MapBuilder()
   self.generator = coroutine.create(generator(attachable))

   local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
   local display = spectrum.Display(spriteAtlas, prism.Vector2(16, 16), attachable)
   
   geometer.EditorState.__new(self, attachable, display)
end

function MapGeneratorState:update(dt)
   if not self.geometer.active then
      coroutine.resume(self.generator)
      self.geometer.active = true
   end

   self.geometer:update(dt)
end

return MapGeneratorState