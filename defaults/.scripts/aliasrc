#!/bin/bash
. ~/.scripts/gitalias.sh

se() { find ~/.scripts ~/.config -type f | fzf | xargs -r $EDITOR; }

# marker templete select
_fzf_marker_main_widget() {
  if echo "$BUFFER" | grep -q -P "{{"; then
    _fzf_marker_placeholder
  else
    local selected
    if selected=$(cat ${FZF_MARKER_CONF_DIR:-~/.config/marker}/*.txt |
      sed -e "s/\(^[a-zA-Z0-9_-]\+\)\s/${FZF_MARKER_COMMAND_COLOR:-\x1b[38;5;255m}\1\x1b[0m /" \
          -e "s/\s*\(#\+\)\(.*\)/${FZF_MARKER_COMMENT_COLOR:-\x1b[38;5;8m}  \1\2\x1b[0m/" |
      fzf --bind 'tab:down,btab:up' --height=80% --ansi -q "$LBUFFER"); then
      LBUFFER=$(echo $selected | sed 's/\s*#.*//')
    fi
    zle redisplay
  fi
}

_fzf_marker_placeholder() {
  local strp pos placeholder
  strp=$(echo $BUFFER | grep -Z -P -b -o "\{\{[\w]+\}\}")
  strp=$(echo "$strp" | head -1)
  pos=$(echo $strp | cut -d ":" -f1)
  placeholder=$(echo $strp | cut -d ":" -f2)
  if [[ -n "$1" ]]; then
    BUFFER=$(echo $BUFFER | sed -e "s/{{//" -e "s/}}//")
    CURSOR=$(($pos + ${#placeholder} - 4))
  else
    BUFFER=$(echo $BUFFER | sed "s/$placeholder//")
    CURSOR=pos
  fi
}

_fzf_marker_placeholder_widget() { _fzf_marker_placeholder "defval" }

zle -N _fzf_marker_main_widget
zle -N _fzf_marker_placeholder_widget
bindkey "${FZF_MARKER_MAIN_KEY:-\C-h}" _fzf_marker_main_widget
bindkey "${FZF_MARKER_PLACEHOLDER_KEY:-\C-v}" _fzf_marker_placeholder_widget

alias vim=nvim
