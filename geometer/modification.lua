---@class Modification : Object
---Represents a reversible modification that can be executed and undone.
---This class provides a base structure for implementing modifications with
---custom behavior for execution and undoing actions.
local Modification = prism.Object:extend "Modification"
geometer.Modification = Modification

---Executes the modification.
---Override this method in subclasses to define the behavior of the modification.
---@param level Level
function Modification:execute(level)
   -- Perform the modification.
end

---Undoes the modification.
---Override this method in subclasses to define how the modification is undone.
function Modification:undo()
   -- Revert the modification.
end