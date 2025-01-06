
if exists('g:loaded_consolelogger')
  finish
endif
let g:loaded_consolelogger = 1

command! -nargs=0 ConsoleLoggerClear lua require('consolelogger').clear_logs_current_file()
