-- quick script by chatgpt to split the monolithic .md output of
-- lualsp

local input_filename = arg[1] -- Get filename from command-line argument
local output_dir = arg[2] or "output/" -- Get output folder from command-line argument or default to "output/"

if not input_filename then
    error("Usage: lua script.lua <input_filename> [output_directory]")
end

-- Ensure the output directory exists
os.execute("mkdir -p " .. output_dir)

local file = io.open(input_filename, "r")
if not file then
    error("Could not open file: " .. input_filename)
end

local current_filename = nil
local output_file = nil

for line in file:lines() do
    local header = line:match("^#%s+(.+)")
    if 
      header and
      not string.match(header, "prism%.") and
      not string.match(header, "love%.") and
      not string.match(header, "bit%.") and
      not string.match(header, "os%.") and
      not string.match(header, "coroutine%.") and
      not string.match(header, "table%.") and
      not string.match(header, "debug%.") and
      not string.match(header, "inky%.%") and
      not string.match(header, "geometer%.") and
      not string.match(header, "spectrum%.") and
      not string.match(header, "jit%.") and
      not string.match(header, "string%.") and
      not string.match(header, "math%.") and
      not string.match(header, "ffi%.") and
      not string.match(header, "io%.") and
      not string.match(header, "package%.")
    then
        -- Close the previous file if open
        if output_file then
            output_file:close()
        end
        
        -- Generate filename from header (lowercase and replace spaces with underscores)
        current_filename = output_dir .. header:gsub("%s", "_"):lower() .. ".md"
        output_file = io.open(current_filename, "w")
    elseif output_file then
        -- Write the content to the current file
        output_file:write(line .. "\n")
    end
end

-- Close the last opened file
if output_file then
    output_file:close()
end

file:close()
print("Splitting complete! Files saved in " .. output_dir)
