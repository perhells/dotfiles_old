#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

whatthecommit(){
  curl -s http://whatthecommit.com/ | tr -s '\n' ' ' \
    | grep -so 'p>\(.*\)</p' | sed -n 's/..\(.*\)..../\1/p' | sed -e 's/<[^>]*>//g' | sed -e 's/\[[^>]*\]//g';
}
gm(){
    git commit -a -m "`whatthecommit`" && git push;
}

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
