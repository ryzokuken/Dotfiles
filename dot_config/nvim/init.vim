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
set nofoldenable                        " but not by default
set cursorline                          " highlight the line on which the curor is placed

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
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
" Plug 'wfxr/minimap.vim'

" ORG MODE
" Plug 'jceb/vim-orgmode'
" Plug 'mattn/calendar-vim'

" AESTHETICS
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'edkolev/tmuxline.vim'

" LANGUAGE
Plug 'rust-lang/rust.vim'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-git'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug '~/Code/google/v8/v8/tools/torque/vim-torque'
Plug 'mboughaba/i3config.vim'

call plug#end()

syntax on
let g:onedark_terminal_italics=1
set termguicolors
colorscheme onedark

" PLUGIN CONFIGURATION

" source ~/.config/nvim/conf-lighline.vim   " source lightline configuration
source ~/.config/nvim/conf-coc.vim        " source coc configuration

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline_skip_empty_sections = 1
let g:airline_theme='onedark'

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

" tmuxline
let g:tmuxline_preset = 'full'

 " KEYMAPS
" C-p for files
map <C-p> :Files<CR>
" C-b for buffers
map <C-b> :Buffers<CR>
" C-t for tags
map <C-t> :TagbarToggle<CR>
" C-f for format
map <C-f> :ALEFix<CR>

" Buffer switching and closing
map <M-Left> :bp<CR>
map <M-Right> :bn<CR>
map <M-w> :bd<CR>

let g:ale_linters = {
\      'python': ['flake8'],
\      'javascript': ['eslint', 'tsserver'],
\      'cpp': ['cpplint', 'clangd'],
\      'rust': ['analyzer'],
\}
let g:ale_fixers = {
\      'python': ['black'],
\      'javascript': ['prettier', 'eslint'],
\      'json': ['prettier'],
\      'rust': ['rustfmt'],
\      'html': ['prettier'],
\      'markdown': ['prettier']
\}
let g:ale_rust_cargo_use_clippy = 1

autocmd FileType gitcommit,mail,markdown,asciidoc setlocal spell

let g:indentLine_fileTypeExclude = ['markdown']

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
