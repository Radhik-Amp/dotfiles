--------------------------------------------------------------
-- LSP
--------------------------------------------------------------
require('mason').setup()
 
-- Show diagnostics inline (off by default since Neovim 0.11)
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
        library = { vim.env.VIMRUNTIME },
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

vim.lsp.config('qmlls', {
  filetypes = { 'qml' },
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
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    -- nothing highlighted yet: pick the first item and accept it
    if vim.fn.complete_info({ 'selected' }).selected == -1 then
      return '<C-n><C-y>'
    end
    -- an item is highlighted: accept it
    return '<C-y>'
  elseif vim.snippet.active({ direction = 1 }) then
    -- inside a snippet: jump to the next placeholder
    return '<Cmd>lua vim.snippet.jump(1)<CR>'
  end
  -- no menu, no snippet: normal Tab
  return '<Tab>'
end, { expr = true, desc = 'Accept completion or Tab' })
