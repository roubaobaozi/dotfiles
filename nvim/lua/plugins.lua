return {
    {
        'folke/lazy.nvim',
        -- It is highly recommended to leave this configuration block untouched.
        -- The reason is that doing so may cause plugins to not load.
        -- If you wish to modify it, please read the documentation thoroughly.
        lazy = false,
        priority = 50,
    },
    {
        'lewis6991/gitsigns.nvim', -- add/change/del line highlighting, git blame!
        config = function()
            require 'gitsigns'.setup {
                numhl = true,
                word_diff = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text_pos = 'right_align', -- stay away from tiny-inline-diagnostic too
                    virt_text_priority = 1000,     -- be under tiny-inline-diagnostic
                },
            }
        end,
    },
    {
        'smoka7/hop.nvim', -- jump in vim, use smoka7's fork for the camelCase hopping on <Leader>l
        version = '*',
        config = function()
            require 'hop'.setup {
                keys = 'ntesiroamvclpufywhdx',
                uppercase_labels = true,
            }
        end,
    },
    {
        'nvim-telescope/telescope.nvim', -- find in all files, open file in dir, * is breaking, think it's installing wrong latest tag
        version = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim', -- required for telescope for find-in-all-files, and nvim-spectre find & replace in all files
        },
        config = function()
            require 'telescope'.setup {
                defaults = {
                    file_ignore_patterns = { ".git/", "tmp/", "node_modules/", "dist/", ".DS_Store" },
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--hidden',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--ignore-case',
                        '--smart-case'
                    }
                },
                pickers = {
                    find_files = {
                        hidden = true
                    },
                    live_grep = {
                        hidden = true
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    frecency = {
                        show_scores = true,
                        show_unindexed = true,
                        ignore_patterns = { ".git/", "tmp/", "node_modules/", "dist/", ".DS_Store" },
                    },
                },
            }
            require 'telescope'.load_extension('fzf')
            require 'telescope'.load_extension('frecency')
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim', -- for fuzzy searching/sorting
        build = 'make',
    },
    {
        'nvim-telescope/telescope-frecency.nvim', -- frecency (frequency & recency) for telescope
    },
    {
        'nvim-pack/nvim-spectre', -- find and replace in all files
        config = function()
            require 'spectre'.setup {
                open_cmd = 'tabnew',
                is_insert_mode = true,
                mapping = {
                    ['send_to_qf'] = {
                        map = "<leader>sq"
                    },
                    ['replace_cmd'] = {
                        map = "<leader>sr"
                    },
                    ['change_view_mode'] = {
                        map = "<leader>sv"
                    },
                    ['resume_last_search'] = {
                        map = "<leader>sl"
                    }
                }
            }
        end,
    },
    {
        'sindrets/diffview.nvim',
        -- command = 'DiffviewOpen',
        config = function()
            require 'diffview'.setup {
                -- key_bindings = {
                --     file_panel = {
                --         ["j"] = "<Down>",
                --         ["k"] = "<Up>",
                --         ["<CR>"] = "select_entry",
                --         ["o"] = "select_entry",
                --         ["R"] = "refresh_files",
                --         ["<C-r>"] = "refresh_files",
                --         ["<C-s>"] = "toggle_stage_entry",
                --         ["U"] = "unstage_entry",
                --         ["X"] = "restore_entry",
                --         ["D"] = "delete_entry",
                --         ["<C-q>"] = "close",
                --     },
                --     file_history_panel = {
                --         ["g!"] = "options",
                --         ["<C-d>"] = "diff_file",
                --         ["<CR>"] = "select_entry",
                --         ["o"] = "select_entry",
                --         ["<C-q>"] = "close",
                --     },
                --     view = {
                --         ["<C-q>"] = "close",
                --     },
                --     diff_options = {
                --         ["scrollbar"] = true,
                --     },
                -- },
            }

            vim.keymap.set('n', '<Leader><Leader>d', function()
                if next(require('diffview.lib').views) == nil then
                    vim.cmd('DiffviewOpen')
                else
                    vim.cmd('DiffviewClose')
                end
            end)

            vim.opt.diffopt = {
                "internal",
                "filler",
                "closeoff",
                "context:12",
                "algorithm:histogram",
                "linematch:200",
                "indent-heuristic",
                "iwhite" -- I toggle this one, it doesn't fit all cases.
            }
        end,
    },
    {
        'nvim-tree/nvim-web-devicons', -- optional fonticons for tree explorer
    },
    {
        'nvim-lualine/lualine.nvim', -- status line
        config = function()
            require 'lualine'.setup {
                options = {
                    -- theme = 'material',
                    theme = 'catppuccin-mocha',
                },
                sections = {
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                        }
                    }
                },
            }
        end,
    },
    {
        'catppuccin/nvim', -- current theme
        name = 'catppuccin',
        config = function()
            require 'catppuccin'.setup {
                color_overrides = {
                    mocha = {
                        base = '#13131e',
                    },
                },
            }
        end,
    },
    {
        'stevearc/oil.nvim', -- apparently this is really cool instead of tree file explorers
        config = function()
            require 'oil'.setup {
                default_file_explorer = false, -- fuuuuck I still need netrw for :GBrowse, don't just disable it!!!
                delete_to_trash = true,
                -- trash_command = 'trash', -- now has native trash apparently!
                view_options = {
                    show_hidden = true,
                },
                float = {
                    padding = 3,
                },
                keymaps = {
                    ['yp'] = {
                        desc = 'Copy filepath to system clipboard',
                        callback = function()
                            require('oil.actions').copy_entry_path.callback()
                            vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
                        end,
                    },
                },
            }
        end,
    },
    --[[ {
        'benomahony/oil-git.nvim',
        dependencies = { 'stevearc/oil.nvim' },
        -- No opts or config needed! Works automatically
    }, ]]
    {
        'tpope/vim-fugitive', -- open line in github, lightline branch info
    },
    {
        'tpope/vim-rhubarb', -- for fugitive + github links, check others for other sites
    },
    {
        'shumphrey/fugitive-gitlab.vim', -- for fugitive + gitlab links
    },
    {
        'nvim-treesitter/nvim-treesitter', -- better javascript syntax highlighting/completion
        dependencies = { 'OXY2DEV/markview.nvim' },
        lazy = false,
        cmd = 'TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "astro", "c", "css", "glimmer", "html", "javascript", "jsdoc", "json", "lua", "markdown", "query", "regex", "scss", "styled", "svelte", "tsx", "typescript", "vim", "vimdoc", "yaml" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        node_incremental = "v",
                        node_decremental = "V",
                    },
                },
                matchup = {
                    enable = true, -- mandatory, false will disable the whole extension
                    -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
                },
            }
        end,
    },
    {
        'code-biscuits/nvim-biscuits', -- nice labels on ending brackets so you can tell
        ensure_installed = 'maintained',
        config = function()
            require 'nvim-biscuits'.setup {
                default_config = {
                    --        max_length = 12,
                    cursor_line_only = true,
                    min_distance = 5,
                    prefix_string = "📎 "
                },
                language_config = {
                    html = {
                        prefix_string = "🌐 ",
                    },
                    javascript = {
                        prefix_string = "🥠 ", -- ✨
                        max_length = 80,
                    },
                    --        python = {
                    --            disabled = true
                    --        }
                }
            }
        end,
    },
    -- LSP stuff
    {
        'neovim/nvim-lspconfig', -- supposedly language syntax/autocomplete/intellisense stuff?
        config = function()
            vim.lsp.config('typos_lsp', {
                root_markers = { '~/.dotfiles/nvim/spell/typos.toml' },
            })
        end,
    },
    {
        'mason-org/mason.nvim', -- Optional, if :Mason isn't installing updates with no version found, do `npm cache clean -fd`
        opts = {},
    },
    {
        'mason-org/mason-lspconfig.nvim', -- Optional
        dependencies = {
            'neovim/nvim-lspconfig',
            'mason-org/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'cssmodules_ls',
                'emmet_language_server',
                'emmet_ls',
                'gh_actions_ls',
                'lua_ls',
                'stylelint_lsp',
                'ts_ls',
                'typos_lsp',
            }
        },
    },
    {
        'hrsh7th/nvim-cmp',         -- Required
        dependencies = {
            'onsails/lspkind.nvim', -- for icons in suggestions, eg. Copilot
        },
        config = function()
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            cmp.setup({
                formatting = {
                    -- needs https://github.com/onsails/lspkind.nvim , also, it interferes with Up/Down arrows on cmp, but sometimes doesn't even work, kinda annoying
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                        max_width = 50,
                        symbol_map = { Copilot = '' }
                    })
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            end
                            cmp.confirm()
                        else
                            fallback()
                        end
                    end, { 'i', 's', 'c', }),
                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item()),
                    ['<PageDown>'] = cmp.mapping(cmp.mapping.select_next_item()),
                    -- ['<PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item()),
                    ['<PageUp>'] = cmp.mapping(cmp.mapping.select_prev_item()),
                    -- ['<PageUp>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
                },
                -- https://mskelton.dev/bytes/emmet-for-styled-components-in-neovim
                -- code highlight works in styled components, but emmet suggestions don't, sigh
                sources = cmp.config.sources({
                        -- Copilot Source
                        { name = 'copilot', group_index = 2 },
                        {
                            name = 'nvim_lsp',
                            group_index = 2,
                            entry_filter = function(entry)
                                local client_name = entry.source.source.client.name
                                local context = require('cmp.config.context')

                                -- Only return Emmet results in styled-component template strings
                                return client_name ~= 'emmet_language_server'
                                    or entry.context.filetype == 'css'
                                    or context.in_treesitter_capture('styled')
                            end,
                        },
                        -- Other Sources
                        { name = 'path',    group_index = 2 },
                        { name = 'luasnip', group_index = 2 },
                    },
                    { name = 'buffer' }
                )
            })

            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
    {
        'hrsh7th/cmp-nvim-lsp', -- Required
    },
    {
        'L3MON4D3/LuaSnip', -- Required
    },
    -- end of LSP stuff
    {
        'styled-components/vim-styled-components',
        branch = 'main',
    },
    {
        'leafOfTree/vim-svelte-plugin', -- for Svelte + emmet
    },
    {
        'akinsho/git-conflict.nvim', -- merge conflict resolution, latest tag (just in case main is broken)
        version = '*',
        config = function()
            require 'git-conflict'.setup {
                default_mappings = {
                    ours = 'co',
                    theirs = 'ct',
                    none = 'c0',
                    both = 'cb',
                    next = '[x',
                    prev = '[b'
                },
                highlights = { -- They must have background color, otherwise the default color will be used
                    current = 'DiffChange',
                    incoming = 'DiffAdd',
                },
            }
        end,
    },
    {
        'yorickpeterse/nvim-pqf', -- for prettier git-conflict list page
        config = function()
            require 'pqf'.setup {}
        end,
    },
    {
        'kdheepak/lazygit.nvim', -- full git ui but slow, git-conflict prob better
    },
    {
        'chrisgrieser/nvim-spider', -- camelCase and snake_case motion
        config = function()
            require 'spider'.setup { skipInsignificantPunctuation = true }
        end,
    },
    {
        'chrisgrieser/nvim-various-textobjs', -- camelCase, kebab-case and snake_case selection
        config = function()
            require 'various-textobjs'.setup {
                keymaps = { defaultKeymaps = true }
            }
            -- various-textobjs sets camelCase/snake_case parts to S which I find annoying,
            -- choosing e as it doesn't exist
            vim.keymap.set({ 'o', 'x' }, 'ae', '<cmd>lua require("various-textobjs").subword(false)<CR>')
            vim.keymap.set({ 'o', 'x' }, 'ie', '<cmd>lua require("various-textobjs").subword(true)<CR>')
        end,
    },
    {
        'machakann/vim-sandwich', -- sandwich text in brackets/quotes/tags/etc, sadly not lua
    },
    {
        'iamcco/markdown-preview.nvim', -- preview markdown files!
        build = 'cd app && yarn install',
    },
    {
        'windwp/nvim-autopairs', -- auto ) for (
        config = function()
            require('nvim-autopairs').setup {}
        end,
    },
    {
        'NMAC427/guess-indent.nvim', -- guess the indent since autopairs etc seem to fuck it up
        config = function()
            require('guess-indent').setup {}
        end,
    },
    {
        'bzf/vim-concentric-sort-motion', -- CSS concentric sorting, gscii
    },
    {
        'sQVe/sort.nvim', -- for sorting selections with :Sort
        config = function()
            require 'sort'.setup {}
        end,
    },
    {
        'akinsho/bufferline.nvim', -- show buffers like tabs
        version = '*',
        config = function()
            require 'bufferline'.setup {
                options = {
                    diagnostics = 'nvim_lsp',
                    max_name_length = 23,
                    max_prefix_length = 20,
                    middle_mouse_command = '%bd|e#', -- doesn't work with iTerm
                    numbers = 'buffer_id',
                    right_mouse_command = '%bd|e#',  -- doesn't work with iTerm
                    tab_size = 23,
                    offsets = {
                        {
                            filetype = 'oil',
                            text = 'Oil',
                            text_align = 'center',
                            separator = true,
                        }
                    },
                }
            }
        end,
    },
    {
        'uga-rosa/ccc.nvim', -- colour picker and shower!
        config = function()
            -- h/l for left/right on sliders, a toggles the alpha channel
            require 'ccc'.setup {
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            }
        end,
    },
    {
        'stevearc/conform.nvim', -- for prettierd (from Mason)
        config = function()
            require 'conform'.setup {
                formatters_by_ft = {
                    -- lua = { 'stylua' },
                    -- Conform will run multiple formatters sequentially
                    -- python = { 'isort', 'black' },
                    -- Use a sub-list to run only the first available formatter
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    typescript = { 'prettierd', 'prettier', stop_after_first = true },
                    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    -- run with conform.format()
                },
                format_on_save = {
                    -- I recommend these options. See :help conform.format for details.
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
            }
            vim.api.nvim_create_user_command('Format', function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ['end'] = { args.line2, end_line:len() },
                    }
                end
                require('conform').format({ async = true, lsp_fallback = true, range = range })
            end, { range = true })
        end,
    },
    {
        'rachartier/tiny-inline-diagnostic.nvim', -- better inline error messages, bit of work to get it to play with gitsigns' current_line_blame, but works!
        config = function()
            require 'tiny-inline-diagnostic'.setup {
                virt_texts = {
                    priority = 999,
                },
            }
        end,
    },
    {
        'OXY2DEV/markview.nvim', -- in-vim markdown! Needs to be after treesitter and web-devicons (dependencies)
        lazy = false,
        -- For `nvim-treesitter` users.
        priority = 49,
    },
    {
        'andymass/vim-matchup', -- better %, see if it works with `
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring', -- pre-commit hook for Comment.nvim for TSX/JSX!
        config = function()
            require 'ts_context_commentstring'.setup {
                enable_autocmd = false,
            }
        end,
    },
    {
        'numToStr/Comment.nvim', -- better commenting
        config = function()
            require 'Comment'.setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                -- toggler = {
                --     ---Line-comment toggle keymap
                --     line = '<Leader>cc',
                --     ---Block-comment toggle keymap
                --     block = '<Leader>bc',
                -- },
                -- ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                -- opleader = {
                --     ---Line-comment keymap
                --     line = '<Leader>c',
                --     ---Block-comment keymap
                --     block = '<Leader>b',
                -- },
                -- extra = {
                --     ---Add comment on the line above
                --     above = '<Leader>cO',
                --     ---Add comment on the line below
                --     below = '<Leader>co',
                --     ---Add comment at the end of line
                --     eol = '<Leader>cA',
                -- },
            }
        end,
    },
    -- {
    --     'folke/ts-comments.nvim', -- better commenting for TSX/JSX?
    --     opts = {},
    --     event = "VeryLazy",
    --     enabled = vim.fn.has("nvim-0.10.0") == 1,
    -- },
    {
        'skardyy/neo-img', -- image preview in Oil, but it doesn't work atm
        build = 'cd ttyimg && go build',
        config = function()
            require 'neo-img'.setup {
                supported_extensions = {
                    ['png'] = true,
                    ['jpg'] = true,
                    ['jpeg'] = true,
                    ['webp'] = true,
                    ['svg'] = true,
                    ['tiff'] = true
                },
                auto_open = true,               -- Automatically open images when buffer is loaded
                oil_preview = true,             -- changes oil preview of images too
                backend = 'auto',               -- auto detect: kitty / iTerm / sixel
                size = {                        --scales the width, will maintain aspect ratio
                    oil = { x = 400, y = 400 }, -- a number (oil = 400) will set both at once
                    main = { x = 800, y = 800 }
                },
                offset = {
                    oil = { x = 5, y = 3 }, -- a number will only change the x
                    main = { x = 10, y = 3 }
                },
                resizeMode = 'Fit' -- Fit / Stretch / Crop
            }
        end,
    },
    {
        'zbirenbaum/copilot.lua', -- Copilot
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require 'copilot'.setup {
                suggestion = { enabled = false },
                panel = { enabled = false },
            }
        end,
    },
    {
        'zbirenbaum/copilot-cmp',
        config = function()
            require 'copilot_cmp'.setup {}
        end,
    },
    --[[ {
        'r0nsha/multinput.nvim',
    }, ]]
}
