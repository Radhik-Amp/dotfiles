------------------------------------------------------------
-- Markdown Preview (browser)
------------------------------------------------------------
vim.g.mkdp_auto_close = 1        -- close the preview when leaving the buffer
vim.g.mkdp_theme = 'dark'
vim.g.mkdp_page_title = '${name}'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>',
      { buffer = ev.buf, desc = 'Toggle markdown browser preview' })
  end,
})
