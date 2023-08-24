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
Plug 'dense-analysis/ale' " go to def, hover info, intellisense-type stuff
Plug 'mattn/emmet-vim' " shortcut code
Plug 'mattn/webapi-vim' " in conjunction with emmet-vim for custom snippets
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " better javascript syntax highlighting/completion
Plug 'neoclide/vim-jsx-improve' " javascriptreact syntax, better react/jsx
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'akinsho/git-conflict.nvim', { 'tag': '*' } " merge conflict resolution, latest tag (just in case main is broken)
Plug 'yorickpeterse/nvim-pqf' " for prettier git-conflict list page
Plug 'kdheepak/lazygit.nvim' " full git ui but slow, git-conflict prob better
Plug 'pocco81/auto-save.nvim' " auto saving!
Plug 'chrisgrieser/nvim-spider' " camelCase and snake_case motion
Plug 'chrisgrieser/nvim-various-textobjs' " camelCase, kebab-case and snake_case selection
Plug 'machakann/vim-sandwich' " sandwich text in brackets/quotes/tags/etc, sadly not lua
call plug#end()
endif

" Settings
" editorConfig is enabled by default in neovim: https://neovim.io/doc/user/editorconfig.html
lua require 'auto-save'.setup {
    \ enabled = true,
    \ execution_message = { cleaning_interval = 2000 },
    \ trigger_events = {"InsertLeave", "TextChanged", "TextYankPost"},
    \ debounce_delay = 2000
\ }
" debounce_delay technically doesn't do anything, waiting on https://github.com/pocco81/auto-save.nvim/issues/61
lua require 'gitsigns'.setup {
    \ numhl = true,
    \ word_diff = true,
    \ current_line_blame = true
\ }
lua require 'hop'.setup {
    \ keys = 'ntesiroamvclpufywhdx',
    \ uppercase_labels = true
\ }
lua require 'nvim-treesitter.configs'.setup {
    \ ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "css", "scss", "html", "javascript", "jsdoc", "json", "markdown", "regex", "tsx", "typescript", "yaml" },
    \ highlight = {
    \    enable = true,
    \    additional_vim_regex_highlighting = false
    \ }
\ }
lua require 'telescope'.setup {
    \ defaults = {
    \     file_ignore_patterns = { "^.git/", "node_modules/", "dist/" },
    \     vimgrep_arguments = {
    \         'rg',
    \         '--color=never',
    \         '--hidden',
    \         '--no-heading',
    \         '--with-filename',
    \         '--line-number',
    \         '--column',
    \         '--ignore-case',
    \         '--smart-case'
    \     }
    \ },
    \ pickers = {
    \     find_files = {
    \         hidden = true
    \     }
    \ }
\ }
lua require 'spectre'.setup {
    \ open_cmd = 'tabnew',
    \ is_insert_mode = true,
    \ mapping = {
    \    ['send_to_qf'] = {
    \        map = "<leader>sq"
    \    },
    \    ['replace_cmd'] = {
    \        map = "<leader>sc"
    \    },
    \    ['change_view_mode'] = {
    \        map = "<leader>sv"
    \    },
    \    ['resume_last_search'] = {
    \      map = "<leader>sl"
    \    }
    \ }
\ }
lua require 'git-conflict'.setup {
    \ default_mappings = {
    \     ours = 'co',
    \     theirs = 'ct',
    \     none = 'c0',
    \     both = 'cb',
    \     next = '[x',
    \     prev = '[b'
    \ },
\ }
lua require 'pqf'.setup {}
lua require 'spider'.setup { skipInsignificantPunctuation = true }
lua require 'various-textobjs'.setup { useDefaultKeymaps = true }
" various-textobjs sets camelCase/snake_case parts to S which I find annoying,
" choosing e as it doesn't exist
lua vim.keymap.set({ 'o', 'x' }, 'ae', '<cmd>lua require("various-textobjs").subword(false)<CR>')
lua vim.keymap.set({ 'o', 'x' }, 'ie', '<cmd>lua require("various-textobjs").subword(true)<CR>')
syntax on " Syntax highlighting
" syntax doesn't automatically apply correctly for any of these
augroup set_ft_syntax
  au!
  autocmd BufNewFile,BufRead *.html.twig   set filetype=html
  autocmd BufNewFile,BufRead *.html.twig   set syntax=html
  autocmd BufNewFile,BufRead *.js          set filetype=javascriptreact
  autocmd BufNewFile,BufRead *.js          set syntax=javascriptreact
  autocmd BufNewFile,BufRead *.scss        set syntax=scss
augroup END
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1
colorscheme material
if (has('termguicolors'))
    set termguicolors
endif
if exists('g:vscode')
    " no lightline on vscode, so turn noshowmode off
    set showmode
else
    set noshowmode " lightline handles this
    set spell " spell check. :setlocal spell spelllang=en
    set spelllang=en " spell language, go for regular en so it covers en_us and en_uk
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

if exists('g:vscode')
    let g:ale_completion_enabled = 0
    let b:ale_linters = {}
    let g:ale_linters_explicit = 1
else
    let g:ale_completion_enabled = 1
    let g:ale_linter_aliases = {'javascript': ['css', 'javascript']}
    let g:ale_linters = {'javascript': ['stylelint', 'eslint', 'tsserver']}
    let g:ale_fixers = {
    \   '*': ['trim_whitespace'],
    \   'javascript': ['stylelint', 'eslint'],
    \ }
endif
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
set smarttab " Autotabs for certain code
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
nnoremap <Leader>w :w<CR>
nnoremap <Leader>f <cmd>Telescope live_grep<CR>
nnoremap <Leader>p <cmd>Telescope find_files<CR>
nnoremap <Leader>g <Esc>v:'<,'>GBrowse<CR>
vnoremap <Leader>g :GBrowse<CR>
nnoremap <Leader>a <Plug>(ale_fix)
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
nnoremap <Leader>v. gv
nnoremap <Leader>lw <cmd>HopWord<CR>
vnoremap <Leader>lw <cmd>HopWord<CR>
nnoremap <Leader>l <cmd>HopCamelCase<CR>
vnoremap <Leader>l <cmd>HopCamelCase<CR>
nnoremap <Leader>u <Plug>(ale_previous_wrap)
nnoremap <Leader>uu <C-W><C-K>
nnoremap <Leader>y <Plug>(ale_next_wrap)
nnoremap <Leader>yy <C-W><C-J>
nnoremap <Leader>n <<
nnoremap <Leader>e ddkP
nnoremap <Leader>i ddp
nnoremap <Leader>it :LazyGit<CR>
nnoremap <Leader>o >>
nnoremap <Leader>, yyP
nnoremap <Leader>. yyp
nnoremap <Leader>/ :ALEHover<CR>
nnoremap <F12> :ALEGoToDefinition<CR>
nnoremap <Leader>m :ALERename<CR>
nnoremap <Leader>d gdcgn
" git-conflict mappings
nnoremap <Leader>1 :GitConflictListQf<CR>
nnoremap <Leader>2 <Plug>(git-conflict-next-conflict)
nnoremap <Leader>3 <Plug>(git-conflict-prev-conflict)
nnoremap <Leader>4 <Plug>(git-conflict-ours)
nnoremap <Leader>5 <Plug>(git-conflict-both)
nnoremap <Leader>6 <Plug>(git-conflict-theirs)
nnoremap <Leader>0 <Plug>(git-conflict-none)

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
inoremap {{ {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap (( ()<Left>
inoremap (<CR> (<CR>)<Esc>O
inoremap [[ []<Left>
inoremap [<CR> [<CR>]<Esc>O
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap `` ``<Left>
inoremap `<CR> `<CR>`<Esc>O
inoremap /arn () => <Esc>4hi
inoremap /arc () => {}<Esc>6hi
inoremap /arp () => ()<Esc>6hi
inoremap /fnc function () {}<Esc>4hi
inoremap /stc const  = styled.div`<CR>    <CR>`;<Esc><<^2k6li
inoremap /jsd /**<cr> * <cr>*/<Esc>k$a
inoremap /cmt /**  */<Esc>2hi
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

