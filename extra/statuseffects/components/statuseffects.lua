--- @alias StatusEffectsHandle integer

--- @class StatusEffects : Component
--- @field instances SparseArray
--- @field modifierMap table<StatusEffectsModifier, StatusEffectsModifier[]>
--- @overload fun(): StatusEffects
local StatusEffects = prism.Component:extend "StatusEffects"

function StatusEffects:__new()
   self.instances = prism.SparseArray()
   self.modifierMap = {}
end

--- @param instance StatusEffectsInstance
--- @return StatusEffectsHandle handle
function StatusEffects:add(instance)
   local handle = self.instances:add(instance)

   for _, modifier in ipairs(instance.modifiers) do
      local meta = getmetatable(modifier)

      if not self.modifierMap[meta] then
         self.modifierMap[meta] = {}
      end

      table.insert(self.modifierMap[meta], modifier)
   end

   return handle
end

--- @param handle StatusEffectsHandle
function StatusEffects:remove(handle)
   local instance = self.instances:get(handle)
   --- @cast instance StatusEffectsInstance

   -- Remove modifiers from global map/set
   for _, modifier in ipairs(instance.modifiers) do
      local meta = getmetatable(modifier)
      local list = self.modifierMap[meta]

      if list then
         for i = #list, 1, -1 do
            if list[i] == modifier then
               table.remove(list, i)
               break
            end
         end
         if #list == 0 then
            self.modifierMap[meta] = nil
         end
      end
   end

   self.instances:remove(handle)
end

--- @param prototype StatusEffectsModifier
--- @return StatusEffectsModifier[]?
function StatusEffects:getModifiersByMeta(prototype)
   return self.modifierMap[prototype]
end

--- @param handle StatusEffectsHandle
--- @return StatusEffectsInstance instance
function StatusEffects:getInstance(handle)
   return self.instances:get(handle)
end

--- @return fun():(StatusEffectsHandle, StatusEffectsInstance)
function StatusEffects:pairs()
   return self.instances:pairs()
end

--- @class StatusEffectsInstanceOptions
--- @field modifiers StatusEffectsModifier[]

--- @class StatusEffectsInstance : Object
--- @field modifiers StatusEffectsModifier[]
--- @field modifierMap table<StatusEffectsModifier, StatusEffectsModifier[]>
local StatusEffectsInstance = prism.Object:extend "StatusEffectsInstance"

function StatusEffectsInstance:__new(options)
   self.modifiers = options.modifiers
   self.modifierMap = {}

   for _, modifier in ipairs(self.modifiers) do
      local meta = getmetatable(modifier)
      if not self.modifierMap[meta] then
         self.modifierMap[meta] = {}
      end

      table.insert(self.modifierMap[meta], modifier)
   end
end

--- @param modifierMeta table
--- @return StatusEffectsModifier[]?
function StatusEffectsInstance:getModifiersByMeta(modifierMeta)
   return self.modifierMap[modifierMeta]
end


--- @class StatusEffectsModifier : Object
local StatusEffectsModifier = prism.Object:extend "StatusEffectsModifier"

StatusEffects.Modifier = StatusEffectsModifier
StatusEffects.Instance = StatusEffectsInstance

print "YAYETT"
return StatusEffects