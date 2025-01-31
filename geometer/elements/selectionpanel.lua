local Inky = geometer.require "inky"
---@type TextInputInit
local TextInput = geometer.require "elements.textinput"
---@type SelectionGridInit
local SelectionGrid = geometer.require "elements.selectiongrid"

---@return Placeable[]
local function initialElements()
   local t = {}
   for _, cell in pairs(prism.cells) do
      table.insert(t, cell)
   end

   for _, actor in pairs(prism.actors) do
      table.insert(t, actor())
   end

   return t
end

---@class SelectionPanelProps : Inky.Props
---@field placeables Placeable[]
---@field filtered number[]
---@field display Display
---@field size Vector2
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
      if placeable:is(prism.Actor) then placeable = getmetatable(placeable) end

      self.props.editor.placeable = placeable
   end

   -- We capture and consume pointer events to avoid the editor grid consuming them,
   -- since the grid overlaps with the panel
   self:onPointerEnter(function(_, pointer)
      pointer:captureElement(self)
   end)

   self:onPointerExit(function(_, pointer)
      pointer:captureElement(self, false)
   end)

   self:onPointer("press", function() end)

   self:onPointer("scroll", function() end)

   self.props.placeables = initialElements()
   self.props.filtered = {}
   for i = 1, #self.props.placeables do
      self.props.filtered[i] = i
   end

   local grid = SelectionGrid(scene)
   grid.props.placeables = self.props.placeables
   grid.props.filtered = self.props.filtered
   grid.props.display = self.props.display
   grid.props.overlay = self.props.overlay
   grid.props.onSelect = onSelect
   grid.props.size = self.props.size

   local font = love.graphics.newFont(geometer.assetPath .. "/assets/FROGBLOCK-Polyducks.ttf", self.props.size.x - 8)
   local textInput = TextInput(scene)
   textInput.props.font = font
   textInput.props.overlay = self.props.overlay
   textInput.props.size = self.props.size
   textInput.props.placeholder = "SEARCH"
   textInput.props.onEdit = function(content)
      local filtered = {}
      for i, placeable in ipairs(self.props.placeables) do
         if placeable.name:find(content) then table.insert(filtered, i) end
      end
      self.props.filtered = filtered
      grid.props.filtered = filtered
   end

   local background = love.graphics.newImage(geometer.assetPath .. "/assets/panel.png")
   local panelTop = love.graphics.newImage(geometer.assetPath .. "/assets/panel_top.png")

   return function(_, x, y, w, h, depth)
      local offsetY = love.graphics.getCanvas():getHeight() - background:getHeight()
      love.graphics.draw(background, x, offsetY)
      love.graphics.draw(panelTop, x)

      textInput:render(x + 8 * 3, y + 2 * 8, 8 * 8, 8, depth + 1)
      grid:render(x, y + 5 * 8, w, 8 * 12, depth + 1)

      love.graphics.push("all")
      love.graphics.setCanvas(self.props.overlay)
      love.graphics.setFont(font)
      love.graphics.print(
         self.props.editor.placeable.name,
         ((x / 8) + 3) * self.props.size.x,
         (y / 8 + 17) * self.props.size.y
      )
      love.graphics.pop()
   end
end

---@alias SelectionPanelInit fun(scene: Inky.Scene): SelectionPanel
---@type SelectionPanelInit
local SelectionPanelElement = Inky.defineElement(SelectionPanel)
return SelectionPanelElement
