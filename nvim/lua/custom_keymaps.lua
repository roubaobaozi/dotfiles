-- x is visual mode only. v is visual & select mode. s is select mode only
-- :h META, D = cmd, M = opt, S = shift, C = ctrl

-- this stopped working with a new neovim release .. vim.cmd.getline doesn't exist, vim.cmd.col has wrong # of args ...
--[[ local function warnMultiOrSingle()
    local command = "yiw$%o\\<CR>console.warn('arst ', );\\<Esc>5hp3lp=="

    -- if the end of the line ends in ;, then it's a single-line function, don't need % to get me to the end of the function
    -- if getline('.')[col('$')-2] == a:char " guessing the -2 is because of \r ?
    if vim.cmd.matchstr(vim.cmd.getline('.'), '\\%' .. (vim.cmd.col('$') - 1) .. 'c.') == ';' then
        command = "yiW$o\\<CR>console.warn('arst ', );\\<Esc>5hp3lp=="
    end

    return command
end ]]

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
vim.keymap.set('n', '<Leader>qu', '<cmd>q<CR>', { desc = "Quit" })
vim.keymap.set('n', '<Leader>qun', '<cmd>q!<CR>', { desc = "Quit ignoring unsaved buffer" })
vim.keymap.set('n', '<Leader>q', '<cmd>bd<CR>', { desc = "Close buffer" })
vim.keymap.set('n', '<Leader>qn', '<cmd>bd!<CR>', { desc = "Close buffer ignoring unsaved" })
vim.keymap.set('n', '<Leader>qo', '<cmd>BufferLineCloseOthers<CR>', { desc = "Close all other buffers" })

-- vim.keymap.set('n', '<Leader>w', warnMultiOrSingle, { desc = "Create console warn" })
vim.keymap.set('n', '<Leader>w',
    'yiw%o<CR>console.warn(\'%c--- HERE WARN ---\', \'background-color:goldenrod;color:#000;font-weight: bold;\', {});<Esc>3hp==',
    { desc = "Create console warn (should always work)" })
vim.keymap.set('n', '<Leader>wi',
    'yiw$o<CR>console.warn(\'%c--- HERE WARN ---\', \'background-color:goldenrod;color:#000;font-weight: bold;\', {});<Esc>3hp==',
    { desc = "Create explicitly inline console warn" })
vim.keymap.set('n', '<Leader>x', '<cmd>x<CR>', { desc = "Save and Quit" })
-- vim.keymap.set('n', '<Leader>f', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>f', function() Snacks.picker.grep() end, { desc = "Open Snacks text grep" })
-- vim.keymap.set('n', '<Leader>pf', '<cmd>Telescope find_files<CR>')
-- use :FrecencyValidate to clear the frecency DB)
-- vim.keymap.set('n', '<Leader>p', '<cmd>Telescope frecency workspace=CWD<CR>')
vim.keymap.set('n', '<Leader>p', function() Snacks.picker.files() end, { desc = "Open Snacks file picker" })
-- vim.keymap.set('n', '<Leader>po', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<Leader>po', function() Snacks.picker.buffers() end, { desc = "Open Snacks open buffers" })
-- vim.keymap.set('n', '<Leader>pr', '<cmd>Telescope resume<CR>')
vim.keymap.set('n', '<Leader>pr', function() Snacks.picker.resume() end, { desc = "Open last Snacks" })
vim.keymap.set('n', '<Leader>g', '<Esc>v:\'<,\'>GBrowse<CR>', { desc = "Open line(s) in GitHub" })
-- for GBrowse, if use <cmd> instead of : , it doesn't add line number to link
-- (leveraging the auto '<,'> from typing :)
vim.keymap.set('v', '<Leader>g', ':GBrowse<CR>', { desc = "Open in GitHub" })
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.format, { desc = "Format code" })
vim.keymap.set('n', '<Leader>;', '<cmd>Format<CR>', { desc = "Prettify code" })
vim.keymap.set('n', '<Leader>r', '<C-r>', { desc = "Redo" })
-- SNACKS
vim.keymap.set('n', '<Leader>s', function() Snacks.picker.smart() end, { desc = "Snacks Smart" })
vim.keymap.set('n', '<Leader>se', function() Snacks.explorer() end, { desc = "Snacks Explorer" })
vim.keymap.set('n', '<Leader>sB', function() Snacks.picker.grep_buffers() end, { desc = "Snacks search open buffers" })
vim.keymap.set('n', '<Leader>sz', function() Snacks.zen() end, { desc = "Snacks Zen mode" })
--[[ vim.keymap.set('n', '<Leader>s', '<cmd>lua require("spectre").toggle()<CR>')
vim.keymap.set('n', '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
vim.keymap.set('x', '<Leader>sw', '<Esc><cmd>lua require("spectre").open_visual()<CR>')
vim.keymap.set('n', '<Leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>') ]]
-- buffers instead of tabs
vim.keymap.set('n', '<Leader>t', '<cmd>enew<CR>', { desc = "New buffer" })
vim.keymap.set('n', '<Leader>tn', '<cmd>bp<CR>', { desc = "Go to previous buffer" })
vim.keymap.set('n', '<Leader>to', '<cmd>bn<CR>', { desc = "Go to next buffer" })
vim.keymap.set({ 'n', 'v' }, '<Leader>tr', '<cmd>Oil --float<CR>', { desc = "Open Oil at current dir" })
vim.keymap.set({ 'n', 'v' }, '<Leader>tr.', '<cmd>Oil . --float<CR>', { desc = "Open Oil at base dir" })
vim.keymap.set('x', '<Space>d', compare_to_clipboard, { desc = "Compare with clipboard" })
vim.keymap.set('n', '<Leader>c', vim.diagnostic.open_float, { desc = "Open Diagnostic window" })
vim.keymap.set('n', '<Leader>co', '<cmd>CccPick<CR>', { desc = "Open Colour Picker" })
-- add ii for 'in this indentation' or ip for 'in this paragraph' (surrounded
-- by empty lines), j/<Down> for 'current line and the one below it', can add numbers like 5<Down>
vim.keymap.set('n', '<Leader>v', '<cmd>set opfunc=ConcentricSort<CR>g@', { desc = "ConcentricSort" })
vim.keymap.set('n', '<Leader>b', '<cmd>botright vs new | 1put | windo diffthis<CR>', { desc = "Diffview" })
vim.keymap.set({ 'n', 'v' }, '<Leader>lw', '<cmd>HopWord<CR>', { desc = "Hop by word" })
vim.keymap.set({ 'n', 'v' }, '<Leader>l', '<cmd>HopCamelCase<CR>', { desc = "Hop by camelCase" })
vim.keymap.set('n', '<Leader>u', vim.diagnostic.goto_prev, { desc = "Go to previous issue" })
vim.keymap.set('n', '<Leader>y', vim.diagnostic.goto_next, { desc = "Go to next issue" })
vim.keymap.set('n', '<Leader>yy', '<C-W><C-J>', { desc = "Go to lower buffer split" })
vim.keymap.set('n', '<Leader>n', '<<', { desc = "Un-tab" })
vim.keymap.set('x', '<Leader>n', '<', { desc = "Un-tab" })
vim.keymap.set('n', '<Leader>e', 'ddkP', { desc = "Move above" })
vim.keymap.set('x', '<Leader>e', 'dkP', { desc = "Move above" })
vim.keymap.set('n', '<Leader>i', 'ddp', { desc = "Move below" })
vim.keymap.set('n', '<Leader>it', '<cmd>LazyGit<CR>', { desc = "Open LazyGit" })
vim.keymap.set('x', '<Leader>i', 'dp', { desc = "Move below" })
vim.keymap.set('n', '<Leader>o', '>>', { desc = "Tab in" })
vim.keymap.set('x', '<Leader>o', '>', { desc = "Tab in" })
vim.keymap.set('n', '<Leader>,', 'yyP', { desc = "Clone above" })
vim.keymap.set('x', '<Leader>,', 'y0P', { desc = "Clone above" })
vim.keymap.set('n', '<Leader>.', 'yyp', { desc = "Clone below" })
vim.keymap.set('x', '<Leader>.', 'y`>p', { desc = "Clone below" })
vim.keymap.set({ 'n', 'i' }, '<F12>', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set({ 'n', 'i' }, '<F2>', vim.lsp.buf.rename, { desc = "Rename definition" })
vim.keymap.set({ 'n', 'i' }, '<F12><F12>', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    { desc = "Go to definition in a new tab" })
vim.keymap.set('n', '<Leader>/', vim.lsp.buf.hover, { desc = "Open Intellisense" })
vim.keymap.set('n', '<Leader>m', vim.lsp.buf.code_action, { desc = "Open Code Actions" })
vim.keymap.set('n', '<Leader>md', '<cmd>Markview<CR>', { desc = "Markdown viewer start" })
vim.keymap.set({ 'n', 'x' }, '<Leader>mm', '<Plug>(matchup-[%)<CR>', { desc = "Matchup square brackets" })
-- vim.keymap.set('n', '<Leader>md', '<Plug>MarkdownPreview')
vim.keymap.set('n', '<Leader>mds', '<Plug>MarkdownPreviewStop', { desc = "Markdown viewer stop" })
-- git-conflict mappings
vim.keymap.set('n', '<Leader>1', '<cmd>GitConflictListQf<CR>', { desc = "Open conflict list" })
vim.keymap.set('n', '<Leader>2', '<Plug>(git-conflict-next-conflict)', { desc = "Go to next conflict" })
vim.keymap.set('n', '<Leader>3', '<Plug>(git-conflict-prev-conflict)', { desc = "Go to previous conflict" })
vim.keymap.set('n', '<Leader>4', '<Plug>(git-conflict-ours)', { desc = "Take our code" })
vim.keymap.set('n', '<Leader>5', '<Plug>(git-conflict-both)', { desc = "Take both codes" })
vim.keymap.set('n', '<Leader>6', '<Plug>(git-conflict-theirs)', { desc = "Take their code" })
vim.keymap.set('n', '<Leader>0', '<Plug>(git-conflict-none)', { desc = "Take none" })
-- see if I can get vscode shortcuts for prev/next change, prev/next issue
-- seems that only opt-sft-f5/f8 work, the without shift doesn't
vim.keymap.set('n', '<M-S-F5>', 'g;', { desc = "Go to previous change" })
vim.keymap.set('n', '<M-F5>', 'g,', { desc = "Go to next change" })
vim.keymap.set('n', '<M-S-F8>', vim.diagnostic.goto_prev, { desc = "Go to previous issue" })
vim.keymap.set('n', '<M-F8>', vim.diagnostic.goto_next, { desc = "Go to next issue" })
vim.keymap.set('n', '<S-l>', '$', { desc = "Go to end of line" })
vim.keymap.set('n', '<S-h>', '^', { desc = "Go to start of line" })

-- go to opening bracket
vim.keymap.set('n', '[[', '?{<CR>w99[{', { desc = "Go to opening bracket" })
-- go to ending bracket
vim.keymap.set('n', ']]', '/}<CR>b99]}', { desc = "Go to ending bracket" })
-- not really sure anymore, also seems to go to opening bracket
vim.keymap.set('n', '][', 'j0[[%/{<CR>', { desc = "Maybe go to opening bracket" })
-- not really sure anymore, top of function?
vim.keymap.set('n', '[]', 'k$][%?}<CR>', { desc = "Maybe go to top of function?" })

-- use matchup instead
vim.keymap.set({ 'n', 'x' }, '%', '<Plug>(matchup-%)<CR>', { desc = "Matchup bracket" })

-- Sometimes I don't want to yank
vim.keymap.set({ 'n', 'x' }, 'D', '"_d', { desc = "Delete without yank" })
-- make Y behave like other capitals
vim.keymap.set('n', 'Y', 'y$', { desc = "Yank to end of line" })

-- switching buffers
vim.keymap.set('n', '<A-4>', '<C-w>h', { desc = "Switch to buffer on left" })
vim.keymap.set('n', '<A-5>', '<C-w>k', { desc = "Switch to buffer above" })
vim.keymap.set('n', '<A-6>', '<C-w>j', { desc = "Switch to buffer below" })
vim.keymap.set('n', '<A-0>', '<C-w>l', { desc = "Switch to buffer on right" })

-- Code completion
vim.keymap.set('i', '/fat', '() => <Esc>4hi', { desc = "Fat-arrow function" })
vim.keymap.set('i', '/fun', 'function () {<CR><CR>}<Esc><<^2k$3hi', { desc = "Classic function" })
vim.keymap.set('i', '/sty', 'const  = styled.div`<CR>    <CR>`;<Esc><<^2k6li', { desc = "Styled div" })
vim.keymap.set('i', '/jsd', '/**<cr> * <cr>*/<Esc>k$a', { desc = "JS Doc" })
vim.keymap.set('i', '/cmt', '/**  */<Esc>2hi', { desc = "Comment" })
vim.keymap.set('i', '/cow',
    'console.warn(\'%c--- HERE WARN ---\', \'background-color:goldenrod;color:#000;font-weight: bold;\', {});<Esc>3hp',
    { desc = "Console warn" })
vim.keymap.set('i', '/coi',
    'console.info(\'%c--- HERE INFO ---\', \'background-color:skyblue;color:#000;font-weight: bold;\', {});<Esc>3hp',
    { desc = "Console info" })
vim.keymap.set('i', '/col',
    'console.log(\'%c--- HERE LOG ---\', \'background-color:#117;color:#fff;font-weight: bold;\', {});<Esc>3hp',
    { desc = "Console log" })
vim.keymap.set('i', '/coe',
    'console.error(\'%c--- HERE ERROR ---\', \'background-color:#711;color:#fff;font-weight: bold;\', {});<Esc>3hp',
    { desc = "Console error" })
-- vim.keymap.set('i', '/cop', '\'arst<Space>\',<Space><Esc>3hp3lp==', { desc = "Console innards" })
-- make C-d in insert mode delete forward
vim.keymap.set('i', '<C-d>', '<Del>', { desc = "Delete forward" })
-- make opt-right, opt-left work correctly, with camelCase and snake_case
vim.keymap.set({ 'n', 'i', 'v' }, '<M-f>', '<cmd>lua require("spider").motion("w")<CR>',
    { desc = "Spider motion forward" })
vim.keymap.set({ 'n', 'i', 'v' }, '<M-Right>', '<cmd>lua require("spider").motion("w")<CR>',
    { desc = "Spider motion forward" })
vim.keymap.set({ 'n', 'i', 'v' }, '<M-b>', '<cmd>lua require("spider").motion("b")<CR>', { desc = "Spider motion back" })
vim.keymap.set({ 'n', 'i', 'v' }, '<M-Left>', '<cmd>lua require("spider").motion("b")<CR>',
    { desc = "Spider motion back" })
