if not prism then error("Spectrum depends on prism!") end

spectrum = {}

--- @type Camera
spectrum.Camera = require "spectrum.camera"

--- @type SensesTracker
spectrum.SensesTracker = require "spectrum.sensestracker"

--- @type SpriteAtlas
spectrum.SpriteAtlas = require "spectrum.spriteatlas"

--- @type Display
spectrum.Display = require "spectrum.display"

--- @type Keybinding
spectrum.Keybinding = require "spectrum.keybindings"

--- @type GameStateManager
spectrum.StateManager = require "spectrum.gamestates.statemanager"

--- @type GameState
spectrum.GameState = require "spectrum.gamestates.gamestate"

--- @type LevelState
spectrum.LevelState = require "spectrum.gamestates.levelstate"