---@param goals table<number, Vector2> List of goal positions.
---@param passable_callback fun(x: integer, y: integer): boolean Function to determine passable cells.
---@return SparseGrid<number> map The Dijkstra map as a SparseGrid where each cell's value is its distance to the nearest goal.
local function dijkstra_map(goals, passable_callback)
   -- Create the SparseGrid to store distances
   local distances = prism.SparseGrid()

   -- Queue for exploring cells (FIFO for BFS-like behavior)
   local frontier = {}

   -- Initialize frontier with goals
   for _, goal in ipairs(goals) do
       table.insert(frontier, goal)
       distances:set(goal.x, goal.y, 0)
   end

   while #frontier > 0 do
       local current = table.remove(frontier, 1)
       ---@cast current Vector2

       local current_cost = distances:get(current.x, current.y) or math.huge

       for _, neighbor_dir in ipairs(prism.neighborhood) do
           local neighbor = current + neighbor_dir
           ---@cast neighbor Vector2

           if passable_callback(neighbor.x, neighbor.y) then
               local existing_cost = distances:get(neighbor.x, neighbor.y) or math.huge

               if current_cost + 1 < existing_cost then
                   distances:set(neighbor.x, neighbor.y, current_cost + 1)
                   table.insert(frontier, neighbor)
               end
           end
       end
   end

   return distances
end

return dijkstra_map
