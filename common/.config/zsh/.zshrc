# PATHS
typeset -U path            # drop duplicate PATH entries
path=(
  $HOME/.local/bin
  $HOME/go/bin
  $HOME/.cargo/bin
  $path
)

# Aliases
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source "$ZDOTDIR/aliases.zsh"

# History
mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Shell Behavior
setopt AUTOCD
setopt NUMERIC_GLOB_SORT
setopt dot_glob
setopt extended_glob

# Completion
mkdir -p "$XDG_CACHE_HOME/zsh"
zmodload -i zsh/complist
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Completion Options
zstyle ':completion:*' menu select

# fzf key bindings and fuzzy completion
command -v fzf >/dev/null && source <(fzf --zsh)

# Prompt (oh-my-posh)
if command -v oh-my-posh >/dev/null; then
  if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(oh-my-posh init zsh --config "$HOMEBREW_PREFIX/opt/oh-my-posh/themes/gruvbox.omp.json")"
  else
    eval "$(oh-my-posh init zsh --config "$XDG_CONFIG_HOME/ohmyposh/pararussel-revised.json")"
  fi
fi

# ls
if [[ "$OSTYPE" == darwin* ]]; then
  # macOS ls has no --hyperlink; use GNU ls from `brew install coreutils` if present
  if command -v gls >/dev/null; then
    alias ls='gls --hyperlink=auto --color=auto'
  else
    alias ls='ls -G'
  fi
else
  alias ls='ls --hyperlink=auto --color=auto'
fi

# Terminal-specific
# kitty (Fedora) / Ghostty (macOS)
