return {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        -- DETECT SYSTEM THEME
        local function get_system_appearance()
            local is_mac = vim.loop.os_uname().sysname == "Darwin"
            if is_mac then            
                local result = vim.fn.system [[osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode']]
                return result:match("true") or result:match("1")
            end

            -- fallback: always dark on non-macOS
            return true 
        end

        -- CUSTOM DARK THEME CONFIG
        local dark_config = {
            colors = {
                bg = "#202020",
                fg = "#D4D4D4",
                red = "#FF6C6B",
                orange = "#FF8800",
                yellow = "#E5C07B",
                green = "#98C379",
                cyan = "#56B6C2",
                blue = "#61AFEF",
                purple = "#C678DD",
                line = "#252525",
                selection = "#4E4E4E",
                comment = "#767676",
                folder = "#F8D775",
            },
            highlights = {
                -- INTERFACE HIGHLIGHTS --
                Normal = { bg = "#202020", fg = "#D4D4D4" },
                NormalFloat = { bg = "#202020" },
                FloatBorder = { bg = "#202020", fg = "#353535" },
                CursorLine = { bg = "#252525" },
                CursorLineNr = { fg = "#FFFFFF" },
                LineNr = { fg = "#FFFFFF" },
                Visual = { bg = "#4E4E4E" },
                Search = { bg = "#7E7E7E" },
                Comment = { fg = "#767676", style = "italic" },

                -- NEOTREE BASE COLORS --
                NeoTreeNormal = { bg = "#202020", fg = "#D4D4D4" },
                NeoTreeNormalNC = { bg = "#202020", fg = "#D4D4D4" },
                NeoTreeDirectoryName = { fg = "#F8D775" },
                NeoTreeDirectoryIcon = { fg = "#F8D775" },
                NeoTreeRootName = { fg = "#F8D775", style = "bold" },
                NeoTreeFileName = { fg = "#D4D4D4" },
                NeoTreeFileIcon = { fg = "#98C379" },

                -- GIT STATUS COLOR
                NeoTreeGitAdded = { fg = "#98C379" },      -- GREEN
                NeoTreeGitDeleted = { fg = "#FF6C6B" },    -- RED
                NeoTreeGitModified = { fg = "#FF8800" },   -- ORANGE
                NeoTreeGitConflict = { fg = "#C678DD" },   -- PURPLE
                NeoTreeGitUntracked = { fg = "#98C379" },  -- GREEN
                NeoTreeGitUnstaged = { fg = "#FF8800" },   -- ORANGE
                NeoTreeGitStaged = { fg = "#98C379" },     -- GREEN
                NeoTreeGitRenamed = { fg = "#FF8800" },    -- ORANGE
                NeoTreeGitIgnored = { fg = "#767676" },    -- GRAY
                NeoTreeFloatNormal = { bg = "#202020" },   -- BLACK (background)
                NeoTreeFloatBorder = { bg = "#202020", fg = "#353535" }, -- BLACK (border)
                NeoTreeTitleBar = { bg = "#202020", fg = "#D4D4D4" }, -- BLACK (title bar)
            }
        }

        -- CUSTOM LIGHT THEME CONFIG
        local light_config = {
            highlights = {
                -- NEOTREE BASE COLORS --
                NeoTreeDirectoryName = { fg = "#F8D775" },
                NeoTreeDirectoryIcon = { fg = "#F8D775" },
                NeoTreeRootName = { fg = "#F8D775", style = "bold" },

                -- GIT STATUS COLORS --
                NeoTreeGitAdded = { fg = "#50A14F" },      -- GREEN
                NeoTreeGitDeleted = { fg = "#E45649" },    -- RED
                NeoTreeGitModified = { fg = "#C18401" },   -- ORANGE
                NeoTreeGitConflict = { fg = "#A626A4" },   -- PURPLE
                NeoTreeGitUntracked = { fg = "#50A14F" },  -- GREEN
                NeoTreeGitUnstaged = { fg = "#C18401" },   -- ORANGE
                NeoTreeGitStaged = { fg = "#50A14F" },     -- GREEN
                NeoTreeGitRenamed = { fg = "#C18401" },    -- ORANGE
                NeoTreeGitIgnored = { fg = "#A0A1A7" },    -- GRAY
            }
        }

        -- FUNCTION TO APPLY THEME CONFIGURATION
        local function apply_theme(is_dark, transparency)
            local config = {
                options = {
                    transparency = transparency or false,
                    terminal_colors = true,
                }
            }

            if is_dark then
                config.colors = dark_config.colors
                config.highlights = dark_config.highlights
            else
                config.highlights = light_config.highlights
            end

            require('onedarkpro').setup(config)
            vim.opt.background = is_dark and 'dark' or 'light'
            vim.cmd('colorscheme ' .. (is_dark and 'onedark' or 'onelight'))
        end

        -- INITIAL THEME SETUP
        local is_dark = get_system_appearance()
        apply_theme(is_dark, false)

        -- TOGGLE TRANSPARENCY
        local bg_transparent = false
        vim.keymap.set('n', '<leader>bg', function()
            bg_transparent = not bg_transparent
            apply_theme(is_dark, bg_transparent)
        end, { noremap = true, silent = true })

        -- AUTO-UPDATE THEME WHEN SYSTEM APPEARANCE CHANGES
        vim.api.nvim_create_autocmd("Signal", {
            pattern = "SIGUSR1",
            callback = function()
                is_dark = get_system_appearance()
                apply_theme(is_dark, bg_transparent)
            end,
        })
    end
}
