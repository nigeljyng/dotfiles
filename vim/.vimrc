" Nigel's vimrc

" launch config {{{
  execute pathogen#infect()
  set nocompatible  " so things run correctly
 
  " get custom fold settings from last line
  set modeline
  set modelines=1  " check last line for custome fold method

  " leader key is space
  let mapleader="\<Space>"
  " Save marks for 100 files. f1 saves global marks (i.e. marks with capital
  " letters
  set viminfo='100,f1
  
  " no bell
  set noerrorbells
  set novisualbell
  set t_vb=
" }}}

" colors and UI {{{
  syntax on
  syntax enable
  set laststatus=2  "always show status
  
  " styles for macvim. Not run if in terminal because it'll look weird
  if has("gui_running")
      set gfn=Inconsolata:h17  " love this font
      colorscheme base16-ateliercave   " theme color from vim-colorschemes plugin
  
      " show cursor line in active buffer only
      au BufEnter * setlocal cursorline
      au BufLeave * setlocal nocursorline
  else
      set cursorline  " if no GUI, set cursorline globally
  endif
  
  " Absolute and relative line numbers
  set number
  set relativenumber
  
  filetype plugin indent on " enable filetype detection, filetype-specific scripts and indent scripts
  
  set wildmenu   " visual autocomplete for command manu
  set lazyredraw  " redraw only when we need to
  set showmatch  " highlight matching brackets
  set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
  
  " center cursor in middle of the screen
  set so=999
  
  "get rid of GUI tabline
  set guioptions-=e
  set showtabline=0
  
  "get rid of scroll bars
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  
  set hidden        " Let's me switch to different buffer without saving
  
  set nowrap        " don't wrap lines
  set backspace=indent,eol,start
                      " allow backspacing over everything in insert mode
                      
  " Don't conceal in markdown
  let g:vim_markdown_conceal = 0
  set title         " change the terminal's title
  set mouse=a       " enable the mouse
  set pastetoggle=<F2>  " enable paste mode (doesn't do smart indent)
  
  " show 100 char colorcolumn only in insert mode
  augroup ColorcolumnOnlyInInsertMode
    autocmd!
    autocmd InsertEnter * setlocal colorcolumn=100
    autocmd InsertLeave * setlocal colorcolumn=0
  augroup END
  set autoindent    " always set autoindenting on
  set copyindent    " copy the previous indentation on autoindenting

  " Highlight words like TODO, FIXME, NOTE, INFO, IDEA etc.
  if has("autocmd")
    " Highlight TODO, FIXME, NOTE, etc.
    if v:version > 701
      autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
      autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
    endif
  endif

  " custom highlight modifications
  hi QuickFixLine cterm=None ctermbg=256 guibg=#005b5b
  hi Search ctermfg=8 ctermbg=3 guifg=#322f36 guibg=#b38b62
  
" }}}

" spaces and tabs {{{
  set expandtab  " tabs are space
  set tabstop=4  " number of visual spaces per tab
  set softtabstop=4  " number of spaces in tab when editing
  retab
  set shiftwidth=4  " how many space when doing << or >>
  
  " sometimes vim removes indent for #. disable smartindent and set these
  set cindent
  set cinkeys-=0#
  set indentkeys-=0#
" }}}
  
" searching {{{
  set hlsearch      " highlight search terms
  set incsearch     " show search matches as you type
  set ignorecase
  set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
  " clears search highlight
  nmap <Leader>/ :nohlsearch<CR>
" }}}

" folding {{{
  set foldenable
  set foldlevelstart=5  " open most folds by default
  set foldnestmax=10     " 10 nested fold max
  
  set foldmethod=indent  " fold based on indent level
  " R code folding
  "let r_syntax_folding = 1
" }}}

" leader shortcuts {{{
  " leader-w to toggle word wrap
  map <Leader>w :set wrap!<CR>

  " Leader x clears hidden buffers
  nnoremap <Leader>x :call DeleteHiddenBuffers()<CR>

  " json formatting
  map <Leader>j !python -m json.tool<CR>
  
  " Use ; instead of : for commands. Saves a SHIFT keypress
  noremap ; :
  
  " But ; has the functionality of finding the next occurence in an f command.
  " Use <Leader>;
  noremap <Leader>; ;
  
  " Add quotation marks to a word with <Leader>" or <Leader>'
  nnoremap <Leader>" :norm bi"<esc>ea"<esc>
  nnoremap <Leader>' :norm bi'<esc>ea'<esc>
  
  " edit vimrc and load vimrc
  nnoremap <Leader>ev :vsp $MYVIMRC<CR>
  nnoremap <Leader>sv :source $MYVIMRC<CR>
" }}}

" plugin specific configurations {{{
  " Vim-tags
  " Don't auto generate
  let g:vim_tags_auto_generate = 0

  " Syntastic syntax checker
  let g:syntastic_python_checkers = ['pyflakes']
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0
  " python line length
  let g:syntastic_python_flake8_post_args="--max-line-length=120"
  " R syntax checking
  let g:syntastic_enable_r_lintr_checker = 1
  let g:syntastic_r_checkers = ['lintr']
  " Turn off Syntastic when startup
  let g:syntastic_mode_map={"mode": "passive"}
  
  " vim-slime to tmux
  let g:slime_target = "tmux"
  let g:slime_python_ipython = 1
  
  " disable assignment operator of _ to <- in NvimR
  let R_assign = 0
  
  " buftabline customizations --------
  " shows tab numbers
  let g:buftabline_numbers = 1
  " show unsaved states
  let g:buftabline_indicators = 1
  " show separator
  let g:buftabline_separators = 1
  
  " lightline configuration ------
  let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [['mode', 'paste'],
      \              ['fugitive', 'filename', 'modified']]
      \           },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \}
" }}}

" custom functions {{{
  " strips trailing whitespace at the end of files. this
  " is called on buffer write in the autogroup above.
  function! StripTrailingWhitespaces()
      " save last search & cursor position
      let _s=@/
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      let @/=_s
      call cursor(l, c)
  endfunction
  
  "Delete all hidden buffers
  function DeleteHiddenBuffers()
      let tpbl=[]
      call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
      for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
          silent execute 'bwipeout' buf
      endfor
  endfunction

" }}}

" autogroups {{{
  " language specific settings
  augroup configgroup
      autocmd!
      autocmd VimEnter * highlight clear SignColumn
      autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md call StripTrailingWhitespaces()
      autocmd FileType java setlocal noexpandtab
      autocmd FileType java setlocal list
      autocmd FileType java setlocal listchars=tab:+\ ,eol:-
      autocmd FileType java setlocal formatprg=par\ -w80\ -T4
      autocmd FileType php setlocal expandtab
      autocmd FileType php setlocal list
      autocmd FileType php setlocal listchars=tab:+\ ,eol:-
      autocmd FileType php setlocal formatprg=par\ -w80\ -T4
      autocmd FileType ruby setlocal tabstop=2
      autocmd FileType ruby setlocal shiftwidth=2
      autocmd FileType ruby setlocal softtabstop=2
      autocmd FileType ruby setlocal commentstring=#\ %s
      autocmd FileType python setlocal commentstring=#\ %s
      autocmd BufEnter *.cls setlocal filetype=java
      autocmd BufEnter *.zsh-theme setlocal filetype=zsh
      autocmd BufEnter Makefile setlocal noexpandtab
      autocmd BufEnter *.sh setlocal tabstop=2
      autocmd BufEnter *.sh setlocal shiftwidth=2
      autocmd BufEnter *.sh setlocal softtabstop=2
  augroup END

  " Persistent folds between sessions
  augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* loadview
  augroup END
" }}}

" non-leader key mappings {{{
  " Syntastic Toggle On Off
  nnoremap <silent> <F5> :SyntasticToggleMode<CR>
  
  " tagbar
  nmap <F8> :TagbarToggle<CR>

  " build ctags
  map <f10> :TagsGenerate!<cr>
  
  " Split navigation
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>
  
  " Move down row-wise (instead of line-wise)
  " Helpful for long, wrapped lines
  :nmap j gj
  :nmap k gk
  
  " write over read-only file with :sudow
  cnoremap sudow w !sudo tee % >/dev/null
  
  " Ctrl N, ctrl-P for next and previous buffer
  nnoremap <C-N> :bnext<CR>
  nnoremap <C-P> :bprev<CR>
" }}}

" Set default fold for this file
" vim: foldmethod=marker:foldlevel=0
