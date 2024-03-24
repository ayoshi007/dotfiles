-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

-----------------
-- Normal mode --
-----------------
-- See ':h vim.map.set()' for more information
-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Window resizing
-- delta = 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- visual mode --
-----------------
-- starts visual mode with the same area as the previous area and the same mode
--vim.keymap.set('v', '<', '<gv', opts)
--vim.keymap.set('v', '>', '>gv', opts)

