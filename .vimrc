
syntax enable
packadd! dracula | colorscheme dracula

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Ensure that the filetype plugin is on
filetype plugin on

" Set tabs only for Makefiles
autocmd FileType make set noexpandtab
autocmd FileType make set tabstop=4
autocmd FileType make set shiftwidth=4


" Set tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab

set autoindent
set title

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Nix
autocmd FileType nix source ~/.vim/syntax/nix.vim
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd FileType shell.nix setlocal tabstop=2 shiftwidth=2 expandtab


" Plugins
let g:UltiSnipsSnippetDirectories = ["~/.vim/Ultisnips"]
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
