#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# All default aliases
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/alias.sh ]; then
        source ~/.scripts/alias.sh
    fi
fi

# Alias for system update
if [ -d ~/.scripts ]; then
    if [ -f ~/.scripts/setProfileUpdateAlias.sh ]; then
        source ~/.scripts/setProfileUpdateAlias.sh
    fi
fi

# Load and execute custom profiles
if [ -d ~/.profile ]; then
    if [ -f ~/.profile/bashprofile ]; then
        source ~/.profile/bashprofile
    fi
fi
