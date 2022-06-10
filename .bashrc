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
shopt -s autocd

# export PS1="[\$?] \h.\u: \W \$ "
# PS1="\[\033[00m\]\A [\$?] \[\033[36m\]\u\[\033[00m\]: \w $ "

# enclosed colors in \[ ... \] because as non printing characters
# they messed up history browsing
export PS1="[\$?] ${BLUE}\h${RESTORE}.${GREEN}\u${RESTORE}: ${YELLOW}\W ${RESTORE}\$ "
#export PS1="[\$?] \[${BLUE}\]\h\[${RESTORE}\].\[${GREEN}\]\u: \[${YELLOW}\]\W \[${RESTORE}\]\$ "
#export PS1="[\$?] \[${GREEN}\]\u: \[${YELLOW}\]\W \[${RESTORE}\]\$ "

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
