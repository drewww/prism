--- Generates points for an ellipse on a grid using the Vector2 class.
--- @param center Vector2 The center of the ellipse.
--- @param rx number The radius along the x-axis.
--- @param ry number The radius along the y-axis.
--- @param callback fun(x: number, y: number) Function to call for each ellipse point.
return function(center, rx, ry, callback)
   local rx2 = rx * rx
   local ry2 = ry * ry

   local x = 0
   local y = ry
   local px = 0
   local py = 2 * rx2 * y

   local p1 = ry2 - (rx2 * ry) + (0.25 * rx2)
   while px < py do
       for fillY = -y, y do
           callback(center.x + x, center.y + fillY)
           callback(center.x - x, center.y + fillY)
       end

       x = x + 1
       px = px + 2 * ry2
       if p1 < 0 then
           p1 = p1 + ry2 + px
       else
           y = y - 1
           py = py - 2 * rx2
           p1 = p1 + ry2 + px - py
       end
   end

   local p2 = ry2 * (x + 0.5) * (x + 0.5) + rx2 * (y - 1) * (y - 1) - rx2 * ry2
   while y >= 0 do
       for fillY = -y, y do
           callback(center.x + x, center.y + fillY)
           callback(center.x - x, center.y + fillY)
       end

       y = y - 1
       py = py - 2 * rx2
       if p2 > 0 then
           p2 = p2 + rx2 - py
       else
           x = x + 1
           px = px + 2 * ry2
           p2 = p2 + rx2 - py + px
       end
   end
end