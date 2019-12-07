set nocompatible
set nu
set tabstop=4 shiftwidth=4
set expandtab
set autoindent

syntax enable
filetype plugin on

"scheme quick run
map <F4> :w !scheme <CR>
"python save and run
autocmd FileType python nnoremap <buffer> <F5> <Esc>:w<CR>:exec '!clear; python3' shellescape(@%, 1)<cr>
"insert line break at cursor point
map <c-b> <esc>i<cr><esc>

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
"things to consider:
"this doesn't help if you want a visual list of tags
