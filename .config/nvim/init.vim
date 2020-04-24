if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
  endif
  call dein#add('preservim/nerdtree')
  call dein#add('kaicataldo/material.vim')
  "call dein#add("vim-pandoc/vim-pandoc")
  "call dein#add("vim-pandoc/vim-pandoc-syntax")
  call dein#add("godlygeek/tabular")
  call dein#add("plasticboy/vim-markdown")
  call dein#add("kien/ctrlp.vim")
  
  call dein#end()
  call dein#save_state()
endif
"if (has('termguicolors'))
"  set termguicolors
"endif
let g:ctrlp_show_hidden = 1
colorscheme material
filetype plugin indent on
syntax enable
set nu
set rnu
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
autocmd Filetype rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<enter>
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
map <C-k> :NERDTreeToggle<CR>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
set tabstop=4
set expandtab
set shiftwidth=4
