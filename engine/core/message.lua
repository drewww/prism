--- The decision is the primary way in which the game interacts with the interface.
--- The Level will yield Decisions whenever it needs something to be decided by
--- @class prism.Message : prism.Object
--- @overload fun(): prism.Message
--- @type prism.Message
local Message = prism.Object:extend("Message")
return Message
