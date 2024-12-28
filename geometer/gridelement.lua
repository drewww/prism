local Inky = require("geometer.inky")

---@class EditorGridProps : Inky.Props
---@field offset Vector2
---@field map Map
---@field actors ActorStorage
---@field display Display
---@field scale Vector2

---@class EditorGrid : Inky.Element
---@field props EditorGridProps

---@param self EditorGrid
---@param scene Inky.Scene
---@return function
local function EditorGrid(self, scene)
   self.props.offset = prism.Vector2(0, 0)

   self:onPointer("drag", function(_, pointer, dx, dy)
      self.props.offset.x = self.props.offset.x + dx
      self.props.offset.y = self.props.offset.y + dy
   end)

   self:onPointer("press", function(_, pointer)
      local x, y = pointer:getPosition()
   end)

   return function(_, x, y, w, h)
      if not self.props.map then
         return
      end

      local map = self.props.map
      local display = self.props.display
      local cX, cY = display.cellSize:decompose()
      local offsetX = self.props.offset.x / self.props.scale.x
      local offsetY = self.props.offset.y / self.props.scale.y

      for mapX = 1, map.w do
         for mapY = 1, map.h do
            local cell = map:getCell(mapX, mapY)
            local spriteQuad = display.spriteAtlas:getQuadByIndex(string.byte(cell.char) + 1)
            local finalX = x + offsetX + mapX * cX
            local finalY = y + offsetY + mapY * cY
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", finalX, finalY, cX, cY)
            if spriteQuad then
               love.graphics.setColor(1, 1, 1, 1)
               love.graphics.draw(display.spriteAtlas.image, spriteQuad, finalX, finalY)
            end
         end
      end

      for actor in self.props.actors:eachActor() do
         local spriteQuad = display:getQuad(actor)
         love.graphics.draw(
            display.spriteAtlas.image,
            spriteQuad,
            x + offsetX + actor.position.x * cX,
            y + offsetY + actor.position.y * cY
         )
      end
   end
end

return Inky.defineElement(EditorGrid)
