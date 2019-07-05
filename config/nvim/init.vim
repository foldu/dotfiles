" auto install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
" Color theme
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

" Fuzzy find thing
Plug 'junegunn/fzf', {'branch': 'release'}
Plug 'junegunn/fzf.vim'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Modify open file on fs
Plug 'tpope/vim-eunuch'
" Expand single line expression to multi line expression
Plug 'AndrewRadev/splitjoin.vim'
" Automatically resize windows when switching to them
Plug 'roman/golden-ratio'
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
" Lint thing
Plug 'w0rp/ale'
" Some git functions
Plug 'tpope/vim-fugitive'
" Show git file status in the gutter (left of line numbers)
Plug 'airblade/vim-gitgutter'
" Show command completion help when hitting <leader>
Plug 'liuchengxu/vim-which-key'
" GDB integration TODO: use this
Plug 'sakhnik/nvim-gdb'
" Automatically change working directory when opening project dirs
Plug 'airblade/vim-rooter'
" Turn vim into a hex editor
Plug 'fidian/hexmode'
" Show newest package version for Cargo.toml with virtualtext
Plug 'meain/vim-package-info', { 'do': 'npm install' }
" Latex
Plug 'lervag/vimtex', {'for': ['latex', 'tex']}
Plug 'justinmk/vim-sneak'
" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Syntax highlighters
Plug 'sheerun/vim-polyglot'
call plug#end()

let mapleader=" "

" Colors
"let g:solarized_use16 = 1
syntax enable
set background=light
colorscheme solarized
set fillchars+=vert:│
let g:lightline = { 'colorscheme': 'solarized' }

" Use the damn clipboard
set clipboard=unnamedplus
set go+=a

" paste from primary clipboard
nnoremap <C-p> :read !xsel -o<CR>

" Activate Plugins
filetype plugin on

" line numbers
set relativenumber
set number

" except for terminals
au TermOpen * setlocal nonumber norelativenumber

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
set t_vb=
set tm=500

" Search
" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Highlight all search results
set incsearch

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

nmap <silent> <leader><leader> :Commands<CR>
nmap <silent> <leader>b :Buffers<CR>
nmap <leader>e :Explore<CR>
nmap <silent> <leader>f :Files<CR>
nmap <silent> <leader>t :terminal<CR>
vnoremap > >gv
vnoremap < <gv
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

let g:ale_rust_rls_executable = 'ra_lsp_server'
let g:ale_rust_rls_toolchain = ''
let g:ale_linters = { 'asm': [] }
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'rust': ['rustfmt'],
            \   'python': ['black'],
            \   'cpp': ['clang-format'],
            \   'c': ['clang-format'],
            \   'sh': ['shfmt'],
            \   'xml': ['xmllint'],
            \   'javascript': ['prettier'],
            \   'typescript': ['prettier'],
            \   'svelte': ['prettier'],
            \   'json': ['prettier'],
            \}
let g:ale_fix_on_save = 1
let g:ale_c_clang_options = "-std=c11 -Wall -pedantic -funroll-loops"
let g:ale_cpp_clang_options = "-std=c++17 -Wall -pedantic -funroll-loops"
let g:ale_virtualtext_cursor = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap <leader><leader>z <Plug>ZVKeyDocset

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" Make fzf close with ESC
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

nnoremap <silent> ge :ALENext<CR>
nnoremap <silent> gE :ALEPrevious<CR>

nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>ga :Gwrite<CR>

" close scratch buffer
nnoremap <silent> <leader>q :<C-w>z<CR>

nnoremap <silent> <leader>      :<c-u>WhichKey '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

"let g:neosnippet#enable_complete_done = 1

" Navigate wrapped lines properly
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-python', 'coc-lists', 'coc-yaml']
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
