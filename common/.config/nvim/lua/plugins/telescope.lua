------------------------------------------------------------
-- Telescope
------------------------------------------------------------
local builtin = require('telescope.builtin')
require("telescope").setup({
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  defaults = {
    file_ignore_patterns = { "%.git/" },  -- keeps .git folders out of results
  },
})
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Search text' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Help' })
