set nocompatible
let mapleader=","
set cpo+=J
set directory=~/tmp//,/var/tmp//,/tmp//
" encoding settings {{{
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif
" }}}
" Remaps {{{
inoremap jk <esc>
vnoremap jk <esc>
" inoremap <esc> <nop>
" vnoremap <esc> <nop>
nnoremap <CR> :update<CR>
nnoremap <leader><S-r> :source ~/.vimrc<CR>
" Space toggles folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
" Movement keys
nnoremap k gk
nnoremap j gj
nnoremap <up> <C-Y>
nnoremap <down> <C-E>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
cabbr <expr> %% expand('%:p:h')
" }}}
" Set up plugins {{{
let g:skipview_files = ['py', 'vim']
let g:notes_directories = ['~/Dropbox/Juniper\ Intern\ Share/notes/', '~/Dropbox/notes/']
let g:notes_suffix = ".txt"

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'gmarik/Vundle.vim'

Bundle 'mhinz/vim-startify'
Bundle 'xolox/vim-misc'
Bundle 'vim-scripts/restore_view.vim'
Bundle 'croaker/mustang-vim'
" Source control
Bundle 'tpope/vim-fugitive'
Bundle 'mhinz/vim-signify'
Bundle 'mattn/gist-vim'
" iMproved editing
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
" Tools
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'milkypostman/vim-togglelist'
Bundle 'kien/tabman.vim'
Bundle 'vim-scripts/taglist.vim'
Bundle 'xolox/vim-notes'
" Syntax/tags
Bundle 'vim-scripts/armasm'
Bundle 'scrooloose/syntastic'
Bundle 'vim-scripts/jpythonfold.vim'

noremap <F2> :NERDTreeToggle<CR>
noremap <F3> :GundoToggle<CR>
noremap <F4> :TMToggle<CR>
noremap <F5> :TlistToggle<CR>
set tags=./.tags;
let g:syntastic_python_checkers=['flake8', 'pyflakes']
let g:syntastic_ruby_checkers=['mri', 'rubocop']
let g:syntastic_always_populate_loc_list=1
let g:git_branch_status_ignore_remotes=1
" }}}
" Setting up views {{{
set scrolloff=3
set number
set relativenumber
set shortmess=at
func! NLToggle()
    if (&rnu == 1) | set nornu | else | set rnu | endif
endfunc
nnoremap <leader>k :call NLToggle()<CR>
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set foldcolumn=1
set list
nnoremap <leader>s :set list!<CR>
set listchars=tab:»\ ,eol:¬
set backspace=indent,eol,start
set undodir=~/.vim/undo
set undofile
set undolevels=1000 " Max changes
set undoreload=10000 " Max number to save on buffer reload
" }}}
" Filetype and syntax and search highlighting. {{{
syntax on
filetype off
filetype plugin indent on
setlocal foldmethod=manual
let @/ = ""
set hlsearch
set incsearch
nnoremap <leader>' :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap <leader>; :set hlsearch!<CR>
noremap / :set hlsearch<CR>/
set ignorecase
set smartcase
" }}}
" Setting up statusline {{{
let g:git_branch_status_text=""
set ls=2
set statusline=%.50F            "Truncated file path
set statusline+=%h%m%r          "help, modified, and read-only
set statusline+=%y              "filetype
set statusline+=%=              "left/right separator
set statusline+=<%{fugitive#statusline()}>
set statusline+=%c,%l/%L\ %P    "cursor and file position
" }}}
" Set up general autocommands {{{
augroup all_autocmds
    autocmd!
augroup END
" }}}
" Set up python autocommands {{{
augroup python_autocmds
    autocmd!
    autocmd FileType python source $HOME/.vim/bundle/jpythonfold.vim/syntax/jpythonfold.vim
    " highlight characters past column 80
    autocmd FileType python match Excess /\%>80v.\+\%<101v/
    autocmd FileType python 2match Excess2 /\%100v.*/
    autocmd FileType python set nowrap
    autocmd FileType python set commentstring=#\ %s
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup END
" }}}
" Set up ruby autocommands {{{
augroup ruby_autocmds
    autocmd!
    autocmd FileType ruby set tabstop=2
    autocmd FileType ruby set shiftwidth=2
    autocmd FileType ruby set softtabstop=2
    " highlight characters past column 80
    autocmd FileType ruby match Excess /\%80v.*/
    autocmd FileType ruby set nowrap
    autocmd FileType ruby set commentstring=#\ %s
augroup END
" }}}
" Set up C autocommands {{{
augroup c_autocmds
    autocmd!
    autocmd FileType c,cpp set tabstop=2
    autocmd FileType c,cpp set shiftwidth=2
    autocmd FileType c,cpp set softtabstop=2
    " highlight characters past column 80
    autocmd FileType c,cpp match Excess /\%80v.*/
    autocmd FileType c,cpp set nowrap
    autocmd FileType c,cpp set commentstring=//\ %s
augroup END
" }}}
" Set up vim autocommands {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    " Auto refresh .vimrc upon change.
    autocmd BufWritePost .vimrc source %
augroup END
" }}}
" Coloring {{{
colorscheme mustang
highlight StatusLine ctermbg=0 ctermfg=32
highlight StatusLineNC ctermbg=0 ctermfg=24
highlight Folded ctermbg=242
highlight ColorColumn ctermbg=60
highlight Excess ctermbg=237 guibg=Black
highlight Excess2 ctermbg=241 guibg=Black
" }}}
set modeline
set nu
