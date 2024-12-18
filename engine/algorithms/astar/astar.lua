---@param a Vector2
---@param b Vector2
local function heuristic(a, b) return a:distance(b)  end

-- helper function to reconstruct the path
local function reconstruct_path(came_from, cost_so_far, current)
   local path = {}
   local costs = {}

   local last
   while current do
      table.insert(path, 1, current)

      if last then
         local last_cost = cost_so_far[last:hash()]
         local cost = cost_so_far[current:hash()]
         table.insert(costs, 1, last_cost - cost)
      end
      
      last = current
      current = came_from[current:hash()]
   end

   table.remove(path, 1)
   return prism.Path(path, costs)
end

local function default_cost_callback(_, _) return 1 end

---@param start Vector2
---@param goal Vector2
---@param passable_callback fun(x: integer, y: integer): boolean
---@param cost_callback fun(x: integer, y: integer): integer
---@param minDistance integer
local function astar_search(start, goal, passable_callback, cost_callback, minDistance)
   minDistance = minDistance or 0
   cost_callback = cost_callback or default_cost_callback

   local frontier = prism.PriorityQueue()
   frontier:push(start, 0)

   local came_from = {} -- [vec] = vec | nil
   local cost_so_far = {} -- [vec] = float

   came_from[start:hash()] = nil
   cost_so_far[start:hash()] = 0

   local final
   local pathFound = false
   while not frontier:is_empty() do
      local current = frontier:pop()
      --- @cast current Vector2
      if current:getRange(prism._defaultDistance, goal) <= minDistance then
         final = current
         pathFound = true
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

   if pathFound then
      return reconstruct_path(came_from, cost_so_far, final)
   end
end

return astar_search
