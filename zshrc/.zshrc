# Interactive shell config. Environment variables and PATH live in ~/.zshenv.

# ---------------- History ----------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

# ---------------- Completion ----------------
autoload -Uz compinit
compinit

# ---------------- Keybinds ----------------
# Vi mode first: it resets the keymap, so other binds must come after it.
bindkey -v

# ctrl+left/right jump by word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# ctrl+backspace deletes previous word
bindkey '^H' backward-kill-word

# up/down search history for lines starting with what's typed
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# ---------------- Aliases ----------------
# editors
alias vim='nvim'
alias vi='nvim'
alias hc='vim ~/.config/flavours/templates/hyprland/templates/default.mustache'

# coreutils replacements
alias cat='bat'
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'

# git
alias gcm='git commit -m'

# apps and scripts
alias spotify='spotify_player'
alias paint='pinta'
alias invoice='~/projects/go/bin/invoice'
alias gdtouch='~/.dotfiles/scripts/gdtouch.zsh'
alias screenrecord='wf-recorder -g "$(slurp)" -f "$HOME/captures/videos/$(date +%Y%m%d_%H%M%S).mp4"'

# ---------------- Tools ----------------
eval "$(starship init zsh)"

# zoxide replaces cd
eval "$(zoxide init --cmd cd zsh)"

# fzf: use fd for file lists, bat/eza for previews
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ** completion for paths and directories
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

eval "$(fzf --zsh)"
source ~/.dotfiles/scripts/fzf-git.sh/fzf-git.sh
