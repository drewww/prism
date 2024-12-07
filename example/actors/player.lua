--- @class PlayerActor : Actor
local Player = prism.Actor:extend("PlayerActor")
Player.name = "Player"
Player.char = "@"

Player.components = {
   prism.components.Collider(),
   prism.components.PlayerController(),
   prism.components.Senses(),
   prism.components.Sight { range = 10, fov = true },
   prism.components.Move { movePoints = 5 },
}

return Player
