--- @class InsertionModule
--- @field insert_log fun(input: string): nil

--- @type InsertionModule
--- @diagnostic disable-next-line
local M = {}

local config = require("consolelogger.config") --- @type ConfigModule
local ts_util = require("consolelogger.treesitter") --- @type TsUtil

local function get_print_statement()
	local ft = vim.bo.filetype
	local lang_map = config.options.languages
	return lang_map[ft] or "console.log"
end

local function build_prefix()
	if not config.options.prefix_filename_line then
		return ""
	end
	local file = vim.fn.expand("%:t")
	local line = vim.fn.line(".")
	return config.options.custom_prefix .. file .. ":" .. line .. " -"
end

function M.insert_log(input)
	local statement = get_print_statement()
	local prefix = build_prefix()

	local final_log = statement .. '("' .. prefix .. '", ' .. input .. ");"

	local row = vim.api.nvim_win_get_cursor(0)[1]
	row = ts_util.adjust_insertion_point(row)
	vim.api.nvim_buf_set_lines(0, row, row, false, { final_log })
end

return M
