# zsh login profile — macOS
#
# Runs once per login shell (every new Ghostty / VS Code terminal on macOS),
# before ~/.zshrc. Only PATH setup lives here.

# Homebrew (Apple Silicon). Also sets HOMEBREW_PREFIX, which ~/.zshrc uses.
eval "$(/opt/homebrew/bin/brew shellenv)"

# pipx-installed CLIs.
export PATH="$HOME/.local/bin:$PATH"
