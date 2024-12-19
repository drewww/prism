---@class SparseArray : Object
local SparseArray = prism.Object:extend("SparseArray")

--- Constructor for SparseArray.
function SparseArray:__new()
   self.data = {}         -- Holds the actual values
   self.freeIndices = {}  -- Tracks free indices
end

--- Adds an item to the sparse array.
--- @param item any The item to add.
--- @return number index The index where the item was added.
function SparseArray:add(item)
   local index
   if #self.freeIndices > 0 then
      -- Reuse a free index
      index = table.remove(self.freeIndices)
   else
      -- Add to the end of the data
      index = #self.data + 1
   end
   self.data[index] = item
   return index
end

--- Removes an item from the sparse array.
--- @param index number The index to remove the item from.
function SparseArray:remove(index)
   if self.data[index] ~= nil then
      self.data[index] = nil
      table.insert(self.freeIndices, index)   -- Mark the index as free
   else
      error("Index " .. index .. " is invalid or already nil.")
   end
end

--- Gets an item from the sparse array.
--- @param index number The index of the item.
--- @return any The item at the specified index, or nil if none exists.
function SparseArray:get(index)
   return self.data[index]
end

--- Clears the sparse array.
function SparseArray:clear()
   self.data = {}
   self.freeIndices = {}
end

--- Bakes the sparse array into a dense array.
--- This removes all nil values and reassigns indices.
--- @return table The new dense array.
function SparseArray:bake()
   local denseArray = {}
   for _, value in ipairs(self.data) do
      if value ~= nil then
         table.insert(denseArray, value)
      end
   end
   self.data = denseArray
   self.freeIndices = {}
   return self.data
end

--- Prints the sparse array for debugging purposes.
function SparseArray:debugPrint()
   for i, v in ipairs(self.data) do
      print("Index", i, ":", v)
   end

   print("Free indices:", table.concat(self.freeIndices, ", "))
end

return SparseArray
