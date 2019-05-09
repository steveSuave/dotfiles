# Auto completion
autoload -Uz compinit
compinit

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd hist_ignore_all_dups hist_ignore_space extended_glob
