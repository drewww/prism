local handlers = {}

---@param spectrum Spectrum
---@param message ActionMessage
handlers[prism.actions.Move] = function (spectrum, message)
   local t = 0
   local maxT = 0.15
   return function(dt)
      t = t + dt
      local lerpFactor = t/maxT
      local actor = message.action.owner
      local lastPos = message.action.previousPosition

      local curPos = actor:getPosition()

      local lerpPos = lastPos:lerp(curPos, lerpFactor * lerpFactor)
      local spriteQuad = spectrum.spriteAtlas:getQuadByIndex(string.byte(actor.char) + 1)
      love.graphics.draw(spectrum.spriteAtlas.image, spriteQuad, lerpPos.x * 16, lerpPos.y * 16)

      return maxT <= t, {actor}
   end
end

---@param spectrum Spectrum
---@param message ActionMessage
handlers[prism.actions.Attack] = function (spectrum, message)
   local t = 0
   local maxT = 0.15
   return function(dt)
      t = t + dt
      local target = message.action:getTarget(2)
      local targetPosition = target:getPosition()
      
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(1, 0, 0, 1)
      local spriteQuad = spectrum.spriteAtlas:getQuadByIndex(string.byte(target.char) + 1)
      love.graphics.draw(spectrum.spriteAtlas.image, spriteQuad, targetPosition.x * 16, targetPosition.y * 16)
      love.graphics.setColor(r, g, b, a)
      return maxT<=t, {target}
   end
end

return handlers