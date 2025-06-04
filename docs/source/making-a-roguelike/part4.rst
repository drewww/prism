Writing Things Down
-------------------

In this chapter we'll add a message log, spruce up the user interface, and get some basic animations going.

Logging
-------

.. code:: lua  

   --- @class Log : Component
   local Log = prism.Component:extend("Log")

   function Log:__new()
      self.messages = prism.Queue()
   end

   function Log:iterLast(n)
      local q = self.messages
      local startIndex = q.last
      local endIndex = math.max(q.first, q.last - n + 1)
      local i = startIndex + 1

      return function()
         i = i - 1
         if i >= endIndex then
               return q.queue[i]
         end
      end
   end

   function Log.addMessage(actor, message)
      --- @type Log
      local log = actor:getComponent(Log)
      if not log then return end

      log.messages:push(message)

      if log.messages:size() > 32 then
         log.messages:pop()
      end
   end

   return Log

We create a really simple Log component that holds a queue of messages, up to a total of 32 before letting them fall off the end.
We define Log.addMessage as a static function that does the getComponent work for us, because it'll make it a lot easier to use
throughout the codebase. As an example:

.. code:: lua
   -- attack.lua
   local Log = prism.components.Log
   
   ...

   function Attack:_perform(level, target)
      -- blah blah

      Log.addMessage(self.owner, "You attack " .. target.name .. ".")
      Log.addMessage(target, self.owner.name .. " attacks you.")
   end

We'll want to add something similar to the end of Kick's _perform too:

.. code:: lua

   function Kick:_perform(level, kicked)
      -- blah blah

      Log.addMessage(kicked, self.owner.name .. " kicks you.")
      Log.addMessage(self.owner, "You kick " .. kicked.name .. ".")
   end

Finally we'll want to add the log to the player's components. I'll trust that you know where to put this component
by now.

.. code:: lua  

   -- Player:initialize
   prism.components.Log(),

Drawing the Log
---------------

Head back over to the MyGameLevelState:draw function, and right after where we're drawing the HP we're going to draw the log.

.. code:: lua  

   local log = actor:getComponent(prism.components.Log)
   if log then
      local count = 0
      for message in log:iterLast(16) do
         count = count + 1         
         local dh = self.display.height
         local yoffset = count
         self.display:putString(2, dh - yoffset - 1, message)
      end
   end

Let's break this down a little bit. Log's messages field is a Queue which tracks it's first and last index in the fields first and last.
We start at the last element in the queue, the most recent one and go up the list. We write out the last five most recent messages to 
the screen starting from the bottom of the screen moving up.

Okay we've got a message log working, but it's a bit ugly. Let's start making this a little more presentable.

