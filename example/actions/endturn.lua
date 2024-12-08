---@class EndTurnAction : Action
---@field name string
---@field silent boolean
---@field targets table<Target>
local EndTurn = prism.Action:extend("EndTurnAction")
EndTurn.name = "end turn"
EndTurn.silent = true

function EndTurn:perform(level)
end

return EndTurn
