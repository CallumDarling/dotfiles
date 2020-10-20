# dotfiles
Dotfiles for my Arch Linux (btw) installation

if for some reason you wanted your system to be like mine

Installation
======
```shell
git clone https://github.com/callumdarling/dotfiles
git clone --bare https://github.com/callumdarling/dotfiles ~/.dotfiles
source dotfiles/.bashrc
rm -rf dotfiles
dotfiles checkout -f
```
* to update:
```shell
dotfiles pull
dotfiles checkout -f
```

