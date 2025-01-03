--- Generates points for an ellipse on a grid using the Vector2 class.
--- @param center Vector2 The center of the ellipse.
--- @param rx number The radius along the x-axis.
--- @param ry number The radius along the y-axis.
--- @param callback fun(x: number, y: number) Function to call for each ellipse point.
return function(center, rx, ry, callback)
   for y = center.y - ry, center.y + ry do
      for x = center.x - rx, center.x + rx do
         local rx, ry = rx + 0.5, ry + 0.5
         if ((x - center.x)^2 / (rx^2) + (y - center.y)^2 / (ry^2)) <= 1 then
            callback(x, y)
         end
      end
   end
end