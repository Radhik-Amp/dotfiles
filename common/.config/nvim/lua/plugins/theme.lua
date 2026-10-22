if vim.uv.os_uname().sysname == 'Darwin' then
  require('gruvbox').setup({})
  vim.o.background = 'dark'
  vim.cmd.colorscheme('gruvbox')
else
  vim.g.adwaita_darker = true
  vim.g.adwaita_transparent = true
  vim.cmd.colorscheme('adwaita')
end
