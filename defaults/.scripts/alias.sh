#!/bin/bash
. ~/.scripts/gitalias.sh

se() { find ~/.scripts ~/.config -type f | fzf | xargs -r $EDITOR; }

alias vim=nvim
