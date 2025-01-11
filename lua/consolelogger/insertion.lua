local config = require("consolelogger.config") --- @type ConfigModule
local ts_util = require("consolelogger.treesitter") --- @type TsUtil

--- @class InsertionModule
--- @field insert_log fun(input: string): nil

--- @type InsertionModule
--- @diagnostic disable-next-line
local M = {}

--- Gets the correct print statement for the language
--- @return string print_statement -- defautls to "console.log"
local function get_print_statement()
	local ft = vim.bo.filetype
	local log_func = config.options.log_func or {}
	return log_func[ft] or "console.log"
end

--- @param callback fun(format: string): nil Callback function that receives the selected format code or nil if none is selected.
local function select_format(callback)
	local ft = vim.bo.filetype
	local options_by_language = {
		-- TODO:
	}
	local options = options_by_language[ft]

	if not options then
		callback("")
		return
	end

	vim.ui.select(options, { prompt = "Select a format:" }, function(choice)
		if choice then
			local format = choice:match("^(%%.)")
			-- extra space to make it less ugly
			callback(" " .. format)
		end
	end)
end

--- @return string prefix retuns the file, line, and user prefix if applicable
local function build_prefix()
	local file_line_info = ""
	local decorator = config.options.decorator or ""
	if config.options.prefix_filename_line then
		file_line_info = vim.fn.expand("%:t") .. ":" .. vim.fn.line(".")
	end

	return config.options.custom_prefix .. file_line_info .. decorator
end

function M.insert_log(input)
	local statement = get_print_statement()
	local prefix = build_prefix()

	select_format(function(format)
		local final_log = statement .. '("' .. prefix .. format .. '", ' .. input .. ");"

		-- Insert the log statement at the current cursor position
		local row = vim.api.nvim_win_get_cursor(0)[1]
		row = ts_util.adjust_insertion_point(row)
		vim.api.nvim_buf_set_lines(0, row, row, false, { final_log })
	end)
end

return M
