#!/bin/zsh

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

# Function for custom echo
c_echo() {
    message="$*"

    local colorized_message
    colorized_message=$(echo -e "\e[34m$1\e[0m")

    echo -e "${colorized_message}"
}

# Function to display the menu
display_menu() {
    clear
    c_echo "Select your setup:"
    c_echo "1. [$(toggle_display $BASH_SELECTED)] BASH"
    c_echo "2. [$(toggle_display $ZSH_SELECTED)] ZSH"
    c_echo "3. [$(toggle_display $VIM_SELECTED)] Vim"
    c_echo "4. [$(toggle_display $TMUX_SELECTED)] Tmux"
    c_echo "5. Install!"
    c_echo "6. Exit"
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
                c_echo "$name is not installed. Installing..."
                sudo apt install "$name" -y &> /dev/null
            else
                c_echo "$name is already installed."
            fi

            # Special case for Zsh to check Oh My Zsh
            if [[ $name == "zsh" && ! -d "$HOME/.oh-my-zsh" ]]; then
                c_echo "Oh My Zsh is not installed. Installing..."
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
            c_echo "Copying $src to $dest"
            cp -r "$src" "$dest"
        else
            c_echo "Warning: $src does not exist and will not be copied."
        fi
    done
}

copy_dotfiles() {
    # Always copy these files
    c_echo "Copying mandatory dotfiles..."
    copy_files "${always_copy}"

    # Conditional copying based on selections
    if [[ $BASH_SELECTED == true ]]; then
        c_echo "Copying Bash dotfiles..."
        copy_files "${bash_dotfiles[@]}"
    fi

    if [[ $VIM_SELECTED == true ]]; then
        c_echo "Copying Vim dotfiles..."
        copy_files "${vim_dotfiles[@]}"
    fi

    if [[ $TMUX_SELECTED == true ]]; then
        c_echo "Copying Tmux dotfile..."
        copy_files "${tmux_dotfiles[@]}"
    fi

    if [[ $ZSH_SELECTED == true ]]; then
        c_echo "Copying Zsh dotfiles..."
        copy_files "${zsh_dotfiles[@]}"

        # Install Dracula theme
        git clone https://github.com/dracula/zsh.git
        cp zsh/dracula.zsh-theme $HOME/.oh-my-zsh/themes/dracula.zsh-theme
        cp -r zsh/lib/ $HOME/.oh-my-zsh/themes/
        rm -rf zsh
    fi

    if [[ $VIM_SELECTED == true ]]; then
        echo "Installing vim-plug..."
        if [ ! -f ~/.vim/autoload/plug.vim ]; then
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        else
            echo "vim-plug is already installed."
        fi

        # Step 2: Install clangd (C Language Server)
        echo "Installing clangd (C Language Server)..."

        sudo apt update
        sudo apt install -y clangd
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        source ~/.bashrc
        source ~/.zshrc
        nvm install 16

        # Step 3: Install coc.nvim plugin in Vim
        echo "Configuring vim to use coc.nvim..."
        if ! grep -q "plug#begin" ~/.vimrc; then
            cat <<EOL >> ~/.vimrc

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

" Add coc.nvim plugin for Language Server Protocol (LSP) support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" End vim-plug configuration
call plug#end()

" Enable coc.nvim extensions globally
let g:coc_global_extensions = ['coc-clangd']

EOL
        else
            echo "coc.nvim plugin already added to ~/.vimrc"
        fi

        # Step 4: Install the coc-clangd extension for Vim (via coc.nvim)
        echo "Installing coc-clangd extension..."
        vim +PlugInstall +qall
        vim +CocInstall coc-clangd +qall

        # Step 5: Verify clangd Installation
        echo "Verifying clangd installation..."
        clangd --version

        # Step 6: Optional - Add clangd specific settings (if needed)
        echo "Configuring clangd settings..."
        if [ ! -f ~/.vim/coc-settings.json ]; then
            cat <<EOL > ~/.vim/coc-settings.json
{
    "clangd.arguments": [
        "--compile-commands-dir=/path/to/your/build/directory"
    ]
}
EOL
        else
            echo "clangd settings already configured in ~/.vim/coc-settings.json"
        fi

    fi
}

# Main loop
while true; do
    display_menu
    c_echo "Choose an option (1-6):"
    read -p "> " choice

    case $choice in
        1|2|3|4) toggle_selection $choice ;;
        5)
            c_echo "Installing with the following setup:"
            [[ $BASH_SELECTED == true ]] && c_echo "- BASH"
            [[ $ZSH_SELECTED == true ]] && c_echo "- ZSH"
            [[ $VIM_SELECTED == true ]] && c_echo "- Vim"
            [[ $TMUX_SELECTED == true ]] && c_echo "- Tmux"
            install_dependencies
            copy_dotfiles
            break
            ;;
        6) c_echo "Exiting..."; exit ;;
        *) c_echo "Invalid option! Please try again." ;;
    esac
done

