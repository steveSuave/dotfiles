source ~/.bin/alif

umask 027

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-/]=** r:|=**'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename "~/.zshrc"

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob notify correct 
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
setopt promptsubst

RPROMPT=%T
autoload -U colors && colors
# (return status) host.user
status_host_user="(%?) %{$fg[blue]%}%m%{$reset_color%}.%{$fg[green]%}%n%{$reset_color%}"
PROMPT="$status_host_user: %1~ %# "

# accomodate when paths are important and long
thePrompt=1
chprmt() {
    if (( thePrompt == 1 )); then
        precmd()  { print "" }
        preexec() { print "" }
        PROMPT=$'%/\n${status_host_user} %# '
        thePrompt=2
    elif ((thePrompt == 2 )); then
        precmd() {}
        preexec() {}
        PROMPT="$status_host_user: %1~ %# "
        thePrompt=1
    fi
}
