[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
setxkbmap -layout gb &&
setxkbmap -option caps:escape &
exec i3
