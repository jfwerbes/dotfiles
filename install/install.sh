#!/usr/bin/env bash
set -euo pipefail

# Update system
sudo pacman -Syu --noconfirm

# ---- repo packages ----
REPO_PKGS=(
  base
  base-devel
  bat
  bluez
  bluez-utils
  check
  clang
  cmake
  discord
  dkms
  dolphin
  dunst
  efibootmgr
  eza
  fastfetch
  fd
  fzf
  gimp
  git
  git-delta
  graphviz
  grim
  hyprland
  hyprpaper
  hyprshot
  i2c-tools
  intel-ucode
  iwd
  kitty
  lazygit
  less
  libva-nvidia-driver
  linux
  linux-firmware
  linux-headers
  mandoc
  mgba-qt
  nano
  neovim
  nodejs
  npm
  nvidia-dkms
  nwg-look
  openrgb
  openssh
  otf-font-awesome
  pavucontrol
  pipewire-alsa
  pipewire-pulse
  polkit-kde-agent
  qt5-wayland
  qt6-wayland
  sddm
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
  zoxide
  zram-generator
  zsh
)

sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}"

# ---- yay bootstrap (only if missing) ----
if ! command -v yay >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

# ---- AUR packages ----
AUR_PKGS=(
  bibata-cursor-theme
  catppuccin-gtk-theme-mocha
  flavours
  flavours-debug
  gruvbox-dark-gtk
  pinta
  python-clickgen
  python-docopt-ng
  python-gdtoolkit
  python-mando
  python-radon
  python-rst2ansi
  vesktop-debug
  yay
  yay-debug
  zen-browser-bin
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "Done."
