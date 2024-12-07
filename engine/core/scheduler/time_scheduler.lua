local function sortFunction(a, b)
    if a.time == b.time then return a.lastAct < b.lastAct end
    return a.time < b.time
end
 
local function insertSorted(list, value)
    local left = 1
    local right = #list
    local mid
 
    while left <= right do
       mid = math.floor((left + right) / 2)
       if sortFunction(value, list[mid]) then
          right = mid - 1
       else
          left = mid + 1
       end
    end
 
    table.insert(list, left, value)
end

--- The 'TimeScheduler' manages a queue of actors and schedules their actions.
--- This default implementation is a time based system, but if you don't modify action
--- time it will just work as a standard 'initiative' style system where each actor takes
--- it's turn in order. You can extend this class and pass it into Level to implement a custom
--- TimeScheduler. You can extend TimeScheduler and modify it's implementation according to the needs
--- of your game.
--- @class TimeScheduler : Object
--- @field queue table The queue of actors waiting to take their actions.
--- @field actCount number The total number of actions taken. This is used for breaking ties.
--- @field time number The total time the has elapsed since the TimeScheduler was constructed.
--- @overload fun(): TimeScheduler
--- @type TimeScheduler
local TimeScheduler = prism.Object:extend("TimeScheduler")

--- Constructor for the TimeScheduler class.
--- Initializes an empty queue and sets the actCount to 0.
function TimeScheduler:__new()
   self.queue = {}
   self.actCount = 0
   self.time = 0
end

--- Adds an actor to the TimeScheduler.
--- @param actor Actor|string The actor, or special tick, to add.
--- @param time number|nil The current time of the actor, can be omitted for new actors.
--- @param lastAct number|nil The time of the actor's last action, can be omitted for new actors.
function TimeScheduler:add(actor, time, lastAct)
   local schedTable = {
      actor = actor,
      time = time or 0,
      lastAct = lastAct or 0,
   }

   insertSorted(self.queue, schedTable)
end

--- Removes an actor from the TimeScheduler.
--- @param actor Actor The actor to remove.
function TimeScheduler:remove(actor)
   for i, schedTable in ipairs(self.queue) do
      if schedTable.actor == actor then
         table.remove(self.queue, i)
         return
      end
   end
end

--- Checks if an actor is in the TimeScheduler.
--- @param actor Actor The actor to check.
--- @return boolean hasActor True if the actor is in the TimeScheduler, false otherwise.
function TimeScheduler:has(actor)
   for i, schedTable in ipairs(self.queue) do
      if schedTable.actor == actor then return true end
   end

   return false
end

--- Adds time to an actor's current time in the TimeScheduler.
--- @param actor Actor|string The actor, or special tick, whose time to add.
--- @param time number The amount of time to add.
function TimeScheduler:addTime(actor, time)
   for i, schedTable in ipairs(self.queue) do
      if schedTable.actor == actor then
         schedTable.time = schedTable.time + time
         -- Re-insert the updated schedTable into the sorted queue
         table.remove(self.queue, i)
         insertSorted(self.queue, schedTable)
         return
      end
   end

   error "Attempted to add time to an actor not in the TimeScheduler!"
end

--- Returns the next actor to act.
--- @return Actor next The actor who is next to act.
function TimeScheduler:next()
   self.actCount = self.actCount + 1
   self.queue[1].lastAct = self.actCount
   self:updateTime(self.queue[1].time)

   return self.queue[1].actor
end

--- Provides a string representation of the TimeScheduler, listing all actors in the queue with their time and lastAct.
--- @return string string The string representation of the TimeScheduler.
function TimeScheduler:__tostring()
   local concat = {}
   for i, schedTable in ipairs(self.queue) do
      table.insert(
         concat,
         schedTable.actor.name .. " " .. schedTable.time .. " " .. schedTable.lastAct
      )
   end

   return table.concat(concat, "\n")
end

--- Updates the time for all actors in the TimeScheduler.
--- @param time number The amount of time to subtract from each actor's current time.
function TimeScheduler:updateTime(time)
   for _, schedTable in ipairs(self.queue) do
      schedTable.time = schedTable.time - time
   end
   self.time = self.time + time
end


function TimeScheduler:timestamp()
    return self.time
end

return TimeScheduler
