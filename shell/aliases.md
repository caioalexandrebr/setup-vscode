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
on WSL. `shell/fish/fish_plugins` is Fisher's lockfile and is intentionally
near-empty — see the note in that file.

## Deliberately NOT shared

**No environment variables are shared between machines.** They are on-demand,
per-machine facts — the macOS box has Java, Go, the Android SDK and aws-vault;
the WSL box has none of them. Mirroring them would only mean carrying `export`
lines that point at directories that do not exist. Each machine's local file
declares what that machine actually has.

| Thing | Where it lives | Why |
| --- | --- | --- |
| Every `export` / `set -gx` | local file | on-demand per machine, see above |
| Node version manager | local file | `nvm` on macOS, `fnm` on WSL — different tools, different init |
| Prompt / theme | local (`ZSH_THEME`, `fish_variables`) | each shell keeps its own theme, by choice |
| Homebrew, GOROOT, Android SDK, openjdk, `AWS_VAULT_BACKEND` | local file (macOS) | macOS-only, absent on WSL |
| `python` alias | local file (macOS) | macOS-only |
| Secrets (`GCHAT_PR_WEBHOOK_URL`, `MEP_CMS_STAGING_MCP_TOKEN`) | local file, gitignored | never commit these |
