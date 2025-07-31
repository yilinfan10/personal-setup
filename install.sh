#!/bin/bash

git submodule init
git pull --recurse-submodules

ln -s $PWD/.bashrc $HOME/.bashrc
ln -s $PWD/.zshrc $HOME/.zshrc
ln -s $PWD/.p10k.zsh $HOME/.p10k.zsh
mkdir -p $HOME/.config
ln -s $PWD/.config/nvim $HOME/.config/nvim
