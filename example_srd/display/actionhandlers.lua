local handlers = {}

---@param display Display
---@param message ActionMessage
handlers[prism.actions.Move] = function (display, message)
   local t = 0
   local maxT = 0.15
   return function(dt)
      t = t + dt
      local lerpFactor = t/maxT

      local action = message.action
      --- @cast action MoveAction
      local actor = action.owner
      local lastPos = action.previousPosition
      local curPos = actor:getPosition()
      local lerpPos = lastPos:lerp(curPos, lerpFactor * lerpFactor)
      display:drawActor(actor, 1, lerpPos.x, lerpPos.y)

      return maxT <= t, {actor}
   end
end

---@param display Display
---@param message ActionMessage
handlers[prism.actions.Attack] = function (display, message)
   local t = 0
   local maxT = 0.15
   return function(dt)
      t = t + dt
      local target = message.action:getTarget(2)      
      love.graphics.setColor(1, 0, 0, 1)
      display:drawActor(target, 1, nil, nil, prism.Color4(1, 0, 0, 1))

      return maxT<=t, {target}
   end
end

return handlers