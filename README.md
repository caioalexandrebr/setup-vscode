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
  zsh/                   macOS
  fish/                  WSL / Ubuntu
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

On WSL it asks whether VS Code runs on the Windows side (Remote-WSL) or as VS
Code Server inside the distro, and reads your Windows username from `cmd.exe`.

## Prerequisites

Install these before running `install.sh` — it warns instead of failing if one
is missing.

**Both machines**

- [Fira Code](https://github.com/tonsky/FiraCode) — editor and terminal font
- `code` on PATH — macOS: Command Palette › *Shell Command: Install 'code' command in PATH*. WSL: the Remote-WSL extension provides it.

**macOS**

```bash
brew install --cask font-fira-code
brew install jq
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

Node is managed with **nvm**, plus a `chpwd` hook that runs `nvm use` when you
enter a directory with a `.nvmrc`.

**WSL / Ubuntu**

```bash
sudo apt install fish jq
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
curl -fsSL https://fnm.vercel.app/install | bash
```

Node is managed with **fnm**, using `--use-on-cd` — fnm's built-in equivalent of
the nvm hook above.

## How the two shells stay in sync

[`shell/aliases.md`](shell/aliases.md) is the canonical list. Add an alias there
first, then to `shell/zsh/.zshrc` and `shell/fish/conf.d/aliases.fish`.

Shared: the git aliases, `gym`, `c.`, `unlink`, `cu`, and `clear`-with-scrollback.

Not shared, on purpose:

| | macOS | WSL |
| --- | --- | --- |
| shell | zsh + oh-my-zsh | fish + Fisher |
| Node | nvm + `chpwd` hook | fnm `--use-on-cd` |
| prompt | `robbyrussell` | whatever `fish_config` is set to |
| plugins | zsh-autosuggestions, zsh-syntax-highlighting | *(both built into fish)* |

**Environment variables are never shared.** They are on-demand, per-machine
facts — the Mac has Java, Go, the Android SDK and aws-vault; the WSL box has
none of them. Each machine declares its own in a local file:

- macOS — `~/.zshrc.local` (template: `shell/zsh/.zshrc.local.example`)
- WSL — `~/.config/fish/local.fish` (template: `shell/fish/local.fish.example`)

Both are gitignored and sourced last, so they can override anything. Secrets
(webhooks, API tokens) live there too and never enter this repo.

## Extensions

| Extension | What for |
| --- | --- |
| [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) | AI assistant, docked in the panel |
| [Builder](https://marketplace.visualstudio.com/items?itemName=builder.builder) | Wellhub internal tooling |
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
