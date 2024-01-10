-- x is visual mode only. v is visual & select mode. s is select mode only

local function warnMultiOrSingle()
    local command = "yiw$%o\\<CR>console.warn('arst ', );\\<Esc>5hp3lp=="

    -- if the end of the line ends in ;, then it's a single-line function, don't need % to get me to the end of the function
    -- if getline('.')[col('$')-2] == a:char " guessing the -2 is because of \r ?
    if vim.cmd.matchstr(vim.cmd.getline('.'), '\\%' .. (vim.cmd.col('$')-1) .. 'c.') == ';' then
        command = "yiW$o\\<CR>console.warn('arst ', );\\<Esc>5hp3lp=="
    end

    return command
end

local function compare_to_clipboard()
    local ftype = vim.api.nvim_eval("&filetype")
    vim.cmd(string.format([[
        execute "normal! \"xy"
        vsplit
        enew
        normal! P
        setlocal buftype=nowrite
        set filetype=%s
        diffthis
        execute "normal! \<C-w>\<C-w>"
        enew
        set filetype=%s
        normal! "xP
        diffthis
    ]], ftype, ftype))
end

-- Leader shortcuts
vim.keymap.set('n', '<Leader>qu', '<cmd>q<CR>')
vim.keymap.set('n', '<Leader>qun', '<cmd>q!<CR>')
vim.keymap.set('n', '<Leader>q', '<cmd>bd<CR>')
vim.keymap.set('n', '<Leader>qn', '<cmd>bd!<CR>')
vim.keymap.set('n', '<Leader>qo', '<cmd>BufferLineCloseOthers<CR>')

vim.keymap.set('n', '<Leader>w', warnMultiOrSingle)

vim.keymap.set('n', '<Leader>wi', 'yiw$o<CR>console.warn(\'arst \', );<Esc>5hp3lp==')
vim.keymap.set('n', '<Leader>x', '<cmd>x<CR>')
vim.keymap.set('n', '<Leader>f', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>pf', '<cmd>Telescope find_files<CR>')
-- use :FrecencyValidate to clear the frecency DB)
vim.keymap.set('n', '<Leader>p', '<cmd>Telescope frecency workspace=CWD<CR>')
vim.keymap.set('n', '<Leader>po', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<Leader>pr', '<cmd>Telescope resume<CR>')
vim.keymap.set('n', '<Leader>g', '<Esc>v:\'<,\'>GBrowse<CR>')
-- for GBrowse, if use <cmd> instead of : , it doesn't add line number to link
-- (leveraging the auto '<,'> from typing :)
vim.keymap.set('v', '<Leader>g', ':GBrowse<CR>')
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.format) -- format the code
vim.keymap.set('n', '<Leader>;', '<cmd>Format<CR>')
vim.keymap.set('n', '<Leader>r', '<C-r>')
vim.keymap.set('n', '<Leader>s', '<cmd>lua require("spectre").toggle()<CR>')
vim.keymap.set('n', '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
vim.keymap.set('x', '<Leader>sw', '<Esc><cmd>lua require("spectre").open_visual()<CR>')
vim.keymap.set('n', '<Leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>')
-- buffers instead of tabs
vim.keymap.set('n', '<Leader>t', '<cmd>enew<CR>')
vim.keymap.set('n', '<Leader>tn', '<cmd>bp<CR>')
vim.keymap.set('n', '<Leader>to', '<cmd>bn<CR>')
vim.keymap.set({'n', 'v'}, '<Leader>tr', '<cmd>Oil --float<CR>') -- open the Oil tree
vim.keymap.set({'n', 'v'}, '<Leader>tr.', '<cmd>Oil . --float<CR>') -- open the Oil tree
vim.keymap.set('x', '<Space>d', compare_to_clipboard)
vim.keymap.set('n', '<Leader>c', vim.diagnostic.open_float) -- open the diagnostic window thing
vim.keymap.set('n', '<Leader>co', '<cmd>CccPick<CR>') -- open the colour picker
-- add ii for 'in this indentation' or ip for 'in this paragraph' (surrounded
-- by empty lines), j/<Down> for 'current line and the one below it', can add numbers like 5<Down>
vim.keymap.set('n', '<Leader>v', '<cmd>set opfunc=ConcentricSort<CR>g@')
vim.keymap.set('n', '<Leader>b', '<cmd>botright vs new | 1put | windo diffthis<CR>')
vim.keymap.set({'n', 'v'}, '<Leader>lw', '<cmd>HopWord<CR>')
vim.keymap.set({'n', 'v'}, '<Leader>l', '<cmd>HopCamelCase<CR>')
vim.keymap.set('n', '<Leader>u', vim.diagnostic.goto_prev) -- go to prev issue
vim.keymap.set('n', '<Leader>y', vim.diagnostic.goto_next) -- go to next issue
vim.keymap.set('n', '<Leader>yy', '<C-W><C-J>')
vim.keymap.set('n', '<Leader>n', '<<')
vim.keymap.set('x', '<Leader>n', '<')
vim.keymap.set('n', '<Leader>e', 'ddkP')
vim.keymap.set('x', '<Leader>e', 'dkP')
vim.keymap.set('n', '<Leader>i', 'ddp')
vim.keymap.set('n', '<Leader>it', '<cmd>LazyGit<CR>')
vim.keymap.set('x', '<Leader>i', 'dp')
vim.keymap.set('n', '<Leader>o', '>>')
vim.keymap.set('x', '<Leader>o', '>')
vim.keymap.set('n', '<Leader>,', 'yyP')
vim.keymap.set('x', '<Leader>,', 'y0P')
vim.keymap.set('n', '<Leader>.', 'yyp')
vim.keymap.set('x', '<Leader>.', 'y`>p')
vim.keymap.set({'n', 'i'}, '<F12>', vim.lsp.buf.definition) -- go to definition
vim.keymap.set({'n', 'i'}, '<F12><F12>', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>') -- go to definition in a new tab
vim.keymap.set('n', '<Leader>/', vim.lsp.buf.hover) -- open the intellisense thing
vim.keymap.set('n', '<Leader>m', vim.lsp.buf.code_action) -- open the code actions thing
vim.keymap.set('n', '<Leader>md', '<Plug>MarkdownPreview')
vim.keymap.set('n', '<Leader>mds', '<Plug>MarkdownPreviewStop')
-- git-conflict mappings
vim.keymap.set('n', '<Leader>1', '<cmd>GitConflictListQf<CR>')
vim.keymap.set('n', '<Leader>2', '<Plug>(git-conflict-next-conflict)')
vim.keymap.set('n', '<Leader>3', '<Plug>(git-conflict-prev-conflict)')
vim.keymap.set('n', '<Leader>4', '<Plug>(git-conflict-ours)')
vim.keymap.set('n', '<Leader>5', '<Plug>(git-conflict-both)')
vim.keymap.set('n', '<Leader>6', '<Plug>(git-conflict-theirs)')
vim.keymap.set('n', '<Leader>0', '<Plug>(git-conflict-none)')
-- see if I can get vscode shortcuts for prev/next change, prev/next issue
-- seems that only opt-sft-f5/f8 work, the without shift doesn't
-- :h META, D = cmd, M = opt, S = shift, C = ctrl
vim.keymap.set('n', '<M-S-F5>', 'g;')
vim.keymap.set('n', '<M-F5>', 'g,')
vim.keymap.set('n', '<M-S-F8>', vim.diagnostic.goto_prev) -- go to prev issue
vim.keymap.set('n', '<M-F8>', vim.diagnostic.goto_next) -- go to next issue
vim.keymap.set('n', 'gl', '$')
vim.keymap.set('n', 'gh', '^')
-- make Y behave like other capitals
vim.keymap.set('n', 'Y', 'y$')
-- go to opening bracket
vim.keymap.set('n', '[[', '?{<CR>w99[{')
-- go to ending bracket
vim.keymap.set('n', ']]', '/}<CR>b99]}')
-- not really sure anymore, also seems to go to opening bracket
vim.keymap.set('n', '][', 'j0[[%/{<CR>')
-- not really sure anymore, top of function?
vim.keymap.set('n', '[]', 'k$][%?}<CR>')

-- Code completion
vim.keymap.set('i', '/arn', '() => <Esc>4hi')
vim.keymap.set('i', '/arc', '() => {}<Esc>6hi')
vim.keymap.set('i', '/arp', '() => ()<Esc>6hi')
vim.keymap.set('i', '/fnc', 'function () {}<Esc>4hi')
vim.keymap.set('i', '/stc', 'const  = styled.div`<CR>    <CR>`;<Esc><<^2k6li')
vim.keymap.set('i', '/jsd', '/**<cr> * <cr>*/<Esc>k$a')
vim.keymap.set('i', '/cmt', '/**  */<Esc>2hi')
vim.keymap.set('i', '/cow', 'console.warn();<Esc>hi')
vim.keymap.set('i', '/coi', 'console.info();<Esc>hi')
vim.keymap.set('i', '/col', 'console.log();<Esc>hi')
vim.keymap.set('i', '/cop', '\'arst<Space>\',<Space><Esc>3hp3lp==')
-- make C-d in insert mode delete forward
vim.keymap.set('i', '<C-d>', '<Del>')
-- make opt-right, opt-left work correctly, with camelCase and snake_case
vim.keymap.set({'n', 'i', 'v'}, '<M-f>', '<cmd>lua require("spider").motion("w")<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<M-Right>', '<cmd>lua require("spider").motion("w")<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<M-b>', '<cmd>lua require("spider").motion("b")<CR>')
vim.keymap.set({'n', 'i', 'v'}, '<M-Left>', '<cmd>lua require("spider").motion("b")<CR>')

