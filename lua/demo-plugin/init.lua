print("loaded demo-plugin/init.lua")
local M = {}

--M.setup = function(opts)
--	print("Options: ", opts)
--end
--
--to set keymap: vim.keymap.set()
--to get keymap: nvim_get_keymap()

local list_mappings = function()
	local keymap = vim.api.nvim_get_keymap("n")
	for i, value in ipairs(keymap) do
		if value.rhs then
			print("HAS", i)
		else
			print("not", i)
		end
	end
end

local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

M._stack = {}

M.push = function (name, mode, mappings)
	local existing_maps = {}
	local keymap = vim.api.nvim_get_keymap(mode)
	for lhs, rhs in pairs(mappings) do
		local existing = find_mapping(keymap, lhs)
		if existing then
			table.insert(existing_maps, existing)
		end
	end
	M._stack[name] = existing_maps
end


M.pop = function (name, mappings)
end


M.push("debug_mode", "n", {
	[" a"] = "echo 'Hello a'",
	[" b"] = "echo 'Hello b'"
})

--[[
-- User would then
-- lua require("demo-plugin").push("debug_mode", "n", {
	 ["<leader>a"] = "echo 'Hello'"
	-- })
--
-- lua require("demo-plugin").pop("debug_mode", )
--
--
--]]

return M
