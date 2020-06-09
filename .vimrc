set nocompatible
set number
set tabstop=4 shiftwidth=4
set expandtab
set autoindent
set noerrorbells
set colorcolumn=100
highlight ColorColumn ctermbg=235 guibg=#2c2d27

syntax enable
filetype plugin on

"scheme quick run
map <F4> :w !scheme <CR>
"python quick run
map <F5> :w !python3 <CR>
"go quick run
map <F6> :!go run % <CR>

"insert line break at cursor point
map <c-k> <esc>i<cr><esc>

"set path+=**
"set wildmenu

"display all matching files when we tab complete
"hit tab to :find by partial match
"use * to make it fuzzy
":b lets you autocomplete

command! MakeTags !ctags -R .

"now we can:
"use ^] to jump to tag under cursor
"use g^] for ambiguous tags
"use ^t to jump back up the tag stack

