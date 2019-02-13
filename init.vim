set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" =====================================
" Plugins
" =====================================
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/deoplete.nvim'
Plugin 'SirVer/ultisnips'
Plugin 'vim-airline/vim-airline'
Plugin 'arakashic/chromatica.nvim'
Plugin 'majutsushi/tagbar'
Plugin 'autozimu/LanguageClient-neovim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Load other config files
source $HOME/.config/nvim/config/python.nvim
source $HOME/.config/nvim/config/chromatica.nvim
source $HOME/.config/nvim/config/langserver.nvim

syntax on

" =====================================
" Mappings
" =====================================
" change the leader key from "\" to ";" ("," is also popular)
let mapleader=";"

" tab config
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

" use ;; for escape
" http://vim.wikia.com/wiki/Avoid_the_escape_key
inoremap ;; <Esc>

nnoremap <silent> <Space> :NERDTreeToggle<CR>

" toggle tagbar
nnoremap <silent> <leader>tb :TagbarToggle<CR>

" toggle line numbers
nnoremap <silent> <leader>n :set number! number?<CR>

" toggle line wrap
nnoremap <silent> <leader>w :set wrap! wrap?<CR>

nnoremap <silent> <leader>h :call ToggleHiddenAll()<CR>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <C-n> :NERDTreeToggle<CR>

" Disable arrow keys:
nnoremap <up> 		<nop>
nnoremap <down>		<nop>
nnoremap <left>		<nop>
nnoremap <right>	<nop>

inoremap <up>		<nop>
inoremap <down>		<nop>
inoremap <left>		<nop>
inoremap <right>	<nop>

" =====================================
" =====================================
function! Dark()
    echom "set bg=dark"
    set bg=dark
    colorscheme hybrid_reverse
endfunction

silent call Dark()

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
	TagbarClose
	NERDTreeClose
        set foldcolumn=10
    else
	set foldcolumn=0
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2 
        set showcmd
	NERDTree
	" NERDTree takes focus, so move focus back to the right
	" (note: "l" is lowercase L (mapped to moving right)
	wincmd l
	TagbarOpen

    endif
endfunction

" =====================================
" Variables
" =====================================
let g:airline_theme='hybrid'

" lang server
let g:LangaugeClient_autoStart = 1
let g:LanguageClient_settingsPath = $HOME.'/.config/nvim/settings.json'
"let g:LanguageClient_loadSettings = 1
let g:LanguageClient_logginLevel = 'DEBUG'
let g:LanguageClient_serverCommands = {
	\ 'cpp': ['/Users/normanziebal/cquery/build/release/bin/cquery', '--log-file=/tmp/cq.log'],
	\ 'python': ['pyls', '-v'],
\ }

" deoplete options
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" disable autocomplete by default
" let b:deoplete_disable_auto_complete=1 
" let g:deoplete_disable_auto_complete=1
" call deoplete#custom#buffer_option('auto_complete', v:false)

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:UltiSnipsUsePythonVersion = 3
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/nvim/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

let g:enable_bold_font = 1
let g:enable_italic_font = 1

let g:ale_completion_enabled = 1

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" =====================================
" Test
" =====================================
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

"imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>(expand_or_cr)" : "\<CR>")
"imap <expr> <Plug>(expand_or_cr) (cm#completed_is_snippet() ? "\<C-U>" : "\<CR>")
"let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
"inoremap <silent> <C-U> <C-R>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<CR>
"let g:UltiSnipsJumpForwardTrigger = "<C-J>"
"let g:UltiSnipsJumpBackwardTrigger = "<C-K>"
