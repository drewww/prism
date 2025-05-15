--- @class SensesSystem : System
local SensesSystem = prism.System:extend("SensesSystem")
SensesSystem.name = "Senses"

function SensesSystem:onTurn(level, actor)
   if actor:hasComponent(prism.components.PlayerController) then return end
   self:triggerRebuild(level, actor)
end

function SensesSystem:postInitialize(level)
   for actor, _ in level:query(prism.components.Senses):iter() do
      self:triggerRebuild(level, actor)
   end
end

---@param level Level
---@param event Message
function SensesSystem:onYield(level, event)
   for actor in level:query(prism.components.Senses):iter() do
      if actor:getComponent(prism.components.PlayerController) then self:triggerRebuild(level, actor) end
   end
end

function SensesSystem:triggerRebuild(level, actor)
   local sensesComponent = actor:getComponent(prism.components.Senses)
   if not sensesComponent then return end

   sensesComponent.cells = prism.SparseGrid()

   level:trigger("onSenses", level, actor)

   for x, y, cell in sensesComponent.cells:each() do
      sensesComponent.explored:set(x, y, cell)
   end
end

return SensesSystem
