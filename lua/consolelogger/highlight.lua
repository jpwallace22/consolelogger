local M = {}

function M.setup_highlight()
	vim.cmd([[
    highlight default link ConsoleLoggerStatement Todo
    augroup ConsoleLoggerHighlight
      autocmd!
      autocmd BufReadPost,FileReadPost * syn match ConsoleLoggerStatement /\v(console\.log|fmt\.Printf)\(.*\)/
    augroup END
  ]])
end

return M
