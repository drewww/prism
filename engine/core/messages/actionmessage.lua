---@class ActionMessage : prism.Message
---@field actor prism.Actor
local ActionMessage = prism.Message:extend("ActionMessage")

--- @param action prism.Action
function ActionMessage:__new(action)
   self.action = action
end

return ActionMessage
