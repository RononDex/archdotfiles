#!/bin/bash
se() { find ~/.scripts ~/.config -type f | fzf | xargs -r $EDITOR; }
