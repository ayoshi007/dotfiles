-- use ':h <option>' for more information about what an option means
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.mouse = "a" -- allow mouse usage in nvim

-- Tab options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true            -- tabs are spaces

-- UI config options
vim.opt.number = true               -- show absolute number
-- vim.opt.relativenumber = true       -- add relative numbers to each line on left side
-- vim.opt.cursorline = true            -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal split right
-- vim.opt.termguicolors = true         -- enable 24-bit RGB colors in TUI
-- vim.opt.showmode = false             -- disable mode display on bottom

-- Searching options
vim.opt.incsearch = true            -- search as characters are entered
vim.opt.hlsearch = false            -- do not highlight matches
vim.opt.ignorecase = true           -- ignore cases by default
vim.opt.smartcase = true            -- make case sensitive if uppercase letters are used

