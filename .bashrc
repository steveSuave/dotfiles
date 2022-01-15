. ~/.bin/alif
. ~/.bin/color-variables

[[ "$TERM_PROGRAM" == "iTerm.app" ]] && export LSCOLORS="Hxfxcxdxbxegedabagacad"

if [[ "dumb" == "$TERM" ]]; then
    alias less='cat'
    alias more='cat'
    export PAGER=cat
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.bin:" ]]
then
    PATH="$HOME/.bin:$PATH"
fi
export PATH

export EDITOR=vi
export GIT_EDITOR=$EDITOR
export HISTIGNORE="[ ]*:ls"
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=200000
export HISTSIZE=200000
shopt -s histappend

export PS1="[\$?] \h.\u: \W \$ "
# PS1="\[\033[00m\]\A [\$?] \[\033[36m\]\u\[\033[00m\]: \w $ "

# export PS1="[\$?] ${BLUE}\h${RESTORE}.${GREEN}\u${RESTORE}: ${YELLOW}\W ${RESTORE}\$ "

