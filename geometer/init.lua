if not spectrum then error("Geometer depends on spectrum!") end

--- @module "geometer"
geometer = {}
geometer.path = ...

function geometer.require(p)
   return require(table.concat({ geometer.path, p }, "."))
end

---@type Modification
geometer.Modification = geometer.require "modification"

---@type Tool
geometer.Tool = geometer.require "tool"

---@type Editor
geometer.Editor = geometer.require "editor"

---@type EditorState
geometer.EditorState = geometer.require "gamestates.editorstate"

---@type MapGeneratorState
geometer.MapGeneratorState = geometer.require "gamestates.mapgenerator"

---@type PrefabEditorState
geometer.PrefabEditorState = geometer.require "gamestates.prefabeditor"
