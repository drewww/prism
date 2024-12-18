local function require_relative(p) return require(table.concat({ prism.path, p }, ".")) end

--- We export a global namespace.
--- @module "prism"
prism = {}
prism.path = ...
prism.require_relative = require_relative

--- @type boolean
prism._initialized = false

prism._defaultDistance = "8way"
prism._defaultRangeType = "8way"

-- Root object

--- @type Object
prism.Object = require_relative "core.object"

-- Math
--- @type Vector2 
prism.Vector2 = require_relative "math.vector"
--- @type BoundingBox
prism.BoundingBox = require_relative "math.bounding_box"

prism.neighborhood = prism.Vector2.neighborhood8

--- @param neighborhood Neighborhood
function prism.setDefaultNeighborhood(neighborhood)
   prism.neighborhood = neighborhood
end

-- Structures
--- @type SparseMap
prism.SparseMap = require_relative "structures.sparsemap"
--- @type SparseGrid
prism.SparseGrid = require_relative "structures.sparsegrid"
--- @type SparseArray
prism.SparseArray = require_relative "structures.sparsearray"
--- @type Grid
prism.Grid = require_relative "structures.grid"
--- @type BooleanBuffer
prism.BooleanBuffer = require_relative "structures.booleanbuffer"
--- @type Queue
prism.Queue = require_relative "structures.queue"
--- @type PriorityQueue
prism.PriorityQueue = require_relative "structures.priority_queue"

-- Algorithms
prism.fov = {}
prism.fov.Row = require_relative "algorithms.fov.row"
prism.fov.Quadrant = require_relative "algorithms.fov.quadrant"
prism.fov.Fraction = require_relative "algorithms.fov.fraction"
prism.computeFOV = require_relative "algorithms.fov.fov"

prism.Path = require_relative "algorithms.astar.path"

--- @alias PassableCallback fun(x: integer, y: integer):boolean
--- @alias CostCallback fun(x: integer, y: integer): integer
--- @type fun(start: Vector2, goal: Vector2, passableCallback: PassableCallback, costCallback: CostCallback?, minDistance: integer?): Path
prism.astar = require_relative "algorithms.astar.astar"

-- Core
--- @type Scheduler
prism.Scheduler = require_relative "core.scheduler.scheduler"
--- @type TimeScheduler
prism.TimeScheduler = require_relative "core.scheduler.time_scheduler"
--- @type SimpleScheduler
prism.SimpleScheduler = require_relative "core.scheduler.simple_scheduler"
--- @type Action
prism.Action = require_relative "core.action"
--- @type Component
prism.Component = require_relative "core.component"
--- @type Actor
prism.Actor = require_relative "core.actor"
--- @type ActorStorage
prism.ActorStorage = require_relative "core.actorstorage"
--- @type Cell
prism.Cell = require_relative "core.cell"
--- @type RNG
prism.RNG = require_relative "core.rng"
--- @type System
prism.System = require_relative "core.system"
--- @type SystemManager
prism.SystemManager = require_relative "core.system_manager"
--- @type MapBuilder
prism.MapBuilder = require_relative "core.map_builder"
--- @type Map
prism.Map = require_relative "core.map"
--- @type Message
prism.Message = require_relative "core.message"
--- @type Decision
prism.Decision = require_relative "core.decision"
--- @type Target
prism.Target = require_relative "core.target"
--- @type Level
prism.Level = require_relative "core.level"

-- Behavior Tree

prism.BehaviorTree = {}

--- @type BTNode
prism.BehaviorTree.Node = require_relative "core.behavior_tree.btnode"
--- @type BTNode
prism.BehaviorTree.Root = require_relative "core.behavior_tree.btroot"
--- @type BTNode
prism.BehaviorTree.Selector = require_relative "core.behavior_tree.btselector"
--- @type BTSequence
prism.BehaviorTree.Sequence = require_relative "core.behavior_tree.btsequence"
--- @type BTSucceeder
prism.BehaviorTree.Succeeder = require_relative "core.behavior_tree.btsucceeder"


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
prism.systems.Senses = require_relative "core.systems.senses"

--- @type ColliderComponent
prism.components.Collider = require_relative "core.components.collider"

--- @type ControllerComponent
prism.components.Controller = require_relative "core.components.controller"

--- @type BTControllerComponent
prism.components.BTController = require_relative "core.components.btcontroller"

--- @type PlayerControllerComponent
prism.components.PlayerController = require_relative "core.components.player_controller"

--- @type SensesComponent
prism.components.Senses = require_relative "core.components.senses"

--- @type OpaqueComponent
prism.components.Opaque = require_relative "core.components.opaque"

--- @type ActionDecision
prism.decisions.ActionDecision = require_relative "core.decisions.actiondecision"

--- @type ActionMessage
prism.messages.ActionMessage = require_relative "core.messages.actionmessage"

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

         assert(strippedClassName ~= "", "File " .. name .. " contains type " .. itemType .. " without a valid stripped name!")
         assert(items[strippedClassName] == nil, "File " .. name .. " contains type " .. itemType .. " with duplicate name!")
         items[strippedClassName] = item
         
         table.insert(definitions, "--- @type " .. item.className)
         table.insert(definitions, "prism." .. itemType .. "." .. strippedClassName .. " = nil")
      elseif info.type == "directory" and recurse then
         loadItems(fileName, itemType, recurse, definitions)
      end
   end
end

function prism.loadModule(directory)
   local source_dir = love.filesystem.getSource() -- Get the source directory
   local definitions = { "---@meta " .. string.lower(directory) }

   for _, item in ipairs(prism._items) do
      loadItems(directory .. "/" .. item, item, true, definitions)
   end

   -- Define the output file path
   local output_file = source_dir .. "/definitions/" .. directory .. ".lua"

   -- Write the concatenated definitions to the file
   local file, err = io.open(output_file, "w")
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
   level:yield(prism.messages.ActionMessage(action))
end