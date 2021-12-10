cnt=$(w -h | grep "^$(whoami) *s[^ ]* *-"|wc -l)
if [ $cnt -eq 1 ]; then
    x=$(pgrep -f karoto)
    [[ $(ps -ef) == *$x* ]] &&
	echo "quitting karoto" && kill $x ||
	    echo "karoto not running"
else
    echo "there are terminals running..."
fi
