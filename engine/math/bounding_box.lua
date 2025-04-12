--- @class BoundingBox : Object
--- @overload fun(x: integer, y: integer, i: integer, j:integer): BoundingBox
local BoundingBox = prism.Object:extend("BoundingBox")

function BoundingBox:__new(x, y, i, j)
   assert(x <= i, "x must be less than or equal to i")
   assert(y <= j, "y must be less than or equal to j")

   self.x = x
   self.y = y
   self.i = i
   self.j = j
end

function BoundingBox:getWidth() return self.i - self.x + 1 end

function BoundingBox:getHeight() return self.j - self.y + 1 end

function BoundingBox:contains(x, y)
   return x >= self.x and x <= self.i and y >= self.y and y <= self.j
end

function BoundingBox:intersects(other)
   return not (self.i < other.x or self.x > other.i or self.j < other.y or self.y > other.j)
end

function BoundingBox:union(other)
   local x = math.min(self.x, other.x)
   local y = math.min(self.y, other.y)
   local i = math.max(self.i, other.i)
   local j = math.max(self.j, other.j)
   return BoundingBox(x, y, i, j)
end

function BoundingBox:__tostring()
   return string.format("BoundingBox(x=%d, y=%d, i=%d, j=%d)", self.x, self.y, self.i, self.j)
end

return BoundingBox
