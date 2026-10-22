-- lua/plugins.lua

-- Rebuild Treesitter parsers whenever the plugin installs or updates
-- (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-lua/plenary.nvim',          -- required by Telescope
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/Mofiqul/adwaita.nvim',
  'https://github.com/ellisonleao/gruvbox.nvim'
})

require('plugins.treesitter')
require('plugins.telescope')
require('plugins.lsp')
require('plugins.theme')
require('plugins.nvim-tree')
require('plugins.alpha')
require('plugins.theme')
