date

# Show previous command's exit status at prompt
export PS1="[\$?] \u: \W \$ "

alias ls="ls -GFh"
alias rm="rm -i"
alias py=python3

abyss=/dev/null

updlct=/usr/libexec/locate.updatedb #sudo

#start | stop | restart
db=/usr/local/mysql-8.0.15-macos10.14-x86_64/support-files/mysql.server 

function run {
	open /Applications/${1}.app
}

function quit {
	pkill -Ili $1 
	#a little aggresive, in a mac could use applescript
	#osascript -e "quit app \"$1\""
}

function cl {
	cd "$1"
	ls -haltFG
}

# see helpful examples of command usage and more
function cht {
	curl https://cht.sh/$1 $2 $3
}

export PATH="$PATH:~/bin"

export HISTCONTROL=ignoredups
export HISTSIZE=1000


# Setting PATH for Python 3.4
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"

# MacPorts Installer: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/

export PATH=$PATH:/usr/local/mysql/bin/
