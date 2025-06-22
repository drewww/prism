--- @class Item : Component
--- @field private weight number
--- @field private volume number
--- @field stackable false|fun(...): Actor
--- @overload fun(options: ItemOptions): Item
local Item = prism.Component:extend( "Item" )
Item.weight = 0
Item.volume = 0
Item.stackable = false
Item.stackCount = nil
Item.stacklimit = nil

--- @alias ItemOptions { weight?: number, volume?: number, stackable?: ActorFactory|boolean, stackLimit: number|nil }

--- @param options ItemOptions
function Item:__new(options)
   if not options then return end

   self.weight = options.weight or 0
   self.volume = options.volume or 0
   self.stackable = options.stackable or false
   self.stackCount = options.stackable and 1 or nil
   self.stackLimit = options.stackable and options.stackLimit or math.huge
end

function Item:canStack(actor)
   local otherItem = actor:expect(prism.components.Item)
   if not self.stackable or not otherItem.stackable then return false end
   if self.stackable ~= otherItem.stackable then return false end

   if (self.stackCount + otherItem.stackCount) > self.stackLimit then
      return false
   end

   return true
end

--- @param actor Actor
function Item:stack(actor)
   local item = actor:expect(prism.components.Item)

   assert(self.stackable == item.stackable)
   local numToStack = math.min(item.stackCount, self.stackLimit - self.stackCount)
   item.stackCount = item.stackCount - numToStack
   self.stackCount = self.stackCount + numToStack
end

--- @param count integer
function Item:split(count)
   if count == 1 and not self.stackable then return self.owner end

   assert(self.stackable, "Can't split a non-stackable item")
   assert(count > 1 and count < self.stackCount, "Split count must be less than current stackCount")

   self.stackCount = self.stackCount - count

   local newActor = self.stackable()
   local newItem = newActor:expect(prism.components.Item)
   newItem.stackCount = count

   return newActor
end

function Item:getWeight()
   return self.weight * self.stackCount
end

function Item:getVolume()
   return self.volume * self.stackCount
end

return Item