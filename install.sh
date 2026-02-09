#!/usr/bin/env bash
# Klear KDE rice – install script
# Copies config files to ~/.config and ~/.local/share, backs up existing configs.
# Run from repo root. No sudo required.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
BACKUP_DIR="$HOME/.config-backup-klear-$(date +%Y%m%d-%H%M%S)"

# --- Safety checks ---
if [[ -z "$HOME" ]]; then
  echo "Error: HOME is not set. Refusing to run." >&2
  exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Error: Do not run this script as root. It installs user config only." >&2
  exit 1
fi

if [[ ! -d "$REPO_ROOT/config" || ! -f "$REPO_ROOT/config/kdeglobals" ]]; then
  echo "Error: Run this script from the klear repo root (where config/ and install.sh live)." >&2
  exit 1
fi

# --- Prereqs check ---
echo "Checking prerequisites..."

MISSING=()
if ! command -v kvantummanager &>/dev/null && ! command -v kvantum &>/dev/null; then
  MISSING+=("Kvantum (qt5-style-kvantum / kvantum)")
fi

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo ""
  echo "The following are recommended for the Liquid Glass look but are missing:"
  printf '  - %s\n' "${MISSING[@]}"
  echo ""
  echo "Install Kvantum:"
  echo "  Fedora:     dnf install kvantum"
  echo "  Arch:       pacman -S kvantum"
  echo "  Ubuntu:     apt install qt5-style-kvantum qt5-style-kvantum-themes"
  echo ""
  echo "Optional: Better Blur DX (KWin blur effect) and rounded corners:"
  echo "  Better Blur DX:  https://github.com/xarblu/kwin-effects-better-blur-dx"
  echo "  Fedora COPR:     copr enable infinality/kwin-effects-better-blur-dx"
  echo "  Arch AUR:        kwin-effects-better-blur-dx"
  echo "  Rounded corners: KDE-Rounded-Corners or Plasma 6.5+ built-in"
  echo ""
  read -r -p "Continue install anyway? [y/N] " resp
  if [[ ! "$resp" =~ ^[yY]$ ]]; then
    exit 1
  fi
else
  echo "Prerequisites OK (Kvantum found)."
fi

# --- Backup ---
echo ""
echo "Backing up existing config to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for name in kdeglobals kwinrc plasmarc plasma-org.kde.plasma.desktop-appletsrc; do
  if [[ -f "$CONFIG_HOME/$name" ]]; then
    cp -a "$CONFIG_HOME/$name" "$BACKUP_DIR/" && echo "  Backed up $name"
  fi
done
if [[ -d "$CONFIG_HOME/Kvantum" ]]; then
  cp -a "$CONFIG_HOME/Kvantum" "$BACKUP_DIR/" && echo "  Backed up Kvantum/"
fi
if [[ -d "$CONFIG_HOME/gtk-3.0" ]]; then
  cp -a "$CONFIG_HOME/gtk-3.0" "$BACKUP_DIR/" && echo "  Backed up gtk-3.0/"
fi

# --- Deploy config/ -> ~/.config ---
echo ""
echo "Installing config files into $CONFIG_HOME ..."
mkdir -p "$CONFIG_HOME"
cp -a "$REPO_ROOT/config/kdeglobals" "$CONFIG_HOME/"
cp -a "$REPO_ROOT/config/kwinrc" "$CONFIG_HOME/"
cp -a "$REPO_ROOT/config/plasmarc" "$CONFIG_HOME/"
mkdir -p "$CONFIG_HOME/Kvantum"
cp -a "$REPO_ROOT/config/Kvantum/"* "$CONFIG_HOME/Kvantum/"
mkdir -p "$CONFIG_HOME/gtk-3.0"
for f in "$REPO_ROOT/config/gtk-3.0"/*; do
  [[ -e "$f" ]] && cp -a "$f" "$CONFIG_HOME/gtk-3.0/"
done
echo "  Installed kdeglobals, kwinrc, plasmarc, Kvantum, gtk-3.0"

# --- Deploy local/ -> ~/.local/share (if present) ---
if [[ -d "$REPO_ROOT/local" ]]; then
  for dir in "$REPO_ROOT/local"/*/; do
    [[ -d "$dir" ]] || continue
    base=$(basename "$dir")
    if [[ "$base" == "color-schemes" ]] && [[ -d "$dir" ]]; then
      mkdir -p "$DATA_HOME/color-schemes"
      for f in "$dir"/*; do
        [[ -e "$f" && "$(basename "$f")" != ".gitkeep" ]] && cp -a "$f" "$DATA_HOME/color-schemes/" && echo "  Installed $DATA_HOME/color-schemes/$(basename "$f")"
      done
    fi
  done
fi

# --- Environment.d for QT_STYLE_OVERRIDE=kvantum ---
if [[ -f "$REPO_ROOT/environment.d/klear.conf" ]]; then
  mkdir -p "$CONFIG_HOME/environment.d"
  cp -a "$REPO_ROOT/environment.d/klear.conf" "$CONFIG_HOME/environment.d/"
  echo "  Installed environment.d/klear.conf (QT_STYLE_OVERRIDE=kvantum)"
fi

# --- Post-install ---
echo ""
echo "Klear install complete."
echo "Backup is at: $BACKUP_DIR"
echo ""
echo "Log out and back in (or reboot) for full effect. If you use a glass theme like Blur-Glassy,"
echo "install it from: https://www.pling.com/p/1267335 or https://github.com/L4ki/Blur-Glassy"
