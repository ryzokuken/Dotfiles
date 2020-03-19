" GENERAL OPTIONS
set number                              " line numbers
set relativenumber                      " relative > absolute
set ignorecase                          " IDGAF
set nowrap                              " wrapping bad
set mouse=a                             " mouse good
set clipboard=unnamedplus               " clipboard good too, as long as it works
set colorcolumn=80                      " highlight column 80 to aid manual wrapping
set showcmd                             " show incomplete commands
filetype plugin on                      " filetypes are nice
filetype indent on                      " some langs have special indent rules
set background=dark                     " just in case...
set noshowmode                          " don't need it because lightline
autocmd BufWritePre * :%s/\s\+$//e      " trailing whitespace is an embarassment
set showtabline=2                       " show tabline always
let mapleader = "\<Space>"              " set leader to space
let maplocalleader = "\<Space>\<Space>" " set local leader to space-space

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
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" ORG MODE
Plug 'jceb/vim-orgmode'
Plug 'mattn/calendar-vim'

" AESTHETICS
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'Yggdroot/indentLine'

" LANGUAGE
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'mboughaba/i3config.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-git'

call plug#end()

set termguicolors                   " 24-bit colors
syntax on                           " turn on syntax highlighting
let g:onedark_terminal_italics = 1  " allow italics
colorscheme onedark                 " OneDark from Atom

" PLUGIN CONFIGURATION

source ~/.config/nvim/conf-lighline.vim   " source lightline configuration
source ~/.config/nvim/conf-coc.vim        " source coc configuration

" NERDCommenter
let g:NERDSpaceDelims = 1         " add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1     " use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'   " align line-wise comment delimiters flush left instead of following code indentation

" EasyMotion
let g:EasyMotion_do_mapping = 0       " disable default mappings
let g:EasyMotion_smartcase = 1        " turn on case-insensitive feature
" jump to anywhere you want with s
nmap s <Plug>(easymotion-overwin-f)
" line motion down
map <Leader>j <Plug>(easymotion-j)
" line motion up
map <Leader>k <Plug>(easymotion-k)

" KEYMAPS
" C-p for fzf
map <C-p> :FZF<CR>
" C-b for buffers
map <C-b> :Buffers<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

let g:ale_linters = {'python': ['flake8'], 'javascript': ['eslint']}
let g:ale_fixers = {'python': ['black'], 'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 1
