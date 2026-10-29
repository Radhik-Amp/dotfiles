--------------------------------------------------------------
-- LSP
--------------------------------------------------------------
require('mason').setup()

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim',
        },
      },
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    pyright = { disableOrganizeImports = true }, -- ruff handles imports
  },
})

vim.lsp.enable({ 'lua_ls', 'pyright', 'ruff', 'qmlls' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

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
