vim.cmd([[
    set number    " Sets line number
    set tabstop=4
    set shiftwidth=4
    set expandtab   " Convert tab to desired amount of space  
    set completeopt=menu,menuone,noselect,popup
]])

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Plugins
vim.g.mapleader = ' '

-- Colors
vim.o.termguicolors = true

require('plugins')
