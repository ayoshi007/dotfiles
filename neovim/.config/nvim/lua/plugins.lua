-- Installs Packer.nvim if not alreayd installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    -- installs Packer.nvim
    if fn.empty(fn.glob(instapp_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'http://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()

-- reloads configurations if plugins.lua is modified
-- <afile> is replaced with the filename of the buffer being manipulated
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Install plugins here by adding 'use ...'
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'


    -- Add third party plugins here --
    use 'tanvirtin/monokai.nvim'
    use {'williamboman/mason.nvim'}
    use {'williamboman/mason-lspconfig.nvim'}
    use {'neovim/nvim-lspconfig'}
    use {'hrsh7th/nvim-cmp', config = [[require('config.nvim-cmp')]]}
    use {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'}
    use {'hrsh7th/cmp-buffer', after = 'nvim-cmp'}      -- buffer autocompletion
    use {'hrsh7th/cmp-path', after = 'nvim-cmp'}        -- path autocompletion
    use {'hrsh7th/cmp-cmdline', after = 'nvim-cmp'}     -- cmdline autocompletion
    use 'L3MON4D3/LuaSnip'                              -- code snippet engine (comment out if not desired)
    use 'saadparwaiz1/cmp_luasnip'


    -- Set up configurations after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

