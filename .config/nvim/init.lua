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

require('plugins')

-------------------------------------------------------------
-- Theme
-------------------------------------------------------------
vim.o.termguicolors = false
local function popup_hl()
  vim.api.nvim_set_hl(0, 'Pmenu',       { ctermbg = 0, ctermfg = 7 })
  vim.api.nvim_set_hl(0, 'PmenuSel',    { ctermbg = 8, ctermfg = 15 })
  vim.api.nvim_set_hl(0, 'PmenuSbar',   { ctermbg = 0 })
  vim.api.nvim_set_hl(0, 'PmenuThumb',  { ctermbg = 8 })
  vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 0, ctermfg = 7 })
end
vim.api.nvim_create_autocmd('ColorScheme', { callback = popup_hl })
popup_hl()

