-- Rebuild Treesitter parsers whenever the plugin installs or updates
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
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/Mofiqul/adwaita.nvim',
  'https://github.com/ellisonleao/gruvbox.nvim',
  "https://github.com/RRethy/base16-nvim",
  'https://github.com/folke/snacks.nvim',
  'https://github.com/catgoose/nvim-colorizer.lua',
})

require('plugins.snacks')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.theme')
require('plugins.colorizer')
