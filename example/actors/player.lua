--- @class PlayerActor : Actor
local Player = prism.Actor:extend("PlayerActor")
Player.name = "Player"
Player.char = "@"

Player.components = {
   prism.components.Collider(),
   prism.components.PlayerController(),
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

return Player
