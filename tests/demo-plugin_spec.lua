local get_mapping = function (lhs)
	local mapping = vim.api.nvim_get_keymap("n")
	for _, value in ipairs(mapping) do
		if value.lhs == lhs then
			return value
		end
	end
end

describe("demo-plugin", function ()
	before_each(function ()
		require("demo-plugin")._clear()
		-- until there's a better way to clear all set mappings in-between tests
		pcall(vim.api.nvim_del_keymap, 'n', "mykey")
		pcall(vim.api.nvim_del_keymap, 'n', "mykey_1")
		pcall(vim.api.nvim_del_keymap, 'n', "mykey_2")
	end)
	it("can be required", function ()
		require("demo-plugin")
	end)
	it("push to stack", function ()
		local rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {["mykey"] = rhs})
		local mymap = get_mapping("mykey")
		assert.are.same(mymap.rhs, rhs)
	end)

	it("can push multiple mappings", function ()
		local rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {
			["mykey_1"] = rhs .. " 1",
			["mykey_2"] = rhs .. " 2",
		})

		local mymap = get_mapping("mykey_1")
		assert.are.same(mymap.rhs, rhs .. " 1")

		local mymap = get_mapping("mykey_2")
		assert.are.same(mymap.rhs, rhs .. " 2")
	end)
	it("can delete mapping - no exisiting case", function ()
		local rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {["mykey"] = rhs})
		local after_push = get_mapping("mykey")
		assert.are.same(after_push.rhs, rhs)

		require("demo-plugin").pop("test", "n")
		local after_pop = get_mapping("mykey")
		assert.are.same(after_pop, nil)
	end)
	it("can delete mapping: exisiting case", function ()
		local original_rhs =  "echo 'this is original mapping'"
		vim.keymap.set("n", "mykey", original_rhs)

		local new_rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {["mykey"] = new_rhs})
		local after_push = get_mapping("mykey")
		assert.are.same(new_rhs, after_push.rhs)

		print("after push -- here we are")
		require("demo-plugin").pop("test", "n")
		local after_pop = get_mapping("mykey")
		assert.are.same(original_rhs, after_pop.rhs)
	end)
end)
