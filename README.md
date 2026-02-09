# Klear

KDE rice inspired by Apple Liquid Glass: blur, translucency, rounded corners, and a consistent glassmorphism look.

## Prerequisites

- **Kvantum** – Qt/KDE widget styling (translucency, rounded corners).
- **Better Blur DX** – KWin blur effect for menus, docks, and decorations.
- **Rounded corners** – [KDE-Rounded-Corners](https://github.com/matinlotfali/KDE-Rounded-Corners) or Plasma 6.5+ built-in.

Optional but recommended:

- **Blur-Glassy** theme (Plasma + Kvantum + Global Theme + Window Decorations): [Pling](https://www.pling.com/p/1267335) / [GitHub](https://github.com/L4ki/Blur-Glassy).

### Install prerequisites (examples)

- **Fedora:** `dnf install kvantum`; Better Blur DX: `copr enable infinality/kwin-effects-better-blur-dx` then install the package.
- **Arch:** `pacman -S kvantum`; Better Blur DX: AUR `kwin-effects-better-blur-dx`.
- **Ubuntu:** `apt install qt5-style-kvantum qt5-style-kvantum-themes`.

## Install

```bash
git clone https://github.com/DanyPops/klear.git
cd klear
./install.sh
```

The script will:

- Check for Kvantum (and warn if missing).
- Back up existing config to `~/.config-backup-klear-YYYYMMDD-HHMMSS`.
- Copy config into `~/.config` and optional files into `~/.local/share`.
- Install `environment.d/klear.conf` so Qt uses Kvantum (`QT_STYLE_OVERRIDE=kvantum`).

**Log out and back in (or reboot)** for the full effect.

## What gets configured

- **kdeglobals** – Color scheme, widget style, fonts, icons.
- **kwinrc** – Better Blur DX, blur/translucency/contrast effects, window decoration.
- **plasmarc** – Plasma theme and wallpaper list.
- **Kvantum** – Active Kvantum theme (e.g. Blur-Glassy).
- **gtk-3.0** – GTK theme and colors so GTK apps match.

Klear sets Kvantum/Plasma theme and color scheme for a consistent glass look; install a glass theme (e.g. Blur-Glassy) for the full Liquid Glass effect.

## Uninstall

```bash
./uninstall.sh
```

Restores from the latest `~/.config-backup-klear-*` backup and removes `environment.d/klear.conf`.

## Screenshots and references

- [How do I get something similar to Apple Liquid](https://www.reddit.com/r/kde/comments/1labnau/how_do_i_get_something_similar_to_apple_liquid/)
- [How to make KDE Plasma look like Liquid Glass](https://www.reddit.com/r/kde/comments/1n4hkp1/how_to_make_kde_plasma_look_like_liquid_glass/)
- [I improved the liquid glass/refraction](https://www.reddit.com/r/kde/comments/1mm694c/i_improved_the_liquid_glassrefraction/)

## License

Config files and scripts: use and modify as you like. Themes (e.g. Blur-Glassy) have their own licenses.
# klear
