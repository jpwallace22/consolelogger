local config = require("consolelogger.config")
local keymaps = config.options.keymaps

--- @class KeymapData
--- @field mode string
--- @field func string
--- @field desc string

--- @type KeymapData[]
local keymapData = {
	{
		mode = "n",
		func = "insert_log_current",
		desc = "Log current cursor",
	},
	{
		mode = "v",
		func = "insert_log_selection",
		desc = "Log current selection",
	},
	{
		mode = "n",
		func = "clear_logs_current_buffer",
		desc = "Remove logs from buffer",
	},
	{
		mode = "n",
		func = "clear_logs_all_buffers",
		desc = "Remove logs from all buffers",
	},
}

-- Register keymaps with which-key (if available)
local function register_with_which_key()
	local ok, which_key = pcall(require, "which-key")
	if not ok then
		return
	end

	which_key.add({
		{ "<leader>l", desc = "Consolelogger", icon = "󰆍" },
	})
end

local M = {}
function M.setup_keymaps()
	if not keymaps then
		error("There are no keymaps set for Consolelogger.nvim")
	end

	for _, data in ipairs(keymapData) do
		vim.keymap.set(
			data.mode,
			keymaps[data.func],
			"<cmd>lua require('consolelogger')." .. data.func .. "()<CR>",
			{ noremap = true, silent = true, desc = data.desc }
		)
	end

	register_with_which_key()
end

return M
