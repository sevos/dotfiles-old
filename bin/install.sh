#!/bin/sh

DOTFILES_DIR = ~/Dotfiles

echo "Installing dotfiles. Provide password"
sudo easy_install dotfiles

git clone --recursive git://github.com/sevos/dotfiles.git ${DOTFILES_DIR}
cd ${DOTFILES_DIR}
git submodule init
git submodule update --recursive
