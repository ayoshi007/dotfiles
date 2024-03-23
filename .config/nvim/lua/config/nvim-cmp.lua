local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        
        -- for luasnip users
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll through docs
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR> to confirm selection
        ['<CR>'] = cmp.mapping.confirm({
            -- accept currently selected item (set to false to only confirm explicitly selected items
            select = true
        }),
        -- Super tabbing, courtesy of https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ['<Tab>'] = cmp.mapping(
            function(fallback)
                -- if completion menu is visible, then select next item
                if cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            -- set for insert and select mode
            {'i', 's'}
        ),
        ['<S-Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            {'i', 's'}
        )

    }),
    -- item appearance configuration, courtesy of https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    formatting = {
        -- sets order from left to right
        -- kind: single letter indicating the type of completion
        -- abbr: abbreviation of 'word'; when not empty, use abbreviation of 'word' in the menu
        -- menu: extra text for the popup menu, displayed after 'word' or 'abbr'
        fields = {'abbr', 'menu'},

        -- customize completion menu appearance
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '[Lsp]',
                luasnip = '[Luasnip]',
                buffer = '[File]',
                path = '[Path]',
            })[entry.source.name]
            return vim_item
        end,

    },
    -- set source precedence
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },  -- for nvim-lap
        { name = 'luasnip' },   -- for luasnip user
        { name = 'buffer' },    -- for buffer word completion
        { name = 'path' },      -- for path completion
    })
})
