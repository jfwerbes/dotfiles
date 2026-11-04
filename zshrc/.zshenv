# Environment for every zsh: interactive, login and scripts.
# Keep this file to exports only; no output, no slow commands.

export EDITOR=nvim

# ssh-agent runs as the systemd user unit ssh-agent.socket.
# environment.d sets this for the session; this is a fallback for shells that didn't inherit it.
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$XDG_RUNTIME_DIR/ssh-agent.socket}"

# Earlier entries win. typeset -U drops duplicates when nested shells re-run this.
typeset -U path
path=(
  $HOME/.local/share/gem/ruby/3.4.0/bin
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.npm-global/bin
  $path
)
export PATH
