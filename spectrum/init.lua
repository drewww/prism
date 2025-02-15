if not prism then error("Spectrum depends on prism!") end

spectrum = {}
spectrum.path = ...

function spectrum.require(p) return require(table.concat({ spectrum.path, p }, ".")) end

--- @type Camera
spectrum.Camera = spectrum.require "camera"

--- @type SensesTracker
spectrum.SensesTracker = spectrum.require "sensestracker"

--- @type SpriteAtlas
spectrum.SpriteAtlas = spectrum.require "spriteatlas"

--- @type Display
spectrum.Display = spectrum.require "display"

--- @type Keybinding
spectrum.Keybinding = spectrum.require "keybindings"

--- @type GameStateManager
spectrum.StateManager = spectrum.require "gamestates.statemanager"

--- @type GameState
spectrum.GameState = spectrum.require "gamestates.gamestate"

--- @type LevelState
spectrum.LevelState = spectrum.require "gamestates.levelstate"