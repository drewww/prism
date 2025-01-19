local Inky = geometer.require "inky"
---@type TextInputInit
local TextInput = geometer.require "elements.textinput"

---@class TileElementProps : Inky.Props
---@field placeable Placeable
---@field size Vector2 the final size of a tile in editor
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
      local quad = spectrum.Display.getQuad(self.props.display.spriteAtlas, drawable)

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

   self.props.elements = initialElements(scene, self.props.size, self.props.display, onSelect)
   self.props.filtered = {}
   for i = 1, #self.props.elements do
      self.props.filtered[i] = i
   end
   resetRange()
   self.props.selected = self.props.elements[1].props.placeable
   self.props.editor.placeable = self.props.selected

   local background = love.graphics.newImage(geometer.path .. "/assets/panel.png")
   local selector = love.graphics.newImage(geometer.path .. "/assets/selector.png")
   local gridAtlas = spectrum.SpriteAtlas.fromGrid(geometer.path .. "/assets/grid.png", 7 * 8, 11 * 8)
   local scrollColor = prism.Color4.fromHex(0x2ce8f5)

   local textInput = TextInput(scene)
   textInput.props.font = love.graphics.newFont(geometer.path .. "/assets/FROGBLOCK-Polyducks.ttf", 8 * 3)
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

   return function(_, x, y, w, h, depth)
      love.graphics.draw(background, x, y)

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

      gridAtlas:drawByIndex(grid, x + 8, y + (8 * 11))

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
      love.graphics.rectangle("fill", x + (9 * 8) + 2, y + (8 * (11 + bucket)), 4, 8)
      love.graphics.setColor(1, 1, 1, 1)
      local column = 1
      local row = 1
      for i = self.props.startRange, self.props.endRange do
         local tile = self.props.elements[self.props.filtered[i]]

         local tileX, tileY = x + (8 * (2 * column)), y + (8 * (11 + row))
         tile:render(tileX, tileY, 8, 8, depth + 1)
         if tile.props.placeable == self.props.selected then love.graphics.draw(selector, tileX - 8, tileY - 8) end
         column = column + 1
         if column % 4 == 0 then
            column = 1
            row = row + 2
         end
      end
      textInput:render(x + 8, y + 8 * 8, 8 * 8, 8, depth + 1)
   end
end

---@alias SelectionPanelInit fun(scene: Inky.Scene): SelectionPanel
---@type SelectionPanelInit
local SelectionPanelElement = Inky.defineElement(SelectionPanel)
return SelectionPanelElement
