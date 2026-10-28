------------------------------------------------------------
-- Colorizer
------------------------------------------------------------
require('colorizer').setup({
  filetypes = { '*' },
  options = {
    parsers = {
      css = true,
      names = { enable = true },
    },
    display = { mode = 'background' },
  },
})
