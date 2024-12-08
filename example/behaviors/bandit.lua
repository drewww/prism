return prism.BehaviorTree.Root {
   prism.BehaviorTree.Selector {
      prism.BehaviorTree.Node(function(level, actor)
         local sensesComponent = actor:getComponent(prism.components.Senses)
         if not sensesComponent then return false end

         local minDistance = math.huge
         local targetActor
         for potentialTarget in sensesComponent.actors:eachActor() do
            local playerController = actor:getComponent(prism.components.PlayerController)
            if playerController then
               local distance = actor:getRange("chebyshev", potentialTarget)

               if distance < minDistance then
                  targetActor = potentialTarget
               end
            end
         end
      end),
      --prism.behaviors.Pathfind(targetActor:getPosition())
   }
}