# zsh — macOS
#
# Portable half of the shell setup. Everything machine-specific (Homebrew, Go,
# Android SDK, nvm, secrets) lives in ~/.zshrc.local, which is NOT in this repo.
# The fish counterpart is shell/fish/ — keep the two in sync via shell/aliases.md.

# ---------------------------------------------------------------- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"

# Theme stays per-shell on purpose: zsh keeps robbyrussell, fish keeps its own.
ZSH_THEME="robbyrussell"

# The `git` plugin is deliberately absent — the aliases below are ours, so both
# shells get the same set instead of oh-my-zsh's.
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------- editor ---
export EDITOR="code -w"

# ------------------------------------------------------------------ aliases ---
# Mirrored in shell/fish/conf.d/aliases.fish. Add to shell/aliases.md first.

# shell config
alias szsh='source ~/.zshrc'
alias czsh='code ~/.zshrc'

# git
alias gs='git status'
alias gl='git log'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gaa='git add .'
alias gpb='git push --set-upstream origin HEAD'
alias gc='git checkout'
alias gcb='git checkout -b'

# navigation
alias gym='cd ~/dev/gympass/'

# vscode
alias c.='code .'

# utils
# `\e[3J` also drops the scrollback, not just the visible screen.
alias clear="clear && printf '\e[3J'"
alias unlink="rm -rf ~/.config/yarn/link/*"

# ------------------------------------------------------- claude code / cacau ---
# Updates the Cacau plugin end to end: marketplace catalog, plugin itself, then
# drops every cached version except the active one. Replaces the deprecated
# symlink-into-mep-docs flow — do not re-add links under ~/.claude/skills, they
# resurface every skill a second time without the cacau: prefix.
cacau-update() {
  command -v claude >/dev/null || { echo "cacau-update: claude CLI not found in PATH"; return 1; }

  claude plugin marketplace update mep-docs || return 1
  claude plugin update cacau@mep-docs || return 1

  local cache_dir="$HOME/.claude/plugins/cache/mep-docs/cacau"
  local installed_json="$HOME/.claude/plugins/installed_plugins.json"
  local active=""

  if command -v jq >/dev/null; then
    active=$(jq -r '.plugins["cacau@mep-docs"][0].version // ""' "$installed_json" 2>/dev/null)
  fi

  # No reliable read of the active version means no prune: deleting the wrong
  # directory here would uninstall the plugin.
  if [[ -n "$active" && -d "$cache_dir" ]]; then
    local dir ver
    for dir in "$cache_dir"/*/; do
      [[ -d "$dir" ]] || continue
      ver="${${dir%/}:t}"
      [[ "$ver" == "$active" ]] && continue
      rm -rf "$dir" && echo "pruned stale cache: $ver"
    done
    echo "active version kept: $active"
  else
    echo "could not determine active version; skipped prune"
  fi

  echo
  echo "Restart Claude Code, or run /reload-plugins then /reload-skills — a running"
  echo "session keeps the old skill list in memory until then."
}
alias cu='cacau-update'

# -------------------------------------------------------------------- local ---
# Machine-specific paths, tool managers and secrets. Copy the example on a fresh
# machine:  cp shell/zsh/.zshrc.local.example ~/.zshrc.local
# Must be sourced last so it can override anything above.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
