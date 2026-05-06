#!/usr/bin/env bash
set -euo pipefail

# Update system
sudo pacman -Syu --noconfirm

# ---- repo packages ----
REPO_PKGS=(
  astroterm
  base
  base-devel
  bat
  bluez
  bluez-utils
  cava
  check
  chromium
  clang
  cmake
  discord
  dkms
  docker
  docker-buildx
  dunst
  efibootmgr
  eza
  fastfetch
  fd
  fzf
  gimp
  git
  git-delta
  git-filter-repo
  graphviz
  greetd-tuigreet
  grim
  hyprland
  hyprlock
  hyprpaper
  hyprshot
  i2c-tools
  intel-ucode
  iptables
  iwd
  jq
  kitty
  lazygit
  less
  libva-nvidia-driver
  linux
  linux-firmware
  linux-headers
  mandoc
  metronome
  mgba-qt
  most
  nano
  neovim
  nodejs
  npm
  nvidia-open-dkms
  nwg-look
  openrgb
  openssh
  otf-font-awesome
  pastel
  pavucontrol
  pipewire-alsa
  pipewire-pulse
  polkit-kde-agent
  poketex
  postgresql
  pyright
  python-black
  python-pip
  qt5-wayland
  qt6-wayland
  ripgrep
  ruby
  slurp
  smartmontools
  solaar
  speedtest-cli
  spotify-player
  starship
  stow
  sxiv
  ttf-anonymouspro-nerd
  ttf-cascadia-code-nerd
  unzip
  uwsm
  vim
  vimix-cursors
  waybar
  webkit2gtk-4.1
  wf-recorder
  wget
  wireless_tools
  wireplumber
  wofi
  wpa_supplicant
  xdg-desktop-portal-hyprland
  xdg-utils
  xorg-server
  xorg-xinit
  xournalpp
  yazi
  zip
  zoxide
  zram-generator
  zsh
)

sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}"

# ---- yay bootstrap (only if missing) ----
if ! command -v yay >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

# ---- AUR packages ----
AUR_PKGS=(
  aseprite
  aseprite-debug
  bashmount
  bibata-cursor-theme
  catppuccin-gtk-theme-mocha
  eontimer-bin
  flavours
  flavours-debug
  gruvbox-dark-gtk
  opentabletdriver
  pinta
  pokefinder
  pokefinder-debug
  python-clickgen
  python-docopt-ng
  python-gdtoolkit
  python-libsass
  python-mando
  python-qtsass
  python-radon
  python-rst2ansi
  slack-desktop
  vesktop-debug
  xp-pen-tablet-debug
  yay
  yay-debug
  zen-browser-bin
  zoom
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "Done."
