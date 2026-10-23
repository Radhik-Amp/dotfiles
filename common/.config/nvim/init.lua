vim.o.number = true          -- Sets line number
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true       -- Convert tab to desired amount of space
vim.o.completeopt = 'menu,menuone,noselect,popup'
vim.o.statuscolumn = "%s%=%{v:virtnum > 0 ? '' : (&nu || &rnu ? (v:relnum ? v:relnum : v:lnum) : '')} "
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Plugins
vim.g.mapleader = ' '

-- Colors
vim.o.termguicolors = true

require('plugins')
