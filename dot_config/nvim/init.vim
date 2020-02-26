" GENERAL OPTIONS
set number                          " line numbers
set relativenumber                  " relative > absolute
set ignorecase                      " IDGAF
set nowrap                          " wrapping bad
set mouse=a                         " mouse good
set clipboard=unnamedplus           " clipboard good too, as long as it works
set colorcolumn=80                  " highlight column 80 to aid manual wrapping
set showcmd                         " show incomplete commands
filetype plugin on                  " filetypes are nice
filetype indent on                  " some langs have special indent rules
set background=dark                 " just in case...
set noshowmode                      " don't need it because lightline
autocmd BufWritePre * :%s/\s\+$//e  " trailing whitespace is an embarassment
set showtabline=2                   " show tabline always

" INDENTATION
set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab

" SCROLLING
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" PACKAGES
call plug#begin()

" ESSENTIALS
Plug 'tpope/vim-sensible'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
Plug 'jceb/vim-orgmode'

" AESTHETICS
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'mengelbrecht/lightline-bufferline'

" LANGUAGE
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" PLUGIN CONFIGURATION

source ~/.config/nvim/conf-lighline.vim   " source lightline configuration
source ~/.config/nvim/conf-coc.vim        " source coc configuration

" NERDCommenter
let g:NERDSpaceDelims = 1         " add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1     " use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'   " align line-wise comment delimiters flush left instead of following code indentation

" KEYMAPS

" C-p for fzf
map <C-p> :FZF<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
