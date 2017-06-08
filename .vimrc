if $TERM == 'xterm'
    set t_Co=256
    let g:molokai_original = 1
endif
set nocompatible
set runtimepath+=/home/per/.vim/bundle
set runtimepath^=/home/per/.vim/bundle/node
"execute pathogen#infect()
syntax on
"filetype plugin indent on

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType markdown set wrap|set linebreak

autocmd FileType java iabbrev <silent> <buffer> for for<C-R>=JAVA_replace("", "normal i () {\n}\ekf(\el")<CR><C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> fori for (int i = 0;; i++) {<CR>}<Esc>k^f;a <C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> forj for (int j = 0;; j++) {<CR>}<Esc>k^f;a <C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> fork for (int k = 0;; k++) {<CR>}<Esc>k^f;a <C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> forint for (int) {<CR>}<Esc>kf)i
autocmd FileType java iabbrev <silent> <buffer> foriti for (Iterator i=;i.hasNext();) {<CR>}<Esc>kf=a<C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> forit for (Iterator) {<CR>}<Esc>kf)i
autocmd FileType java iabbrev <silent> <buffer> while while<C-R>=JAVA_replace("", "normal i () {\n}\ekf(\el")<CR><C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> pl <C-R>=JAVA_replace("normal isysout", "normal iSystem.out.println();\eF)")<CR><C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> ple <C-R>=JAVA_replace("normal isyserr", "normal iSystem.err.println();\eF)")<CR><C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> privfun private() {<CR>}<Esc>kf(i
autocmd FileType java iabbrev <silent> <buffer> pubfun public() {<CR>}<Esc>kf(i
autocmd FileType java iabbrev <silent> <buffer> profun protected() {<CR>}<Esc>kf(i
autocmd FileType java iabbrev <silent> <buffer> tryc try {<CR>} catch () {}<Esc>F)i<C-R>=JAVA_EatChar('\s')<CR>
autocmd FileType java iabbrev <silent> <buffer> trya try {<CR>} catch (Exception e) {}<Esc>O<C-R>=JAVA_EatChar('\s')<CR>

func! JAVA_EatChar(pat)
    let c=nr2char(getchar())
    return (c =~ a:pat) ? '' : c
endfunc

func! JAVA_insert_p()
    exec "normal i \e"
    let modeVal=synIDattr( synIDtrans( synID(line("."), col("."), 0)), "name")
    return modeVal!=?"Constant" && modeVal!=?"Comment"
endfunc

func! JAVA_replace(name, repl)
    if JAVA_insert_p()
        exec a:repl
        return ""
    else
        exec a:name
        return " "
    endif
endfunc

set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set number
set backspace=2
set scrolloff=999
set sidescrolloff=999

colorscheme Monokai

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

nmap <F4> :w !clear & python<CR>
nmap <F5> :w<CR>:silent !mdpdf % &<CR>:redraw!<CR>

for prefix in ['i', 'n', 'v']
    for key in ['<Up>', '<Down>', '<Left>', '<Right>']
        exe prefix . "noremap " . key . " <Nop>"
    endfor
endfor

function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
        echo "Mouse disabled"
    else
        " enable mouse everywhere
        set mouse=a
        echo "Mouse enabled"
    endif
endfunc

nnoremap <F2> :set invpaste paste?<CR>
nnoremap <F3> :call ToggleMouse()<CR>
set pastetoggle=<F2>
set showmode

if v:progname != "vimdiff"
    autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
endif

if v:progname == "vimdiff"
    cabbrev q qa
endif

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

function! HighlightRepeats() range
    let lineCounts = {}
    let lineNum = a:firstline
    while lineNum <= a:lastline
        let lineText = getline(lineNum)
        if lineText != ""
            let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
        endif
        let lineNum = lineNum + 1
    endwhile
    exe 'syn clear Repeat'
    for lineText in keys(lineCounts)
        if lineCounts[lineText] >= 2
            exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
        endif
    endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
