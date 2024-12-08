if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
   require("lldebugger").start()
end

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
   local lldebugger = require "lldebugger"
   lldebugger.start()
   local run = love.run
   function love.run(...)
       local f = lldebugger.call(run, false, ...)
       return function(...) return lldebugger.call(f, false, ...) end
   end
end

require "engine"
prism.loadModule("example")

local mapbuilder = prism.MapBuilder(prism.cells.Wall)
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)

mapbuilder:addActor(prism.actors.Player(), 12, 12)
mapbuilder:addActor(prism.actors.Player(), 16, 16)

local map, actors = mapbuilder:build()

local level = prism.Level(map, actors)
local sensesSystem = prism.systems.Senses()
local sightSystem = prism.systems.Sight()
level:addSystem(sensesSystem)
level:addSystem(sightSystem)

local StateManager = require "example.gamestates.statemanager"
local LevelState = require "example.gamestates.levelstate"

local manager = StateManager()

function love.load() manager:push(LevelState(level)) end

function love.draw()
   manager:draw()
end

function love.update(dt) manager:update(dt) end

function love.keypressed(key, scancode) manager:keypressed(key, scancode) end

function love.mousepressed( x, y, button, istouch, presses )
   manager:mousepressed(x, y, button, istouch, presses )
end