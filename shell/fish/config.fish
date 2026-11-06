# fish — WSL / Ubuntu
#
# Portable half of the setup; the zsh counterpart is shell/zsh/.zshrc, kept in
# sync via shell/aliases.md. Machine-specific paths and secrets go in
# ~/.config/fish/local.fish, which is not in this repo.
#
# Aliases live in conf.d/aliases.fish, which fish sources before this file.
# Nothing here needs to load them.
#
# The prompt is per-shell on purpose: fish keeps whatever `fish_config` set, in
# the uncommitted fish_variables (macOS uses Starship). Node is fnm on both.
# fish also ships autosuggestions and syntax highlighting built in, so those two
# zsh plugins need no counterpart.

if status is-interactive
    set -gx EDITOR "code -w"
    set -g fish_greeting
end

# Sourced last so it can override anything above.
# Fresh machine: cp shell/fish/local.fish.example ~/.config/fish/local.fish
if test -f "$HOME/.config/fish/local.fish"
    source "$HOME/.config/fish/local.fish"
end
