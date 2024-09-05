#!/bin/bash

# Symlink dotfiles
ln -sf ~/src/dotfiles/.bashrc ~/.bashrc
ln -sf ~/src/dotfiles/.bash_aliases ~/.bash_aliases
ln -sf ~/src/dotfiles/.bash_vars ~/.bash_vars
ln -sf ~/src/dotfiles/.vimrc ~/.vimrc
ln -sf ~/src/dotfiles/.vim ~/.vim

# Handle kali
if [ "$(uname -a | grep -i kali)" ]; then
    # Kali-specific configurations
    ln -sf ~/src/dotfiles/kali/.bash_aliases ~/.bash_aliases
fi
