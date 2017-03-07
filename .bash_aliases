alias p='p1 ; p2 ; p3 ; p4 ; p5 ; p6 ; p7 ; p8 ; p9 ; p0'
alias ..='cd ..'
alias ls='ls -lh --color'
alias ssh-kth='ssh perhells@u-shell.csc.kth.se'
alias sftp-kth='sftp perhells@u-shell.csc.kth.se'
alias ssh-rpi='ssh per@maltlager.gysingebryggeri.se'
alias sftp-rpi='sftp per@maltlager.gysingebryggeri.se'
alias pong='ping 8.8.8.8 -c 3'
alias reloadaliases='. ~/.bash_aliases'
alias wow='git status'
alias such='git'
alias very='git'
alias many='git'
alias much='git'
alias so='git'
alias editaliases='vim ~/.bash_aliases && . ~/.bash_aliases'
alias grep='grep --color=auto'
alias top='atop'
alias mkdir='mkdir -pv'
alias usb-serial='sudo screen /dev/ttyUSB0 115200'
alias yaaas='yes yaaas'
alias network='sudo systemctl start NetworkManager'
alias visudo='sudo visudo'

for x in 0 1 2 3 4 5 6 7 8 9
do
    alias s$x='pwd > ~/.savedfolder'$x
    alias l$x='cd $(cat ~/.savedfolder'$x' 2> /dev/null) && pwd'
    alias p$x='check_folder '$x
    alias r$x='rm ~/.savedfolder'$x
done

alias ra='for x in 0 1 2 3 4 5 6 7 8 9; do rm ~/.savedfolder$x 2> /dev/null; done'

check_folder() {
    folder='~/.savedfolder'$1
    echo Saved folder $1 is: $(cat ~/.savedfolder$1 2> /dev/null)
}
