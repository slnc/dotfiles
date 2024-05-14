if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
let $FZF_DEFAULT_COMMAND='find . \( -name public/cache* tmp/* -name public/storage* -o -name .git \) -prune -o -print'

call plug#end()

filetype indent plugin on

set autoindent  " Copy indent from current line when starting a new line
set background=dark  " Tell Vim that we are using a dark background
set backspace=2  " Make sure backspace always works
set cc=+1  " Highlight the first column after textwidth
set rtp+=~/.fzf
set cindent  " Get the amount of indent according the C indenting rules
set cinkeys-=0#  " Treat # as a normal character when indenting
set expandtab  " Always replace tabs with spaces
set ff=unix  " Always use unix EOLs
set gdefault  " All matches in a line are substituted instead of one
set hidden  " Buffer becomes hidden (can have pending changes) when abandoned
set hlsearch  " When there is a prev search pattern, highlight all its matches
set incsearch  " While typing a search command show first match
set laststatus=2  " Always show status line
set nostartofline   " don't jump to first character when paging
set relativenumber  " Show relative line numbers on the left side
set ruler  " Show the line and column number of the cursor position
set scrolloff=3  "Minimal number of lines to keep above and below the cursor
set matchtime=1  " Show matching character for 1th of a second
set shiftwidth=2  " Number of spaces to use for each step of (auto)indent
set shortmess=atIoO   " Abbreviate messages
set showcmd  " Show (partial) command in the last line of the screen
set showmatch  " When a bracket is inserted, briefly jump to the matching one.
set t_Co=256
set tabstop=2
set ballooneval
set textwidth=80
set visualbell
set wildignore+=*.swp,*.log,*.png,*.gif,*.jpeg,*/.git/*,*/tmp/*,*/log/*,*/test/reports/*,*public/storage*
set wildmode=longest,list:full
set guifont=Menlo-Regular:h14
set updatetime=1000

function! WindowNumber()
    let str=tabpagewinnr(tabpagenr())
    return str
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return '[p]'
    en
    return ' '
endfunction

set statusline=%<\ %{WindowNumber()}\ %t\ %{HasPaste()}\%h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Colors
syntax on
if &diff
  syntax off
endif

let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

highlight ExtraWhitespace ctermbg=red
highlight ColorColumn ctermbg=0
highlight DiffAdd ctermfg=black ctermbg=darkgreen
highlight DiffDelete ctermfg=lightred ctermbg=darkred
highlight DiffChange ctermfg=black ctermbg=brown
highlight DiffText ctermfg=black ctermbg=yellow
highlight ColorColumn ctermbg=8


" Keyboard remappings
" Make the comma be the leader key.
let mapleader = ","

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" xnoremap <D-\> gc<CR>
" xnoremap <D-/> gc<CR>
" xnoremap <D-_> gc<CR>
"
" Disable default shortcut to enter Ex mode.
noremap Q <ESC>

" Whe moving up (<C-e>) or down (<C-y>) do it 3 by 3 lines instead of 1 by 1
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Disable accidentally closing windows when <C-w>c too quickly
nnoremap <C-w>c <Nop>

" Make Ctrl-C behave exactly like ESC so that InsertLeave events are fired and
" therefore things like multiline insert work well.
inoremap <C-c> <ESC>

" Allow POSIX regexps in searches
nnoremap / /\v
cnoremap %s/ %s/\v

" Shortcuts to quickly move between vim windows.
map <leader>1 :1wincmd w<CR>
map <leader>2 :2wincmd w<CR>
map <leader>3 :3wincmd w<CR>
map <leader>4 :4wincmd w<CR>
map <leader>5 :5wincmd w<CR>
map <leader>6 :6wincmd w<CR>
map <leader>7 :7wincmd w<CR>
map <leader>8 :8wincmd w<CR>
map <leader>9 :9wincmd w<CR>

" Toggle comment on selected lines. Requires iterm2 Key Binding:
"
"   Keyboard Shortcut: cmd+/
"   Action: Send Text with "vim" Special Chars
"   Text: \<C-_>
map <C-_> gc

map <Leader>r :FZF --reverse --inline-info<CR>
map <Leader>nt :tabnew<CR>
nmap <leader>w :e ~/.worklog.md<CR>

" Custom commands
command! -buffer Fmt call s:GoFormat()
command! Fig :normal i<CR>{{% figure src="" title="" %}}<CR><CR>

function! GoFormat()
    let view = winsaveview()
    silent %!gofmt
    if v:shell_error
        let errors = []
        for line in getline(1, line('$'))
            let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
            if !empty(tokens)
                call add(errors, {"filename": @%,
                                 \"lnum":     tokens[2],
                                 \"col":      tokens[3],
                                 \"text":     tokens[4]})
            endif
        endfor
        if empty(errors)
            % | " Couldn't detect gofmt error format, output errors
        endif
        undo
        if !empty(errors)
            call setloclist(0, errors, 'r')
        endif
        echohl Error | echomsg "Gofmt returned error" | echohl None
    endif
    call winrestview(view)
endfunction

let b:did_ftplugin_go_fmt = 1


" Function to remove trailing whitespace from the currently opened file
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

augroup configgroup
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
  autocmd BufWritePost .vimrc source ~/.vimrc

  autocmd BufEnter * highlight ColorColumn ctermbg=0
  autocmd BufEnter * match ExtraWhitespace /\s\+$/
  " autocmd BufEnter *.go map <C-o> :call GoFormat()<CR>
  " autocmd BufLeave *.go unmap <C-o>
  autocmd BufRead,BufNewFile *.wiki :set ft=markdown formatoptions-=tc
  autocmd BufWritePre * :silent call <SID>StripTrailingWhitespaces()
  autocmd ColorScheme * highlight ColorColumn ctermbg=0
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,typescript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType go set shiftwidth=2
  autocmd FileType go set tabstop=2
  autocmd FileType go set textwidth=80
  autocmd FileType go setlocal noexpandtab
  " autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType make setlocal noexpandtab  " Don't expand tabs in Makefiles
  autocmd FileType python AutoFormatBuffer yapf
  " make the QuickFix window automatically appear if :make has any errors.
  autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
  autocmd FileType typescript setlocal completeopt+=menu,preview
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

  " indent plugin overrides global .py indent settings, we re-override them here.
  autocmd FileType python setl sw=2 ts=2 sts=2

  autocmd BufRead,BufNewFile ~/.worklog.md setlocal norelativenumber
augroup END

" Plugins config

" clang
let clang_format_executable="~/bin/clang-format"

" vim-go
let g:go_fmt_command = "goimports"

" syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_typescript_checkers = ['tsuquyomi']
let g:syntastic_go_checkers = []
let g:syntastic_mode_map = { 'mode': 'passive', 'passive_filetypes': ['html'] }

" ctrlp
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_dotfiles = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_mruf_relative = 1
let g:ctrlp_max_height = 50
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir',
                          \ 'autoignore']

" typescript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = '--lib es2015,dom'
let g:tsuquyomi_disable_quickfix = 1

" Allows you to configure % to match more than just single characters
runtime macros/matchit.vim

" fzf
let g:fzf_layout = { 'down': '~60%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
set runtimepath+=~/.fzf
let $FZF_DEFAULT_COMMAND='find . \( -name public\/storage -o -name public\/cache -name tmp\/cache -o -name .git \) -prune -o -print'
let $FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'

let g:omni_sql_no_default_maps = 1

set t_vb=
