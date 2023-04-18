# zplug on M1 has a different install path
# if [ ! -d "/usr/local/opt/zplug" ]
if [ ! -d "/opt/homebrew/opt/zplug" ]
then
  curl -sL zplug.sh/installer | zsh
fi
chsh -s $(which zsh)

