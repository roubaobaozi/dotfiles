vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct, except not using lazy because it breaks emmet
vim.g.maplocalleader = ' '

-- Emmet settings
vim.g.user_emmet_leader_key = ','
vim.g.user_emmet_expandabbr_key = '<A-Tab>'
vim.g.user_emmet_mode = 'a' -- a is all, n is normal, inv is insert/normal/visual (same as a)
-- with lazy.nvim, emmet no longer works on styled-components sadly
vim.g.user_emmet_settings = "{ 'javascript': { 'extends': 'jsx,scss' }, 'javascript.jsx': { 'extends': 'jsx,scss' } }"

-- Auto-save modified buffer during idle after 'updatetime' has elapsed (default 4 sec)
vim.api.nvim_create_autocmd({'CursorHoldI', 'CursorHold'}, {
  pattern = {"*"},
  command = 'silent! update'
})

local o = vim.opt

--.syntax = true -- what is it?
o.updatetime = 1000 -- for how long to wait until writing to swapfile
o.showmode = false
o.timeoutlen = 300
o.whichwrap = 'b,s,<,>'
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smarttab = true
o.scrolloff = 5
o.encoding = 'utf-8'
o.showmatch = true -- Shows matching brackets
o.ruler = true -- Always shows location in file (line# and column, this is in status bar)
o.number = true -- show line numbers in insert mode, and below autocmd to also show relative line numbers otherwise
o.cursorline = true

o.smarttab = true -- Auto-tabs for certain code
o.backspace = 'indent,eol,start'
o.ignorecase = true
o.smartcase = true
-- o.filetype = true
-- o.plugin = true
-- o.indent = true
o.autoindent = true
o.smartindent = true
o.list = true
o.listchars = {
    tab = '│┈', -- »
    nbsp = '·',
    space = '·',
    trail = '·',
    extends = '›',
    precedes = '‹',
}
o.textwidth = 0
o.clipboard = 'unnamedplus'
o.wildignore:append({
    '**/node_modules/**',
    '.git/**',
    'dist/**',
    '**/*.jpg',
    '**/*.jpeg',
    '**/*.png',
    '**/*.gif',
})

local numberToggle = vim.api.nvim_create_augroup('number_toggle', { clear = false })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    pattern = '*',
    group = numberToggle,
    command = 'if &nu && mode() != "i" | set rnu | endif'
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    pattern = '*',
    group = numberToggle,
    command = 'if &nu | set nornu | endif'
})

local setFtSyntax = vim.api.nvim_create_augroup('set_ft_syntax', { clear = false })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.html.twig',
    group = setFtSyntax,
    command = 'set filetype=html',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.html.twig',
    group = setFtSyntax,
    command = 'set syntax=html',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.js',
    group = setFtSyntax,
    command = 'set filetype=javascriptreact',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.js',
    group = setFtSyntax,
    command = 'set syntax=javascriptreact',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.scss',
    group = setFtSyntax,
    command = 'set syntax=scss',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.html',
    group = setFtSyntax,
    command = 'set syntax=html',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.astro',
    group = setFtSyntax,
    command = 'set syntax=html',
})

-- svelte plugin
vim.g.vim_svelte_plugin_use_typescript = 1
vim.g.vim_svelte_plugin_use_sass = 1

-- set the colorscheme
vim.cmd.colorscheme 'catppuccin-mocha'
