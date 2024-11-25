#!/bin/bash

# Install script for dotfiles
# Author: Chandler Scott
# Date: 11/24/2024

# Variables to track selections
BASH_SELECTED=false
ZSH_SELECTED=true
VIM_SELECTED=true
TMUX_SELECTED=true

# Base and conditional dotfiles
always_copy=(
    ".config"
    ".profile"
)

bash_dotfiles=(
    ".bashrc"
    ".bash_logout"
    ".bash_aliases"
    ".bash_vars"
)

vim_dotfiles=(
    ".vim"
    ".vimrc"
)

tmux_dotfiles=(
    ".tmux.conf"
)

zsh_dotfiles=(
    ".oh-my-zsh"
    ".zshrc"
    ".zsh_aliases"
    ".zsh_vars"
)

# Function to display the menu
display_menu() {
    clear
    echo "Select your setup:"
    echo "1. [$(toggle_display $BASH_SELECTED)] BASH"
    echo "2. [$(toggle_display $ZSH_SELECTED)] ZSH"
    echo "3. [$(toggle_display $VIM_SELECTED)] Vim"
    echo "4. [$(toggle_display $TMUX_SELECTED)] Tmux"
    echo "5. Install!"
    echo "6. Exit"
}

# Helper function to toggle selection display
toggle_display() {
    [[ $1 == true ]] && echo "x" || echo " "
}

# Function to toggle selections
toggle_selection() {
    case $1 in
        1) BASH_SELECTED=$([[ $BASH_SELECTED == true ]] && echo false || echo true) ;;
        2) ZSH_SELECTED=$([[ $ZSH_SELECTED == true ]] && echo false || echo true) ;;
        3) VIM_SELECTED=$([[ $VIM_SELECTED == true ]] && echo false || echo true) ;;
        4) TMUX_SELECTED=$([[ $TMUX_SELECTED == true ]] && echo false || echo true) ;;
    esac
}

install_dependencies() {
    # Array of software with custom checks
    software=(
        "vim:$VIM_SELECTED"
        "tmux:$TMUX_SELECTED"
        "zsh:$ZSH_SELECTED"
    )

    # Loop through software
    for item in "${software[@]}"; do
        IFS=":" read -r name selected <<< "$item"
        if [[ $selected == true ]]; then
            if ! command -v "$name" &> /dev/null; then
                echo "$name is not installed. Installing..."
                sudo apt install "$name" -y &> /dev/null
            else
                echo "$name is already installed."
            fi

            # Special case for Zsh to check Oh My Zsh
            if [[ $name == "zsh" && ! -d "$HOME/.oh-my-zsh" ]]; then
                echo "Oh My Zsh is not installed. Installing..."
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            fi
        fi
    done
}

copy_files () {
    local files=("$@")
    for file in "${files[@]}"; do
        src="$(dirname "$(realpath "$0")")/$file"
        dest="$HOME/$file"
        if [[ -e "$src" ]]; then
            echo "Copying $src to $dest"
            cp -r "$src" "$dest"
        else
            echo "Warning: $src does not exist and will not be copied."
        fi
    done
}

copy_dotfiles() {
    # Always copy these files
    echo "Copying mandatory dotfiles..."
    copy_files "${always_copy}"

    # Conditional copying based on selections
    if [[ $BASH_SELECTED == true ]]; then
        echo "Copying Bash dotfiles..."
        copy_files "${bash_dotfiles[@]}"
    fi

    if [[ $VIM_SELECTED == true ]]; then
        echo "Copying Vim dotfiles..."
        copy_files "${vim_dotfiles[@]}"
    fi

    if [[ $TMUX_SELECTED == true ]]; then
        echo "Copying Tmux dotfile..."
        copy_files "${tmux_dotfiles[@]}"
    fi

    if [[ $ZSH_SELECTED == true ]]; then
        echo "Copying Zsh dotfiles..."
        copy_files "${zsh_dotfiles[@]}"
    fi
}

# Main loop
while true; do
    display_menu
    read -p "Choose an option (1-6): " choice

    case $choice in
        1|2|3|4) toggle_selection $choice ;;
        5)
            echo "Installing with the following setup:"
            [[ $BASH_SELECTED == true ]] && echo "- BASH"
            [[ $ZSH_SELECTED == true ]] && echo "- ZSH"
            [[ $VIM_SELECTED == true ]] && echo "- Vim"
            [[ $TMUX_SELECTED == true ]] && echo "- Tmux"
            install_dependencies
            copy_dotfiles
            break
            ;;
        6) echo "Exiting..."; exit ;;
        *) echo "Invalid option! Please try again." ;;
    esac
done

