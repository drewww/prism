---@type SRDAction
local SRDAction = require "example.actions.srdaction"

local AttackTarget = prism.Target:extend("PointTarget")
AttackTarget.typesAllowed = { Actor = true }
AttackTarget.range = 1

---@param owner Actor
---@param targetObject Actor
function AttackTarget:validate(owner, targetObject)
   --- TODO: Dynamic range check goes here
   return targetObject:hasComponent(prism.components.SRDStats)
end

---@class AttackAction : SRDAction
---@field name string
---@field silent boolean
---@field targets table<Target>
local Attack = SRDAction:extend("AttackAction")
Attack.name = "attack"
Attack.silent = true
Attack.targets = { AttackTarget }
Attack.stripName = true

function Attack:movePointCost(level, actor)
   return 0
end

function Attack:actionSlot()
   return "Action"
end

function Attack:perform(level)
   --- @type Actor
   local attackTarget = self:getTarget(1)

   local ownerStats = self.owner:getComponent(prism.components.SRDStats)
   local targetStats = attackTarget:getComponent(prism.components.SRDStats)

   local attackRoll = ownerStats.stats.STR + level.RNG:random(1, 20)
   if attackRoll >= targetStats.naturalAC then
      local damageRoll = ownerStats.stats.STR + level.RNG:random(1, 6)
      targetStats.HP = targetStats.HP - damageRoll

      if targetStats.HP < 0 then
         print "HE DEAD"
         level:removeActor(attackTarget)
      end
   end
end

return Attack
