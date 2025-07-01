Carving out caverns
===================

In this section of the tutorial we'll create a more interesting place to kick kobolds,
and put some in the game world to start. 

Getting started on a map
------------------------

Let's create a new file in the root of the project called ``levelgen.lua``. We're gonna want to
return a function from this module that takes a few parameters.

.. code:: lua

   --- @param rng RNG
   --- @param player Actor
   --- @param width integer
   --- @param height integer
   return function(rng, player, width, height)
      local builder = prism.MapBuilder(prism.cells.Wall)
      return builder
   end

We give the level building function an RNG which will be exclusive to it, the player we want to place, and
the width and height of the map we want generated. Inside we create a MapBuilder and return it.

Populating the void
-------------------

The first step is going to be filling the void with a width * height initialization of pits and walls. To
decide where to put what we're going to use perlin noise.

.. code:: lua

    -- Fill the map with random noise of pits and walls.
   local nox, noy = rng:getUniformInt(1, 10000), rng:getUniformInt(1, 10000)
   for x = 1, width do
      for y = 1, height do
         local noise = love.math.perlinNoise(x / 5 + nox, y / 5 + noy)
         local cell = noise > 0.5 and prism.cells.Wall or prism.cells.Pit
         builder:set(x, y, cell())
      end
   end

First we generate an offset for the noise using our RNG. This ensures every map gets a unique pattern of
pits and walls.

Then we loop through each tile in the map, grab our result from the perlinNoise which we scale a little bit,
and finally check if the noise is > 0.5. If it is we put a wall there, and if it's not we place a pit.


Making room
-----------

.. code:: lua

   -- Create rooms in each of the partitions.
   --- @type table<number, Rectangle>
   local rooms = {}

   local missing = prism.Vector2(rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1))
   local pw, ph = math.floor(width / PARTITIONS), math.floor(height / PARTITIONS)
   local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
   local maxrw, maxrh = pw - 2, ph - 2 -- Subtract 2 to ensure there's a margin.
   for px = 0, PARTITIONS - 1 do
      for py = 0, PARTITIONS - 1 do
         if missing ~= prism.Vector2(px, py) then
            local rw, rh = rng:getUniformInt(minrw, maxrw), rng:getUniformInt(minrh, maxrh)
            local x = rng:getUniformInt(px * pw + 1, (px + 1) * pw - rw - 1)
            local y = rng:getUniformInt(py * ph + 1, (py + 1) * ph - rh - 1)

            local roomRect = prism.Rectangle(x, y, rw, rh)
            rooms[prism.Vector2._hash(px, py)] = roomRect

            builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
         end
      end
   end

Okay so this is a little chunky, but we're gonna break it down. The first thing we do is decide which one of the partitions
we're going to omit a room in.

.. code:: lua

   local missing = prism.Vector2(rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1))

Then we're going to calculate the total width and height of our patitions.

.. code:: lua

   local pw, ph = math.floor(width / PARTITIONS), math.floor(height / PARTITIONS)

After that let's set some reasonable limits on the minimum and maximum room width and height.

.. code:: lua

   local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
   local maxrw, maxrh = pw - 2, ph - 2 -- Subtract 2 to ensure there's a margin.

Next we loop through each of our partitions and build a room so long as it's not the one we're omitting. We build our
room rectangle, hash it's partition coordinates, and put it into a dictionary of rooms. Finally we draw the room onto our map.

.. code:: lua

   for px = 0, PARTITIONS - 1 do
      for py = 0, PARTITIONS - 1 do
         if missing ~= prism.Vector2(px, py) then
            local rw, rh = rng:getUniformInt(minrw, maxrw), rng:getUniformInt(minrh, maxrh)
            local x = rng:getUniformInt(px * pw + 1, (px + 1) * pw - rw - 1)
            local y = rng:getUniformInt(py * ph + 1, (py + 1) * ph - rh - 1)

            local roomRect = prism.Rectangle(x, y, rw, rh)
            rooms[prism.Vector2._hash(px, py)] = roomRect

            builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
         end
      end
   end

Carving hallways
----------------

Next we're gonna create a function local function (yes, that's correct) to draw the classic Rogue style L shaped hallways between
rooms. It accepts two Rectangles representing the rooms, and if both a and b exist we draw a hallway between them. We use the level
generator's RNG to figure out if we should start vertically or horizontally for a little bit of spice.

.. code:: lua

   -- Helper function to connect two points with an L-shaped hallway.
   --- @param a Rectangle
   --- @param b Rectangle
   local function createLShapedHallway(a, b)
      if not a or not b then return end

      local ax, ay = a:center():floor():decompose()
      local bx, by = b:center():floor():decompose()
      -- Randomly choose one of two L-shaped tunnel patterns for variety.
      if rng:getUniform() > 0.5 then
         builder:drawLine(ax, ay, bx, ay, prism.cells.Floor)
         builder:drawLine(bx, ay, bx, by, prism.cells.Floor)
      else
         builder:drawLine(ax, ay, ax, by, prism.cells.Floor)
         builder:drawLine(ax, by, bx, by, prism.cells.Floor)
      end
   end

Now that we've got this little helper function done let's go through each room and try to connect it to the one to the right, and the
one to the bottom. If either doesn't exist the hallway helper won't get past the guard and nothing will happen.

.. code:: lua

   for hash, currentRoom in pairs(rooms) do
      local px, py = prism.Vector2._unhash(hash)

      createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px + 1, py)])
      createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px, py + 1)])
   end

Spawning people
---------------

Now to place the player. We'll select a random room and put the player on the center tile.

.. code:: lua

   -- Choose the first room (top-left partition) to place the player.
   local startRoom
   while not startRoom do
      local x, y = rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1)
      startRoom = rooms[prism.Vector2._hash(x, y)]
   end

   local playerPos = startRoom:center():floor()
   builder:addActor(player, playerPos.x, playerPos.y)

We're getting close now, but we need some kobolds to kick. Let's go through every room that's not the starting room and spawn
a kobold there.

.. code:: lua

   for _, room in pairs(rooms) do
      if room ~= startRoom then
         local cx, cy = room:center():floor():decompose()

         builder:addActor(prism.actors.Kobold(), cx, cy)
      end
   end

Okay, we've got the player and the kobolds spawning. Time to wrap things up.

Sending it back
--------------

.. code:: lua

   builder:addPadding(1, prism.cells.Wall)

   return builder

Finally we'll wrap the entire map in some walls and return the finished MapBuilder.

.. dropdown:: Complete levelgen.lua

   .. code:: lua

      local PARTITIONS = 3

      --- @param rng RNG
      --- @param player Actor
      --- @param width integer
      --- @param height integer
      return function(rng, player, width, height)
         local builder = prism.MapBuilder(prism.cells.Wall)

         -- Fill the map with random noise of pits and walls.
         local nox, noy = rng:getUniformInt(1, 10000), rng:getUniformInt(1, 10000)
         for x = 1, width do
            for y = 1, height do
               local noise = love.math.perlinNoise(x / 5 + nox, y / 5 + noy)
               local cell = noise > 0.5 and prism.cells.Wall or prism.cells.Pit
               builder:set(x, y, cell())
            end
         end

         -- Create rooms in each of the partitions.
         --- @type table<number, Rectangle>
         local rooms = {}

         local missing = prism.Vector2(rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1))
         local pw, ph = math.floor(width / PARTITIONS), math.floor(height / PARTITIONS)
         local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
         local maxrw, maxrh = pw - 2, ph - 2 -- Subtract 2 to ensure there's a margin.
         for px = 0, PARTITIONS - 1 do
            for py = 0, PARTITIONS - 1 do
               if missing ~= prism.Vector2(px, py) then
                  local rw, rh = rng:getUniformInt(minrw, maxrw), rng:getUniformInt(minrh, maxrh)
                  local x = rng:getUniformInt(px * pw + 1, (px + 1) * pw - rw - 1)
                  local y = rng:getUniformInt(py * ph + 1, (py + 1) * ph - rh - 1)

                  local roomRect = prism.Rectangle(x, y, rw, rh)
                  rooms[prism.Vector2._hash(px, py)] = roomRect

                  builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
               end
            end
         end

         -- Helper function to connect two points with an L-shaped hallway.
         --- @param a Rectangle
         --- @param b Rectangle
         local function createLShapedHallway(a, b)
            if not a or not b then return end

            local ax, ay = a:center():floor():decompose()
            local bx, by = b:center():floor():decompose()
            -- Randomly choose one of two L-shaped tunnel patterns for variety.
            if rng:getUniform() > 0.5 then
               builder:drawLine(ax, ay, bx, ay, prism.cells.Floor)
               builder:drawLine(bx, ay, bx, by, prism.cells.Floor)
            else
               builder:drawLine(ax, ay, ax, by, prism.cells.Floor)
               builder:drawLine(ax, by, bx, by, prism.cells.Floor)
            end
         end

         for hash, currentRoom in pairs(rooms) do
            local px, py = prism.Vector2._unhash(hash)

            createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px + 1, py)])
            createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px, py + 1)])
         end

         -- Choose the first room (top-left partition) to place the player.
         local startRoom
         while not startRoom do
            local x, y = rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1)
            startRoom = rooms[prism.Vector2._hash(x, y)]
         end

         local playerPos = startRoom:center():floor()
         builder:addActor(player, playerPos.x, playerPos.y)

         for _, room in pairs(rooms) do
            if room ~= startRoom then
               local cx, cy = room:center():floor():decompose()

               builder:addActor(prism.actors.Kobold(), cx, cy)
            end
         end

         builder:addPadding(1, prism.cells.Wall)

         return builder
      end

Updating GameLevelState
-------------------------

Head back to ``gamestates/gamelevelstate.lua`` and add the following line to the top of the file.

.. code:: lua

   local levelgen = require "levelgen"

Then we're going to change it's constructor. Head to ``GameLevelState:__new`` and let's replace the map
builder code there with this:

.. code:: lua

   local seed = tostring(os.time())
   local mapbuilder = levelgen(prism.RNG(seed), prism.actors.Player(), 60, 30)

Now run the game! You'll be exploring a totally sick classic Rogue style map with some caverns and pits all
around the room!

Descending to the next part
---------------------------

In the :doc:`next section <part8>` of the tutorial we'll add a set of stairs and let the player descend deeper into the dungeon!

