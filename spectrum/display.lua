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
---@field width integer The width of the display in cells.
---@field height integer The height of the display in cells.
---@field cells table<number, table<number, DisplayCell>>
---@field camera Vector2 The offset to draw the display at.
---@field pushed boolean Whether to draw with the camera offset applied or not.
---@field animations AnimationMessage[]
---@overload fun(width: integer, heigh: integer, spriteAtlas: SpriteAtlas, cellSize: Vector2): Display
local Display = prism.Object:extend("Display")

--- Initializes the terminal display.
--- @param width integer The width of the display in cells.
--- @param height integer The height of the display in cells.
--- @param spriteAtlas SpriteAtlas The sprite atlas used for drawing characters.
--- @param cellSize Vector2 The size of each cell in pixels.
function Display:__new(width, height, spriteAtlas, cellSize)
   self.spriteAtlas = spriteAtlas
   self.cellSize = cellSize
   self.width = width
   self.height = height
   self.camera = prism.Vector2()
   self.pushed = false

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

--- Updates animations in the display.
--- @param level Level
--- @param dt number
function Display:update(level, dt)
   for i = #self.animations, 1, -1 do
      local animation = self.animations[i]
      if spectrum.Animation:is(animation.animation) then
         animation.animation:update(dt)

         if animation.animation.status == "paused" then
            table.remove(self.animations, i)
            if animation.blocking then self.blocking = false end
         end
      end
   end

   for _, _, animation in
      level:query(prism.components.Position, prism.components.IdleAnimation):iter()
   do
      --- @cast animation IdleAnimation
      animation.animation:update(dt)
   end
end

--- Draws the entire display to the screen. This function iterates through all cells
--- and draws their background colors and then their characters.
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

--- Puts the drawable components of a level (cells and actors) onto the display.
--- This function uses the current camera position to determine what part of the level to draw.
--- @param attachable SpectrumAttachable An object representing the level, capable of providing cell and actor information.
function Display:putLevel(attachable)
   local camX, camY = self.camera:decompose()

   for x = 1, self.width do
      for y = 1, self.height do
         local cell = attachable:getCell(x - camX, y - camY)
         if cell then
            local drawable = cell:expect(prism.components.Drawable)
            self:putDrawable(x, y, drawable, nil, 0)
         end
      end
   end

   for _, position, drawable in
      attachable:query(prism.components.Position, prism.components.Drawable):iter()
   do
      --- @cast drawable Drawable
      --- @cast position Position
      local ax, ay = position:getVector():decompose()
      self:putDrawable(ax + camX, ay + camY, drawable)
   end
end

local reusedPosition = prism.Vector2()
--- Puts animations to the display.
--- @param queryable IQueryable
function Display:putAnimations(queryable)
   for actor, position, idleAnimation in
      queryable:query(prism.components.Position, prism.components.IdleAnimation):iter()
   do
      --- @cast idleAnimation IdleAnimation
      --- @cast position Position
      local x, y = position:getVector():decompose()
      local animation = idleAnimation.animation

      animation:draw(self, x, y)
   end

   for i = #self.animations, 1, -1 do
      local animation = self.animations[i]
      if spectrum.Animation:is(animation.animation) then
         local x, y = animation.x, animation.y
         if animation.actor then
            animation.actor:getPosition(reusedPosition)
            x = x + (reusedPosition and reusedPosition.x or 0)
            y = y + (reusedPosition and reusedPosition.y or 0)
         end

         animation.animation:draw(self, x, y)
      else
         if animation.animation(love.timer.getDelta()) then table.remove(self.animations, i) end
      end
   end
end

--- Removes any animations that are skippable.
function Display:skipAnimations()
   for i = #self.animations, 1, -1 do
      local animation = self.animations[i]
      if animation.skippable then table.remove(self.animations, i) end
   end
end

--- Adds an animation
--- @param message AnimationMessage
--- @param manager GameStateManager
--- @param level Level
function Display:yieldAnimation(message, manager, level)
   table.insert(self.animations, message)
   if message.blocking then
      self.blocking = true
      manager:push(spectrum.AnimatedState(self, level))
   end
end

local tempColor = prism.Color4()

--- Draws cells from a given cell map onto the display, handling depth and transparency.
--- @private
--- @param drawnCells SparseGrid A sparse grid to keep track of already drawn cells to prevent overdrawing.
--- @param cellMap table A map of cells to draw.
--- @param alpha number The transparency level for the drawn cells (0.0 to 1.0).
function Display:_drawCells(drawnCells, cellMap, alpha)
   local x, y = self.camera:decompose()

   for cx, cy, cell in cellMap:each() do
      if not drawnCells:get(cx, cy) then
         drawnCells:set(cx, cy, true)
         --- @cast cell Cell

         local drawable = cell:expect(prism.components.Drawable)
         tempColor = drawable.color:copy(tempColor)
         tempColor.a = tempColor.a * alpha
         self:putDrawable(x + cx, y + cy, drawable, tempColor)
      end
   end
end

--- Draws actors from a queryable object onto the display, handling depth and transparency.
--- @private
--- @param drawnActors table A table to keep track of already drawn actors to prevent overdrawing.
--- @param queryable IQueryable An object capable of being queried for actors with drawable components.
--- @param alpha number The transparency level for the drawn actors (0.0 to 1.0).
function Display:_drawActors(drawnActors, queryable, alpha)
   local x, y = self.camera:decompose()

   for actor, position, drawable in
      queryable:query(prism.components.Position, prism.components.Drawable):iter()
   do
      --- @cast drawable Drawable
      if not drawnActors[actor] then
         drawnActors[actor] = true
         tempColor = drawable.color:copy(tempColor)
         tempColor.a = tempColor.a * alpha

         --- @cast position Position
         local ax, ay = position:getVector():decompose()
         self:putDrawable(x + ax, y + ay, drawable, tempColor)
      end
   end
end

--- @param drawnActors table
---@param grid SparseGrid
---@param alpha number
function Display:_drawRemembered(drawnActors, grid, alpha)
   local cx, cy = self.camera:decompose()

   for x, y, actor in grid:each() do
      if not drawnActors[actor] then
         drawnActors[actor] = true

         local drawable = actor:expect(prism.components.Drawable)
         tempColor = drawable.color:copy(tempColor)
         tempColor.a = tempColor.a * alpha

         self:putDrawable(x + cx, y + cy, drawable, tempColor)
      end
   end
end

--- Puts vision and explored areas from primary and secondary senses onto the display.
--- Cells and actors from primary senses are drawn fully opaque, while those from secondary
--- senses are drawn with reduced opacity. Explored areas are drawn with even lower opacity.
--- @param primary Senses[] A list of primary Senses objects.
--- @param secondary Senses[] A list of secondary Senses objects.
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
      if senses.explored then self:_drawCells(drawnCells, senses.explored, 0.3) end
   end

   local drawnActors = {}

   for _, senses in ipairs(primary) do
      self:_drawActors(drawnActors, senses, 1)
   end

   for _, senses in ipairs(secondary) do
      self:_drawActors(drawnActors, senses, 0.7)
   end

   for _, senses in ipairs(primary) do
      self:_drawRemembered(drawnActors, senses.remembered, 0.3)
   end

   for _, senses in ipairs(secondary) do
      if senses.remembered then self:_drawRemembered(drawnActors, senses.remembered, 0.3) end
   end
end

--- Puts a Drawable object onto the display grid at specified coordinates, considering its depth.
--- If a `color` or `layer` is provided, they will override the drawable's default values.
--- @param x integer The X grid coordinate.
--- @param y integer The Y grid coordinate.
--- @param drawable Drawable The drawable object to put.
--- @param color Color4? An optional color to use for the drawable.
--- @param layer number? An optional layer to use for depth sorting.
function Display:putDrawable(x, y, drawable, color, layer)
   for ox = 1, drawable.size do
      for oy = 1, drawable.size do
         self:put(
            x + ox - 1,
            y + oy - 1,
            drawable.index,
            color or drawable.color,
            drawable.background,
            layer or drawable.layer
         )
      end
   end
end

--- Puts a character, foreground color, and background color at a specific grid position.
--- This function respects drawing layers, so higher layer values will overwrite lower ones.
--- @param x integer The X grid coordinate.
--- @param y integer The Y grid coordinate.
--- @param char string|integer The character or index to draw.
--- @param fg? Color4 The foreground color.
--- @param bg? Color4 The background color.
--- @param layer number? The draw layer (higher numbers draw on top). Defaults to -math.huge.
function Display:put(x, y, char, fg, bg, layer)
   if self.pushed then
      x = x + self.camera.x
      y = y + self.camera.y
   end
   if x < 1 or x > self.width or y < 1 or y > self.height then return end

   fg = fg or prism.Color4.WHITE
   bg = bg or prism.Color4.TRANSPARENT

   local cell = self.cells[x][y]

   if not layer or layer >= cell.depth then
      cell.char = char
      fg:copy(cell.fg)
      bg:copy(cell.bg)
      cell.depth = layer or -math.huge
   end
end

--- Sets only the background color of a cell at a specific grid position, with depth checking.
--- @param x integer The X grid coordinate.
--- @param y integer The Y grid coordinate.
--- @param bg Color4 The background color to set.
--- @param layer number? The draw layer (optional, higher numbers draw on top). Defaults to -math.huge.
function Display:putBG(x, y, bg, layer)
   if x < 1 or x > self.width or y < 1 or y > self.height then return end

   bg = bg or prism.Color4.TRANSPARENT

   local cell = self.cells[x][y]

   if not layer or layer >= cell.depth then
      bg:copy(cell.bg)
      cell.depth = layer or -math.huge
   end
end

--- Draws a string of characters at a grid position, with optional alignment.
--- @param x integer The starting X grid coordinate.
--- @param y integer The Y grid coordinate.
--- @param str string The string to draw.
--- @param fg Color4? The foreground color (defaults to white).
--- @param bg Color4? The background color (defaults to transparent).
--- @param layer number? The draw layer (optional).
--- @param align "left"|"center"|"right"? The alignment of the string within the specified width.
--- @param width integer? The width within which to align the string.
function Display:putString(x, y, str, fg, bg, layer, align, width)
   local strLen = #str
   width = width or self.width

   if align == "center" then
      x = x + math.floor((width - strLen) / 2)
   elseif align == "right" then
      x = x + width - strLen
   elseif align ~= "left" and align ~= nil then -- Added check for nil as default for "left"
      error("Invalid alignment: " .. tostring(align))
   end

   fg = fg or prism.Color4.WHITE
   bg = bg or prism.Color4.TRANSPARENT
   for i = 1, #str do
      local char = str:sub(i, i)
      self:put(x + i - 1, y, char, fg, bg, layer)
   end
end

--- Retrieves the appropriate sprite atlas quad based on an index (number) or name (string).
--- @param index string|integer The index (number) or name (string) of the quad to retrieve.
--- @return love.graphics.Quad? optquad The quad object, or nil if not found.
function Display:getQuad(index)
   if type(index) == "number" then
      return self.spriteAtlas:getQuadByIndex(index)
   elseif type(index) == "string" then
      return self.spriteAtlas:getQuadByName(index)
   end
end

--- Clears the entire display grid, resetting all cell characters to nil,
--- setting backgrounds to a specified color (or transparent), and resetting depth.
--- @param bg Color4? Optional background color to clear to (defaults to transparent).
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

--- Adjusts the Love2D window size to perfectly fit the terminal display's dimensions,
--- considering cell size.
function Display:fitWindowToTerminal()
   local cellWidth, cellHeight = self.cellSize.x, self.cellSize.y
   local windowWidth = self.width * cellWidth
   local windowHeight = self.height * cellHeight
   love.window.setMode(windowWidth, windowHeight, { resizable = true, usedpiscale = false })
end

--- Calculates the top-left offset needed to center a given position on the display.
--- @param x integer The X coordinate to center.
--- @param y integer The Y coordinate to center.
--- @return integer offsetx The calculated X offset.
--- @return integer offsety The calculated Y offset.
function Display:getCenterOffset(x, y)
   local centerX = math.floor(self.width / 2)
   local centerY = math.floor(self.height / 2)
   local offsetX = centerX - x
   local offsetY = centerY - y
   return offsetX, offsetY
end

--- Draws a Drawable object directly at pixel coordinates on the screen,
--- without considering the grid or camera, and handling multi-cell drawables.
--- @param x number The pixel X coordinate of the top-left corner.
--- @param y number The pixel Y coordinate of the top-left corner.
--- @param drawable Drawable The drawable object to render.
function Display:drawDrawable(x, y, drawable)
   local quad = self:getQuad(drawable.index)
   if quad then
      love.graphics.setColor(drawable.color:decompose())
      love.graphics.draw(self.spriteAtlas.image, quad, x, y)
   end
end

--- Returns the grid cell under the current mouse position, adjusted by optional grid offsets.
--- @param mx? number A custom X coordinate to use for the mouse position.
--- @param my? number A custom Y coordinate to use for the mouse position.
--- @return integer? x The X grid coordinate, or nil if out of bounds.
--- @return integer? y The X grid coordinate, or nil if out of bounds.
function Display:getCellUnderMouse(mx, my)
   local x, y = self.camera:decompose()
   local mmx, mmy = love.mouse.getPosition()

   local gx = math.floor((mx or mmx) / self.cellSize.x) - x + 1
   local gy = math.floor((my or mmy) / self.cellSize.y) - y + 1

   return gx, gy
end

--- Sets the camera's position. This position acts as an offset for drawing
--- elements from the level or other world-space coordinates onto the display.
--- @param x integer The X coordinate for the camera.
--- @param y integer The Y coordinate for the camera.
function Display:setCamera(x, y)
   self.camera:compose(x, y)
end

--- Moves the camera by a specified delta.
--- @param dx integer The change in the camera's X position.
--- @param dy integer The change in the camera's Y position.
function Display:moveCamera(dx, dy)
   self.camera.x = self.camera.x + dx
   self.camera.y = self.camera.y + dy
end

--- Push the camera offset, so everything drawn will get the camera applied.
function Display:push()
   self.pushed = true
end

--- Pop the camera offset, so everything drawn will not get the camera applied.
function Display:pop()
   self.pushed = false
end

--- Draws a hollow rectangle on the display grid using specified characters and colors.
--- @param x integer The starting X grid coordinate of the rectangle.
--- @param y integer The starting Y grid coordinate of the rectangle.
--- @param w integer The width of the rectangle.
--- @param h integer The height of the rectangle.
--- @param char string|integer The character or index to draw the rectangle with.
--- @param fg Color4? The foreground color.
--- @param bg Color4? The background color.
--- @param layer number? The draw layer.
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

--- Draws a filled rectangle on the display grid using specified characters and colors.
--- @param x integer The starting X grid coordinate of the rectangle.
--- @param y integer The starting Y grid coordinate of the rectangle.
--- @param w integer The width of the rectangle.
--- @param h integer The height of the rectangle.
--- @param char string|integer The character or index to fill the rectangle with.
--- @param fg Color4? The foreground color.
--- @param bg Color4? The background color.
--- @param layer number? The draw layer.
function Display:putFilledRect(x, y, w, h, char, fg, bg, layer)
   for dx = 0, w - 1 do
      for dy = 0, h - 1 do
         self:put(x + dx, y + dy, char, fg, bg, layer)
      end
   end
end

--- Draws a line between two grid points using Bresenham's line algorithm.
--- @param x0 integer The starting X grid coordinate.
--- @param y0 integer The starting Y grid coordinate.
--- @param x1 integer The ending X grid coordinate.
--- @param y1 integer The ending Y grid coordinate.
--- @param char string|integer The character or index to draw the line with.
--- @param fg Color4? The foreground color.
--- @param bg Color4? The background color.
--- @param layer number? The draw layer.
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
