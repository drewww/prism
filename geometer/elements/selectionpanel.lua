local Inky = geometer.require "inky"
---@type TextInputInit
local TextInput = geometer.require "elements.textinput"

---@class TileElementProps : Inky.Props
---@field placeable Placeable
---@field size Vector2 the final size of a tile in editor
---@field display Display
---@field onSelect function
---@field overlay love.Canvas

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
      local quad = spectrum.Display.getQuad(self.props.display.spriteAtlas, drawable)

      love.graphics.push("all")
      love.graphics.setCanvas(self.props.overlay)
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
---@param overlay love.Canvas
---@param onSelect function
---@return TileElement[]
local function initialElements(scene, size, display, overlay, onSelect)
   local t = {}
   for _, cell in pairs(prism.cells) do
      local tile = TileElement(scene)
      tile.props.size = size
      tile.props.display = display
      tile.props.overlay = overlay
      tile.props.onSelect = onSelect
      tile.props.placeable = cell
      table.insert(t, tile)
   end

   for _, actor in pairs(prism.actors) do
      local tile = TileElement(scene)
      tile.props.size = size
      tile.props.display = display
      tile.props.overlay = overlay
      tile.props.placeable = actor()
      tile.props.onSelect = onSelect
      table.insert(t, tile)
   end

   return t
end

---@class SelectionPanelProps : Inky.Props
---@field elements TileElement[]
---@field startRange number
---@field endRange number
---@field filtered number[]
---@field display Display
---@field size Vector2
---@field selected Placeable
---@field editor Editor
---@field overlay love.Canvas

---@class SelectionPanel : Inky.Element
---@field props SelectionPanelProps

---@param self SelectionPanel
---@param scene Inky.Scene
---@return function
local function SelectionPanel(self, scene)
   ---@param placeable Placeable
   local function onSelect(placeable)
      self.props.selected = placeable

      if placeable:is(prism.Actor) then placeable = getmetatable(placeable) end

      self.props.editor.placeable = placeable
   end

   local function resetRange()
      self.props.startRange = 1
      self.props.endRange = #self.props.filtered <= 15 and #self.props.filtered or 15
   end

   self:onPointerEnter(function(_, pointer)
      pointer:captureElement(self)
   end)

   self:onPointerExit(function(_, pointer)
      pointer:captureElement(self, false)
   end)

   self:onPointer("press", function() end)

   self:onPointer("scroll", function(_, pointer, dx, dy)
      local max = #self.props.filtered
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

   self.props.elements = initialElements(scene, self.props.size, self.props.display, self.props.overlay, onSelect)
   self.props.filtered = {}
   for i = 1, #self.props.elements do
      self.props.filtered[i] = i
   end
   resetRange()
   self.props.selected = self.props.elements[1].props.placeable
   self.props.editor.placeable = self.props.selected

   local background = love.graphics.newImage(geometer.assetPath .. "/assets/panel.png")
   local selector = love.graphics.newImage(geometer.assetPath .. "/assets/selector.png")
   local gridAtlas = spectrum.SpriteAtlas.fromGrid(geometer.assetPath .. "/assets/grid.png", 7 * 8, 11 * 8)
   local scrollColor = prism.Color4.fromHex(0x2ce8f5)
   -- 4 = 8
   -- 7 = 16

   local textInput = TextInput(scene)
   textInput.props.font =
      love.graphics.newFont(geometer.assetPath .. "/assets/FROGBLOCK-Polyducks.ttf", self.props.size.x - 8)
   textInput.props.overlay = self.props.overlay
   textInput.props.size = self.props.size
   textInput.props.onEdit = function(content)
      self.props.filtered = {}
      for i, tile in ipairs(self.props.elements) do
         local placeable = tile.props.placeable
         if placeable.name:find(content) then table.insert(self.props.filtered, i) end
      end

      resetRange()
   end

   local panelTop = love.graphics.newImage(geometer.assetPath .. "/assets/panel_top.png")

   return function(_, x, y, w, h, depth)
      local offsetY = love.graphics.getCanvas():getHeight() - background:getHeight()
      love.graphics.draw(background, x, offsetY)
      love.graphics.draw(panelTop, x)

      local grid = 2
      local max = #self.props.filtered
      if self.props.startRange > 3 then
         if self.props.endRange < max then
            grid = 4
         else
            grid = 1
         end
      elseif self.props.endRange < max then
         grid = 3
      end

      local topGridEdge = 5 * 8

      gridAtlas:drawByIndex(grid, x + 24, topGridEdge)

      local bucket
      if self.props.startRange == 1 then
         bucket = 1
      elseif self.props.endRange == max then
         bucket = 9
      else
         local perBucket = max / 9
         bucket = ((self.props.startRange + self.props.endRange) / 2) / perBucket
      end
      love.graphics.setColor(scrollColor:decompose())
      love.graphics.rectangle("fill", x + (11 * 8) + 2, topGridEdge + (8 * bucket), 4, 8)
      love.graphics.setColor(1, 1, 1, 1)
      local column = 1
      local row = 1
      for i = self.props.startRange, self.props.endRange do
         local tile = self.props.elements[self.props.filtered[i]]

         local tileX, tileY = x + 16 + (8 * (2 * column)), topGridEdge + (8 * row)
         tile:render(tileX, tileY, 8, 8, depth + 1)
         if tile.props.placeable == self.props.selected then love.graphics.draw(selector, tileX - 8, tileY - 8) end
         column = column + 1
         if column % 4 == 0 then
            column = 1
            row = row + 2
         end
      end
      textInput:render(x + 8 * 3, topGridEdge - 8 * 3, 8 * 8, 8, depth + 1)
   end
end

---@alias SelectionPanelInit fun(scene: Inky.Scene): SelectionPanel
---@type SelectionPanelInit
local SelectionPanelElement = Inky.defineElement(SelectionPanel)
return SelectionPanelElement
