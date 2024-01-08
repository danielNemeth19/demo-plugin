print("loaded demo-plugin/init.lua")
local M = {}

M.setup = function(opts)
	print("Options: ", opts)
end

return M
