local dashboard = require('alpha.themes.dashboard')

-- ASCII art header, read from ~/.config/nvim/header.txt
local header_path = vim.fn.stdpath('config') .. '/header.txt'
if vim.fn.filereadable(header_path) == 1 then
  dashboard.section.header.val = vim.fn.readfile(header_path)
end
dashboard.section.header.opts.hl = 'Comment'

dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file',  '<Cmd>Telescope find_files<CR>'),
  dashboard.button('g', '  Search text', '<Cmd>Telescope live_grep<CR>'),
  dashboard.button('e', '  File tree',  '<Cmd>NvimTreeToggle<CR>'),
  dashboard.button('q', '  Quit',       '<Cmd>qa<CR>'),
}

require('alpha').setup(dashboard.config)
