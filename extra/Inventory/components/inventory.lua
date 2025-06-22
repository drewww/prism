--- @alias InventoryOptions {limitCount: integer?, limitWeight: number?, limitVolume: number?, multipleStacks: boolean?}

--- @class Inventory : Component, IQueryable
--- @field totalCount integer The current item/stack count in the inventory.
--- @field totalWeight number The current weight in the inventory.
--- @field totalVolume number The current volume in the inventory.
--- @field limitCount integer The number of total items/stacks allowed in the inventory.
--- @field limitWeight number The total weight allowed in the inventory.
--- @field limitVolume number The total volume allowed in the inventory.
--- @overload fun(options: InventoryOptions?)
local Inventory = prism.Component:extend( "Inventory" )
Inventory.totalCount = 0
Inventory.totalWeight = 0
Inventory.totalVolume = 0
Inventory.limitCount = math.huge
Inventory.limitWeight = math.huge
Inventory.limitVolume = math.huge
Inventory.multipleStacks = true

function Inventory:__new(options)
   self.inventory = prism.ActorStorage()

   if not options then return end
   self.limitCount = options.limitCount or self.limitCount
   self.limitVolume = options.limitVolume or self.limitVolume
   self.limitWeight = options.limitWeight or self.limitWeight

   if options.multipleStacks ~= nil then
      self.multipleStacks = options.multipleStacks
   end
end

function Inventory:query(...)
   return self.inventory:query(...)
end

function Inventory:hasItem(actor)
   return self.inventory:hasActor(actor)
end

--- @param stackable ActorFactory
--- @return Actor?
function Inventory:getStack(stackable)
   if not stackable then return end

   for actor in self.inventory:query():iter() do
      local item = actor:expect(prism.components.Item)
      if item.stackable == stackable then
         if item.stackCount < item.stackLimit then
            return actor
         else
            if not self.multipleStacks then return actor end
         end
      end
   end
end

--- @param actor Actor
function Inventory:canAddItem(actor)
   local item = actor:expect(prism.components.Item)

   local stack = self:getStack(item.stackable)
   if item.stackable and stack then
      local stackItem = stack:expect(prism.components.Item)
      if stackItem.stackCount + item.stackCount > stackItem.stackLimit then
         if not self.multipleStacks then
            return false, "Stack limit exceeded"
         end
      end
   else
      if self.totalCount + 1 > self.limitCount then
         return false, "Inventory count limit exceeded"
      end
   end

   if item:getWeight() + self.totalWeight > self.limitWeight then
      return false, "Inventory weight limit exceeded"
   end

   if item:getVolume() + self.totalVolume > self.limitVolume then
      return false, "Inventory volume limit exceeded"
   end

   return true
end

--- @param actor Actor
function Inventory:addItem(actor)
   assert(self:canAddItem(actor))
   
   local item = actor:expect(prism.components.Item)

   local stack = self:getStack(item.stackable)
   if stack then
      local otheritem = stack:expect(prism.components.Item)

      otheritem:stack(actor)
      self:updateLimits()
      if item.stackCount == 0 then return end
   end

   self.inventory:addActor(actor)
   self:updateLimits()
end

--- @param actor Actor
--- @return Actor
function Inventory:removeItem(actor)
   self.inventory:removeActor(actor)
   self:updateLimits()
   return actor
end

--- @param actor Actor
--- @param count integer
--- @return boolean
function Inventory:canRemoveQuantity(actor, count)
   local item = actor:expect(prism.components.Item)
   if count == 1 and not item.stackable then return true end
   if not item.stackable then return false end
   if count <= 0 or count > item.stackCount then return false end

   return true
end

--- @param actor Actor
--- @param count integer
--- @return Actor
function Inventory:removeQuantity(actor, count)
   assert(self:canRemoveQuantity(actor, count), "Can't remove quantity!")

   local item = actor:expect(prism.components.Item)
   if count == 1 and not item.stackable then return self:removeItem(actor) end
   if count == item.stackCount then return self:removeItem(actor) end

   local newActor = item:split(count)
   self:updateLimits()
   return newActor
end

function Inventory:updateLimits()
   self.totalCount = 0
   self.totalVolume = 0
   self.totalWeight = 0

   for _, item in self:query(prism.components.Item):iter() do
      --- @cast item Item
      self.totalCount = self.totalCount + 1
      self.totalVolume = self.totalVolume + item:getVolume()
      self.totalWeight = self.totalWeight + item:getWeight()
   end
end



return Inventory