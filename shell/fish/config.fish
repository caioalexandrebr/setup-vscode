# fish — WSL / Ubuntu
#
# Portable half of the shell setup. Everything machine-specific (fnm, paths,
# secrets) lives in ~/.config/fish/local.fish, which is NOT in this repo.
# The zsh counterpart is shell/zsh/.zshrc — keep the two in sync via
# shell/aliases.md.
#
# Note on plugins: fish ships autosuggestions and syntax highlighting natively,
# so the two oh-my-zsh plugins used on macOS need nothing installed here. That
# is the entire plugin overlap between the two shells.
#
# Theme stays per-shell on purpose: fish keeps whatever you set with
# `fish_config`, stored in ~/.config/fish/fish_variables (machine-local, never
# committed). zsh keeps robbyrussell.

# Interactive-only setup. Keeps scripts and `fish -c` fast.
if status is-interactive
    # ------------------------------------------------------------- editor ---
    set -gx EDITOR "code -w"

    # Greeting off — matches the bare prompt on macOS.
    set -g fish_greeting
end

# Aliases and paths are split into conf.d/, which fish sources automatically
# before this file. Nothing to do here.

# ------------------------------------------------------------------- local ---
# Machine-specific paths, tool managers and secrets. Copy the example on a fresh
# machine:  cp shell/fish/local.fish.example ~/.config/fish/local.fish
# Sourced last so it can override anything above.
if test -f "$HOME/.config/fish/local.fish"
    source "$HOME/.config/fish/local.fish"
end
