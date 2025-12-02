# dotfiles

This repository contains my personal dotfiles and configuration, organized to be managed via **GNU Stow**.  

The goal is to keep each application’s config in its own directory, and then use `stow` to symlink them into the home directory (or other target directories).  

![image](https://github.com/user-attachments/assets/8794bd96-4f8b-4379-87ba-80ce47cdf693)
![image](https://github.com/user-attachments/assets/ef5ce92e-504d-4b85-b20b-1134bfe40ac8)
---

## 📁 Structure

Here’s the high-level layout of the repository:

```
.
├── applications/
│   └── dot-local/
│       └── share/
│           └── applications/
├── backgrounds/
│   └── dot-config/
│       └── backgrounds/
├── bat/
│   └── dot-config/
│       └── bat/
│           └── syntaxes/
├── dunst/
│   └── dot-config/
│       └── dunst/
├── flavours/
│   └── dot-config/
│       └── flavours/
│           └── templates/
├── hyprland/
│   └── dot-config/
│       └── hypr/
├── hyprpaper/
│   └── dot-config/
│       └── hypr/
├── kitty/
│   └── dot-config/
│       └── kitty/
├── nvim/
│   └── dot-config/
│       └── nvim/
├── scripts/
│   ├── day_night.zsh
│   └── gdtouch.zsh
├── starship/
│   └── dot-config/
├── systemd/
│   └── dot-config/
│       └── systemd/
│           └── user/
├── waybar/
│   └── dot-config/
│       └── waybar/
├── wofi/
│   └── dot-config/
│       └── wofi/
├── zshrc
└── .gitignore
```

Each top-level folder (e.g. `nvim`, `kitty`, `hyprland`, etc.) corresponds to one “package” in stow parlance. Inside, the path structure mirrors where those config files should land in your home directory (or appropriate config directory). GNU stow interprets the prefix "dot-" as a prepended . in the file path allowing for traversal without having to comb hidden directories. In order to store these properly though, the --dotfiles flag must be passed to stow.

---

## 🛠 Installation / Usage with GNU Stow

Here’s a basic workflow for deploying/configuring your dotfiles via `stow`.

### Prerequisites

- You need **GNU Stow** installed (`stow` command).  
- You should have a clean home directory (or at least not conflicting existing files) or back up existing configs before stowing.

### Usage

1. Clone this repository and install dependency packages, e.g.:

   ```sh
   git clone https://github.com/jfwerbes/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   chmod +x ./install/install.sh
   ./install/install.sh
   ```

   > 💡 **Recommendation**: Remove the `.git` folder if you want to version-control your dotfiles yourself.  
   > This avoids being tied to my repository history:  
   > ```sh
   > rm -rf ~/.dotfiles/.git
   > git init ~/.dotfiles
   > ```

2. Use stow to symlink one or more packages. For example:

   ```sh
   stow --dotfiles nvim
   stow --dotfiles kitty
   stow --dotfiles zshrc
   ```

   This will create symlinks from `~/.dotfiles/nvim/dot-config/nvim` → `~/.config/nvim` (and similarly for other packages).  
   If you want to stow into other directories (not in your home dir), use the `-t` / `--target` flag:

   ```sh
   stow -t ~ nvim
   stow -t ~ .zshrc
   ```

3. To remove or undo a package, use:

   ```sh
   stow -D nvim
   ```

   This will remove the symlinks created by that package (if they’re unmodified).

4. (Optional) You can stow multiple at once:

   ```sh
   stow --dotfiles nvim kitty starship
   ```

---

## ✅ Tips & Considerations

- Before stowing, ensure there are no conflicting files or folders where the symlinks would go. If there are existing configs, back them up or remove them.
- Use `stow -n` (dry run) to preview what symlinks would be created.
- You can combine multiple stow packages flexibly (for instance, if you want `nvim` and `zshrc`).
- If you ever want to migrate or reorganize a package, just update the folder structure; stow’s behavior remains consistent.
- The dotfiles are tracked via Git, so you can version your configuration changes, sync across machines, or roll back.
- ⚠️ **Disclaimer**: Kitty themes are intentionally not included in this repository.
  If you’d like to install themes, you can clone them from [dexpota/kitty-themes](https://github.com/dexpota/kitty-themes):

  ```sh
  git clone https://github.com/dexpota/kitty-themes.git PATH_TO_YOUR_DOTFILES/kitty/.config/kitty/kitty-themes
  ```

  > 💡 **Recommendation**: Remove the `.git` folder from the cloned `kitty-themes` repo:
  > ```sh
  > rm -rf PATH_TO_YOUR_DOTFILES/kitty/.config/kitty/kitty-themes/.git
  > ```
  > This avoids dealing with **nested Git repositories** inside your own dotfiles repo.

---

## 📦 Package Dependencies

Several configs and scripts assume the following software is already available. Install them before stowing to avoid missing command errors.

### Pacman (official repositories)

| Package | Required by |
| --- | --- |
| `hyprland` | Core compositor referenced throughout `hyprland/dot-config/hypr/hyprland.conf` and by `scripts/day_night.zsh` via `hyprctl`. |
| `hyprpaper` | Wallpaper management configured in `hyprpaper/dot-config/hypr/hyprpaper.conf` and reloaded by `scripts/day_night.zsh`. |
| `waybar` | Status bar with config in `waybar/dot-config/waybar/` and restarted from `scripts/day_night.zsh`. |
| `openrgb` | Launched on login in `hyprland/dot-config/hypr/hyprland.conf`. |
| `kitty` | Default terminal in Hyprland, the Kitty profile itself, and the Spotify desktop entry under `applications/`. |
| `wofi` | Application launcher bound as `$menu` in `hyprland/dot-config/hypr/hyprland.conf`. |
| `dolphin` | File manager referenced via `$fileManager` in the Hyprland config. |
| `zsh` | Shell used by `scripts/day_night.zsh` and the `systemd` user unit in `systemd/dot-config/systemd/user/`. |
| `starship` | Prompt configuration stored in `starship/dot-config/starship.toml` and initialized from `.zshrc`. |
| `zoxide` | Directory jumping initialized from `.zshrc`. |
| `fzf` | Interactive fuzzy finder sourced in `.zshrc`. |
| `fd` | Preferred search backend for FZF functions in `.zshrc`. |
| `eza` | Replacement for `ls` aliased in `.zshrc`. |
| `bat` | Replacement for `cat` aliased in `.zshrc`. |
| `neovim` | Editor targeted by the `vim` alias in `.zshrc` and the `nvim` package. |
| `wf-recorder` | Screen recording alias in `.zshrc`. |
| `slurp` | Region selection helper used by the `wf-recorder` alias. |
| `wireplumber` | Audio module configured in `waybar/dot-config/waybar/config`. |
| `pavucontrol` | Audio mixer launched from the Waybar module on right-click. |
| `dunst` | Notification daemon themed through `dunst/dot-config/dunst/dunstrc` and `flavours` hooks. |
| `godot` | Binary referenced by `applications/dot-local/share/applications/godot.desktop`. |
| `openssh` | Provides `ssh-add`, invoked near the top of `.zshrc`. |

Install everything from the official repositories with:

```sh
sudo pacman -S --needed hyprland hyprpaper waybar openrgb kitty wofi dolphin zsh starship zoxide fzf fd eza bat neovim wf-recorder slurp wireplumber pavucontrol dunst godot openssh
```

### AUR packages (via yay)

| Package | Required by |
| --- | --- |
| `flavours` | Theme orchestrator configured in `flavours/dot-config/flavours/` and triggered by `scripts/day_night.zsh`. |
| `spotify-player` | CLI Spotify client launched by `applications/dot-local/share/applications/spotify.desktop` and the `spotify` alias. |
| `nerd-fonts-anonymice` | Provides “AnonymicePro Nerd Font” used in `dunst/dot-config/dunst/dunstrc` and `waybar/dot-config/waybar/style.css`. |
| `nerd-fonts-caskaydia-cove` | Supplies “CaskaydiaCove Nerd Font Mono” configured in `kitty/dot-config/kitty/kitty.conf`. |

Install these packages from the AUR with:

```sh
yay -S --needed flavours spotify-player nerd-fonts-anonymice nerd-fonts-caskaydia-cove
```

---

## 🎨 Theme Management with Flavours

The repository now uses [flavours](https://github.com/Misterio77/flavours) to keep the visual theme of supported applications in sync.

- Stow the `flavours` package alongside the apps you want to theme:

  ```sh
  stow --dotfiles flavours waybar dunst kitty wofi starship hyprland
  ```

- The main configuration lives in `flavours/dot-config/flavours/config.toml`. It maps each application to a flavours template and optional hooks (e.g. restarting `dunst`).
- Run `flavours apply <scheme-name>` to switch to a different theme. The config already references templates for Waybar, Dunst, Kitty, Wofi, Starship, and Hyprland.
- Hooks are executed through `zsh` so zsh-specific features are available. Adjust the `shell` directive or the individual `[[items]]` blocks if your setup differs.

If you add more applications, extend `config.toml` with another `[[items]]` block pointing to the appropriate config file and template.

---

## ⏱ Automating Day/Night Theme Switching (systemd)

To automatically update wallpapers and themes twice a day, stow the `systemd` and `scripts` packages:

```sh
stow --dotfiles systemd scripts
```

- `scripts/day_night.zsh` handles theme switching, runs `flavours apply` with the appropriate scheme, reloads Waybar, and updates the Hyprpaper wallpaper based on the time of day.
- The user units `systemd/dot-config/systemd/user/day_night.service` and `day_night.timer` call that script at 06:00 and 18:00 daily.

> **Important:** Update the absolute path in `ExecStart=` inside `day_night.service` so it matches your username and dotfiles location.

After stowing the units, reload the user systemd daemon and enable the timer:

```sh
systemctl --user daemon-reload
systemctl --user enable --now day_night.timer
```

You can verify everything is working with:

```sh
systemctl --user status day_night.timer
systemctl --user status day_night.service
```

The timer will trigger the service at the next scheduled interval. You can also test immediately by manually starting the service with `systemctl --user start day_night.service`.

---

## 🧭 Example Workflow (fresh setup)

```sh
# On a fresh Arch Linux machine:
sudo pacman -S stow git

git clone https://github.com/jfwerbes/dotfiles.git ~/dotfiles
cd ~/dotfiles
rm -rf .git && git init   # optional: reset Git history for personal use

stow --dotfiles nvim
stow --dotfiles kitty
stow --dotfiles zshrc
stow --dotfiles hyprland
# … etc.

# (Optional) install kitty themes
git clone https://github.com/dexpota/kitty-themes.git PATH_TO_YOUR_DOTFILES/kitty/dot-config/kitty/kitty-themes
rm -rf PATH_TO_YOUR_DOTFILES/kitty/dot-config/kitty/kitty-themes/.git
```

If you encounter file conflicts, stow will warn you; you can fix or remove existing conflicting files, then retry.

---

## 💡 Why This Setup?

Using GNU Stow for dotfiles offers several advantages:

- **Modularity** — each app’s config is in its own package, so it's easy to enable/disable or reorganize.
- **Safe symlinking** — avoids the mess of manually managing symlinks.
- **Version control** — your config files remain fully in Git, but deployed cleanly to home directories.
- **Portability** — install the repository on a new machine and stow packages to reproduce your environment easily.

