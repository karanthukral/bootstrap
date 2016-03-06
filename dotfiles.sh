#!/bin/bash

# Download Dotfiles
mkdir -p ~/Development/personal/other
cd ~/Development/personal/other
git clone git@github.com:karanthukral/dotfiles.git
cd ~/dotfiles

git remote set-url origin git@github.com:karanthukral/dotfiles.git

~/Development/personal/other/dotfiles/install_dotfiles.sh
