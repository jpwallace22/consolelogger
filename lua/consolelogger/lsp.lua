--- @class LspUtil
--- Get the identifier (variable name) at the current cursor position
--- @field get_cursor_identifier fun(): string

--- @type LspUtil
--- @diagnostic disable-next-line
local M = {}

function M.get_cursor_identifier()
	local params = vim.lsp.util.make_position_params()
	local responses = vim.lsp.buf_request_sync(0, "textDocument/documentHighlight", params, 1000)

	if responses then
		for _, response in pairs(responses) do
			if response.result then
				local result = response.result[1]
				if result and result.range then
					local range = result.range
					local start_line = range.start.line + 1
					local start_col = range.start.character + 1
					local end_col = range["end"].character

					local line = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
					return string.sub(line, start_col, end_col)
				end
			end
		end
	end

	-- Fallback to the word under the cursor.
	return vim.fn.expand("<cword>")
end

return M
