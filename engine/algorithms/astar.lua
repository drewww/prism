---@param a Vector2
---@param b Vector2
local function heuristic(a, b) return a:distance(b)  end

-- helper function to reconstruct the path
local function reconstruct_path(came_from, current)
   local path = {}

   while current do
      table.insert(path, current)
      current = came_from[current:hash()]
   end

   return path
end

local function default_cost_callback(_, _) return 1 end

---@param start Vector2
---@param goal Vector2
---@param passable_callback fun(x: integer, y: integer): boolean
---@param cost_callback fun(x: integer, y: integer): integer
local function astar_search(start, goal, passable_callback, cost_callback)
   cost_callback = cost_callback or default_cost_callback

   local frontier = prism.PriorityQueue()
   frontier:push(start, 0)

   local came_from = {} -- [vec] = vec | nil
   local cost_so_far = {} -- [vec] = float

   came_from[start:hash()] = nil
   cost_so_far[start:hash()] = 0

   while not frontier:is_empty() do
      local current = frontier:pop()
      --- @cast current Vector2
      if current == goal then
         break 
      end

      for _, neighbor_dir in ipairs(prism.neighborhood) do
         local neighbor = current + neighbor_dir
         --- @cast neighbor Vector2
         if passable_callback(neighbor.x, neighbor.y) then
            local move_cost = cost_callback(neighbor.x, neighbor.y)
            local new_cost = cost_so_far[current:hash()] + move_cost
            if not cost_so_far[neighbor:hash()] or new_cost < cost_so_far[neighbor:hash()] then
               cost_so_far[neighbor:hash()] = new_cost
               local priority = new_cost + heuristic(neighbor, goal)
               frontier:push(neighbor, priority)
               came_from[neighbor:hash()] = current
            end
         end
      end
   end

   return reconstruct_path(came_from, goal)
end

return astar_search
