local BanditBehavior = require "example.behaviors.bandit"

--- @class BanditActor : Actor
local Bandit = prism.Actor:extend("BanditActor")
Bandit.name = "Bandit"
Bandit.char = "b"

Bandit.components = {
   prism.components.Collider(),
   prism.components.BTController(BanditBehavior),
   prism.components.Senses(),
   prism.components.Sight { range = 10, fov = true },
   prism.components.SRDStats {
      stats = {
         STR = 10,
         DEX = 10,
         CON = 10,
         WIS = 10,
         CHA = 10,
         INT = 10
      },
      movePoints = 6
   }
}

return Bandit
