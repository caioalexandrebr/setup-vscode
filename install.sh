#!/usr/bin/env bash
# Install this VS Code + shell setup on macOS, Linux or WSL.
#
# Symlinks rather than copies, so `git pull` in this repo updates the live
# config. Never overwrites without moving the existing file to *.bak first, and
# never touches your machine-local files (~/.zshrc.local, local.fish).
#
# Usage:  ./install.sh            interactive
#         ./install.sh --dry-run  print what it would do and exit
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
run()  { if (( DRY_RUN )); then printf '   would run: %s\n' "$*"; else "$@"; fi; }

# --------------------------------------------------------------- platform ---
detect_platform() {
  case "$(uname -s)" in
    Darwin) echo macos ;;
    Linux)
      # WSL exposes "microsoft" in the kernel release string.
      if grep -qi microsoft /proc/version 2>/dev/null; then echo wsl; else echo linux; fi
      ;;
    *) echo unknown ;;
  esac
}
PLATFORM="$(detect_platform)"
say "Platform: $PLATFORM"
[[ "$PLATFORM" == unknown ]] && { warn "Unsupported platform, aborting."; exit 1; }

# ------------------------------------------------------------ link helper ---
link() {
  local src="$1" dest="$2"
  run mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    run rm "$dest"
  elif [[ -e "$dest" ]]; then
    warn "$dest exists — backing up to $dest.bak"
    run mv "$dest" "$dest.bak"
  fi
  run ln -s "$src" "$dest"
  say "linked $dest -> $src"
}

# ------------------------------------------------- vs code settings target ---
# On WSL, the User settings dir depends on where VS Code actually runs:
#   - Windows-side VS Code + Remote-WSL  -> /mnt/c/Users/<user>/AppData/Roaming/Code/User
#   - VS Code Server inside the distro   -> ~/.vscode-server/data/Machine
vscode_user_dir() {
  case "$PLATFORM" in
    macos) echo "$HOME/Library/Application Support/Code/User" ;;
    linux) echo "$HOME/.config/Code/User" ;;
    wsl)
      echo "Where does VS Code read its settings from?" >&2
      echo "  1) Windows-side VS Code (Remote-WSL)  [default]" >&2
      echo "  2) VS Code Server inside this distro" >&2
      read -rp "  choice [1]: " choice >&2
      if [[ "${choice:-1}" == "2" ]]; then
        echo "$HOME/.vscode-server/data/Machine"
      else
        local guess winuser
        # cmd.exe is the reliable way to read the Windows username from WSL.
        guess="$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n' || true)"
        read -rp "  Windows username [${guess}]: " winuser >&2
        winuser="${winuser:-$guess}"
        [[ -z "$winuser" ]] && { warn "No Windows username given."; exit 1; }
        echo "/mnt/c/Users/$winuser/AppData/Roaming/Code/User"
      fi
      ;;
  esac
}

VSCODE_DIR="$(vscode_user_dir)"
say "VS Code User dir: $VSCODE_DIR"
link "$REPO/vscode/settings.json"    "$VSCODE_DIR/settings.json"
link "$REPO/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

# ------------------------------------------------------------- extensions ---
if command -v code >/dev/null 2>&1; then
  say "Installing extensions from vscode/extensions.txt"
  while read -r ext; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    run code --install-extension "$ext" --force
  done < "$REPO/vscode/extensions.txt"
else
  warn "\`code\` not on PATH — skipping extensions."
  warn "macOS: Command Palette > 'Shell Command: Install code command in PATH'."
  warn "WSL:   install the Remote-WSL extension, then reopen the terminal."
fi

# ------------------------------------------------------------------ shell ---
# zsh on macOS, fish on Linux/WSL. Each keeps its own theme by design.
if [[ "$PLATFORM" == macos ]]; then
  say "Shell: zsh"
  [[ -d "$HOME/.oh-my-zsh" ]] || warn "oh-my-zsh not installed — see README prerequisites."
  link "$REPO/shell/zsh/.zshrc" "$HOME/.zshrc"
  if [[ ! -f "$HOME/.zshrc.local" ]]; then
    say "Seeding ~/.zshrc.local from the example (fill in paths + secrets)"
    run cp "$REPO/shell/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
  else
    say "~/.zshrc.local already exists — left untouched"
  fi
else
  say "Shell: fish"
  command -v fish >/dev/null 2>&1 || warn "fish not installed — see README prerequisites."
  FISH_DIR="$HOME/.config/fish"
  link "$REPO/shell/fish/config.fish"                 "$FISH_DIR/config.fish"
  link "$REPO/shell/fish/conf.d/aliases.fish"         "$FISH_DIR/conf.d/aliases.fish"
  link "$REPO/shell/fish/functions/clear.fish"        "$FISH_DIR/functions/clear.fish"
  link "$REPO/shell/fish/functions/cacau-update.fish" "$FISH_DIR/functions/cacau-update.fish"
  link "$REPO/shell/fish/fish_plugins"                "$FISH_DIR/fish_plugins"
  if [[ ! -f "$FISH_DIR/local.fish" ]]; then
    say "Seeding ~/.config/fish/local.fish from the example (fill in paths + secrets)"
    run cp "$REPO/shell/fish/local.fish.example" "$FISH_DIR/local.fish"
  else
    say "local.fish already exists — left untouched"
  fi
  if command -v fisher >/dev/null 2>&1; then
    run fisher update
  else
    warn "Fisher not installed — see README prerequisites."
  fi
fi

say "Done."
(( DRY_RUN )) && say "(dry run — nothing was changed)"
