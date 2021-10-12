[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
feh --bg-scale ~/Downloads/deskPicture.jpg
exec i3
