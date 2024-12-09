--- @class SRDStatsComponent : Component
--- @field stats table<string, boolean>
--- @field movePoints integer
--- @field curMovePoints integer
--- @field naturalAC integer
--- @field HP integer
local SRDStats = prism.Component:extend( "SRDStatsComponent" )
SRDStats.name = "Move"

SRDStats.actions = {
   prism.actions.EndTurn,
   prism.actions.Move,
   prism.actions.Attack
}

local statsRequired = {
   STR = true,
   DEX = true,
   CON = true,
   WIS = true,
   CHA = true,
   INT = true
}

local actionSlots = {
   "Action",
   "BonusAction",
   "FreeAction"
}

function SRDStats:__new(options)
   assert(options.stats)
   for stat, _ in pairs(statsRequired) do
      assert(options.stats[stat])
   end
   
   self.maxHP = options.maxHP or 10
   self.HP = self.maxHP 
   self.naturalAC = (options.naturalAC or 10)
   self.stats = options.stats
   self.movePoints = options.movePoints
   self.curMovePoints = options.movePoints
   self.actionSlots = {
      Action = true,
      BonusAction = true,
      ObjectInteraction = true
   }
end

function SRDStats:resetOnTurn()
   self.curMovePoints = self.movePoints

   for _, slot in ipairs(actionSlots) do
      self.actionSlots[slot] = true
   end
end

return SRDStats
