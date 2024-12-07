---@class ActionDecision : Decision
---@field actor Actor
local ActionDecision = prism.Decision:extend("ActionDecision")

--- @param actor Actor
function ActionDecision:__new(actor)
   self.actor = actor
end