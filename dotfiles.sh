#!/bin/bash

# Install ZPrezto
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git
"${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

# Download Dotfiles
mkdir -p ~/Development/personal/other
cd ~/Development/personal/other
git clone git@github.com:karanthukral/dotfiles.git
cd ~/dotfiles

git remote set-url origin git@github.com:karanthukral/dotfiles.git

~/Development/personal/other/dotfiles/install_dotfiles.sh

# Install Vim Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
