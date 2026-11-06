# Brewfile — macOS packages for this setup.
#   brew bundle --file=Brewfile        (install.sh runs this on macOS)
#
# The Atlassian tap is third-party: newer Homebrew refuses to install from it
# until you trust the formula once:  brew trust --formula atlassian/acli/acli

tap "atlassian/acli"

# ---------------------------------------------------------------- shell ---
brew "starship"                  # prompt
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"
brew "zsh-you-should-use"
brew "fzf"
brew "fzf-tab"
brew "zoxide"
brew "eza"
brew "jq"

# ----------------------------------------------------------------- dev ---
brew "fnm"                       # Node versions; yarn/pnpm come from corepack
brew "pipx"
brew "gh"
brew "atlassian/acli/acli"       # Jira CLI (OAuth login)

# ----------------------------------------------------------- containers ---
brew "colima"                    # open-source Docker runtime
brew "docker"
brew "docker-compose"

# ---------------------------------------------------------------- apps ---
cask "ghostty"
cask "visual-studio-code"
cask "bruno"                     # API client, collections live in git
cask "claude-code"

# ---------------------------------------------------------------- fonts ---
cask "font-fira-code"            # VS Code editor
cask "font-fira-code-nerd-font"  # VS Code terminal (Starship glyphs)
cask "font-jetbrains-mono"       # Ghostty
