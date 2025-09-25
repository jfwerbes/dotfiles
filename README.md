# dotfiles

This repository contains my personal dotfiles and configuration, organized to be managed via **GNU Stow**.  

The goal is to keep each application’s config in its own directory, and then use `stow` to symlink them into the home directory (or other target directories).  

---

## 📁 Structure

Here’s the high-level layout of the repository:

```
.
├── backgrounds/
│   └── .config/
│       └── backgrounds/
├── dunst/
│   └── .config/
│       └── dunst/
├── hyprland/
│   └── .config/
│       └── hypr/
├── hyprpaper/
│   └── .config/
│       └── hypr/
├── kitty/
│   └── .config/
│       └── kitty/
├── nvim/
│   └── .config/
│       └── nvim/
├── starship/
│   └── .config/
├── waybar/
│   └── .config/
│       └── waybar/
├── wofi/
│   └── .config/
│       └── wofi/
├── zshrc
└── .gitignore
```

Each top-level folder (e.g. `nvim`, `kitty`, `hyprland`, etc.) corresponds to one “package” in stow parlance. Inside, the path structure mirrors where those config files should land in your home directory (or appropriate config directory).

---

## 🛠 Installation / Usage with GNU Stow

Here’s a basic workflow for deploying/configuring your dotfiles via `stow`.

### Prerequisites

- You need **GNU Stow** installed (`stow` command).  
- You should have a clean home directory (or at least not conflicting existing files) or back up existing configs before stowing.

### Usage

1. Clone this repository, e.g.:

   ```sh
   git clone https://github.com/jfwerbes/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Use stow to symlink one or more packages. For example:

   ```sh
   stow nvim
   stow kitty
   stow zshrc
   ```

   This will create symlinks from `~/.dotfiles/nvim/.config/nvim` → `~/.config/nvim` (and similarly for other packages).  
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
   stow nvim kitty starship
   ```

---

## ✅ Tips & Considerations

- Before stowing, ensure there are no conflicting files or folders where the symlinks would go. If there are existing configs, back them up or remove them.
- Use `stow -n` (dry run) to preview what symlinks would be created.
- You can combine multiple stow packages flexibly (for instance, if you want `nvim` and `zshrc`).
- If you ever want to migrate or reorganize a package, just update the folder structure; stow’s behavior remains consistent.
- The dotfiles are tracked via Git, so you can version your configuration changes, sync across machines, or roll back.
- ⚠️ **Disclaimer**: Kitty themes are intentionally not included in this repository.  
  If you’d like to install themes, you can clone them from [dexpota/kitty-themes](https://github.com/dexpota/kitty-themes).

---

## 🧭 Example Workflow (fresh setup)

```sh
# On a fresh Arch Linux machine:
sudo pacman -S stow git

git clone https://github.com/jfwerbes/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim
stow kitty
stow zshrc
stow hyprland
# … etc.
```

If you encounter file conflicts, stow will warn you; you can fix or remove existing conflicting files, then retry.

---

## 💡 Why This Setup?

Using GNU Stow for dotfiles offers several advantages:

- **Modularity** — each app’s config is in its own package, so it's easy to enable/disable or reorganize.
- **Safe symlinking** — avoids the mess of manually managing symlinks.
- **Version control** — your config files remain fully in Git, but deployed cleanly to home directories.
- **Portability** — install the repository on a new machine and stow packages to reproduce your environment easily.

