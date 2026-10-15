require('nvim-tree').setup({
  view = { width = 30 },
  filters = { dotfiles = false },
})

vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', { desc = 'File tree' })
