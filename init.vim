set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
call vundle#begin('~/.config/nvim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'w0rp/ale'
Plugin 'SirVer/ultisnips'
Plugin 'vim-airline/vim-airline'
Plugin 'arakashic/chromatica.nvim'
Plugin 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" python path
let g:python3_host_prog = '/usr/local/bin/python3.6'
let g:python_host_prog = '/usr/local/bin/python2.7'

" lang server
let g:LanguageClient_serverCommands = {
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

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" set sources
let g:deoplete#sources = {}
let g:deoplete#sources.cpp = ['LanguageClient']
let g:deoplete#sources.python = ['LanguageClient']
let g:deoplete#sources.python3 = ['LanguageClient']
let g:deoplete#sources.rust = ['LanguageClient']
let g:deoplete#sources.c = ['LanguageClient']
let g:deoplete#sources.vim = ['vim']

" deoplete-racer config
let g:deoplete#sources#rust#racer_binary='/Users/aenayet/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path= '/Users/aenayet/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'

" deoplete end

let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/nvim/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:chromatica#enable_at_startup = 1
let g:chromatica#libclang_path = '/usr/local/opt/llvm/lib'

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <C-n> :NERDTreeToggle<CR>
