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
		vim.keymap.set(mode, lhs, rhs)
		local existing = find_mapping(keymap, lhs)
		if existing then
			existing_maps[lhs] = existing
		end
	end

	M._stack[name] = M._stack[name] or {}
	M._stack[name][mode] = {
		existing = existing_maps,
		mappings = mappings,
	}
end


M.pop = function (name, mode)
	local state = M._stack[name][mode]
	M._stack[name][mode] = nil
	-- created mappings will need to be dropped
	-- existing mappings (existing from before push) need to be reinstated
	for lhs, _ in pairs(state.mappings) do
		if state.existing[lhs] then
			-- handle re-instating mappings
			local original_mapping = state.existing[lhs]
			vim.keymap.set(mode, lhs, original_mapping.rhs)
		else
			vim.api.nvim_del_keymap(mode, lhs)
		end
	end
end

M._clear = function ()
	M._stack = {}
end

--M.push("debug_mode", "n", {
--	[" a"] = "echo 'Hello a'",
--	[" b"] = "echo 'Hello b'"
--})
--
--M.pop("debug_mode", {
--	[" a"] = "echo 'Hello a'",
--	[" b"] = "echo 'Hello b'"
--})

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
