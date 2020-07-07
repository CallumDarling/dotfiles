#
#l ~/.bashrc
#

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
shopt -s autocd
set -o vi
export PS1="[\[$(tput sgr0)\]\[\033[38;5;29m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;29m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]] \W:>\[$(tput sgr0)\]"]
alias c="code"
alias v="nvim"
alias s='sudo $(history -p !!)'
alias sbb='sudo "$BASH" -c "$(history -p !!)"'
alias ls="ls -hN --color=auto --group-directories-first"
alias dotfiles='/usr/bin/git --git-dir=/home/callum/.dotfiles/ --work-tree=/home/callum'
alias lock="i3lock-fancy -p"
alias r="ranger"

