# dotfiles

Personal dotfiles managed with **GNU Stow**, organized so each application lives in its own package.

![image](https://github.com/user-attachments/assets/8794bd96-4f8b-4379-87ba-80ce47cdf693)
![image](https://github.com/user-attachments/assets/ef5ce92e-504d-4b85-b20b-1134bfe40ac8)

---

## 📁 Structure

```
.
├── applications/dot-local/share/applications/
├── backgrounds/dot-config/backgrounds/
├── dunst/dot-config/dunst/
├── flavours/dot-config/flavours/templates/
├── greetd/etc/greetd/
├── hyprland/dot-config/hypr/
├── hyprpaper/dot-config/hypr/
├── install/
├── kitty/dot-config/kitty/
├── nvim/dot-config/nvim/
├── scripts/{day_night.zsh,gdtouch.zsh,fzf-git.sh/}
├── starship/dot-config/
├── systemd/dot-config/systemd/user/
├── waybar/dot-config/waybar/
├── wofi/dot-config/wofi/
├── yazi/dot-config/yazi/
└── zshrc/.zshrc
```

Each directory mirrors the final path under `$HOME` (or another target) using the `dot-` prefix so `stow --dotfiles` expands hidden paths correctly.

---

## 🛠 Stowing

Refer to the [GNU Stow manual](https://www.gnu.org/software/stow/manual/stow.html) for usage details. Notes specific to this repo:

- Always pass `--dotfiles` so `dot-*` paths resolve to hidden files.
- `greetd` targets the root filesystem; stow it with `sudo stow --dotfiles -t / greetd`.
- Other packages can be stowed from the repo root with `stow --dotfiles <package>`.

---

## 🚀 Install at a glance

```sh
git clone https://github.com/jfwerbes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x ./install/install.sh && ./install/install.sh
```

Remove `.git` if you plan to version your own changes.

---

## 🎨 Theme management

[flavours](https://github.com/Misterio77/flavours) keeps supported apps in sync. Stow `flavours` alongside themed apps (Waybar, Dunst, Kitty, Wofi, Starship, Hyprland) and run `flavours apply <scheme>` to switch themes. Templates live in `flavours/dot-config/flavours/`.

---

## ⏱ Day/Night automation

Stow `systemd` and `scripts` to enable scheduled theming:

```sh
stow --dotfiles systemd scripts
```

`scripts/day_night.zsh` picks a wallpaper, applies the matching flavours scheme, preloads Hyprpaper, and Waybar picks up style changes automatically via its `reload_style_on_change` setting. User units `day_night.service` and `day_night.timer` run the script at 06:00 and 18:00 (update the `ExecStart` path for your username). After stowing, run `systemctl --user daemon-reload` and `systemctl --user enable --now day_night.timer`.

---

## 📦 Package dependencies

Install the expected tools before stowing to avoid missing command errors.

### Pacman

`hyprland` · `hyprpaper` · `waybar` · `openrgb` · `kitty` · `wofi` · `dolphin` · `zsh` · `starship` · `zoxide` · `fzf` · `fd` · `eza` · `bat` · `neovim` · `wf-recorder` · `slurp` · `wireplumber` · `pavucontrol` · `dunst` · `godot` · `openssh`

### AUR (via yay)

`flavours` · `spotify-player` · `nerd-fonts-anonymice` · `nerd-fonts-caskaydia-cove`

---

## 💡 Why use Stow?

- Modular packages make it easy to enable/disable pieces of the setup.
- Symlinks keep the working tree clean while preserving Git versioning.
- Moving to a new machine is a matter of cloning and stowing the desired packages.
