#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
target=${NVIM_CONFIG_DIR:-"$config_home/nvim"}

if [ "$#" -ne 0 ]; then
  echo "Usage: ./install.sh" >&2
  exit 2
fi

mkdir -p "$(dirname -- "$target")"

if [ -L "$target" ]; then
  rm -- "$target"
fi

if [ -d "$target" ]; then
  target_real=$(CDPATH= cd -- "$target" 2>/dev/null && pwd -P || true)
  if [ "$target_real" = "$repo_dir" ]; then
    echo "Source and target are the same directory: $target"
    exit 0
  fi
fi

mkdir -p "$target"

for path in init.lua lazy-lock.json lua README.md docs install.sh; do
  rm -rf -- "$target/$path"
  if [ -e "$repo_dir/$path" ]; then
    cp -R -- "$repo_dir/$path" "$target/"
  fi
done

echo "Copied Neovim config to: $target"
