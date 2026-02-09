#!/usr/bin/env bash
# Klear KDE rice – uninstall script
# Restores config from the latest ~/.config-backup-klear-* backup and removes environment.d/klear.conf.
# Run from repo root.

set -e

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ -z "$HOME" ]]; then
  echo "Error: HOME is not set." >&2
  exit 1
fi

LATEST_BACKUP=""
for d in "$HOME"/.config-backup-klear-*; do
  [[ -d "$d" ]] || continue
  if [[ -z "$LATEST_BACKUP" || "$d" -nt "$LATEST_BACKUP" ]]; then
    LATEST_BACKUP="$d"
  fi
done

if [[ -z "$LATEST_BACKUP" || ! -d "$LATEST_BACKUP" ]]; then
  echo "No Klear backup found (~/.config-backup-klear-*). Nothing to restore." >&2
  echo "To remove Klear config manually, delete or overwrite:"
  echo "  $CONFIG_HOME/kdeglobals"
  echo "  $CONFIG_HOME/kwinrc"
  echo "  $CONFIG_HOME/plasmarc"
  echo "  $CONFIG_HOME/Kvantum/"
  echo "  $CONFIG_HOME/gtk-3.0/"
  exit 1
fi

echo "Restoring from: $LATEST_BACKUP"
read -r -p "This will overwrite current KDE/GTK config. Continue? [y/N] " resp
if [[ ! "$resp" =~ ^[yY]$ ]]; then
  exit 0
fi

for name in kdeglobals kwinrc plasmarc plasma-org.kde.plasma.desktop-appletsrc; do
  if [[ -f "$LATEST_BACKUP/$name" ]]; then
    cp -a "$LATEST_BACKUP/$name" "$CONFIG_HOME/" && echo "  Restored $name"
  fi
done
if [[ -d "$LATEST_BACKUP/Kvantum" ]]; then
  rm -rf "$CONFIG_HOME/Kvantum"
  cp -a "$LATEST_BACKUP/Kvantum" "$CONFIG_HOME/" && echo "  Restored Kvantum/"
fi
if [[ -d "$LATEST_BACKUP/gtk-3.0" ]]; then
  rm -rf "$CONFIG_HOME/gtk-3.0"
  cp -a "$LATEST_BACKUP/gtk-3.0" "$CONFIG_HOME/" && echo "  Restored gtk-3.0/"
fi

if [[ -f "$CONFIG_HOME/environment.d/klear.conf" ]]; then
  rm -f "$CONFIG_HOME/environment.d/klear.conf"
  echo "  Removed environment.d/klear.conf"
  rmdir "$CONFIG_HOME/environment.d" 2>/dev/null || true
fi

echo ""
echo "Restore complete. Log out and back in for changes to take effect."
