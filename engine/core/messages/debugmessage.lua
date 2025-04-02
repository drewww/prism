---@class DebugMessage : prism.Message
---@field message string A human readable message for why we stopped her.
local ActionMessage = prism.Message:extend "DebugMessage"

--- @param message string
function ActionMessage:__new(message)
   self.message = message
end

return ActionMessage
