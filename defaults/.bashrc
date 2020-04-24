#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# All default aliases
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/aliasrc ]; then
        source ~/.scripts/aliasrc
    fi
fi

# Alias for system update
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/setProfileUpdateAlias.sh ]; then
        source ~/.scripts/setProfileUpdateAlias.sh
    fi
fi

# Load and execute custom profiles
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/bashprofile ]; then
        source ~/.scripts/bashprofile
    fi
fi

source ~/.profile
