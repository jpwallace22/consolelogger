# Consolelogger

> [!WARNING]
> This is not currently intended for public use. You have been warned. 

The point of this nvim plugin is to make a utility that I use everyday and get more familiar with the neovim/plugin ecosystem. 

For this reason, there is probably some bugs and it is definitely not documented well enough for public consumption.
It also only supports the languages I use on a day to day basis (TS, Go, and Lua). 

## Setup
### Options Schema
```lua
--- @class ConsoleloggerOptions
--- @field debug boolean | nil                     -- Optional: Enables or disables debug mode
--- @field custom_prefix string | nil              -- Optional: Custom prefix for log statements
--- @field prefix_filename_line boolean | nil      -- Optional: Prefix log statements with filename and line number
--- @field prefix_function_name boolean | nil      -- Optional: Prefix log statements with the function name
--- @field keymaps KeymapsConfig | nil             -- Optional: Keymaps for actions

--- @class KeymapsConfig
--- @field insert_log_current string | nil           -- Optional: Keymap for inserting a log at the current cursor position
--- @field insert_log_selection string | nil         -- Optional: Keymap for inserting a log for the current selection
--- @field clear_logs_current_buffer string | nil    -- Optional: Keymap for clearing logs in the current buffer
--- @field clear_logs_all_buffers string | nil       -- Optional: Keymap for clearing logs in all buffers

```

### Lazy 
```lua
return {
	"jpwallace22/consolelogger",
--- @class ConsoleLoggerOptions
	opts = {
    ...
		},
	},
}
```

### Packer
```lua
use({
	"jpwallace22/consolelogger",
	config = function()
--- @class ConsoleLoggerOptions
		require("consolelogger").setup({
      ...
			},
		})
	end,
})
```

### Vim-Plug
```vim
Plug 'jpwallace22/consolelogger'

lua << EOF
--- @class ConsoleLoggerOptions
require("consolelogger").setup({
  ...
})
EOF
```

