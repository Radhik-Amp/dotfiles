------------------------------------------------------------
-- Snacks
------------------------------------------------------------
local header_path = vim.fn.stdpath('config') .. '/header.txt'
local header = vim.fn.filereadable(header_path) == 1
  and table.concat(vim.fn.readfile(header_path), '\n')
  or nil

require('snacks').setup({
  bigfile   = { enabled = true },
  quickfile = { enabled = true },
  indent    = { enabled = true },
  input     = { enabled = true },
  notifier  = { enabled = true },
  scope     = { enabled = true },
  scroll    = { enabled = true },
  words     = { enabled = true },
  lazygit   = { enabled = true },
  explorer  = { enabled = true },
  picker = {
    enabled = true,
    ui_select = true,
    sources = {
      files    = { hidden = true },
      explorer = { hidden = true },
    },
  },
  dashboard = {
    enabled = true,
    preset = {
      header = header,
      keys = {
        { icon = ' ', key = 'f', desc = 'Find file',   action = function() Snacks.picker.files() end },
        { icon = ' ', key = 'g', desc = 'Search text', action = function() Snacks.picker.grep() end },
        { icon = ' ', key = 'e', desc = 'File tree',   action = function() Snacks.explorer() end },
        { icon = ' ', key = 'q', desc = 'Quit',        action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },
})

-- Keep the header dim  because :colorscheme clears it
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function() vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { link = 'Comment' }) end,
})

-- Picker
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end,   { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end,    { desc = 'Search text' })
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end,    { desc = 'Help' })

-- Explorer
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File tree' })

local explorer_fts = {
  snacks_layout_box = true,
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_picker_preview = true,
}

-- This solution is inspired by the nvim-tree autoclose solutions in https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    local cur = vim.api.nvim_get_current_win()
    local in_explorer = explorer_fts[vim.bo.filetype] ~= nil
    local real_wins, explorer_wins = 0, {}
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
      if explorer_fts[ft] then
        table.insert(explorer_wins, w)
      elseif vim.api.nvim_win_get_config(w).relative == '' then
        real_wins = real_wins + 1
      end
    end
    if #explorer_wins == 0 then return end

    if in_explorer then
      if real_wins == 0 then vim.schedule(function() vim.cmd('qa') end) end
    elseif real_wins == 1 then
      for _, picker in ipairs(Snacks.picker.get({ source = 'explorer' })) do
        picker:close()
      end
      for _, w in ipairs(explorer_wins) do
        if w ~= cur then pcall(vim.api.nvim_win_close, w, true) end
      end
    end
  end,
})

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end,          { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>n',  function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end,    { desc = 'Dismiss notifications' })
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end,        { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Rename file' })
vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end,  { desc = 'Next reference' })
vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev reference' })
vim.keymap.set({ 'n', 't' }, '<C-/>', function() Snacks.terminal() end,     { desc = 'Toggle terminal' })
