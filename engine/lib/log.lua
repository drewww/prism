--
-- log.lua
--
-- Copyright (c) 2016 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local logger = {}

--- Whether to use terminal colors or not.
logger.usecolor = true
--- A file to log to.
logger.outfile = nil
--- The log level to log up to.
logger.level = "trace"
--- Toggle this off to disable debug loggers.
logger.enabled = true

local modes = {
	{ name = "trace", color = "\27[34m" },
	{ name = "debug", color = "\27[36m" },
	{ name = "info", color = "\27[32m" },
	{ name = "warn", color = "\27[33m" },
	{ name = "error", color = "\27[31m" },
	{ name = "fatal", color = "\27[35m" },
}

local levels = {}
for i, v in ipairs(modes) do
	levels[v.name] = i
end

local round = function(x, increment)
	increment = increment or 1
	x = x / increment
	return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
end

local _tostring = tostring

local tostring = function(...)
	local t = {}
	for i = 1, select("#", ...) do
		local x = select(i, ...)
		if type(x) == "number" then
			x = round(x, 0.01)
		end
		t[#t + 1] = _tostring(x)
	end
	return table.concat(t, " ")
end

local function log(i, ...)
	local x = modes[i]
	local nameupper = x.name:upper()
	if not logger.enabled then
		return
	end

	-- Return early if we're below the logger level
	if i < levels[logger.level] then
		return
	end

	local msg = tostring(...)
	local info = debug.getinfo(2, "Sl")

	local lineinfo = info.short_src .. ":" .. info.currentline

	-- Output to console
	print(
		string.format(
			"%s[%-6s%s]%s %s: %s",
			logger.usecolor and x.color or "",
			nameupper,
			os.date("%H:%M:%S"),
			logger.usecolor and "\27[0m" or "",
			lineinfo,
			msg
		)
	)

	-- Output to logger file
	if logger.outfile then
		local fp = io.open(logger.outfile, "a")
		local str = string.format("[%-6s%s] %s: %s\n", nameupper, os.date(), lineinfo, msg)
		fp:write(str)
		fp:close()
	end
end

function logger.warn(...)
	log(4, ...)
end

function logger.info(...)
	log(3, ...)
end

return logger
