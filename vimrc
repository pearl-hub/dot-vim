"""""""""""""""""""""
" Global Vim settings
"""""""""""""""""""""
set encoding=utf8

" Automatically change window's cwd to file's dir.
" Disabled as may conflict with plugins:
"set autochdir
" Set working directory to the current file:
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * silent! lcd %:p:h

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Keep 5000 lines of command line history
set history=5000
" Show the cursor position all the time
set ruler
" Show (partial) command in the last line of the screen
set showcmd

" Hide buffers instead of closing them.
set hidden

" Show the line numbers
set number
set relativenumber

"Color the line number in a different color
"highlight LineNr guifg=lightblue ctermfg=lightgray
"highlight LineNr ctermbg=darkcyan ctermbg=black

" Set a light blue colored column at 79
set colorcolumn=79
highlight ColorColumn ctermbg=lightblue guibg=lightblue
" Highlight the lines that exceed the lenght 80 chars.
" Disabled as this can be a noisy!
" match ErrorMsg '\%>80v.\+'

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  " disable the background color erase
  set t_ut=
endif

" Maintain undo history between sessions
set undofile
set undodir=~/.vim/undodir

" Show matching brackets.
set showmatch
" Tenths of a second to show the matching parent, when 'showmatch' is set
set mat=5

" Show $ at end of line and trailing space as ~
set listchars=tab:>-,eol:\ \,trail:~,extends:>,precedes:<
set list

" No blinking
set novisualbell
" No noise
set noerrorbells
" No audio/visual bell
set visualbell t_vb=

set laststatus=2  " Always show status line.

""""""""""""
" Formatting
""""""""""""
" Indent by 4 spaces when pressing <TAB>
set softtabstop=4
" Use softtabstop spaces instead of tab characters for indentation
set expandtab
" A Tab inserts blanks according to shiftwidth
set smarttab
" Indent by 4 spaces when using >>, <<, == etc.
set shiftwidth=4
" Keep indentation from previous line
set autoindent
" Automatically inserts indentation in some conditions
" (i.e. line ending with {)
set smartindent
" Like smartindent, but stricter and more customisable
set cindent
set cinoptions=:0,p0,t0
" Add extra indent in next line when this words occur
set cinwords=if,else,while,do,for,switch,case
" Tabs are 4 spaces
set tabstop=4
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Let blocks be in virutal edit mode
set virtualedit=block
" Tab path completion like bash
set wildmenu
set formatoptions=tcqr
" Do not break line
set textwidth=0
"Wrap lines
set wrap
" This displays long lines as wrapped at word boundaries
" (do not affect file content)
set linebreak

" Folding
set foldcolumn=1
let g:markdown_folding = 1

"Files with these suffixes get a lower priority when multiple files match a wildcard.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.class

" During diff mode, keep files synced and ignore whitespace
set diffopt=filler,iwhite

""""""""""""""""
" Search/replace
""""""""""""""""
" Make search case-insensitive. Used for Cntrl-N
set ignorecase
" Override the ignorecase if the search pattern contains uppercase chars
set smartcase
" While typing the search show the pattern
set incsearch
" Highlights the matching words
set hlsearch

" Set the dictionaries
set complete+=k
for dict_path in split(globpath("~/.vim/dict/", "*"), "\n")
  exec "set dictionary+=".dict_path
endfor
for dict_path in split(globpath("/usr/share/dict/", "*"), "\n")
  exec "set dictionary+=".dict_path
endfor

" Search, replace
map <Leader>s :%s/old/new/gc

""""""""""""""""
" Spell settings
""""""""""""""""
set spellfile=~/.vim/spell/en.utf-8.add
set spell spelllang=en
" Provide spell suggestions
map <silent> <Leader>os i<C-x>s
" Set new language for spelling
map <Leader>ol :set spell spelllang=
" Disable spell
map <silent> <Leader>or :set nospell<cr>
" Add spell exception to the spell file
map <silent> <Leader>oa zg
" Go to the next/previous spell error
map <silent> <Leader>on ]s
map <silent> <Leader>op [s

""""""""""""""""""
" Windows settings
""""""""""""""""""
" Maps to resizing a window split (Warn: conflict with indentation)
" Another alternative is to use submode:
" https://vi.stackexchange.com/questions/3632/how-to-repeat-a-mapping-when-keeping-key-pressed
if bufwinnr(1)
  map <silent> + <C-W>+
  map <silent> - <C-W>-
  "map <silent> > <C-w>>
  "map <silent> < <C-w><
endif

" Maximize a window
map <silent> _ <C-w>_
map <silent> <Bar> <C-w><Bar>
map <silent> = <C-w>=

"""""""""
" Explore
"""""""""
nnoremap <silent> <Leader>e :Explore<CR>

" Hide .pyc and hidden files
let g:explHideFiles='^\.,.*\.pyc$'
let g:netrw_list_hide='^\.,.*\.pyc$'

"""""""""
" Session
"""""""""
"nmap SQ <ESC>:mksession! ~/vim/Session.vim<CR>:wqa<CR>
"function! RestoreSession()
    "if argc() == 0 "vim called without arguments
        "execute 'source ~/.vim/Session.vim'
    "end
"endfunction
"autocmd VimEnter * call RestoreSession()

nmap <Leader>sa :wa<CR>:mksession! ~/.vim/sessions/
nmap <Leader>so :wa<CR>:so ~/.vim/sessions/
nmap <Leader>sr :!rm ~/.vim/sessions/

"""""""""""""""""""""""""""""""""""""""""""""""""""
" File type specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on
filetype plugin on
" Automatically do language-dependent indenting.
filetype plugin indent on

" Autocompletion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
"From https://vim.fandom.com/wiki/Completion_using_a_syntax_file
setlocal omnifunc=syntaxcomplete#Complete

" Syntax
" Choose the fold method depending of the file type
" and unfold when opening it
autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
autocmd Syntax python setlocal foldmethod=indent
autocmd Syntax c,cpp,vim,xml,html,xhtml,perl,python normal zR

" To check where the setting of a given variable occurred use (for
" debugging)
" :verbose setlocal tabstop?
" For all text files set 'textwidth' to 79 characters.
autocmd FileType text setlocal textwidth=79
autocmd FileType markdown setlocal textwidth=79 shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType vim setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd Filetype javascript setlocal tabstop=4 shiftwidth=4 softtabstop=0
autocmd Filetype coffeescript setlocal tabstop=4 shiftwidth=4 softtabstop=0
autocmd Filetype jade setlocal tabstop=4 shiftwidth=4 softtabstop=0

""""""""""""""""
" Other settings
""""""""""""""""
" Sudo writing command
" Allow saving of files as sudo when you forgot to start vim using sudo.
command Wsudo w !sudo tee > /dev/null %

" Create the `tags` file (ctags command is required)
command! MakeTags !ctags -R .

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Smart Home
function! SmartHome()
  let s:col = col(".")
  normal! ^
  if s:col == col(".")
    normal! 0
  endif
endfunction
nnoremap <silent> <Home> :call SmartHome()<CR>
inoremap <silent> <Home> <C-O>:call SmartHome()<CR>

" Disable the indentation when pasting text
nnoremap <leader>d :set invpaste paste?<CR>
set pastetoggle=<leader>d
set showmode

" Use tabs like Firefox
map <C-t> :tabnew<cr>
map <C-p> :tabprevious<cr>
map <C-n> :tabnext<cr>
map <C-q> :tabclose<cr>

" Block indentation
" Allow to let indent the selection as many time as you want
vnoremap < <gv
vnoremap > >gv

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Autoclose tags
" https://aonemd.github.io/blog/handy-keymaps-in-vim
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
" disable the following, does work well with multiple-cursors plugin
" inoremap " ""<Left>

" Move to the split in the direction shown, or create a new split
" https://aonemd.github.io/blog/handy-keymaps-in-vim
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction


" FZF command is available if fzf has been installed into the system
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
map <Leader>f :FZF<CR>
