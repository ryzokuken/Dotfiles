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
set noshowmode                          " don't need it because ~lightline~ airline
autocmd BufWritePre * :%s/\s\+$//e      " trailing whitespace is an embarassment
set showtabline=2                       " show tabline always
let mapleader = "\<Space>"              " set leader to space
let maplocalleader = "\<Space>\<Space>" " set local leader to space-space
set foldmethod=indent                   " fold code based on indentation

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
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'

" LANGUAGE
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-git'

call plug#end()

set termguicolors                   " 24-bit colors
syntax on                           " turn on syntax highlighting
let g:onedark_terminal_italics = 1  " allow italics
colorscheme onedark                 " OneDark from Atom

" PLUGIN CONFIGURATION

" source ~/.config/nvim/conf-lighline.vim   " source lightline configuration
source ~/.config/nvim/conf-coc.vim        " source coc configuration

" Airline
let g:airline_theme='onedark' " just in case...
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

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
" C-p for files
map <C-p> :Files<CR>
" C-b for buffers
map <C-b> :Buffers<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Buffer switching and closing
map <M-Left> :bp<CR>
map <M-Right> :bn<CR>
map <C-w> :bd<CR>

let g:ale_linters = {'python': ['flake8'], 'javascript': ['eslint']}
let g:ale_fixers = {'python': ['black'], 'javascript': ['prettier', 'eslint'], 'json': ['prettier']}
let g:ale_fix_on_save = 1
