---@class APAction : Action
---@field name string
---@field silent boolean
---@field targets table<Target>
local APAction = prism.Action:extend("APAction")
APAction.name = "APAction"
APAction.silent = true
APAction.movePointCost = 0
APAction.actionPointCost = 0

function APAction:canPerform(actor)
   if self.movePointCost > 0 then
      local moveComponent = actor:getComponent(prism.components.Move)
      if not moveComponent then return false end
   end
end

return APAction
