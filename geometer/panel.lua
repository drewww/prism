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
---@field startRange number
---@field endRange number
---@field filter string
---@field filtered number[]
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

   ---@return boolean
   local function isFiltered()
      return self.props.filter ~= ""
   end

   ---@return number
   local function amountShown()
      return isFiltered() and #self.props.filtered or #self.props.elements
   end

   self:onPointerEnter(function(_, pointer)
      pointer:captureElement(self)
   end)

   self:onPointerExit(function(_, pointer)
      pointer:captureElement(self, false)
   end)

   self:onPointer("press", function() end)

   self:onPointer("scroll", function(_, pointer, dx, dy)
      local max = amountShown()
      local startRange = self.props.startRange
      local endRange = self.props.endRange

      if dy < 0 and max > endRange then
         startRange = startRange + 3
         endRange = math.min(endRange + 3, max)
      elseif dy > 0 and startRange > 3 then
         startRange = startRange - 3
         local sub = endRange % 3 == 0 and 3 or endRange % 3
         endRange = endRange - sub
      end

      self.props.startRange = startRange
      self.props.endRange = endRange
   end)

   self.props.elements = initialElements(scene, self.props.size, self.props.display, onSelect)
   self.props.startRange = 1
   self.props.endRange = #self.props.elements <= 15 and #self.props.elements or 15
   self.props.filtered = {}
   self.props.filter = ""
   self.props.selected = self.props.elements[1].props.placeable
   self.props.geometer.placeable = self.props.selected

   local background = love.graphics.newImage("geometer/assets/panel.png")
   local selector = love.graphics.newImage("geometer/assets/selector.png")
   local gridAtlas = spectrum.SpriteAtlas.fromGrid("geometer/assets/grid.png", 7 * 8, 11 * 8)
   local scrollColor = prism.Color4.fromHex(0x2ce8f5)

   return function(_, x, y, w, h, depth)
      love.graphics.draw(background, x, y)

      local grid = 2
      local filtered = isFiltered()
      local max = amountShown()
      if self.props.startRange > 3 then
         if self.props.endRange < max then
            grid = 4
         else
            grid = 1
         end
      elseif self.props.endRange < max then
         grid = 3
      end

      gridAtlas:drawByIndex(grid, x + 8, y + (8 * 11))

      local bucket
      if self.props.startRange == 1 then
         bucket = 1
      elseif self.props.endRange == max then
         bucket = 9
      else
         local perBucket = amountShown() / 9
         bucket = ((self.props.startRange + self.props.endRange) / 2) / perBucket
      end
      love.graphics.setColor(scrollColor:decompose())
      love.graphics.rectangle("fill", x + (9 * 8) + 2, y + (8 * (11 + bucket)), 4, 8)
      love.graphics.setColor(1, 1, 1, 1)
      local column = 1
      local row = 1
      for i = self.props.startRange, self.props.endRange do
         local tile = self.props.elements[i]
         if filtered then
            tile = self.props.elements[self.props.filtered[i]]
         end

         local tileX, tileY = x + (8 * (2 * column)), y + (8 * (11 + row))
         tile:render(tileX, tileY, 8, 8, depth + 1)
         if tile.props.placeable == self.props.selected then
            love.graphics.draw(selector, tileX - 8, tileY - 8)
         end
         column = column + 1
         if column % 4 == 0 then
            column = 1
            row = row + 2
         end
      end
   end
end

---@type fun(scene: Inky.Scene): Panel
local PanelElement = Inky.defineElement(Panel)
return PanelElement
