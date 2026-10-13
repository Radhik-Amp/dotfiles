vim.cmd([[
    set nocompatible    " V improved
    set number    " Sets line number

    set tabstop=4
    set shiftwidth=4
    set expandtab   " Convert tab to desired amount of space  

    set completeopt=menu,menuone,noselect,popup
]])

-- Plugins
vim.g.mapleader = ' '

require('plugins')

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
require('nvim-treesitter').install({ 'python', 'javascript', 'bash', 'json' })

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

------------------------------------------------------------
-- Telescope
------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Search text' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Help' })

--------------------------------------------------------------
-- LSP
--------------------------------------------------------------
-- Needs these in your vim.pack.add list:
--   'https://github.com/neovim/nvim-lspconfig'  -- server configs
--   'https://github.com/mason-org/mason.nvim'   -- server installer
-- Install servers once with: :MasonInstall lua-language-server pyright ruff
 
require('mason').setup()
 
-- Show diagnostics inline (off by default since Neovim 0.11)
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})
 
-- Per-server settings: must come BEFORE vim.lsp.enable
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME }, -- so `vim.*` is recognized in your config
      },
    },
  },
})
 
vim.lsp.config('pyright', {
  settings = {
    pyright = { disableOrganizeImports = true }, -- ruff handles imports
  },
})

vim.lsp.config('ruff', {
  capabilities = {
    general = { positionEncodings = { 'utf-16' } },
  },
})

vim.lsp.enable({ 'lua_ls', 'pyright', 'ruff', 'qmlls' })
 
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
 
    -- Built-in completion popup
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
 
    if client.name == 'ruff' then
      -- pyright gives better hover info; avoid duplicates
      client.server_capabilities.hoverProvider = false
 
      -- Format with ruff on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('user-ruff-format-' .. ev.buf, { clear = true }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
        end,
      })
    end
  end,
})

-------------------------------------------------------------
-- Theme
-------------------------------------------------------------
vim.o.termguicolors = false

--- Darker popup menus (numbers are your terminal's 16 colors: 0 = black, 8 = gray, 7/15 = white)
vim.api.nvim_set_hl(0, 'Pmenu',      { ctermbg = 0, ctermfg = 7 })   -- the menu
vim.api.nvim_set_hl(0, 'PmenuSel',   { ctermbg = 8, ctermfg = 15 })  -- the highlighted item
vim.api.nvim_set_hl(0, 'PmenuSbar',  { ctermbg = 0 })                -- scrollbar track
vim.api.nvim_set_hl(0, 'PmenuThumb', { ctermbg = 8 })                -- scrollbar handle
vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 0, ctermfg = 7 })  -- docs popup next to the menu
