prism.loadModule("example_srd")

local mapbuilder = prism.MapBuilder(prism.cells.Wall)
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)

mapbuilder:addActor(prism.actors.Player(), 12, 12)
mapbuilder:addActor(prism.actors.Player(), 16, 16)
mapbuilder:addActor(prism.actors.Bandit(), 19, 19)

local map, actors = mapbuilder:build()

local level = prism.Level(map, actors)
local sensesSystem = prism.systems.Senses()
local sightSystem = prism.systems.Sight()
level:addSystem(sensesSystem)
level:addSystem(sightSystem)

local StateManager = require "example_srd.gamestates.statemanager"
local LevelState = require "example_srd.gamestates.levelstate"

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