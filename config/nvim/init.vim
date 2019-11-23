" auto install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
" Color themes
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Modify open file on fs
Plug 'tpope/vim-eunuch'
" Better status line
Plug 'itchyny/lightline.vim'
" You need this
Plug 'tpope/vim-surround'
" Make repeat . work properly
Plug 'tpope/vim-repeat'
" Emacs keybindings for commandline
Plug 'tpope/vim-rsi'
" Apply editorconfig
Plug 'editorconfig/editorconfig-vim'
" Some git functions
Plug 'tpope/vim-fugitive'
" Show git file status in the gutter (left of line numbers)
Plug 'airblade/vim-gitgutter'
" Show command completion help when hitting <leader>
Plug 'liuchengxu/vim-which-key'
" Fuzzy finder
Plug 'liuchengxu/vim-clap'
" Semantic code navigation
Plug 'liuchengxu/vista.vim'
" GDB integration TODO: use this
"Plug 'sakhnik/nvim-gdb'
" Automatically change working directory when opening project dirs
Plug 'airblade/vim-rooter'
" Turn vim into a hex editor
Plug 'fidian/hexmode'
" Show newest package version for Cargo.toml with virtualtext
"Plug 'meain/vim-package-info', { 'do': 'npm install' }
" Latex
Plug 'lervag/vimtex', {'for': ['latex', 'tex']}
Plug 'justinmk/vim-sneak'

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Highlight yanked
Plug 'machakann/vim-highlightedyank'

" Better matching parens highlighting
Plug 'andymass/vim-matchup'

" Syntax highlighters
Plug 'sheerun/vim-polyglot'
call plug#end()

let mapleader=" "

" Colors
" enables 24-bit colors for TUI
" don't remove this
set termguicolors
syntax enable
set background=light
colorscheme solarized8_flat
set fillchars+=vert:│
let g:lightline = { 'colorscheme': 'solarized' }

" Use the damn clipboard
set clipboard=unnamedplus

" paste from primary clipboard
nnoremap <C-p> :read !xsel -o<CR>

" Activate Plugins
filetype plugin on

" line numbers
set number

" except for terminals
autocmd TermOpen * setlocal nonumber

" Wrap lines
set linebreak
let &showbreak = '\ '

" highlight substitutions
set inccommand=nosplit

" Enable indentation
filetype indent on

" Filetype recognition
filetype on

set autoindent
set smartindent
set smarttab

" Linux Tarballs told me tabs are 8 spaces so it must be true
set tabstop=8

" don't use tabs
set shiftwidth=4
set softtabstop=4
set expandtab

" disable arbitrary code execution on file open
set nomodeline

" Shut up
set noerrorbells
set novisualbell

" Usable search
set ignorecase
set smartcase
set hlsearch
set incsearch

" center search results
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Navigate wrapped lines properly
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Show min 2 lines above and below cursor
set scrolloff=2

" Show matching brackets when cursor is over them
set showmatch

" Enable mouse interaction
set mouse=a

" make vim regex suck less
set magic

" Normal backspace
set backspace=indent,eol,start

" not useless status line
set ruler

" remove annoying bar
set laststatus=2

" this is important
set hidden

" persistent undo
set undofile
let &undodir = getenv('HOME') .. '/.local/share/nvim/undir'
call mkdir(&undodir, 'p')

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

" Y should work like D
nnoremap Y y$

set shortmess=Iatc

" 80 column highlight thing
function! s:vt_tgl()
    if &g:cc == 80
        set cc=0
    else
        set cc=80
    endif
endfunction
command! Vttoggle call s:vt_tgl()
nnoremap <leader>tf :Vttoggle<CR>

" highlight trailing whitespace
highlight trailing_ws ctermbg = gray guibg = gray
match trailing_ws /\s\+\%#\@<!$/

" hide current mode
set noshowmode

" don't make my statusbar too big
"set cmdheight=1

vnoremap > >gv
vnoremap < <gv
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

" listen for file changes outside of nvim
" https://github.com/neovim/neovim/issues/2127
augroup checktime
    autocmd!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter,FocusGained,BufEnter,FocusLost,WinLeave * checktime
    endif
augroup END


" fixing clap colors for solarized
"highlight ClapInput Pmenu
nmap <silent> <leader><leader> :Clap commands<CR>
nmap <silent> <leader>b :Clap buffers<CR>
nmap <silent> <leader>cc :Clap colors<CR>
nmap <leader>e :Explore<CR>
nmap <silent> <leader>f :Clap files<CR>
nmap <silent> <leader>t :terminal<CR>

nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>ga :Gwrite<CR>

" vim whichkey
nnoremap <silent> <leader>      :<c-u>WhichKey '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
set timeoutlen=300

" disable offscreen matching
let g:matchup_matchparen_offscreen={}

let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-python',
            \ 'coc-lists',
            \ 'coc-yaml',
            \ 'coc-rust-analyzer',
            \ 'coc-html',
            \ 'coc-tsserver',
            \ 'coc-css'
            \]
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>r <Plug>(coc-rename)
nmap <leader>a <Plug>(coc-codeaction)

command! -nargs=0 Format :call CocAction('format')
" Autoformat before save
autocmd BufWritePre * Format

nnoremap <silent> <leader>vv :Vista coc<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
