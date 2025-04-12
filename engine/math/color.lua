---@class Color4 : Object
---@field private r number The red component (0-1).
---@field private g number The green component (0-1).
---@field private b number The blue component (0-1).
---@field private a number The alpha component (0-1).
---@overload fun(r: number, g: number, b: number, a: number): Color4
---@type Color4
local Color4 = prism.Object:extend("Color4")

--- Constructor for Color4 accepts red, green, blue, and alpha values.
---@param r number The red component (0-1).
---@param g number The green component (0-1).
---@param b number The blue component (0-1).
---@param a number The alpha component (0-1).
function Color4:__new(r, g, b, a)
   self.r = r or 0
   self.g = g or 0
   self.b = b or 0
   self.a = a or 1  -- Default alpha to 1 (fully opaque)
end

--- Constructor for Color4 that accepts a hexadecimal number.
--- @param hex number A hex number representing a color, e.g. 0xFFFFFF. Alpha is optional and defaults to 1.
function Color4.fromHex(hex)
   local hasAlpha = #string.format("%x", hex) > 6

   local a = bit.band(bit.rshift(hex, 0), 0xff) / 0xff
   local b = bit.band(bit.rshift(hex, hasAlpha and 8 or 0), 0xff) / 0xff
   local g = bit.band(bit.rshift(hex, hasAlpha and 16 or 8), 0xff) / 0xff
   local r = bit.band(bit.rshift(hex, hasAlpha and 24 or 16), 0xff) / 0xff

   return Color4(r, g, b, hasAlpha and a or 1)
end

--- Returns a copy of the color.
---@return Color4 A copy of the color.
function Color4:copy()
   return Color4(self.r, self.g, self.b, self.a)
end

--- Linearly interpolates between two colors.
---@param target Color4 The target color.
---@param t number A value between 0 and 1, where 0 is this color and 1 is the target color.
---@return Color4 The interpolated color.
function Color4:lerp(target, t)
   return Color4(
      self.r + (target.r - self.r) * t,
      self.g + (target.g - self.g) * t,
      self.b + (target.b - self.b) * t,
      self.a + (target.a - self.a) * t
   )
end

--- Multiplies the color's components by a scalar.
---@param scalar number The scalar value.
---@return Color4 The scaled color.
function Color4.__mul(self, scalar)
   return Color4(self.r * scalar, self.g * scalar, self.b * scalar, self.a * scalar)
end

--- Adds two colors together.
---@param a Color4 The first color.
---@param b Color4 The second color.
---@return Color4 The sum of the two colors.
function Color4.__add(a, b)
   return Color4(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
end

--- Subtracts one color from another.
---@param a Color4 The first color.
---@param b Color4 The second color.
---@return Color4 The difference of the two colors.
function Color4.__sub(a, b)
   return Color4(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
end

--- Negates the color's components.
---@return Color4 The negated color.
function Color4.__unm(self)
   return Color4(-self.r, -self.g, -self.b, -self.a)
end

--- Checks equality between two colors.
---@param a Color4 The first color.
---@param b Color4 The second color.
---@return boolean True if the colors are equal, false otherwise.
function Color4.__eq(a, b)
   return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
end

--- Creates a string representation of the color.
---@return string The string representation.
function Color4:__tostring()
   return string.format("r: %.2f, g: %.2f, b: %.2f, a: %.2f", self.r, self.g, self.b, self.a)
end

--- Returns the components of the color as numbers.
---@return number r, number g, number b, number a The components of the color.
function Color4:decompose()
   return self.r, self.g, self.b, self.a
end

--- Clamps the components of the color between 0 and 1.
---@return Color4 The clamped color.
function Color4:clamp()
   return Color4(
      math.min(1, math.max(0, self.r)),
      math.min(1, math.max(0, self.g)),
      math.min(1, math.max(0, self.b)),
      math.min(1, math.max(0, self.a))
   )
end

--- Predefined colors
Color4.BLACK = Color4(0, 0, 0, 1)
Color4.WHITE = Color4(1, 1, 1, 1)
Color4.RED = Color4(1, 0, 0, 1)
Color4.GREEN = Color4(0, 1, 0, 1)
Color4.BLUE = Color4(0, 0, 1, 1)
Color4.TRANSPARENT = Color4(0, 0, 0, 0)

return Color4
