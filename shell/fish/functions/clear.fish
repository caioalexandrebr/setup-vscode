# Clear the screen AND drop the scrollback.
#
# zsh does this as `alias clear="clear && printf '\e[3J'"`. In fish, `\e` is not
# interpreted inside single quotes the same way, and shadowing a builtin needs
# `command` to avoid infinite recursion — hence a function.
function clear --description 'Clear screen and scrollback'
    command clear
    printf '\e[3J'
end
