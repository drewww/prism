local Inky = require "geometer.inky"
local Display = require "spectrum.display"

---@class TileElementProps : Inky.Props
---@field placeable Placeable
---@field size Vector2 the final size of a tile in geometer
---@field display Display
---@field onSelect function

---@class TileElement : Inky.Element
---@field props TileElementProps

---@param self TileElement
---@param scene Inky.Scene
local function Tile(self, scene)
   local scale = prism.Vector2(
      self.props.size.x / self.props.display.cellSize.x,
      self.props.size.y / self.props.display.cellSize.y
   )

   self:onPointer("press", function()
      self.props.onSelect(self.props.placeable)
   end)

   self:onPointerEnter(function()
      love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
   end)

   self:onPointerExit(function()
      love.mouse.setCursor()
   end)

   return function(_, x, y, w, h)
      local drawable
      if self.props.placeable:is(prism.Actor) then
         local actor = self.props.placeable
         ---@cast actor Actor
         drawable = actor:getComponent(prism.components.Drawable)
      else
         drawable = self.props.placeable.drawable
      end

      local color = drawable.color or prism.Color4.WHITE
      local quad = Display.getQuad(self.props.display.spriteAtlas, drawable)

      love.graphics.push("all")
      love.graphics.setCanvas()
      love.graphics.translate((x / 8) * self.props.size.x, (y / 8) * self.props.size.y)
      love.graphics.scale(scale.x, scale.y)
      love.graphics.setColor(color:decompose())
      love.graphics.draw(self.props.display.spriteAtlas.image, quad)
      love.graphics.pop()
   end
end

---@type fun(scene: Inky.Scene): TileElement
local TileElement = Inky.defineElement(Tile)

---@param scene Inky.Scene
---@param size Vector2
---@param display Display
---@param onSelect function
---@return TileElement[]
local function initialElements(scene, size, display, onSelect)
   local t = {}
   for _, cell in pairs(prism.cells) do
      local tile = TileElement(scene)
      tile.props.display = display
      tile.props.placeable = cell
      tile.props.size = size
      tile.props.onSelect = onSelect
      table.insert(t, tile)
   end

   for _, actor in pairs(prism.actors) do
      local tile = TileElement(scene)
      tile.props.display = display
      tile.props.placeable = actor()
      tile.props.size = size
      tile.props.onSelect = onSelect
      table.insert(t, tile)
   end

   return t
end

---@class PanelProps : Inky.Props
---@field elements TileElement[]
---@field display Display
---@field size Vector2
---@field selected Placeable
---@field geometer Geometer

---@class Panel : Inky.Element
---@field props PanelProps

---@param self Panel
---@param scene Inky.Scene
---@return function
local function Panel(self, scene)
   ---@param placeable Placeable
   local function onSelect(placeable)
      self.props.selected = placeable
      
      if placeable:is(prism.Actor) then
         placeable = getmetatable(placeable)
      end
      
      self.props.geometer.placeable = placeable
   end

   self.props.elements = initialElements(scene, self.props.size, self.props.display, onSelect)
   self.props.selected = self.props.elements[1].props.placeable
   self.props.geometer.placeable = self.props.selected

   local background = love.graphics.newImage("geometer/assets/panel.png")
   local selector = love.graphics.newImage("geometer/assets/selector.png")
   local grid = spectrum.SpriteAtlas.fromGrid("geometer/assets/grid.png", 7 * 8, 11 * 8)

   return function(_, x, y, w, h)
      love.graphics.draw(background, x, y)

      grid:drawByIndex(2, x + 8, y + (8 * 11))
      local column = 1
      local row = 1
      for i, tile in ipairs(self.props.elements) do
         local tileX, tileY = x + (8 * (2 * column)), y + (8 * (11 + row))
         tile:render(tileX, tileY, 8, 8)
         if tile.props.placeable == self.props.selected then
            love.graphics.draw(selector, tileX - 8, tileY - 8)
         end
         column = column + 1
         if i % 3 == 0 then
            column = 1
            row = row + 2
         end
      end
   end
end

---@type fun(scene: Inky.Scene): Panel
local PanelElement = Inky.defineElement(Panel)
return PanelElement
