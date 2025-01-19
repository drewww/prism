--- @class EditorState : GameState
--- @field editor Editor
local EditorState = spectrum.GameState:extend "EditorState"

--- Create a new Editor managing gamestate, attached to a
--- SpectrumAttachable, this is a Level|MapBuilder interface.
--- @param attachable SpectrumAttachable
function EditorState:__new(attachable, display, fileEnabled)
   self.editor = geometer.Editor(attachable, display, fileEnabled)
end

function EditorState:load()
   self.editor:startEditing()
end

function EditorState:update(dt)
   if not self.editor.active then self.manager:pop() end

   self.editor:update(dt)
end

function EditorState:draw()
   self.editor:draw()
end

function EditorState:mousemoved(x, y, dx, dy, istouch)
   self.editor:mousemoved(x, y, dx, dy, istouch)
end

function EditorState:wheelmoved(dx, dy)
   self.editor:wheelmoved(dx, dy)
end

function EditorState:mousepressed(x, y, button)
   self.editor:mousepressed(x, y, button)
end

function EditorState:mousereleased(x, y, button)
   self.editor:mousereleased(x, y, button)
end

function EditorState:keypressed(key, scancode)
   self.editor:keypressed(key, scancode)
end

function EditorState:textinput(text)
   self.editor:textinput(text)
end

return EditorState
