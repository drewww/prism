---@param a Vector2
---@param b Vector2
local function heuristic(a, b) return a:distance(b) end

-- helper function to reconstruct the path
local function reconstructPath(cameFrom, costSoFar, current)
   local path = {}
   local costs = {}

   local last
   while current do
      table.insert(path, 1, current)

      if last then
         local lastCost = costSoFar[last:hash()]
         local cost = costSoFar[current:hash()]
         table.insert(costs, 1, lastCost - cost)
      end

      last = current
      current = cameFrom[current:hash()]
   end

   table.remove(path, 1)
   return prism.Path(path, costs)
end

local function defaultCostCallback(_, _) return 1 end

---@param start Vector2
---@param goal Vector2
---@param passableCallback fun(x: integer, y: integer): boolean
---@param costCallback? fun(x: integer, y: integer): integer
---@param minDistance? integer
local function astarSearch(start, goal, passableCallback, costCallback, minDistance)
   minDistance = minDistance or 0
   costCallback = costCallback or defaultCostCallback

   local frontier = prism.PriorityQueue()
   frontier:push(start, 0)

   local cameFrom = {}  -- [vec] = vec | nil
   local costSoFar = {} -- [vec] = float

   cameFrom[start:hash()] = nil
   costSoFar[start:hash()] = 0

   local final
   local pathFound = false
   while not frontier:isEmpty() do
      local current = frontier:pop()
      --- @cast current Vector2
      if current:getRange(prism._defaultDistance, goal) <= minDistance then
         final = current
         pathFound = true
         break
      end

      for _, neighborDir in ipairs(prism.neighborhood) do
         local neighbor = current + neighborDir
         --- @cast neighbor Vector2
         if passableCallback(neighbor.x, neighbor.y) then
            local moveCost = costCallback(neighbor.x, neighbor.y)
            local newCost = costSoFar[current:hash()] + moveCost
            if not costSoFar[neighbor:hash()] or newCost < costSoFar[neighbor:hash()] then
               costSoFar[neighbor:hash()] = newCost
               local priority = newCost + heuristic(neighbor, goal)
               frontier:push(neighbor, priority)
               cameFrom[neighbor:hash()] = current
            end
         end
      end
   end

   if pathFound then
      return reconstructPath(cameFrom, costSoFar, final)
   end
end

return astarSearch
