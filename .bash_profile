date

# Show previous command's exit status at prompt
export PS1="(\$?) \u: \W \$ "

alias ls="ls -GFh"
alias rmi="rm -i"
alias rmt="rmtrash"
alias grep='grep --color=auto'
alias py=python3
alias ducks='du -cks * | sort -rn | head' #largest dirs or files from current dir"

abyss=/dev/null

alias updlct='sudo /usr/libexec/locate.updatedb'
alias mysql.start="sudo /usr/local/mysql/support-files/mysql.server start"
alias mysql.stop="sudo /usr/local/mysql/support-files/mysql.server stop"
alias mysql.restart="sudo /usr/local/mysql/support-files/mysql.server restart"
alias mysql.status="sudo /usr/local/mysql/support-files/mysql.server status"

run() {
	open -a "$1"
	# mac specific
}

quit() {
	pkill -Ili "$1" 
	# a little aggresive, in a mac could use applescript
	# osascript -e "quit app \"$1\""
}

cl() {
	cd "$1" || exit 
	ls -althFG
}

# see helpful examples of command usage and more
cht() {
	curl https://cht.sh/"$*"
}

check() {
	pgrep -f "$1"
}

# Merges, or joins multiple PDF files into "joined.pdf"
joinpdf () {
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=joined.pdf "$@"
}

export PATH="$PATH:~/bin"

export HISTCONTROL=ignoredups
export HISTSIZE=1000

#############################

# Setting PATH for Python 3.4
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"

# MacPorts Installer: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/

export PATH=$PATH:/usr/local/mysql/bin/
