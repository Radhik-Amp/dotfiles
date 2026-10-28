------------------------------------------------------------
-- Completion (blink.cmp)
------------------------------------------------------------

require('blink.cmp').setup({
  -- Tab accepts the highlighted item (first one by default) or jumps to the next snippet placeholder; S-Tab jumps back. C-space opens the menu.
  keymap = { preset = 'super-tab' },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    list = {
      selection = {
        preselect = function() return not require('blink.cmp').snippet_active({ direction = 1 }) end,
      },
    },
  },

  signature = { enabled = true },

  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
