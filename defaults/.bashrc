#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Load and execute custom profiles
if [ -d ~/.profile ] ; then
    if [ -f ~/.profile/bashprofile ] ; then
        source ~/.profile/bashprofile
    fi
fi
