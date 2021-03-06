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
  call dein#add("ferrine/md-img-paste.vim")
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
set tabstop=4
set expandtab
set shiftwidth=4

"autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup markdown_syntax
    au! BufNewFile,BufFilePre,BufRead *.rmd set filetype=markdown
augroup END
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
map <C-k> :NERDTreeToggle<CR>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>


" RMD Shortcuts
autocmd Filetype rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<enter>
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
autocmd FileType rmd inoremap ;box \noindent\fbox{\begin{minipage}{\textwidth}<enter><enter><enter><enter>\end{minipage}}<Up><Up>
autocmd FileType rmd inoremap ;sig {\Sigma}
autocmd FileType rmd inoremap ;vep {\varepsilon}
autocmd FileType rmd inoremap ;ep {\epsilon}
autocmd FileType rmd inoremap ;del {\delta}
autocmd FileType rmd inoremap ;del {\delta}
autocmd FileType rmd inoremap ;; $$<Left>
autocmd FileType rmd inoremap ;ems {\emptyset}
autocmd FileType rmd inoremap ;ra {\xrightarrow{}}<Left><Left>
autocmd FileType rmd inoremap ;Ra {\Rightarrow^{}}<Left><Left>
autocmd FileType rmd inoremap ;bu {\bullet}
autocmd FileType rmd inoremap ;ems {\emptyset}
