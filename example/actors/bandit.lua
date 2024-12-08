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
   prism.components.Move { movePoints = 10 },
}

return Bandit
