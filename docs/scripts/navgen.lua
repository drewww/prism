local output_dir = arg[1] or "output/"

local function get_files(directory)
   local files = {}
   print(directory)
   for file in io.popen('ls "' .. directory .. '"'):lines() do
      if file:match("%.md$") then table.insert(files, file) end
   end
   return files
end

local function generate_nav(files)
   print("nav:")
   for _, file in ipairs(files) do
      local name = file:gsub("_", " "):gsub("%.md$", "")
      print(string.format("  - %s: api/%s", name, file))
   end
end

local files = get_files(output_dir)
table.sort(files) -- Sort alphabetically
generate_nav(files)
