"Dr. Roche's vimrc
"feel free to edit!

"light background, lots of colors
set background=light
set t_Co=256

" turn syntax highlighting on
syntax enable
filetype plugin indent on

"settings for all files
set mouse=nv
set autoindent
set showmatch
set expandtab
set softtabstop=2
set shiftwidth=2
set modeline
set tw=80
set shiftround
set scrolloff=7
set whichwrap=<,>,h,l

set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*

"settings for specific filetypes
autocmd FileType make setlocal noexpandtab softtabstop=0
autocmd FileType text setlocal spell linebreak textwidth=72
autocmd FileType markdown setlocal spell linebreak textwidth=72 softtabstop=4 shiftwidth=4
autocmd Filetype python setlocal softtabstop=4 shiftwidth=4
autocmd Filetype php setlocal nocindent nosmartindent indentexpr="" 
autocmd Filetype php setlocal autoindent
autocmd Filetype tex setlocal nocindent nosmartindent indentexpr="" 
autocmd Filetype tex setlocal autoindent spell linebreak textwidth=72

"underline misspellings in text files
highlight clear SpellBad
highlight SpellBad ctermfg=1 cterm=underline
highlight clear SpellCap
highlight SpellCap ctermfg=4 cterm=underline

" F2 toggles paste mode
set pastetoggle=<F2>
" F8 turns off smart indenting in an emergency
:nnoremap <F8> :setl nocin nosi inde=<CR>
" F9 toggles spell checking
nnoremap <F9> :setlocal spell!<CR>
