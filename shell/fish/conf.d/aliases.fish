# Aliases — mirrored from shell/zsh/.zshrc. Add to shell/aliases.md first.
#
# `abbr` rather than `alias`: fish expands the abbreviation in place as you type,
# so you see the real command before running it and history stays readable.
# Abbreviations are interactive-only, hence the guard.

if status is-interactive
    # --------------------------------------------------------------- shell config ---
    # zsh calls these szsh/czsh — same intent, fish-appropriate names.
    abbr -a sfish 'source ~/.config/fish/config.fish'
    abbr -a cfish 'code ~/.config/fish/config.fish'

    # ----------------------------------------------------------------------- git ---
    abbr -a gs 'git status'
    abbr -a gl 'git log'
    abbr -a glg "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
    abbr -a gaa 'git add .'
    abbr -a gpb 'git push --set-upstream origin HEAD'
    abbr -a gc 'git checkout'
    abbr -a gcb 'git checkout -b'

    # ---------------------------------------------------------------- navigation ---
    abbr -a gym 'cd ~/dev/gympass/'

    # -------------------------------------------------------------------- vscode ---
    abbr -a c. 'code .'

    # --------------------------------------------------------------------- utils ---
    abbr -a unlink 'rm -rf ~/.config/yarn/link/*'

    # ---------------------------------------------------------------------- cacau ---
    abbr -a cu 'cacau-update'

    # `clear` is a function, not an abbr — see functions/clear.fish.
end
