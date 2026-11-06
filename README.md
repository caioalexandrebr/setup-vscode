# setup-vscode

My VS Code and shell setup, shared between a macOS laptop (zsh) and a WSL/Ubuntu
box (fish). One VS Code config for both; the shells share everything that can be
shared and nothing that can't.

```
vscode/
  settings.json          cross-platform, grouped by section
  keybindings.json       `key` for Linux/Windows, `mac` override where needed
  extensions.txt         output of `code --list-extensions`
shell/
  aliases.md             canonical alias + plugin list — the source of truth
  zsh/                   macOS (.zshrc, .zprofile, .zshrc.local.example)
  fish/                  WSL / Ubuntu
ghostty/config           macOS terminal
Brewfile                 macOS apps, fonts and CLI tools
install.sh               detects macOS / Linux / WSL and symlinks everything
```

## Install

```bash
git clone git@github.com:caioalexandrebr/setup-vscode.git ~/dev/setup-vscode
cd ~/dev/setup-vscode
./install.sh --dry-run   # see what it would do
./install.sh
```

It symlinks instead of copying, so `git pull` here updates the live config.
Anything it would overwrite is moved to `*.bak` first, and your machine-local
files are never touched.

On macOS it also runs `brew bundle` on the `Brewfile`, links `.zprofile`,
`.zshrc` and the Ghostty config, sets the `gh` aliases, and writes
`~/.docker/config.json` once (only if it does not exist yet) so Colima's docker
CLI finds the compose plugin.

On WSL it asks whether VS Code runs on the Windows side (Remote-WSL) or as VS
Code Server inside the distro, and reads your Windows username from `cmd.exe`.

One exception to the symlinking: files that land on the Windows drive
(`/mnt/c/...`, the Remote-WSL answer above) are **copied**. A symlink made from
WSL there is a WSL-only construct — `ln -s` succeeds, but Windows-side VS Code
cannot follow it and quietly falls back to no settings at all. So after a
`git pull` that touches `vscode/`, re-run `./install.sh` on WSL to refresh the
copies; on macOS and inside the distro the symlinks still update on their own.

## Prerequisites

Install these before running `install.sh` — it warns instead of failing if one
is missing.

**Both machines**

- [Fira Code](https://github.com/tonsky/FiraCode) — editor and terminal font
- `code` on PATH — macOS: Command Palette › *Shell Command: Install 'code' command in PATH*. WSL: the Remote-WSL extension provides it.

**macOS**

Only [Homebrew](https://brew.sh) — everything else is in the `Brewfile`, which
`install.sh` runs for you:

- **Terminal:** Ghostty + zsh, Starship prompt, zsh-autosuggestions,
  zsh-syntax-highlighting, zsh-completions, fzf-tab, zsh-you-should-use, fzf,
  zoxide, eza
- **Dev:** fnm (Node), gh, Atlassian CLI (`acli`), pipx, Claude Code
- **Apps:** VS Code, Bruno (API client), Colima + docker + docker-compose
- **Fonts:** Fira Code (editor), FiraCode Nerd Font (VS Code terminal),
  JetBrains Mono (Ghostty)

The Atlassian tap is third-party, so newer Homebrew asks you to trust it once:
`brew trust --formula atlassian/acli/acli`.

Node is managed with **fnm** `--use-on-cd`, the same as on WSL. yarn and pnpm
come from **corepack** (`corepack enable` once per Node version; Node 25+ needs
`npm install -g corepack` first), which reads the version pinned in each
project's `packageManager`.

After installing, a few things are logins only you can do: `gh auth login`,
`acli jira auth login --web`, and `colima start` whenever you need containers.

**WSL / Ubuntu**

```bash
sudo apt install fish jq
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
curl -fsSL https://fnm.vercel.app/install | bash
```

Node is managed with **fnm**, using `--use-on-cd` — same as on macOS.

## How the two shells stay in sync

[`shell/aliases.md`](shell/aliases.md) is the canonical list. Add an alias there
first, then to `shell/zsh/.zshrc` and `shell/fish/conf.d/aliases.fish`.

Shared: the git and gh aliases, `gym`/`dev`/`well`, `c.`, `unlink`, and
`clear`-with-scrollback.

Not shared, on purpose:

| | macOS | WSL |
| --- | --- | --- |
| shell | zsh, plugins from Homebrew | fish + Fisher |
| terminal | Ghostty | not managed here |
| Node | fnm `--use-on-cd` | fnm `--use-on-cd` |
| prompt | Starship | whatever `fish_config` is set to |
| plugins | autosuggestions, syntax-highlighting, completions, fzf-tab, you-should-use | *(the first two are built into fish)* |

**Machine-specific config is never shared.** Corporate CA bundles,
company-internal CLIs and their aliases, optional toolchains (Java, Go, Android,
aws-vault) and secrets are per-machine facts. Each machine declares its own in a
local file:

- macOS — `~/.zshrc.local` (template: `shell/zsh/.zshrc.local.example`)
- WSL — `~/.config/fish/local.fish` (template: `shell/fish/local.fish.example`)

Both are gitignored. On macOS it is sourced just before the plugins, so it can
override aliases and variables while syntax-highlighting still loads last.
Secrets (webhooks, API tokens) live there too and never enter this repo.

## Extensions

| Extension | What for |
| --- | --- |
| [package-json-upgrade](https://marketplace.visualstudio.com/items?itemName=codeandstuff.package-json-upgrade) | inline dependency update hints |
| [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) | linting, `fixAll` on save |
| [Dracula](https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula) | color theme |
| [Generate Getter Setter](https://marketplace.visualstudio.com/items?itemName=dskwrk.vscode-generate-getter-setter) | accessor scaffolding |
| [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) | git blame and history |
| [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) | default formatter |
| [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag) | rename paired JSX/HTML tags |
| [Color Highlight](https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight) | inline color swatches |
| [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) | file icons |
| [Trailing Spaces](https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces) | highlight + strip, bound to `alt+8` |
| [Styled Components](https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components) | CSS-in-JS syntax |
| [Sort Lines](https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines) | bound to `alt+9` |
| [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens) | diagnostics inline |

Regenerate the list after installing or removing one:

```bash
code --list-extensions > vscode/extensions.txt
```

## Keybindings

| Chord (macOS) | Chord (Linux/Win) | Action |
| --- | --- | --- |
| `⌥;` | `alt+;` | toggle line comment |
| `⌥9` | `alt+9` | sort selected lines |
| `⌥8` | `alt+8` | delete trailing spaces |
| `⌥d` | `alt+d` | delete line |
| `⌥c` | `alt+c` | insert `console.log` |
| `⌥⌘b` | `ctrl+alt+b` | CodeSwing: run |
