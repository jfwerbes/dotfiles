# Lines configured by zsh-newuser-install
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/brutus/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Start ssh-agent and add key, silence add output
 ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

# history setup for autocompletion
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# Start starship and zoxide, macro cd to zoxide
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# fix ctrl jump for words
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Aliases
alias hc='vim ~/.config/hypr/hyprland.conf'
alias vim='nvim'
alias gdtouch='~/.dotfiles/scripts/gdtouch.zsh'
alias spotify='spotify_player'

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
