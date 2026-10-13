#PATHS
export PATH="$HOME/.cargo/bin:$PATH"   
export PATH="$HOME/go/bin:$PATH"

# Aliases
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

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
zmodload -i zsh/complist
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Completion Options
zstyle ':completion:*' menu select


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Prompt configuration using oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/pararussel-revised.json)"
