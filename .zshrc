plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

## git
alias gs='git status'
alias gl='git log'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gaa='git add .'
alias gpb='git push --set-upstream origin HEAD'
alias ghard='git reset --hard'

## zsh
alias szsh='source ~/.zshrc'
alias czsh='code ~/.zshrc'

## code
alias c.='code .'

## yarn
alias yi='yarn install'
alias unlink="rm -rf ~/.config/yarn/link/*"

## system
alias clear="clear && printf '\e[3J'"
alias dev='cd ~/dev/'
