if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Plug 'itchyny/lightline.vim'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'leafgarland/typescript-vim'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'Quramy/tsuquyomi'
" Plug 'tpope/vim-vinegar'
call plug#end()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers = ["go"]

" Enable filetype plugins
execute pathogen#infect()

filetype indent on
filetype plugin on

syntax on  " Enable syntax highlighting

" Disable syntax highlighting when in Vimdiff mode
if &diff
  syntax off
endif

set autoindent  " Copy indent from current line when starting a new line
set background=dark  " Tell Vim that we are using a dark background
set backspace=2  " Make sure backspace always works
set cc=+1  " Highlight the first column after textwidth
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

"set statusline=%<[%n]\ %{StatusLinePath()}\ \ %h%m%r%=%-14.(%l,%c%V%)\ %P
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



set t_Co=256  " Restrict to 16 for solarize
set tabstop=2  " Number of spaces that a <Tab> in the file counts for
set textwidth=80  " Stick to 80 chars lines for readability
set visualbell  " Use visual bell instead of beeping.
set wildignore+=*.swp,*.log,*.png,*.gif,*.jpeg,*/.git/*,*/tmp/*,*/log/*,*/test/reports/*,*/public/storage/*,*/public/cache/*,*/public/images/*,*/wp-content/uploads/* " Patterns to ignore when completing filenames
set wildmode=longest,list:full  " Mode to use when completing filenames
set guifont=Menlo-Regular:h12

autocmd FileType make setlocal noexpandtab  " Don't expand tabs in Makefiles
autocmd FileType go setlocal noexpandtab

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red
au ColorScheme * highlight ExtraWhitespace ctermbg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" solarized options
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" Customize some colors
highlight ColorColumn ctermbg=0
au ColorScheme * highlight ColorColumn ctermbg=0
au BufEnter * highlight ColorColumn ctermbg=0

" Vimdiff mode
highlight DiffAdd ctermfg=black ctermbg=darkgreen
highlight DiffDelete ctermfg=lightred ctermbg=darkred
highlight DiffChange ctermfg=black ctermbg=brown
highlight DiffText ctermfg=black ctermbg=yellow

" Visual mode pressing * or # searches for the current selection
" " Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Disable default shortcut to enter Ex mode.
noremap Q <ESC>


" Function to remove trailing whitespace from the currently opened file
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Automatically remove trailing whitespace when saving files
autocmd BufWritePre * :silent call <SID>StripTrailingWhitespaces()

" Make the comma be the leader key.
let mapleader = ","

" Whe moving up (<C-e>) or down (<C-y>) do it 3 by 3 lines instead of 1 by 1
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Disable accidentally closing windows when <C-w>c too quickly
nnoremap <C-w>c <Nop>

" Make Ctrl-C behave exactly like ESC so that InsertLeave events are fired and
" therefore things like multiline insert work well.
inoremap <C-c> <ESC>

" CTRLP OPTIONS
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

" Enable filename completion with <comma>r
map <Leader>r :CtrlP<CR>
" map <Leader>e :CtrlPBookmarkDir<CR>

map <Leader>h :lcd ~/core/projects/Jutsu/ts/<CR>

map <Leader>nt :tabnew<CR>

" TAGLIST OPTIONS
set updatetime=1000  " 1s delay for the taglist window to update

" Always sort method names by name
let Tlist_Sort_Type = "name"

" Increase default taglist window width to 60 chars
let Tlist_WinWidth = 60

" Don't show line numbering on taglist window
" autocmd FileType taglist setlocal norelativenumber

" Redefine ColorColumn's color now because Taglist overrides right
highlight ColorColumn ctermbg=8


if has("macunix")
  " Don't load taglist on osx because of lack of ctags binaries
  let g:loaded_taglist = 1
else
  " Shortcut for showing taglist window
  nmap <leader>o :TlistToggle<CR>
endif


" SESSIONS
" Shortcut for saving sessions
nmap <leader>ss :wa<CR>:mksession! ~/.vim/sessions/

" Shortcut for loading sessions
nmap <leader>sr :wa<CR>:so ~/.vim/sessions/

" Reload .vimrc on session load to make sure .vimrc settings are always on.
""autocmd SessionLoadPost * so ~/.vimrc
"
"" Show and hide the taglist window to handle an issue I have forgotten about.
"autocmd SessionLoadPost * :TlistToggle
"autocmd SessionLoadPost * :TlistToggle


" PLUGINS
" Allows you to configure % to match more than just single characters
runtime macros/matchit.vim

" Vimwiki
let g:vimwiki_list = [{'path': '~/core/projects/wiki/', 'path_html': '~/.wiki_html/'}, {'path': '~/core/projects/zhymballa/wiki/', 'path_html': '~/core/projects/zhymballa/wiki_html/', 'template_path': '~/core/projects/zhymballa/wiki/templates', 'template_default': 'default', 'template_ext': '.html', 'auto_export': 1}]
" let g:vimwiki_ext2syntax = {} " otherwise vimwiki autoconceal on markdown drives me crazy for the blog
let g:vimwiki_conceallevel = 0
" Disabling markdown because it makes things really slow
autocmd BufRead,BufNewFile *.wiki :set ft=markdown

" Allow POSIX regexps in searches
nnoremap / /\v
cnoremap %s/ %s/\v

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

let VimuxUseNearestPane = 1
let g:no_turbux_mappings = 1
map <leader>ut <Plug>SendTestToTmux
map <leader>uT <Plug>SendFocusedTestToTmux

" Map gofmt to ^O.  Walk through any syntax errors caught by gofmt.
"if exists("b:did_ftplugin_go_fmt")
"    finish
"endif

command! -buffer Fmt call s:GoFormat()

command Fig :normal i<CR>{{% figure src="" title="" %}}<CR><CR>

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

au BufEnter *.go map <C-o> :call GoFormat()<CR>
au BufLeave *.go unmap <C-o>
autocmd FileType go set textwidth=80
autocmd FileType go set tabstop=2
autocmd FileType go set shiftwidth=2


map <leader>1 :1wincmd w<CR>
map <leader>2 :2wincmd w<CR>
map <leader>3 :3wincmd w<CR>
map <leader>4 :4wincmd w<CR>
map <leader>5 :5wincmd w<CR>
map <leader>6 :6wincmd w<CR>
map <leader>7 :7wincmd w<CR>
map <leader>8 :8wincmd w<CR>
map <leader>9 :9wincmd w<CR>

map <leader>n :NERDTreeToggle<CR>

autocmd BufUnload journal.wiki !rm /tmp/personal_journal.lock
autocmd BufUnload journal_personal.wiki !rm /tmp/personal_journal.lock

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | en

" Writing mode (requires VimroomToggle plugin
command! Prose set spell tw=80 fo=t1a norelativenumber|
nnoremap <leader>W :Prose<CR>:VimroomToggle<CR>

" set conceallevel=0
" let g:vim_markdown_conceal = 0
" autocmd BufNewFile,BufRead,BufEnter,InsertEnter * set conceallevel=0
" autocmd *.md :set ft=markdown
" autocmd BufRead,BufNewFile,BufEnter *.md :set conceallevel=0
"

" Commonly used dirs:
command Hdigf cd ~/core/projects/hdigf.blog/content/posts

augroup autoreloadvimrc
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
augroup END

" let g:netrw_banner = 0
" let g:netrw_browse_split = 2
" let g:netrw_liststyle = 3
" let g:netrw_winsize = 25
" let g:netrw_altv = 1

" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END
let g:airline_solarized_bg='dark'

let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = '--lib es2015,dom'

" make the QuickFix window automatically appear if :make has any errors.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

autocmd FileType typescript setlocal completeopt+=menu,preview

set ballooneval
autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()

let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']


augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,typescript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END


let clang_format_executable="~/bin/clang-format"
