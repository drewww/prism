---@class prism.decisions.ActionDecision : prism.Decision
---@field actor prism.Actor
---@field action prism.Action|nil
local ActionDecision = prism.Decision:extend("ActionDecision")

--- @param actor prism.Actor
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
