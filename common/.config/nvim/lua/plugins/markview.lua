------------------------------------------------------------
-- Markview 
------------------------------------------------------------
require('markview').setup({
  preview = { icon_provider = 'devicons' },
})

-- no wrap
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function() vim.wo.wrap = false end,
})
