---@class ActionDecision : Decision
---@field actor Actor
---@field action Action|nil
local ActionDecision = prism.Decision:extend("ActionDecision")

--- @param actor Actor
function ActionDecision:__new(actor)
   self.actor = actor
end

function ActionDecision:validateResponse()
   return self.action ~= nil
end

function ActionDecision:setAction(action)
   self.action = action
end

return ActionDecision