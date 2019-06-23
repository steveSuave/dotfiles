set nu

set tabstop=4 shiftwidth=4
set autoindent
set nocompatible

syntax enable

filetype plugin on

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
