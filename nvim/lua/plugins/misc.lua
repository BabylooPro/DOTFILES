local keywords = [[QUESTION,EXCLAMATION,STAR]]

-- Standalone plugins with less than 10 lines of config go here
return {
    {
        -- AUTOMATIC TIME TRACKING
        'wakatime/vim-wakatime',
    },
    {
        -- Tmux & split window navigation
        'christoomey/vim-tmux-navigator',
    },
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
    },
    {
        -- Powerful Git integration for Vim
        'tpope/vim-fugitive',
    },
    {
        -- GitHub integration for vim-fugitive
        'tpope/vim-rhubarb',
    },
    {
        -- Hints keybinds
        'folke/which-key.nvim',
    },
    {
        -- Autoclose parentheses, brackets, quotes, etc.
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
        opts = {},
    },
    {
        -- AUTOMATICALLY RENAME HTML/XML TAGS
        'AndrewRadev/tagalong.vim',
    },
    {
        -- INFO:
        -- WARN:
        -- FIX:
        -- TODO:
        -- HACK:
        -- PERF:
        -- ?
        -- !
        -- *
        -- question
        -- help
        -- alert
        -- important
        -- highlight
        -- star

        -- Highlight todo, notes, etc in comments
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' },
        -- opts = { signs = false },
        enabled = true,

        keys = {
            {"<leader>fy", "<cmd>Find Todo keywords="..keywords.."<cr>"},
        },

        opts = function(_, opts)
            opts.signs = false
            opts.merge_keywords = true
            opts.keywords = {
                ["?"] = { icon = " ", color = "warning", alt = { "question", "help" } },
                ["!"] = { icon = " ", color = "error", alt = { "alert", "important" } },
                ["*"] = { icon = " ", color = "hint", alt = { "highlight", "star" } },
            }
        end,

        config = function()
            require("todo-comments").setup()

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.cmd("highlight Todo? guifg=#ffcc00 guibg=NONE gui=bold")
                    vim.cmd("highlight Todo! guifg=#ff3300 guibg=NONE gui=bold")
                    vim.cmd("highlight Todo* guifg=#ffcc00 guibg=NONE gui=bold")
                end,
            })
        end,
    },
    {
        -- High-performance color highlighter
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    },
    {
        -- EASY CODE COMMENTING
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    },
    {
        -- MARKDOWN PREVIEW PLUGIN
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install && git checkout -- .",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_theme = 'dark'
            vim.g.mkdp_echo_preview_url = 1
        end,
        ft = { "markdown" },
        keys = {
            { '<leader>md', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown Preview Toggle' },
        },
    },
}
