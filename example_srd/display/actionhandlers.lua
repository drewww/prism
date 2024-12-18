local handlers = {}

---@param spectrum Spectrum
---@param message ActionMessage
handlers[prism.actions.Move] = function (spectrum, message)
   local t = 0
   local maxT = 0.15
   local cSx, cSy = spectrum.cellSize.x, spectrum.cellSize.y
   return function(dt)
      t = t + dt
      local lerpFactor = t/maxT

      local action = message.action
      --- @cast action MoveAction
      local actor = action.owner
      local lastPos = action.previousPosition

      local curPos = actor:getPosition()

      local lerpPos = lastPos:lerp(curPos, lerpFactor * lerpFactor)
      local spriteQuad = spectrum.spriteAtlas:getQuadByIndex(string.byte(actor.char) + 1)
      love.graphics.draw(spectrum.spriteAtlas.image, spriteQuad, lerpPos.x * cSx, lerpPos.y * cSy)

      return maxT <= t, {actor}
   end
end

---@param spectrum Spectrum
---@param message ActionMessage
handlers[prism.actions.Attack] = function (spectrum, message)
   local t = 0
   local maxT = 0.15
   local cSx, cSy = spectrum.cellSize.x, spectrum.cellSize.y
   return function(dt)
      t = t + dt
      local target = message.action:getTarget(2)
      local targetPosition = target:getPosition()
      
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(1, 0, 0, 1)
      local spriteQuad = spectrum.spriteAtlas:getQuadByIndex(string.byte(target.char) + 1)
      love.graphics.draw(spectrum.spriteAtlas.image, spriteQuad, targetPosition.x * cSx, targetPosition.y * cSy)
      love.graphics.setColor(r, g, b, a)
      return maxT<=t, {target}
   end
end

return handlers