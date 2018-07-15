source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
if $TERM == 'xterm'
    set t_Co=256
    let g:molokai_original = 1
endif
set nocompatible
execute pathogen#infect()
syntax on
filetype plugin indent on

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType markdown set wrap|set linebreak

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set expandtab
set smartindent
set smarttab
set shiftwidth=4
set nowrap
set number
set backspace=2
set scrolloff=999
set sidescrolloff=999
set linebreak
set foldmethod=manual

colorscheme Monokai

set showcmd		    " Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch        " Highlight matches
set hidden		    " Hide buffers when they are abandoned

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

set lazyredraw
set title
set autoread
"set confirm
set noswapfile

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
        echo "Mouse disabled"
        set scrolloff=999
        set sidescrolloff=999
    else
        " enable mouse everywhere
        set mouse=a
        echo "Mouse enabled"
        set scrolloff=0
        set sidescrolloff=0
    endif
endfunc

" Whitespace/special chars for list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

function! ToggleWhitespace()
    if &list == 1
        set nolist
        echo "Whitespace highlighting disabled"
    else
        set list
        echo "Whitespace highlighting enabled"
    endif
endfunc

function! ToggleWrap()
    if (&wrap == 1)
        set nowrap
        echo "Wrap disabled"
    else
        set wrap
        echo "Wrap enabled"
    endif
endfunc

nnoremap <F2> :!echo -e "F3: Toggle paste\nF4: Toggle mouse\nF5: Toggle whitespace\nF6: Toggle wrap\nF7: Exec file"<CR>

set showmode
set pastetoggle=<F3>

nnoremap <F3> :set invpaste paste?<CR>
nnoremap <F4> :call ToggleMouse()<CR>
nnoremap <F5> :call ToggleWhitespace()<CR>
nnoremap <F6> :call ToggleWrap()<CR>

au BufRead *.py nmap <F7> :w !clear & python<CR>
au Bufread *.md nmap <F7> :w<CR>:silent !mdpdf % &<CR>:redraw!<CR>

let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_smart_startup_focus=2

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

map <C-o> :NERDTreeTabsToggle<CR>

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

function! s:CloseIfOnlyControlWinLeft()
    if winnr("$") != 1
        return
    endif
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
    endif
endfunction
augroup CloseIfOnlyControlWinLeft
    au!
    au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END
