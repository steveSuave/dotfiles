date

# Show previous command's exit status at prompt
export PS1="[\$?] $PS1"

alias ls="ls -F"
alias rm="rm -i"

# see helpful examples of command usage and more
function cht {
	curl https://cheat.sh/$1
}

export PATH="$PATH:~/bin"



# Setting PATH for Python 3.4
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"

# MacPorts Installer: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/
export ANT_HOME=/opt/apache-ant-1.10.5

export PATH=$PATH:/usr/local/mysql/bin/