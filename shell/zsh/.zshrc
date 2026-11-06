# zsh — macOS
#
# Portable half of the shell setup. Everything machine-specific (corporate CA
# bundles, company-internal tools, secrets) lives in ~/.zshrc.local, which is
# NOT in this repo. Homebrew's PATH comes from ~/.zprofile (shell/zsh/.zprofile).
# The fish counterpart is shell/fish/ — keep the two in sync via shell/aliases.md.
#
# Everything here is installed by the Brewfile; no plugin manager, no oh-my-zsh.

# ------------------------------------------------------------------ history ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

# ------------------------------------------------------------- completion ---
# zsh-completions must be on fpath before compinit runs.
# If compinit asks about "insecure directories": chmod go-w "$(brew --prefix)/share"
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # case-insensitive

# --------------------------------------------------------------------- node ---
# fnm switches Node on `cd` into a dir with .nvmrc / .node-version.
eval "$(fnm env --use-on-cd --shell zsh)"
# corepack fetches the yarn/pnpm version pinned in packageManager without asking.
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# -------------------------------------------------------------------- tools ---
eval "$(zoxide init zsh)"          # z <dir>, zi <dir>
source <(fzf --zsh)                # Ctrl+R history, Ctrl+T files, Alt+C dirs
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -la --icons=auto --git --group-directories-first'
alias tree='eza --tree --icons=auto --git-ignore'

# ------------------------------------------------------------------- prompt ---
eval "$(starship init zsh)"

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

# github cli
eval "$(gh completion -s zsh)"
alias ghpr='gh pr create'
alias ghd='gh pr create --draft --fill'
alias ghv='gh pr view --web'
alias ghb='gh browse'

# navigation
alias gym='cd ~/dev/wellhub'
alias dev='cd ~/dev/wellhub'
alias well='cd ~/dev/wellhub'

# vscode
alias c.='code .'

# utils
# `\e[3J` also drops the scrollback, not just the visible screen.
alias clear="clear && printf '\e[3J'"
alias unlink="rm -rf ~/.config/yarn/link/*"

# -------------------------------------------------------------------- local ---
# Machine-specific config, company-internal tools and secrets.
# Fresh machine:  cp shell/zsh/.zshrc.local.example ~/.zshrc.local
# Sourced before the plugins below so syntax-highlighting still loads last.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# ------------------------------------------------------------------ plugins ---
# Order matters: fzf-tab after compinit and fzf (it takes over Tab), before
# autosuggestions; syntax-highlighting always last.
source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Reminds you when a typed command already has an alias.
source "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh"

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
