" Plugins
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

silent! if plug#begin()
Plug 'lewis6991/gitsigns.nvim' " add/change/del line highlighting, git blame!
Plug 'roubaobaozi/hop.nvim', { 'branch': 'feature/camel-case' } " jump in vim, use my own fork for the camelCase hopping on <Leader>l
Plug 'nvim-lua/plenary.nvim' " required for telescope for find-in-all-files, and nvim-spectre find & replace in all files
Plug 'nvim-telescope/telescope.nvim', { 'tag': '*' } " find in all files, open file in dir
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' } " required for telescope
Plug 'nvim-pack/nvim-spectre' " find and replace in all files
Plug 'kaicataldo/material.vim', { 'branch': 'main' } " theme
Plug 'itchyny/lightline.vim' " status line
Plug 'tpope/vim-fugitive' " open line in github, lightline branch info
Plug 'tpope/vim-rhubarb' " for fugitive + github links, check others for other sites
Plug 'shumphrey/fugitive-gitlab.vim' " for fugitive + gitlab links
"Plug 'dense-analysis/ale' " go to def, hover info, intellisense-type stuff
Plug 'mattn/emmet-vim' " shortcut code
Plug 'mattn/webapi-vim' " in conjunction with emmet-vim for custom snippets
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " better javascript syntax highlighting/completion
" LSP stuff
Plug 'neovim/nvim-lspconfig' " supposedly language syntax/autocomplete/intellisense stuff?
Plug 'williamboman/mason.nvim'           " Optional
Plug 'williamboman/mason-lspconfig.nvim' " Optional
Plug 'hrsh7th/nvim-cmp'         " Required
Plug 'hrsh7th/cmp-nvim-lsp'     " Required
Plug 'L3MON4D3/LuaSnip'         " Required
Plug 'VonHeikemen/lsp-zero.nvim', { 'branch': 'v2.x' }
" end of LSP stuff
" Plug 'neoclide/vim-jsx-improve' " javascriptreact syntax, better react/jsx
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'akinsho/git-conflict.nvim', { 'tag': '*' } " merge conflict resolution, latest tag (just in case main is broken)
Plug 'yorickpeterse/nvim-pqf' " for prettier git-conflict list page
Plug 'kdheepak/lazygit.nvim' " full git ui but slow, git-conflict prob better
Plug 'pocco81/auto-save.nvim' " auto saving!
Plug 'chrisgrieser/nvim-spider' " camelCase and snake_case motion
Plug 'chrisgrieser/nvim-various-textobjs' " camelCase, kebab-case and snake_case selection
Plug 'machakann/vim-sandwich' " sandwich text in brackets/quotes/tags/etc, sadly not lua
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'windwp/nvim-autopairs' " auto ) for (
Plug 'NMAC427/guess-indent.nvim' " guess the indent since autopairs etc seem to fuck it up
"Plug 'kana/vim-textobj-indent' " supposedly required for CSS concentric sorting? Seems to work without it though?
Plug 'bzf/vim-concentric-sort-motion' " CSS concentric sorting, gscii
Plug 'sQVe/sort.nvim' " for sorting selections with :Sort
call plug#end()
endif

" Settings
" editorConfig is enabled by default in neovim: https://neovim.io/doc/user/editorconfig.html
lua <<EOF
require 'auto-save'.setup {
    enabled = true,
    execution_message = { cleaning_interval = 2000 },
    trigger_events = {"InsertLeave", "TextChanged", "TextYankPost"},
    debounce_delay = 2000
}
-- debounce_delay technically doesn't do anything, waiting on https://github.com/pocco81/auto-save.nvim/issues/61
require 'gitsigns'.setup {
    numhl = true,
    word_diff = true,
    current_line_blame = true
}
require 'hop'.setup {
    keys = 'ntesiroamvclpufywhdx',
    uppercase_labels = true
}

-- LSP stuff
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
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

require('lspconfig').tsserver.setup{
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
            checkJs = true
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
    }
}
require 'telescope'.setup {
    defaults = {
        file_ignore_patterns = { "^.git/", "node_modules/", "dist/" },
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
        }
    }
}
require 'spectre'.setup {
    open_cmd = 'tabnew',
    is_insert_mode = true,
    mapping = {
       ['send_to_qf'] = {
           map = "<leader>sq"
       },
       ['replace_cmd'] = {
           map = "<leader>sc"
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
}
require 'pqf'.setup {}
require 'spider'.setup { skipInsignificantPunctuation = true }
require 'various-textobjs'.setup { useDefaultKeymaps = true }
-- various-textobjs sets camelCase/snake_case parts to S which I find annoying,
-- choosing e as it doesn't exist
vim.keymap.set({ 'o', 'x' }, 'ae', '<cmd>lua require("various-textobjs").subword(false)<CR>')
vim.keymap.set({ 'o', 'x' }, 'ie', '<cmd>lua require("various-textobjs").subword(true)<CR>')

require 'sort'.setup {}
EOF
" end of lua specific stuff

syntax on " Syntax highlighting
" syntax doesn't automatically apply correctly for any of these
augroup set_ft_syntax
  au!
  autocmd BufNewFile,BufRead *.html.twig   set filetype=html
  autocmd BufNewFile,BufRead *.html.twig   set syntax=html
  autocmd BufNewFile,BufRead *.js          set filetype=javascriptreact
  autocmd BufNewFile,BufRead *.js          set syntax=javascriptreact
  autocmd BufNewFile,BufRead *.scss        set syntax=scss
  autocmd BufNewFile,BufRead *.html        set syntax=html
  autocmd BufNewFile,BufRead *.astro       set syntax=html
augroup END
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1
colorscheme material
if (has('termguicolors'))
    set termguicolors
endif
" highlight Visual cterm=none ctermbg=Blue ctermfg=cyan
if exists('g:vscode')
    " no lightline on vscode, so turn noshowmode off
    set showmode
else
    set noshowmode " lightline handles this
    " set spell " spell check. :setlocal spell spelllang=en
    " set spelllang=en " spell language, go for regular en so it covers en_us and en_uk
    " Spellcheck ignore camelCase/MixedCase .. but it doesn't work, why not?
    " @TODO: get this to work
    "fun! IgnoreCamelCaseSpell()
    "    syn match myExCapitalWords "\w*[_0-9A-Z-]\w*" contains=@NoSpell
    "    syn cluster Spell add=myExCapitalWords
    "    "syn match CamelCase /\<[a-ZA-Z]\+[a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
    "    "syn cluster Spell add=CamelCase
    "endfun
    "autocmd BufRead,BufNewFile * :call IgnoreCamelCaseSpell()
endif
" lightline settings
let g:lightline = {
    \ 'colorscheme': 'material_vim',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'readonly', 'filename', 'modified' ],
    \               [ 'gitbranch' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'filetype' ] ]
    \ },
    \ 'component_function': {
    \     'gitbranch': 'FugitiveHead',
    \     'filename': 'LightlineFilename'
    \ },
    \ 'component': {
    \     'lineinfo': '%3l:%-2v%<'
    \ }
\ }

function! LightlineFilename()
    return expand('%:t') !=# '' ? expand('%:ft') : '[No Name]'
endfunction

"if exists('g:vscode')
"    let g:ale_completion_enabled = 0
"    let b:ale_linters = {}
"    let g:ale_linters_explicit = 1
"else
    " gonna use LSPs
"    let g:ale_completion_enabled = 0
"    let g:ale_linter_aliases = {'javascript': ['css', 'javascript']}
"    let g:ale_linters = {'javascript': ['stylelint', 'eslint', 'tsserver']}
"    let g:ale_fixers = {
"    \   '*': ['trim_whitespace'],
"    \   'javascript': ['stylelint', 'eslint']
"    \ }
"endif
set timeoutlen=300
set whichwrap=b,s,<,>
set tabstop=4
set shiftwidth=4
set expandtab smarttab
set scrolloff=5
set encoding=utf-8
set showmatch " Shows matching brackets
set ruler " Always shows location in file (line# and column, this is in status bar)
set number " show line numbers in insert mode, and below autocmd to also show relative line numbers otherwise
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
set smarttab " Auto-tabs for certain code
set backspace=indent,eol,start
set ignorecase smartcase
filetype plugin indent on
set autoindent smartindent
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,space:·,trail:·
set textwidth=0
set clipboard=unnamed
set wildignore+=**/node_modules/**,.git/**,dist/**,**/*.jpg,**/*.jpeg,**/*.png,**/*.gif
if exists('&colorcolumn')
    set colorcolumn=140
endif
set updatetime=1000 " for how long to wait until writing to swapfile

" Emmet settings
let g:user_emmet_leader_key = ','
let g:user_emmet_expandabbr_key = '<A-Tab>'
let g:user_emmet_mode = 'a' " a is all, n is normal, inv is insert/normal/visual (same as a)
let g:user_emmet_settings = { 'javascript': { 'extends': 'jsx,scss' }, 'javascript.jsx': { 'extends': 'jsx,scss' } }

" Leader key remaps
let mapleader = ' '
let maplocalleader = ' '
nnoremap <Leader>q :q<CR>
nnoremap <Leader>qn :q!<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>w yiw$%o<CR>console.warn('arst ', );<Esc>5hp3lp==
nnoremap <Leader>f <cmd>Telescope live_grep<CR>
nnoremap <Leader>p <cmd>Telescope find_files<CR>
nnoremap <Leader>g <Esc>v:'<,'>GBrowse<CR>
vnoremap <Leader>g :GBrowse<CR>
"nnoremap <Leader>a <Plug>(ale_fix)
lua vim.keymap.set('n', '<Leader>a', vim.lsp.buf.format) -- format the code
nnoremap <Leader>r <C-r>
nnoremap <Leader>s <cmd>lua require('spectre').toggle()<CR>
nnoremap <Leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <Leader>sw <Esc><cmd>lua require('spectre').open_visual()<CR>
nnoremap <Leader>sp <cmd>lua require('spectre').open_file_search({select_word=true})<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>tn :tabp<CR>
nnoremap <Leader>to :tabn<CR>
nnoremap 1t 1gt
nnoremap 2t 2gt
nnoremap 3t 3gt
nnoremap 4t 4gt
nnoremap 5t 5gt
nnoremap 6t 6gt
nnoremap 7t 7gt
nnoremap 8t 8gt
nnoremap 9t 9gt
lua vim.keymap.set('n', '<Leader>c', vim.diagnostic.open_float) -- open the diagnostic window thing
" add ii for 'in this indentation' or ip for 'in this paragraph' (surrounded
" by empty lines), j/<Down> for 'current line and the one below it', can add numbers like 5<Down>
nnoremap <Leader>v :set opfunc=ConcentricSort<CR>g@

nnoremap <Leader>lw <cmd>HopWord<CR>
vnoremap <Leader>lw <cmd>HopWord<CR>
nnoremap <Leader>l <cmd>HopCamelCase<CR>
vnoremap <Leader>l <cmd>HopCamelCase<CR>
"nnoremap <Leader>u <Plug>(ale_previous_wrap)
lua vim.keymap.set('n', '<Leader>u', vim.diagnostic.goto_prev) -- go to prev issue
nnoremap <Leader>uu <C-W><C-K>
"nnoremap <Leader>y <Plug>(ale_next_wrap)
lua vim.keymap.set('n', '<Leader>y', vim.diagnostic.goto_next) -- go to next issue
nnoremap <Leader>yy <C-W><C-J>
nnoremap <Leader>n <<
nnoremap <Leader>e ddkP
nnoremap <Leader>i ddp
nnoremap <Leader>it :LazyGit<CR>
nnoremap <Leader>o >>
nnoremap <Leader>, yyP
nnoremap <Leader>. yyp
"nnoremap <Leader>/ :ALEHover<CR>
"nnoremap <F12> :ALEGoToDefinition<CR>
" lua vim.keymap.set({'n', 'i'}, '<F12>', vim.lsp.buf.definition) -- go to definition
lua vim.keymap.set({'n', 'i'}, '<F12>', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>') -- go to definition in a new tab
lua vim.keymap.set('n', '<Leader>/', vim.lsp.buf.hover) -- open the intellisense thing
lua vim.keymap.set('n', '<Leader>m', vim.lsp.buf.code_action) -- open the code actions thing
"nnoremap <Leader>m :ALERename<CR> " covered by f2, my own layer
nnoremap <Leader>md <Plug>MarkdownPreview
nnoremap <Leader>mds <Plug>MarkdownPreviewStop
nnoremap <Leader>d gdcgn
" git-conflict mappings
nnoremap <Leader>1 :GitConflictListQf<CR>
nnoremap <Leader>2 <Plug>(git-conflict-next-conflict)
nnoremap <Leader>3 <Plug>(git-conflict-prev-conflict)
nnoremap <Leader>4 <Plug>(git-conflict-ours)
nnoremap <Leader>5 <Plug>(git-conflict-both)
nnoremap <Leader>6 <Plug>(git-conflict-theirs)
nnoremap <Leader>0 <Plug>(git-conflict-none)

" see if I can get vscode shortcuts for prev/next change, prev/next issue
" seems that only opt-sft-f5/f8 work, the without shift doesn't
" :h META, D = cmd, M = opt, S = shift, C = ctrl
nnoremap <M-S-F5> g;
nnoremap <M-F5> g,
lua vim.keymap.set('n', '<M-S-F8>', vim.diagnostic.goto_prev) -- go to prev issue
lua vim.keymap.set('n', '<M-F8>', vim.diagnostic.goto_next) -- go to next issue

" make Y behave like other capitals
nnoremap Y y$
" go to opening bracket
nnoremap [[ ?{<CR>w99[{
" go to ending bracket
nnoremap ]] /}<CR>b99]}
" not really sure anymore, also seems to go to opening bracket
nnoremap ][ j0[[%/{<CR>
" not really sure anymore, top of function?
nnoremap [] k$][%?}<CR>

" Code completion
"inoremap {{ {}<Left>
"inoremap {<CR> {<CR>}<Esc>O
"inoremap (( ()<Left>
"inoremap (<CR> (<CR>)<Esc>O
"inoremap [[ []<Left>
"inoremap [<CR> [<CR>]<Esc>O
"inoremap "" ""<Left>
"inoremap '' ''<Left>
"inoremap `` ``<Left>
"inoremap `<CR> `<CR>`<Esc>O
inoremap /arn () => <Esc>4hi
inoremap /arc () => {}<Esc>6hi
inoremap /arp () => ()<Esc>6hi
inoremap /fnc function () {}<Esc>4hi
inoremap /stc const  = styled.div`<CR>    <CR>`;<Esc><<^2k6li
inoremap /jsd /**<cr> * <cr>*/<Esc>k$a
inoremap /cmt /**  */<Esc>2hi
inoremap /cow console.warn('arst ', );<Esc>5hp3lp==
inoremap /coi console.info('arst ', );<Esc>5hp3lp==
inoremap /col console.log('arst ', );<Esc>5hp3lp==
inoremap <C-d> <Del>
" make opt-right, opt-left work correctly
nnoremap <M-f> <cmd>lua require('spider').motion('w')<CR>
inoremap <M-f> <cmd>lua require('spider').motion('w')<CR>
vnoremap <M-f> <cmd>lua require('spider').motion('w')<CR>
vnoremap <M-b> <cmd>lua require('spider').motion('b')<CR>
inoremap <M-b> <cmd>lua require('spider').motion('b')<CR>

" Navigation
nnoremap w <cmd>lua require('spider').motion('w')<CR>
nnoremap e <cmd>lua require('spider').motion('e')<CR>
nnoremap b <cmd>lua require('spider').motion('b')<CR>
nnoremap ge <cmd>lua require('spider').motion('ge')<CR>

