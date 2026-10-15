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
