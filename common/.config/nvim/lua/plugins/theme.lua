if vim.uv.os_uname().sysname == 'Darwin' then
  require('gruvbox').setup({})
  vim.o.background = 'dark'
  vim.cmd.colorscheme('gruvbox')
else
local function set_bg(group, bg)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = bg
    vim.api.nvim_set_hl(0, group, hl)
  end

  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'base16-3024',
    callback = function()
      for _, group in ipairs({ 'Normal', 'NormalNC', 'SignColumn', 'EndOfBuffer', 'LineNr' }) do
        set_bg(group, 'none')
      end
      for _, group in ipairs({ 'NormalFloat', 'FloatBorder', 'Pmenu' }) do
        set_bg(group, '#000000')
      end
    end,
  })
  require('base16-colorscheme').with_config({ telescope = false })
  vim.cmd.colorscheme('base16-3024')
end
