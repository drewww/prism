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