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
alias gd='git diff'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gaa='git add .'
alias gpb='git push --set-upstream origin HEAD'
alias gc='git checkout'
alias gcb='git checkout -b'

# vscode
alias c.='code .'

# utils
# `\e[3J` also drops the scrollback, not just the visible screen.
alias clear="clear && printf '\e[3J'"
alias unlink="rm -rf ~/.config/yarn/link/*"

# -------------------------------------------------------------------- local ---
# Machine-specific paths, tool managers and secrets. Copy the example on a fresh
# machine:  cp shell/zsh/.zshrc.local.example ~/.zshrc.local
# Must be sourced last so it can override anything above.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
