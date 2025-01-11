--- @class LogFuncConfig
--- @field javascript string
--- @field typescript string
--- @field go string
--- @field lua string

--- @class KeymapsConfig
--- @field insert_log_current string | nil           -- Optional: Keymap for inserting a log at the current cursor position
--- @field insert_log_selection string | nil         -- Optional: Keymap for inserting a log for the current selection
--- @field clear_logs_current_buffer string | nil    -- Optional: Keymap for clearing logs in the current buffer
--- @field clear_logs_all_buffers string | nil       -- Optional: Keymap for clearing logs in all buffers

--- @class ConsoleloggerOptions
--- @field debug boolean | nil                     -- Optional: Enables or disables debug mode
--- @field custom_prefix string | nil              -- Optional: Custom prefix for log statements
--- @field prefix_filename_line boolean | nil      -- Optional: Prefix log statements with filename and line number
--- @field prefix_function_name boolean | nil      -- Optional: Prefix log statements with the function name
--- @field decorator string | nil                  -- Optional: The final string between the prefix and the log. Defaults to " ->"
--- @field log_func LogFuncConfig | nil          -- Optional: Language-specific configurations
--- @field keymaps KeymapsConfig | nil             -- Optional: Keymaps for actions

--- @class ConfigModule
--- @field defaults ConsoleloggerOptions
--- @field options ConsoleloggerOptions
--- @field setup fun(user_opts: ConsoleloggerOptions)
--- @field apply fun(user_opts: ConsoleloggerOptions)

--- @type ConfigModule
--- @diagnostic disable-next-line
local M = {}

M.defaults = {
	debug = false,
	custom_prefix = "🔍",
	prefix_filename_line = false,
	prefix_function_name = true, -- TODO: add in the functionality for this
	decorator = " ->",
	log_func = {
		javascript = "console.log",
		typescript = "console.log",
		go = "fmt.Println",
		lua = "print",
	},
	keymaps = {
		insert_log_current = "<leader>ll", -- normal
		insert_log_selection = "<leader>ll", -- visual
		clear_logs_current_buffer = "<leader>lc", -- normal
		clear_logs_all_buffers = "<leader>lC", -- normal
	},
}

M.options = vim.tbl_deep_extend("force", {}, M.defaults)

-- used by lazy internally to apply the `opts` table
function M.apply(user_opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

-- used by everything else
function M.setup(user_opts)
	M.apply(user_opts)
end

return M
