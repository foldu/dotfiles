" auto install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh'
            \ }
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'
Plug 'roman/golden-ratio'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/float-preview.nvim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'KabbAmine/zeavim.vim'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tikhomirov/vim-glsl'
Plug 'editorconfig/editorconfig-vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mhinz/vim-startify'
Plug 'sakhnik/nvim-gdb'
Plug 'fidian/hexmode'

Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'leafgarland/typescript-vim'
Plug 'dag/vim-fish', {'for': ['fish']}
Plug 'LnL7/vim-nix', {'for': ['nix']}
Plug 'peterhoeg/vim-qml', {'for': 'qml'}
Plug 'vmchale/ion-vim', {'for': 'ion'}
Plug 'rust-lang/rust.vim', {'for': ['rs', 'rust']}
Plug 'stfl/meson.vim'
Plug 'udalov/kotlin-vim', {'for': ['kt', 'kotlin']}
Plug 'zah/nim.vim', {'for': ['nim']}
Plug 'shiracamus/vim-syntax-x86-objdump-d'
Plug 'jakwings/vim-pony', {'for': ['pony']}
Plug 'lervag/vimtex', {'for': ['latex', 'tex']}
call plug#end()

let mapleader=" "

" Colors
syntax enable
set background=light
colorscheme solarized
let g:solarized_termcolors=256
" make line numbers blend in
highlight LineNr ctermbg=15
"highlight LineNr ctermfg=10
highlight VertSplit ctermbg=NONE
"highlight StatusBar ctermfg=8
highlight SignColumn ctermbg=15
set fillchars+=vert:│

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
set laststatus=1

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
set cmdheight=1

" I forgot what this does but it's probably important
set hidden

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

let g:LanguageClient_useFloatingHover = 1

let g:LanguageClient_serverCommands = {
            \ 'rust': ['ra_lsp_server'],
            \ 'python': ['pyls'],
            \ 'cpp': ['clangd'],
            \ 'c': ['clangd'],
            \ 'javascript': ['javascript-typescript-stdio'],
            \ 'typescript': ['javascript-typescript-stdio'],
            \ }


let g:LanguageClient_autoStart = 1

nmap <silent> <leader><leader> :Commands<CR>
nmap <silent> <leader>b :Buffers<CR>
nmap <leader>e :Explore<CR>
nmap <silent> <leader>f :Files<CR>
nmap <silent> <leader>t :terminal<CR>
vnoremap > >gv
vnoremap < <gv
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

let g:ale_linters = { 'asm': [] }
let g:LanguageClient_hoverPreview = "Never"
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'rust': ['rustfmt'],
            \   'python': ['black'],
            \   'sh': ['shfmt'],
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

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gD :call LanguageClient#textDocument_implementation()<CR>
nnoremap <silent> <leader>a :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> <leader>sa :call LanguageClient#workspace_symbol()<CR>
nnoremap <silent> <leader>sd :call LanguageClient#textDocument_documentSymbol()<CR>

nnoremap <silent> ge :ALENext<CR>
nnoremap <silent> gE :ALEPrevious<CR>

nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>ga :Gwrite<CR>

" close scratch buffer
nnoremap <silent> <leader>q :<C-w>z<CR>

" ncm2 stuff
set completeopt=noinsert,menuone,noselect
autocmd BufEnter * call ncm2#enable_for_buffer()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> <leader>      :<c-u>WhichKey '<leader>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
