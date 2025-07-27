--- @alias DropTableOptions DropTableCategory[]|DropTableCategory

--- @class DropTableCategory
--- @field chance number? Defaults to one if not specified
--- @field entries DropTableWeightedOption[]?
--- @field entry DropTableEntry?

--- @class DropTableWeightedOption
--- @field weight integer
--- @field entry DropTableEntry

--- @alias DropTableEntry ActorFactory|Actor

--- A drop table which tracks what items the actor should drop upon death.
--- @class DropTable : Controller
--- @field table DropTableOptions
--- @overload fun(table: DropTableOptions): DropTable
--- @type DropTable
local DropTable = prism.Component:extend "DropTable"


---@param table DropTableOptions
function DropTable:__new(table)
   -- Wrap single categories in a table to simplify logic.
   if table.chance or table.entries or table.entry then
      self.table = {table}
   else
      self.table = table
   end
   
   assert(#self.table > 0, "Initialized a drop table with zero elements!")
   
   -- Calculate the weights for categories with multiple entries.
   self.weights = {}
   for i, category in ipairs(self.table) do
      if category.entries then
         local cumulativeWeights = {}
         local cumulativeWeight = 0
         for j, weightedOption in ipairs(category.entries) do
            cumulativeWeight = cumulativeWeight + weightedOption.weight
            cumulativeWeights[j] = cumulativeWeight
         end

         self.weights[category] = cumulativeWeights
      elseif not category.entry then
         error("Category " .. i .. " has neither entries nor entry field!")
      end
   end
end

--- Takes an RNG and returns an actor from the drop table.
---@param rng RNG
---@return Actor[]
function DropTable:getDrops(rng)
   --- @type Actor[]
   local drops = {}
   
   for _, category in ipairs(self.table) do
      local chance = category.chance or 1.0
      
      if rng:random() <= chance then
         local entry = category.entry

         if category.entries then
            local cumulativeWeights = self.weights[category]
            local roll = rng:random(0, cumulativeWeights[#cumulativeWeights] - 1)
            
            -- Binary search over cumulativeWeights
            local low, high = 1, #cumulativeWeights
            while low < high do
               local mid = math.floor((low + high) / 2)
               if roll < cumulativeWeights[mid] then
                  high = mid
               else
                  low = mid + 1
               end
            end
            
            entry = category.entries[low].entry
         end
         
         local actor = entry
         if type(entry) == "function" then
            actor = entry()
         end
         
         ---@cast actor Actor
         table.insert(drops, actor)
      end
   end
   
   return drops
end

return DropTable
