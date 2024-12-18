local PathfindBehavior = require "example_srd.behaviors.pathfind"

return prism.BehaviorTree.Root {
   prism.BehaviorTree.Sequence {
      prism.BehaviorTree.Node(function(_, level, actor, controller)
         local senses = actor:getComponent(prism.components.Senses)
         local stats = actor:getComponent(prism.components.SRDStats)

         if not stats or not senses then return false end

         local candidate
         local candidateDistance = math.huge
         for sensedActor in senses.actors:eachActor() do
            if actor ~= sensedActor then
               local range = actor:getRange(prism._defaultDistance, sensedActor)
               if range < candidateDistance then
                  candidate = sensedActor
                  candidateDistance = range
               end
            end
         end

         if candidate then
            controller.blackboard.melee_target = candidate
            return true
         end

         return false
      end),
      PathfindBehavior(function(_, _, controller) return controller.blackboard.melee_target:getPosition() end, 1),
      prism.BehaviorTree.Node(function(_, level, actor, controller)
         local attackAction = actor:getAction(prism.actions.Attack)
         if not attackAction then return false end

         local stats = actor:getComponent(prism.components.SRDStats)
         local weapon = stats.attacks:get(1)

         local attackInstance = attackAction(actor, {weapon, controller.blackboard.melee_target})
         if attackInstance:canPerform(level) then
            return attackInstance
         end

         return false
      end)
   },
   prism.BehaviorTree.Node(function ()
      return prism.actions.EndTurn()
   end)
}