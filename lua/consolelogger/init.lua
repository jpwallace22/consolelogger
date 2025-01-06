local config = require("consolelogger.config")
-- local highlight = require("consolelogger.highlight")
local insertion = require("consolelogger.insertion")
local lsp_util = require("consolelogger.lsp") --- @type LspUtil
local keymaps = require("consolelogger.keymaps")

local M = {}

local function clear_logs_in_buffer(bufnr, remove_all)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("console%.log") or line:match("fmt%.Printf") then
			lines[i] = remove_all and "" or ("-- " .. line)
		end
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

function M.setup(user_opts)
	config.setup(user_opts)
	-- highlight.setup_highlight()
	keymaps.setup_keymaps()
end

function M.insert_log_current()
	local variable = lsp_util.get_cursor_identifier()
	insertion.insert_log(variable)
end

function M.insert_log_selection()
	local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
	local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
	local lines = vim.api.nvim_buf_get_lines(0, csrow - 1, cerow, false)

	if #lines == 0 then
		return
	end

	if #lines == 1 then
		lines[1] = string.sub(lines[1], cscol, cecol)
	end

	local selected_text = table.concat(lines, "\n")
	insertion.insert_log(selected_text)
end

function M.clear_logs_current_file()
	local buf = vim.api.nvim_get_current_buf()
	clear_logs_in_buffer(buf, false)
end

function M.clear_logs_all_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			clear_logs_in_buffer(buf, false)
		end
	end
end

return M
