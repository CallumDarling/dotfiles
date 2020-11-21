[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
setxkbmap -layout gb &&
setxkbmap -option caps:escape &
xmodmap -e "keysym ISO_Level3_Shift  = Hyper_L" &
xmodmap -e "remove Mod5 = Hyper_L" -e "add Mod3 = Hyper_L" &
exec i3
