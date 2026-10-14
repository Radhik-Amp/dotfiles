#!/usr/bin/env bash
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
filepath="$dir/$(date +%Y%m%d%H%M%S).png"

case "${1:-fullscreen}" in
  region)
    g=$(slurp -d) || exit 1
    grim -g "$g" "$filepath" ;;
  window)
    g=$(mmsg get focusing-client | jq -r 'select(.width != null) | "\(.x),\(.y) \(.width)x\(.height)"')
    [[ -n $g ]] || exit 1
    grim -g "$g" "$filepath" ;;
  *)
    grim "$filepath" ;;
esac

[[ -s $filepath ]] || exit 1
wl-copy < "$filepath"

satty --filename "$filepath" --output-filename "$filepath" \
      --copy-command wl-copy \
      --actions-on-enter save-to-clipboard,save-to-file \
      --early-exit
