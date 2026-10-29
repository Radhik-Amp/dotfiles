------------------------------------------------------------
-- Lua Line
------------------------------------------------------------
local theme
if vim.uv.os_uname().sysname == 'Darwin' then
  theme = 'gruvbox'
else
  theme = vim.deepcopy(require('lualine.themes.base16'))
  for _, mode in pairs(theme) do
    if mode.c then mode.c.bg = 'NONE' end
  end
end

require('lualine').setup({
  options = {
    theme = theme,
    icons_enabled = true,
    globalstatus = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

