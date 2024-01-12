local get_mapping = function (mode, lhs)
	local mapping = vim.api.nvim_get_keymap(mode)
	for _, value in ipairs(mapping) do
		if value.lhs == lhs then
			return value
		end
	end
end

describe("demo-plugin", function ()
	it("can be required", function ()
		require("demo-plugin")
	end)
	it("push to stack", function ()
		local rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {["mykey"] = rhs})
		local mymap = get_mapping("n", "mykey")
		assert.are.same(mymap.rhs, rhs)
	end)

	it("can push multiple mappings", function ()
		local rhs = "echo 'Hello World'"
		require("demo-plugin").push("test", "n", {
			["mykey_1"] = rhs .. " 1",
			["mykey_2"] = rhs .. " 2",
		})

		local mymap = get_mapping("n", "mykey_1")
		assert.are.same(mymap.rhs, rhs .. " 1")

		local mymap = get_mapping("n", "mykey_2")
		assert.are.same(mymap.rhs, rhs .. " 2")
	end)
end)
