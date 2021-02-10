syntax on

set hidden
set autoindent
set autowrite
set number
set norelativenumber
" set ruler
set showmode
set noerrorbells
set tabstop=2 
set softtabstop=2
set shiftwidth=2
set smarttab
set smartindent
set nofixendofline
set expandtab
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set hlsearch
set linebreak
set textwidth=72
set ttyfast
set history=100

" Install vim-plug if not already installed
" (Yes I know about Vim 8 Plugins. They suck.)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  echo "Don't forget to GoInstallBinaries if you're doing Go dev."
endif

call plug#begin('~/.vim/plugged')
" Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/fern-mapping-mark-children.vim'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'vim-pandoc/vim-pandoc'
Plug 'https://gitlab.com/rwxrob/vim-pandoc-syntax-simple'
Plug 'https://gitlab.com/rwx.gg/abnf'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
Plug 'cespare/vim-toml'
Plug 'PProvost/vim-ps1'
Plug 'morhetz/gruvbox' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

colorscheme gruvbox
let g:lightline = {
  \ 'colorscheme': 'gruvbox'
  \ }
hi Normal ctermbg=NONE " for transparent background
hi SpellBad ctermbg=red " for transparent background
hi SpellRare ctermbg=red
hi Special ctermfg=cyan 
let g:airline_theme='gruvbox'
set background=dark
set cmdheight=2
" set rulerformat=%55(%f\ %y%r\ %l:%c\ %p%%%) "55 effective max
let mapleader=" "
map Y y$
noremap <up> :echoerr "Umm, use k instead"<CR>
noremap <down> :echoerr "Umm, use j instead"<CR>
noremap <left> :echoerr "Umm, use h instead"<CR>
noremap <right> :echoerr "Umm, use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>
inoremap jj <Esc>
cnoremap jj <Esc>
inoremap kk <Esc>
cnoremap kk <Esc>
inoremap kj <Esc>
cnoremap kj <Esc>

" golang
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_fail_silently = 0
let g:go_fmt_command = 'goimports'
let g:go_fmt_autosave = 1
let g:go_gopls_enabled = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_metalinter_command='golangci-lint'
let g:go_metalinter_command='golint'
let g:go_metalinter_autosave=1
set updatetime=100
let g:go_gopls_analyses = { 'composites' : v:false }
au FileType go nmap<leader>r :GoRun!<CR>
au FileType go nmap<leader>t :GoTest!<CR>
au FileType go nmap<leader>v :GoVet!<CR>
au FileType go nmap<leader>b :GoBuild!<CR>
au FileType go nmap <leader>c :GoCoverageToggle<CR>
au FileType go nmap <leader>i :GoInfo<CR>
au FileType go nmap <leader>l :GoMetaLinter!<CR>

" CoC
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-angular', 'coc-tslint']
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" c space to trigger coc 
noremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Customize fzf colors to match your color scheme.
let g:fzf_colors =
 \ { 'fg':      ['fg', 'Normal'],
 \ 'bg':      ['bg', 'Normal'],
 \ 'hl':      ['fg', 'Comment'],
 \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
 \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
 \ 'hl+':     ['fg', 'Statement'],
 \ 'info':    ['fg', 'PreProc'],
 \ 'prompt':  ['fg', 'Conditional'],
 \ 'pointer': ['fg', 'Exception'],
 \ 'marker':  ['fg', 'Keyword'],
 \ 'spinner': ['fg', 'Label'],
 \ 'header':  ['fg', 'Comment'] }

let g:fzf_action = {
 \ 'ctrl-t': 'tab split',
 \ 'ctrl-b': 'split',
 \ 'ctrl-v': 'vsplit',
 \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

" Launch fzf with CTRL+P.
nnoremap <silent><C-p> :FZF -m<CR>

" Map a few common things to do with FZF.
"nnoremap <silent><Leader><Enter>:Buffers<CR>
nnoremap <silent><Leader><Enter> :Buffers<CR>
nnoremap <silent><Leader>l :Lines<CR>

" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* Rg
 \ call fzf#vim#grep(
 \ "rg --column --line-number --no-heading --color=always --smart-case " .
 \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)

