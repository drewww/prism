--- @class PlayerActor : Actor
local Player = prism.Actor:extend("PlayerActor")
Player.name = "Player"
Player.char = "@"

Player.components = {
   prism.components.Collider(),
   prism.components.PlayerController(),
   prism.components.Senses(),
   prism.components.Sight { range = 10, fov = true },
   prism.components.Move { movePoints = 10 },
   prism.components.ActionPoint { actionPoints = 1 }
}

return Player
