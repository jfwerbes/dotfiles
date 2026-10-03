#!/usr/bin/env python3
"""Rofi wallpaper picker.

Choose a wallpaper from a thumbnail grid, then a dark or light base16 scheme
generated from it (previewed as sample code), and apply both together.
"""

import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

HOME = Path.home()
BACKGROUNDS = HOME / ".config/backgrounds"
CACHE = HOME / ".cache/wallpick"
THUMB_SIZE = "960x270"  # 32:9, previews the ultrawide cover-crop
ROFI_THEME = HOME / ".config/rofi/wallpick.rasi"
IMAGE_EXTS = {".jpg", ".jpeg", ".png"}
MODES = ["dark", "light"]

# Own slug so day_night's "generated" scheme (and its current-theme check) is untouched
SLUG = "wallpick"
DATA_HOME = Path(os.environ.get("XDG_DATA_HOME", HOME / ".local/share"))
SCHEME_FILE = DATA_HOME / f"flavours/base16/schemes/generated/{SLUG}.yaml"

PREVIEW_WIDTH = 44  # characters; every line is padded to this


def is_stale(target: Path, source: Path) -> bool:
    """True if target is missing or older than source."""
    return not target.exists() or source.stat().st_mtime > target.stat().st_mtime


def rofi(entries: str, prompt: str, *args: str) -> int | None:
    """Run a rofi dmenu, return the chosen entry's index, or None if cancelled."""
    result = subprocess.run(
        ["rofi", "-dmenu", "-format", "i", "-theme", str(ROFI_THEME), "-p", prompt, *args],
        input=entries,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return int(result.stdout)


def list_images() -> list[Path]:
    """Images in BACKGROUNDS, skipping the mask_* overlays."""
    return sorted(
        (
            p
            for p in BACKGROUNDS.iterdir()
            if p.is_file() and p.suffix.lower() in IMAGE_EXTS and not p.name.startswith("mask_")
        ),
        key=lambda p: p.name.casefold(),
    )


def thumbnail(image: Path) -> Path:
    """Cached 32:9 thumbnail, rebuilt only when the image is newer."""
    thumb = CACHE / f"{image.name}.png"
    if is_stale(thumb, image):
        subprocess.run(
            ["magick", str(image), "-thumbnail", f"{THUMB_SIZE}^",
             "-gravity", "center", "-extent", THUMB_SIZE, str(thumb)],
            check=True,
        )
    return thumb


def scheme(image: Path, mode: str) -> Path:
    """Cached base16 scheme for an image and mode, regenerated when the image is newer."""
    path = CACHE / "schemes" / f"{image.name}.{mode}.yaml"
    if is_stale(path, image):
        result = subprocess.run(
            ["flavours", "generate", "--stdout", "--name", "Wallpick", mode, str(image)],
            check=True,
            capture_output=True,
            text=True,
        )
        path.write_text(result.stdout)
    return path


def read_colors(scheme_file: Path) -> dict[str, str]:
    """Parse base00..base0F from a scheme yaml into '#rrggbb' strings."""
    colors = {}
    for line in scheme_file.read_text().splitlines():
        match = re.match(r'(base0[0-9A-F]):\s*"?([0-9a-fA-F]{6})"?', line)
        if match:
            colors[match[1]] = f"#{match[2]}"
    return colors


def preview_markup(title: str, scheme_file: Path) -> str:
    """Sample terminal output as rofi pango markup, coloured like a base16 terminal."""
    c = read_colors(scheme_file)

    def fg(color: str, text: str) -> str:
        return f"<span foreground='{c[color]}'>{text}</span>"

    # base08 red, 09 orange, 0A yellow, 0B green, 0C cyan, 0D blue, 0E magenta, 03 comments
    lines = [
        fg("base05", f"<b>{title}</b>"),
        "",
        f"{fg('base0B', 'brutus@arch')} {fg('base0D', '~/.dotfiles')} {fg('base0E', 'main')}",
        f"{fg('base0B', '❯')} git status --short",
        f" {fg('base0A', 'M')} scripts/wallpick.py",
        f"{fg('base08', '??')} rofi/",
        fg("base03", "-- feel.lua"),
        f"{fg('base0E', 'local')} gaps {fg('base0C', '=')} {fg('base09', '20')}",
        f"hl.{fg('base0D', 'config')}({{ border {fg('base0C', '=')} {fg('base0B', '&quot;round&quot;')} }})",
    ]

    # Pad every line to the same visible width so the background forms a solid block
    def visible_len(line: str) -> int:
        return len(re.sub(r"<[^>]*>", "", line).replace("&quot;", '"'))

    body = "\n".join(f"  {line}{' ' * (PREVIEW_WIDTH - visible_len(line))}" for line in lines)
    return f"<span background='{c['base00']}' foreground='{c['base05']}'>{body}</span>"


def main() -> int:
    (CACHE / "schemes").mkdir(parents=True, exist_ok=True)

    images = list_images()
    if not images:
        print(f"wallpick: no images in {BACKGROUNDS}", file=sys.stderr)
        return 1

    # Pick wallpaper from a thumbnail grid
    entries = "".join(f"{img.name}\0icon\x1f{thumbnail(img)}\n" for img in images)
    choice = rofi(entries, "Wallpaper", "-show-icons")
    if choice is None:
        return 0
    wallpaper = images[choice]

    # Pick theme mode: both schemes previewed as multi-line markup entries separated by "|"
    schemes = [scheme(wallpaper, mode) for mode in MODES]
    previews = "|".join(preview_markup(mode, s) for mode, s in zip(MODES, schemes))
    choice = rofi(
        previews, "Theme",
        "-markup-rows", "-sep", "|", "-eh", "9",
        "-theme-str", "window { width: 1100px; } listview { columns: 2; lines: 1; }",
    )
    if choice is None:
        return 0
    mode = MODES[choice]

    # Install the chosen scheme under its own slug before applying anything,
    # so wallpaper and colours switch at the same moment
    SCHEME_FILE.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(schemes[choice], SCHEME_FILE)

    # Apply the wallpaper to the first active monitor, then the theme
    monitors = subprocess.run(
        ["hyprctl", "monitors", "-j"], check=True, capture_output=True, text=True
    ).stdout
    monitor = json.loads(monitors)[0]["name"]
    subprocess.run(["hyprctl", "hyprpaper", "wallpaper", f"{monitor},{wallpaper}"], check=True)
    subprocess.run(["flavours", "apply", SLUG], check=True)

    # dunst was restarted by the flavours hook; give it a moment
    time.sleep(0.3)
    subprocess.run(["notify-send", "Wallpaper", f"{wallpaper.name} ({mode})"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
