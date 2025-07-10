-- Settings: my settings in lua
-- editorConfig is enabled by default in neovim: https://neovim.io/doc/user/editorconfig.html
-- To install all the nerd fonts:
-- brew tap homebrew/cask-fonts && brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true

vim.g.mapleader =
' '                   -- Make sure to set `mapleader` before lazy so your mappings are correct, except not using lazy because it breaks emmet
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- require('plugins')
require('options')
require('custom_keymaps')
