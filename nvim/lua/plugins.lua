vim.cmd [[
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent execute '!curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
]]

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- add/change/del line highlighting, git blame!
Plug 'lewis6991/gitsigns.nvim'
Plug('smoka7/hop.nvim', { ['version'] = '*' }) -- jump in vim, use smoka7's fork for the camelCase hopping on <Leader>l
Plug 'nvim-lua/plenary.nvim' -- required for telescope for find-in-all-files, and nvim-spectre find & replace in all files
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' }) -- find in all files, open file in dir, * is breaking, think it's installing wrong latest tag
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' }) -- for fuzzy searching/sorting
Plug 'nvim-telescope/telescope-frecency.nvim' -- frecency (frequency & recency) for telescope
Plug 'nvim-pack/nvim-spectre' -- find and replace in all files
Plug 'nvim-tree/nvim-web-devicons' -- optional fonticons for tree explorer
Plug 'nvim-lualine/lualine.nvim' -- status line
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
-- Plug 'marko-cerovac/material.nvim' " material theme
-- Plug 'Mofiqul/dracula.nvim' " dracula theme
-- Plug 'EdenEast/nightfox.nvim' " nightfox nordfox theme
-- Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' } " nightfly theme
-- Plug 'folke/tokyonight.nvim' " tokyonight-moon theme
Plug 'stevearc/oil.nvim' -- apparently this is really cool instead of tree file explorers
Plug 'tpope/vim-fugitive' -- open line in github, lightline branch info
Plug 'tpope/vim-rhubarb' -- for fugitive + github links, check others for other sites
Plug 'shumphrey/fugitive-gitlab.vim' -- for fugitive + gitlab links
-- Plug 'dense-analysis/ale' -- go to def, hover info, intellisense-type stuff
Plug 'mattn/emmet-vim' -- shortcut code
-- Plug 'mattn/webapi-vim' -- in conjunction with emmet-vim for custom snippets
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' }) -- better javascript syntax highlighting/completion
Plug 'code-biscuits/nvim-biscuits' -- nice labels on ending brackets so you can tell
-- Plug 'nvim-treesitter/nvim-treesitter-textobjects' " select function/classes etc
-- LSP stuff
Plug 'neovim/nvim-lspconfig' -- supposedly language syntax/autocomplete/intellisense stuff?
Plug 'williamboman/mason.nvim'           -- Optional
Plug 'williamboman/mason-lspconfig.nvim' -- Optional
Plug 'hrsh7th/nvim-cmp'         -- Required
Plug 'hrsh7th/cmp-nvim-lsp'     -- Required
Plug 'L3MON4D3/LuaSnip'         -- Required
Plug('VonHeikemen/lsp-zero.nvim', { ['branch'] = 'v2.x' })
-- end of LSP stuff
Plug('styled-components/vim-styled-components', { ['branch'] = 'main' })
Plug 'leafOfTree/vim-svelte-plugin' -- for Svelte + emmet
Plug('akinsho/git-conflict.nvim', { ['tag'] = '*' }) -- merge conflict resolution, latest tag (just in case main is broken)
Plug 'yorickpeterse/nvim-pqf' -- for prettier git-conflict list page
Plug 'kdheepak/lazygit.nvim' -- full git ui but slow, git-conflict prob better
Plug 'chrisgrieser/nvim-spider' -- camelCase and snake_case motion
Plug 'chrisgrieser/nvim-various-textobjs' -- camelCase, kebab-case and snake_case selection
Plug 'machakann/vim-sandwich' -- sandwich text in brackets/quotes/tags/etc, sadly not lua
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && yarn install' })
Plug 'windwp/nvim-autopairs' -- auto ) for (
Plug 'NMAC427/guess-indent.nvim' -- guess the indent since autopairs etc seem to fuck it up
-- Plug 'kana/vim-textobj-indent' -- supposedly required for CSS concentric sorting? Seems to work without it though?
Plug 'bzf/vim-concentric-sort-motion' -- CSS concentric sorting, gscii
Plug 'sQVe/sort.nvim' -- for sorting selections with :Sort
Plug('akinsho/bufferline.nvim', { ['tag'] = '*' }) -- show buffers like tabs
Plug 'uga-rosa/ccc.nvim' -- colour picker and shower!
Plug 'stevearc/conform.nvim' -- for prettierd (from Mason)
Plug 'rachartier/tiny-inline-diagnostic.nvim' -- better inline error messages, bit of work to get it to play with gitsigns' current_line_blame, but works!
-- Plug 'rasulomaroff/reactive.nvim' -- for curr line changes based on mode! but it's a bit slow and I don't like the insert green
Plug 'OXY2DEV/markview.nvim' -- in-vim markdown! Needs to be after treesitter and web-devicons (dependencies)
Plug 'andymass/vim-matchup' -- better %, see if it works with `

vim.call('plug#end')

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
            callback = function ()
                require('oil.actions').copy_entry_path.callback()
                vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
            end,
        },
    },
}
require 'conform'.setup {
    formatters_by_ft = {
        -- lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        -- python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettier', 'prettierd' } },
        -- run with conform.format()
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
--require 'nvim-treesitter.configs'.setup {
--    textobjects = {
--        select = {
--            enable = true,
--            -- Automatically jump forward to textobj, similar to targets.vim
--            lookahead = true,
--
--            keymaps = {
--                -- You can use the capture groups defined in textobjects.scm
--                ["af"] = "@function.outer",
--                ["if"] = "@function.inner",
--                ["ac"] = "@class.outer",
--                -- You can optionally set descriptions to the mappings (used in the desc parameter of
--                -- nvim_buf_set_keymap) which plugins like which-key display
--                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
--                -- You can also use captures from other query groups like `locals.scm`
--                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
--                },
--            -- You can choose the select mode (default is charwise 'v')
--            --
--            -- Can also be a function which gets passed a table with the keys
--            -- * query_string: eg '@function.inner'
--            -- * method: eg 'v' or 'o'
--            -- and should return the mode ('v', 'V', or '<c-v>') or a table
--            -- mapping query_strings to modes.
--            selection_modes = {
--                ['@parameter.outer'] = 'v', -- charwise
--                ['@function.outer'] = 'V', -- linewise
--                ['@class.outer'] = '<c-v>', -- blockwise
--                },
--            -- If you set this to `true` (default is `false`) then any textobject is
--            -- extended to include preceding or succeeding whitespace. Succeeding
--            -- whitespace has priority in order to act similarly to eg the built-in
--            -- `ap`.
--            --
--            -- Can also be a function which gets passed a table with the keys
--            -- * query_string: eg '@function.inner'
--            -- * selection_mode: eg 'v'
--            -- and should return true of false
--            include_surrounding_whitespace = true,
--        }
--    }
--}
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
-- require 'material'.setup {
--     lualine_style = 'default',
--     plugins = {
--         'gitsigns',
--         'nvim-cmp',
--         'nvim-web-devicons',
--         'telescope',
--     },
--     styles = {
--         comments = { italic = true },
--         functions = { bold = true },
--     },
--     custom_colors = function(colors)
--         colors.editor.cursor = "#F4DBD6"
--     end
-- }

require 'tiny-inline-diagnostic'.setup {
    virt_texts = {
        priority = 999,
    },
}

require 'gitsigns'.setup {
    numhl = true,
    word_diff = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text_pos = 'right_align', -- stay away from tiny-inline-diagnostic too
        virt_text_priority = 1000, -- be under tiny-inline-diagnostic
    },
}
require 'hop'.setup {
    keys = 'ntesiroamvclpufywhdx',
    uppercase_labels = true
}

-- LSP stuff
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

-- " (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

require('nvim-autopairs').setup {}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ['<Tab>'] = cmp.mapping(function(fallback)
                -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            cmp.confirm()
                        end
                else
                    fallback()
                end
            end, {"i","s","c",}),
    }
})
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

require('lspconfig').ts_ls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        completions = {
            completeFunctionCalls = true
        },
        diagnostics = {
            ignoredCodes = {
                -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                7016, -- Could not find a declaration file for module 'baconjs'. '~/project/node_modules/baconjs/dist/Bacon.js' implicitly has an 'any' type.
                7044, -- Parameter 'x' implicitly has an 'any' type, but a better type may be inferred from usage.
                2556, -- A spread argument must either have a tuple type or be passed to a rest parameter
                2345, -- Argument of type is missing in type
                2416, -- property of type is not assignable to the same property in base type
                -- 2322, -- property 'children' does not exist on type
                -- 2769, -- no overload matches this call
                -- 2305, -- module 'blah' has no exported member 'blah'
            }
        },
        quotePreference = 'single',
        includeCompletionsForImportStatements = true,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayVariableTypeHints = false,
        javascript = {
            format = {
                convertTabsToSpaces = true, -- prob don't need this if editorConfig
                tabSize = 4, -- prob don't need this if editorConfig
                semicolons = 'insert', -- prob don't need this if editorConfig
                insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
                insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
                insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
                trimTrailingWhitespace = true -- prob don't need this if editorConfig
            }
        },
        implicitProjectConfiguration = {
            checkJs = false
        }
    }
}
require('lspconfig').ember.setup {} -- not sure if this actually does anything, but anyway, for handlebars
-- grammarly in html is a WIP so eh just turn it off atm
require('lspconfig').grammarly.setup {
    config = {
        suggestionCategories = { oxfordComma = "on" } },
--        filetypes = { 'markdown', 'javascriptreact' }
}

lsp.setup()

require('guess-indent').setup {}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "astro", "c", "css", "glimmer", "html", "javascript", "jsdoc", "json", "lua", "markdown", "query", "regex", "scss", "svelte", "tsx", "typescript", "vim", "vimdoc", "yaml" },
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
        enable = true,                 -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
  },
}

require 'nvim-biscuits'.setup {
    default_config = {
--        max_length = 12,
        cursor_line_only = true,
        min_distance = 5,
        prefix_string = "📎 "
    },
    language_config = {
        html = {
            prefix_string = "🌐 "
        },
        javascript = {
            prefix_string = "🥠 ", -- ✨
            max_length = 80
        },
--        python = {
--            disabled = true
--        }
    }
}

require 'telescope'.setup {
    defaults = {
        file_ignore_patterns = {".git/", "tmp/", "node_modules/", "dist/", ".DS_Store"},
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
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
        },
        frecency = {
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = {".git/", "tmp/", "node_modules/", "dist/", ".DS_Store"},
        },
    },
}
require 'telescope'.load_extension('fzf')
require 'telescope'.load_extension('frecency')
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
require 'pqf'.setup {}
require 'spider'.setup { skipInsignificantPunctuation = true }
require 'various-textobjs'.setup { useDefaultKeymaps = true }
-- various-textobjs sets camelCase/snake_case parts to S which I find annoying,
-- choosing e as it doesn't exist
vim.keymap.set({ 'o', 'x' }, 'ae', '<cmd>lua require("various-textobjs").subword(false)<CR>')
vim.keymap.set({ 'o', 'x' }, 'ie', '<cmd>lua require("various-textobjs").subword(true)<CR>')

require 'sort'.setup {}

-- h/l for left/right on sliders, a toggles the alpha channel
require 'ccc'.setup {
    highlighter = {
        auto_enable = true,
        lsp = true,
    },
}

require 'catppuccin'.setup {
    color_overrides = {
        mocha = {
            base = '#13131e',
        },
    },
}

require 'bufferline'.setup {
    options = {
        diagnostics = "nvim_lsp",
        max_name_length = 23,
        max_prefix_length = 20,
        middle_mouse_command = "%bd|e#", -- doesn't work with iTerm
        numbers = "buffer_id",
        right_mouse_command = "%bd|e#", -- doesn't work with iTerm
        tab_size = 23,
        offsets = {
            {
                filetype = "oil",
                text = "Oil",
                text_align = "center",
                separator = true,
            }
        },
    }
}

-- require 'reactive'.setup {
--   builtin = {
--     cursorline = true,
--     cursor = true,
--     modemsg = true,
--   }
-- }

-- require('lazy').setup(plugins) -- not using Lazy because emmet-vim doesn't work properly with it
