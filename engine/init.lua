--- We export a global namespace.
--- @module "prism"
prism = {}
prism.path = ...

function prism.require(p) return require(table.concat({ prism.path, p }, ".")) end

prism.json = prism.require "lib/json"

--- @type boolean
prism._initialized = false

prism._defaultDistance = "8way"
prism._defaultRangeType = "8way"

-- Root object

--- @type Object
prism.Object = prism.require "core.object"

-- Colors
--- @type Color4
prism.Color4 = prism.require "math.color"

-- Math
--- @type Vector2
prism.Vector2 = prism.require "math.vector"
--- @type BoundingBox
prism.BoundingBox = prism.require "math.bounding_box"

prism.neighborhood = prism.Vector2.neighborhood8

--- @param neighborhood Neighborhood
function prism.setDefaultNeighborhood(neighborhood)
   prism.neighborhood = neighborhood
end

-- Structures
--- @type SparseMap
prism.SparseMap = prism.require "structures.sparsemap"
--- @type SparseGrid
prism.SparseGrid = prism.require "structures.sparsegrid"
--- @type SparseArray
prism.SparseArray = prism.require "structures.sparsearray"
--- @type Grid
prism.Grid = prism.require "structures.grid"
--- @type BooleanBuffer
prism.BooleanBuffer = prism.require "structures.booleanbuffer"
--- @type Queue
prism.Queue = prism.require "structures.queue"
--- @type PriorityQueue
prism.PriorityQueue = prism.require "structures.priority_queue"

-- Algorithms
prism.fov = {}
prism.fov.Row = prism.require "algorithms.fov.row"
prism.fov.Quadrant = prism.require "algorithms.fov.quadrant"
prism.fov.Fraction = prism.require "algorithms.fov.fraction"
prism.computeFOV = prism.require "algorithms.fov.fov"

prism.Path = prism.require "algorithms.astar.path"

--- @alias PassableCallback fun(x: integer, y: integer):boolean
--- @alias CostCallback fun(x: integer, y: integer): integer
--- @type fun(start: Vector2, goal: Vector2, passableCallback: PassableCallback, costCallback: CostCallback?, minDistance: integer?): Path
prism.astar = prism.require "algorithms.astar.astar"

-- Core
--- @type Scheduler
prism.Scheduler = prism.require "core.scheduler.scheduler"
--- @type SimpleScheduler
prism.SimpleScheduler = prism.require "core.scheduler.simple_scheduler"
--- @type Action
prism.Action = prism.require "core.action"
--- @type Component
prism.Component = prism.require "core.component"
--- @type Actor
prism.Actor = prism.require "core.actor"
--- @type ActorStorage
prism.ActorStorage = prism.require "core.actorstorage"
--- @type Cell
prism.Cell = prism.require "core.cell"
--- @type RNG
prism.RNG = prism.require "core.rng"
--- @type System
prism.System = prism.require "core.system"
--- @type SystemManager
prism.SystemManager = prism.require "core.system_manager"
--- @type MapBuilder
prism.MapBuilder = prism.require "core.map_builder"
--- @type Map
prism.Map = prism.require "core.map"
--- @type Message
prism.Message = prism.require "core.message"
--- @type Decision
prism.Decision = prism.require "core.decision"
--- @type Target
prism.Target = prism.require "core.target"
--- @type Level
prism.Level = prism.require "core.level"

-- Behavior Tree

prism.BehaviorTree = {}

--- @type BTNode
prism.BehaviorTree.Node = prism.require "core.behavior_tree.btnode"
--- @type BTNode
prism.BehaviorTree.Root = prism.require "core.behavior_tree.btroot"
--- @type BTNode
prism.BehaviorTree.Selector = prism.require "core.behavior_tree.btselector"
--- @type BTSequence
prism.BehaviorTree.Sequence = prism.require "core.behavior_tree.btsequence"
--- @type BTSucceeder
prism.BehaviorTree.Succeeder = prism.require "core.behavior_tree.btsucceeder"


prism.actors = {}
prism.actions = {}
prism.components = {}
prism.cells = {}
prism.targets = {}
prism.messages = {}
prism.systems = {}
prism.messages = {}
prism.decisions = {}
prism.behaviors = {}

--- @type SensesSystem
prism.systems.Senses = prism.require "core.systems.senses"

--- @type ColliderComponent
prism.components.Collider = prism.require "core.components.collider"

--- @type ControllerComponent
prism.components.Controller = prism.require "core.components.controller"

--- @type BTControllerComponent
prism.components.BTController = prism.require "core.components.btcontroller"

--- @type PlayerControllerComponent
prism.components.PlayerController = prism.require "core.components.player_controller"

--- @type SensesComponent
prism.components.Senses = prism.require "core.components.senses"

--- @type OpaqueComponent
prism.components.Opaque = prism.require "core.components.opaque"

--- @type ActionDecision
prism.decisions.ActionDecision = prism.require "core.decisions.actiondecision"

--- @type ActionMessage
prism.messages.ActionMessage = prism.require "core.messages.actionmessage"

prism._items = {
   "targets",
   "cells",
   "actions",
   "components",
   --"behaviors",
   "actors",
   "messages",
   "decisions",
   "systems",
}

prism._itemPatterns = {
   components = "[cC][oO][mM][pP][oO][nN][eE][nN][tT]",
   actors = "[aA][cC][tT][oO][rR]",
   actions = "[aA][cC][tT][iI][oO][nN]",
   cells = "[cC][eE][lL][lL]",
   targets = "[tT][aA][rR][gG][eE][tT]",
   messages = "[mM][eE][sS][sS][aA][gG][eE]",
   systems = "[sS][yY][sS][tT][eE][mM]",
   decisions = "[dD][eE][cC][iI][sS][iI][oO][nN]",
   behaviors = "[bB][eE][hH][aA][vV][iI][oO][rR]",
}


local function loadItems(path, itemType, recurse, definitions)
   local info = {}
   local items = prism[itemType]

   for k, item in pairs(love.filesystem.getDirectoryItems(path)) do
      local fileName = path .. "/" .. item
      love.filesystem.getInfo(fileName, info)
      if info.type == "file" then
         fileName = string.gsub(fileName, ".lua", "")
         fileName = string.gsub(fileName, "/", ".")

         local name = string.gsub(item, ".lua", "")
         local item = require(fileName)
         local strippedClassName = string.gsub(item.className, prism._itemPatterns[itemType], "")

         if not item.stripName then
            strippedClassName = item.className
         end

         assert(strippedClassName ~= "",
            "File " .. name .. " contains type " .. itemType .. " without a valid stripped name!")
         assert(items[strippedClassName] == nil,
            "File " .. name .. " contains type " .. itemType .. " with duplicate name!")
         items[strippedClassName] = item

         table.insert(definitions, "--- @type " .. item.className)
         table.insert(definitions, "prism." .. itemType .. "." .. strippedClassName .. " = nil")
      elseif info.type == "directory" and recurse then
         loadItems(fileName, itemType, recurse, definitions)
      end
   end
end

function prism.loadModule(directory)
   local sourceDir = love.filesystem.getSource() -- Get the source directory
   local definitions = { "---@meta " .. string.lower(directory) }

   for _, item in ipairs(prism._items) do
      loadItems(directory .. "/" .. item, item, true, definitions)
   end

   -- Define the output file path
   local outputFile = sourceDir .. "/definitions/" .. directory .. ".lua"

   -- Write the concatenated definitions to the file
   local file, err = io.open(outputFile, "w")
   if not file then
      print("Failed to open file for writing: " .. (err or "Unknown error"))
      return
   end

   file:write(table.concat(definitions, "\n"))
   file:close()
end

--- This is the core turn logic, and if you need to use a different scheduler or want a different turn structure you should override this.
--- There is a version of this provided for time-based
---@param level Level
---@param actor Actor
---@param controller ControllerComponent
---@diagnostic disable-next-line
function prism.turn(level, actor, controller)
   local _, action

   action = controller:act(level, actor)

   -- we make sure we got an action back from the controller for sanity's sake
   assert(action, "Actor " .. actor.name .. " returned nil from act()")

   level:performAction(action)
end

--- Runs the level coroutine and returns the next message, or nil if the coroutine has halted.
--- @return Message|nil
function prism.advanceCoroutine(updateCoroutine, level, decision)
   local success, ret = coroutine.resume(updateCoroutine, level, decision)

   if not success then
      error(ret .. "\n" .. debug.traceback(updateCoroutine))
   end

   local coroutineStatus = coroutine.status(updateCoroutine)
   if coroutineStatus == "suspended" then
      return ret
   end
end
