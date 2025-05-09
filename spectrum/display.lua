---@class SpectrumAttachable : Object, IQueryable
---@field getCell fun(self, x:integer, y:integer): Cell
---@field setCell fun(self, x:integer, y:integer, cell: Cell|nil)
---@field addActor fun(self, actor: Actor)
---@field removeActor fun(self, actor: Actor)
---@field inBounds fun(self, x: integer, y:integer)
---@field getSize fun(): Vector2
---@field eachCell fun(self): fun(): integer, integer, Cell
---@field debug boolean

---@class Display : Object
---@field width integer
---@field height integer
---@field cells table<number, table<number, {char: (string|integer)?, fg: Color4, bg: Color4, depth: number}>>
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

   self.cells = {{}}

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
            love.graphics.draw(
               self.spriteAtlas.image,
               quad,
               dx * cSx,
               dy * cSy
            )
         end
      end
   end
end

--- @param x integer
--- @param y integer
--- @param attachable SpectrumAttachable
function Display:putLevel(x, y, attachable)
   for ax, ay, cell in attachable:eachCell() do
      local drawable = cell:getComponent(prism.components.Drawable)
      self:putDrawable(ax + x, ay + y, drawable, nil, 0)
   end

   for actor, drawable in attachable:query(prism.components.Drawable):iter() do
      --- @diagnostic disable-next-line
      local ax, ay = actor.position:decompose()
      self:putDrawable(ax + x, ay + y, drawable)
   end
end

--- @param attachable SpectrumAttachable
--- @param primary Senses[]
--- @param secondary Senses[]
function Display:putSenses(x, y, primary, secondary)
   local tempColor = prism.Color4()
   local drawnCells = prism.SparseGrid()

   --- @param senses Senses
   local function drawCells(cellMap, alpha)
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

   for _, senses in ipairs(primary) do
      drawCells(senses.cells, 1)
   end

   for _, senses in ipairs(secondary) do
      drawCells(senses.cells, 0.7)
   end

   for _, senses in ipairs(primary) do
      drawCells(senses.explored, 0.3)
   end

   for _, senses in ipairs(secondary) do
      drawCells(senses.explored, 0.3)
   end

   local drawnActors = {}

   local function drawActors(queryable, alpha)
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

   for _, senses in ipairs(primary) do
      drawActors(senses, 1)
   end

   for _, senses in ipairs(secondary) do
      drawActors(senses, 0.7)
   end
end

--- Puts a Drawable at a position with depth checking
--- @param x integer
--- @param y integer
--- @param drawable Drawable
function Display:putDrawable(x, y, drawable, color, layer)
   self:put(x, y, drawable.index, color or drawable.color, drawable.background, layer or drawable.layer)
end

function Display:put(x, y, char, fg, bg, layer)
   if x < 1 or x > self.width or y < 1 or y > self.height then return end

   fg = fg or prism.Color4.WHITE
   bg = bg or prism.Color4.TRANSPARENT

   local cell = self.cells[x][y]

   if layer >= cell.depth then
      cell.char = char
      fg:copy(cell.fg)
      bg:copy(cell.bg)
      cell.depth = layer
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
   love.window.setMode(windowWidth, windowHeight, { resizable = true })
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

return Display