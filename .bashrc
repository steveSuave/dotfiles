. ~/.bin/alif
. ~/.bin/color-variables

[[ "$TERM_PROGRAM" == "iTerm.app" ]] && export LSCOLORS="Hxfxcxdxbxegedabagacad"

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.bin:" ]]
then
    PATH="$HOME/.bin:$PATH"
fi
export PATH

PS1="[\$?] \h.\u: \W \$ "
# PS1="\[\033[00m\]\A [\$?] \[\033[36m\]\u\[\033[00m\]: \w $ " 

# enclosed colors in \[ ... \] because as non printing characters
# they messed up history browsing
# export PS1="[\$?] \[${GREEN}\]\u: \[${YELLOW}\]\W \[${RESTORE}\]\$ "
