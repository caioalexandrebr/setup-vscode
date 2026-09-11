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
| `gym`  | `cd ~/dev/gympass/` | |
| `gs`   | `git status` | |
| `gl`   | `git log` | |
| `glg`  | `git log --graph --decorate --all` (pretty) | quoting differs per shell |
| `gaa`  | `git add .` | |
| `gpb`  | `git push --set-upstream origin HEAD` | |
| `gc`   | `git checkout` | |
| `gcb`  | `git checkout -b` | |
| `c.`   | `code .` | |
| `cu`   | `cacau-update` | function, see below |
| `unlink` | `rm -rf ~/.config/yarn/link/*` | |

## Aliases that differ by shell

Same intent, different name or implementation. Kept symmetrical on purpose.

| Intent | zsh | fish |
| --- | --- | --- |
| reload shell config | `szsh` | `sfish` |
| edit shell config   | `czsh` | `cfish` |
| clear + wipe scrollback | `clear` (alias) | `clear` (function — `\e[3J` needs `printf` escaping fish does differently) |
| `cacau-update` | zsh function | fish function (`[[ ]]` and `${dir:t}` are zsh-only) |

## Plugins

Only three things are configured in zsh, and only one of them needs a plugin in
fish — the other two ship with fish itself. That is the whole overlap.

| zsh | fish | how |
| --- | --- | --- |
| `zsh-autosuggestions` | built in | nothing to install |
| `zsh-syntax-highlighting` | built in | nothing to install |
| oh-my-zsh `git` plugin | not used | the aliases above replace it, so both shells get *your* aliases rather than oh-my-zsh's |

Plugin manager: oh-my-zsh on macOS, [Fisher](https://github.com/jorgebucaran/fisher)
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
