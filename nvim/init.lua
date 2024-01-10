-- Settings: my settings in lua
-- editorConfig is enabled by default in neovim: https://neovim.io/doc/user/editorconfig.html
-- To install all the nerd fonts:
-- brew tap homebrew/cask-fonts && brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
require('plugins')
require('options')
require('custom_keymaps')

