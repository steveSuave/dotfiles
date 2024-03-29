date

. ~/.bashrc

# MacPorts Installer adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# set path for Racket
export PATH="$PATH:/Applications/Racket v7.7/bin"

# set path for java etc.
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk11/Contents/Home
export M2_HOME=~/Applications/apache-maven-3.6.1
export PATH="${PATH}:${M2_HOME}/bin"

# set path for mysql
export PATH="$PATH:/usr/local/mysql/bin"

# set path for my stuff
export PATH="$PATH:~/.bin"

export PATH="$(go env GOPATH)/bin:$PATH"

# if [[ "$TERM_PROGRAM" != 'vscode' ]]; then
#     karoto&
# fi

