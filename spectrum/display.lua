---@class SpectrumAttachable : Object, IQueryable
---@field getCell fun(self, x:integer, y:integer): Cell
---@field setCell fun(self, x:integer, y:integer, cell: Cell|nil)
---@field addActor fun(self, actor: Actor)
---@field removeActor fun(self, actor: Actor)
---@field inBounds fun(self, x: integer, y:integer)
---@field getSize fun(): Vector2
---@field eachCell fun(self): fun(): integer, integer, Cell
---@field debug boolean

--- @alias DisplayCell {char: (string|integer)?, fg: Color4, bg: Color4, depth: number}
---@class Display : Object
---@field width integer
---@field height integer
---@field cells table<number, table<number, DisplayCell>>
---@overload fun(width: integer, heigh: integer, spriteAtlas: SpriteAtlas, cellSize: Vector2): Display
local Display = prism.Object:extend("Display")

--- Initializes the terminal display
--- @param width integer
--- @param height integer
--- @param spriteAtlas SpriteAtlas
--- @param cellSize Vector2
function Display:__new(width, height, spriteAtlas, cellSize)
   self.spriteAtlas = spriteAtlas
   self.cellSize = cellSize
   self.width = width
   self.height = height
   self.camera = prism.Vector2()

   self.cells = { {} }

   -- Initialize the grid with empty cells
   for x = 1, self.width do
      self.cells[x] = {}
      for y = 1, self.height do
         self.cells[x][y] = {
            char = nil,
            fg = prism.Color4(1, 1, 1, 1),
            bg = prism.Color4(0, 0, 0, 0),
            depth = -math.huge, -- Lowest possible depth
         }
      end
   end
end

function Display:draw()
   local cSx, cSy = self.cellSize.x, self.cellSize.y

   -- draw bgs
   for x = 1, self.width do
      for y = 1, self.height do
         local cell = self.cells[x][y]

         if cell.bg.a ~= 0 then
            local dx, dy = x - 1, y - 1
            love.graphics.setColor(cell.bg:decompose())
            love.graphics.rectangle("fill", dx * cSx, dy * cSy, cSx, cSy)
         end
      end
   end

   -- Draw characters
   for x = 1, self.width do
      for y = 1, self.height do
         local cell = self.cells[x][y]
         local dx, dy = x - 1, y - 1
         local quad = self:getQuad(cell.char)

         if quad then
            love.graphics.setColor(cell.fg:decompose())
            love.graphics.draw(self.spriteAtlas.image, quad, dx * cSx, dy * cSy)
         end
      end
   end
end

--- @param attachable SpectrumAttachable
function Display:putLevel(attachable)
   local camX, camY = self.camera:decompose()

   for x = 1, self.width do
      for y = 1, self.height do
         local cell = attachable:getCell(x - camX, y - camY)
         if cell then
            local drawable = cell:expectComponent(prism.components.Drawable)
            self:putDrawable(x, y, drawable, nil, 0)
         end
      end
   end

   for actor, drawable in attachable:query(prism.components.Drawable):iter() do
      --- @diagnostic disable-next-line
      local ax, ay = actor.position:decompose()
      self:putDrawable(ax + camX, ay + camY, drawable)
   end
end

local tempColor = prism.Color4()

--- @private
function Display:_drawCells(drawnCells, cellMap, alpha)
   local x, y = self.camera:decompose()

   for cx, cy, cell in cellMap:each() do
      if not drawnCells:get(cx, cy) then
         drawnCells:set(cx, cy, true)
         --- @cast cell Cell

         local drawable = cell:expectComponent(prism.components.Drawable)
         tempColor = drawable.color:copy(tempColor)
         tempColor.a = tempColor.a * alpha
         self:putDrawable(x + cx, y + cy, drawable, tempColor)
      end
   end
end

--- @private
function Display:_drawActors(drawnActors, queryable, alpha)
   local x, y = self.camera:decompose()

   for actor, drawable in queryable:query(prism.components.Drawable):iter() do
      --- @cast drawable Drawable
      if not drawnActors[actor] then
         drawnActors[actor] = true
         tempColor = drawable.color:copy(tempColor)
         tempColor.a = tempColor.a * alpha

         local ax, ay = actor.position:decompose()
         self:putDrawable(x + ax, y + ay, drawable, tempColor)
      end
   end
end

--- @param primary Senses[]
--- @param secondary Senses[]
function Display:putSenses(primary, secondary)
   local drawnCells = prism.SparseGrid()

   for _, senses in ipairs(primary) do
      self:_drawCells(drawnCells, senses.cells, 1)
   end

   for _, senses in ipairs(secondary) do
      self:_drawCells(drawnCells, senses.cells, 0.7)
   end

   for _, senses in ipairs(primary) do
      self:_drawCells(drawnCells, senses.explored, 0.3)
   end

   for _, senses in ipairs(secondary) do
      self:_drawCells(drawnCells, senses.explored, 0.3)
   end

   local drawnActors = {}

   for _, senses in ipairs(primary) do
      self:_drawActors(drawnActors, senses, 1)
   end

   for _, senses in ipairs(secondary) do
      self:_drawActors(drawnActors, senses, 0.7)
   end
end

--- Puts a Drawable at a position with depth checking
--- @param x integer
--- @param y integer
--- @param drawable Drawable
function Display:putDrawable(x, y, drawable, color, layer)
   self:put(
      x,
      y,
      drawable.index,
      color or drawable.color,
      drawable.background,
      layer or drawable.layer
   )
end

function Display:put(x, y, char, fg, bg, layer)
   if x < 1 or x > self.width or y < 1 or y > self.height then return end

   fg = fg or prism.Color4.WHITE
   bg = bg or prism.Color4.TRANSPARENT

   local cell = self.cells[x][y]

   if not layer or layer >= cell.depth then
      cell.char = char
      fg:copy(cell.fg)
      bg:copy(cell.bg)
      cell.depth = layer
   end
end

--- Draws a string of characters at a grid position
--- @param x integer Starting X grid coordinate
--- @param y integer Y grid coordinate
--- @param str string The string to draw
--- @param fg? Color4 Foreground color (defaults to white)
--- @param bg? Color4 Background color (defaults to transparent)
--- @param layer? number Draw layer (optional)
function Display:putString(x, y, str, fg, bg, layer)
   fg = fg or prism.Color4.WHITE
   bg = bg or prism.Color4.TRANSPARENT
   for i = 1, #str do
      local char = str:sub(i, i)
      self:put(x + i - 1, y, char, fg, bg, layer)
   end
end

--- @param index string|integer
function Display:getQuad(index)
   if type(index) == "number" then
      return self.spriteAtlas:getQuadByIndex(index)
   elseif type(index) == "string" then
      return self.spriteAtlas:getQuadByName(index)
   end
end

--- Clears the grid to a background color and resets depth
--- @param bg? Color4 Optional background color
function Display:clear(bg)
   bg = bg or prism.Color4.TRANSPARENT

   for x = 1, self.width do
      for y = 1, self.height do
         local cell = self.cells[x][y]
         cell.char = nil
         bg:copy(cell.bg)
         cell.depth = -math.huge
      end
   end
end

function Display:fitWindowToTerminal()
   local cellWidth, cellHeight = self.cellSize.x, self.cellSize.y
   local windowWidth = self.width * cellWidth
   local windowHeight = self.height * cellHeight
   love.window.setMode(windowWidth, windowHeight, { resizable = true, usedpiscale = false })
end

--- Calculates the top-left offset needed to center a position on the display
--- @param x integer
--- @param y integer
--- @return integer offsetx, integer offsety  The x and y offset
function Display:getCenterOffset(x, y)
   local centerX = math.floor(self.width / 2)
   local centerY = math.floor(self.height / 2)
   local offsetX = centerX - x
   local offsetY = centerY - y
   return offsetX, offsetY
end

--- Draws a Drawable at pixel coordinates (not grid coordinates)
--- @param x number Pixel X coordinate
--- @param y number Pixel Y coordinate
--- @param drawable Drawable
function Display:drawDrawable(x, y, drawable)
   local quad = self:getQuad(drawable.index)
   if quad then
      love.graphics.setColor(drawable.color:decompose())
      love.graphics.draw(self.spriteAtlas.image, quad, x, y)
   end
end

--- Returns the grid cell under the current mouse position, adjusted by optional grid offsets
--- @return integer? x, integer? y  Grid coordinates, or nil if out of bounds
function Display:getCellUnderMouse()
   local x, y = self.camera:decompose()

   local mx, my = love.mouse.getPosition()
   local gx = math.floor(mx / self.cellSize.x) - x + 1
   local gy = math.floor(my / self.cellSize.y) - y + 1

   return gx, gy
end

function Display:setCamera(x, y)
   self.camera:compose(x, y)
end

function Display:moveCamera(dx, dy)
   self.camera.x = self.camera.x + dx
   self.camera.y = self.camera.y + dy
end

function Display:putRect(x, y, w, h, char, fg, bg, layer)
   for dx = 0, w - 1 do
      self:put(x + dx, y, char, fg, bg, layer)
      self:put(x + dx, y + h - 1, char, fg, bg, layer)
   end
   for dy = 1, h - 2 do
      self:put(x, y + dy, char, fg, bg, layer)
      self:put(x + w - 1, y + dy, char, fg, bg, layer)
   end
end

function Display:putFilledRect(x, y, w, h, char, fg, bg, layer)
   for dx = 0, w - 1 do
      for dy = 0, h - 1 do
         self:put(x + dx, y + dy, char, fg, bg, layer)
      end
   end
end

function Display:putLine(x0, y0, x1, y1, char, fg, bg, layer)
   local dx = math.abs(x1 - x0)
   local dy = math.abs(y1 - y0)
   local sx = x0 < x1 and 1 or -1
   local sy = y0 < y1 and 1 or -1
   local err = dx - dy

   while true do
      self:put(x0, y0, char, fg, bg, layer)
      if x0 == x1 and y0 == y1 then break end
      local e2 = 2 * err
      if e2 > -dy then
         err = err - dy
         x0 = x0 + sx
      end
      if e2 < dx then
         err = err + dx
         y0 = y0 + sy
      end
   end
end

return Display
