# Aliases & plugins — canonical list

Single source of truth. `shell/zsh/.zshrc` and `shell/fish/` are both written
from this table; when you add an alias, add it here first, then to both shells.

Rule for what lives here: **only what works identically in zsh and fish.**
Anything machine-specific (paths, SDKs, secrets) goes in the local file instead
— `~/.zshrc.local` on macOS, `~/.config/fish/local.fish` on WSL. Those are
gitignored.

## Shared aliases

| Alias | Command | Note |
| --- | --- | --- |
| `gym`  | `cd ~/dev/wellhub` | |
| `dev`  | `cd ~/dev/wellhub` | same as `gym` |
| `well` | `cd ~/dev/wellhub` | same as `gym` |
| `gs`   | `git status` | |
| `gl`   | `git log` | |
| `gd`   | `git diff` | |
| `glg`  | `git log --graph --decorate --all` (pretty) | quoting differs per shell |
| `gaa`  | `git add .` | |
| `gpb`  | `git push --set-upstream origin HEAD` | |
| `gc`   | `git checkout` | |
| `gcb`  | `git checkout -b` | |
| `ghpr` | `gh pr create` | |
| `ghd`  | `gh pr create --draft --fill` | |
| `ghv`  | `gh pr view --web` | |
| `ghb`  | `gh browse` | |
| `c.`   | `code .` | |
| `unlink` | `rm -rf ~/.config/yarn/link/*` | |

## Aliases that differ by shell

Same intent, different name or implementation. Kept symmetrical on purpose.

| Intent | zsh | fish |
| --- | --- | --- |
| reload shell config | `szsh` | `sfish` |
| edit shell config   | `czsh` | `cfish` |
| clear + wipe scrollback | `clear` (alias) | `clear` (function — `\e[3J` needs `printf` escaping fish does differently) |

## Plugins

zsh plugins come from Homebrew (see the `Brewfile`) and are sourced directly in
`.zshrc` — no plugin manager. Two of them are built into fish.

| zsh | fish | how |
| --- | --- | --- |
| `zsh-autosuggestions` | built in | nothing to install |
| `zsh-syntax-highlighting` | built in | nothing to install |
| `zsh-completions` | mostly built in | fish ships completions for most tools |
| `fzf-tab` (Tab opens fzf) | not used | zsh-only |
| `zsh-you-should-use` (alias reminders) | not used | fish `abbr` already expands in place |

The prompt (Starship), zoxide, fzf and eza are tools, not plugins, and only the
macOS side wires them up today.

Plugin manager: none on macOS, [Fisher](https://github.com/jorgebucaran/fisher)
on WSL. `shell/fish/fish_plugins` is Fisher's lockfile and holds only Fisher
itself, which manages itself. It carries no comments on purpose: `fisher update`
rewrites the file from scratch and would strip them. Add a plugin there only
when it has a real equivalent in the zsh setup, so the two shells do not drift.

## Deliberately NOT shared

Every `export` / `set -gx`, the Node manager and the prompt. See
[the README](../README.md#how-the-two-shells-stay-in-sync) for the reasoning —
short version: environment variables are per-machine facts, so they live in the
gitignored local file (`~/.zshrc.local`, `~/.config/fish/local.fish`) alongside
the secrets.
