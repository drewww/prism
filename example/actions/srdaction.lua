---@class SRDAction : Action
---@field name string
---@field silent boolean
---@field targets table<Target>
local SRDAction = prism.Action:extend("SRDAction")
SRDAction.name = "SRDAction"
SRDAction.silent = true
SRDAction.stripName = false

function SRDAction:movePointCost(level, actor)
   return 0
end

function SRDAction:actionSlot(level, actor)
   return "Action"
end

function SRDAction:canPerform(level, actor)
   local SRDStatsComponent = actor:getComponent(prism.components.SRDStats)
   ---@cast SRDStatsComponent SRDStatsComponent

   if SRDStatsComponent then
      local moveCost = self:movePointCost(level, actor)
      local actionSlot = self:actionSlot(level, actor)

      if SRDStatsComponent.curMovePoints < moveCost then
         return false
      end

      if actionSlot and not SRDStatsComponent.actionSlots[actionSlot] then
         return false
      end
   end

   return true
end

return SRDAction