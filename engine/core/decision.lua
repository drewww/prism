--- The decision is the primary way in which the game interacts with the interface.
--- The Level will yield Decisions whenever it needs something to be decided by the
--- player. The interface will then construct a response with a handler.
--- @class Decision : Message
--- @field actor Actor
--- @overload fun(): Decision
local Decision = prism.Message:extend("Decision")

function Decision:validateResponse()
   assert("You must overwrite validateResponse in your Decision!")
end

return Decision
