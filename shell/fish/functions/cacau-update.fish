# Updates the Cacau plugin end to end: marketplace catalog, plugin itself, then
# drops every cached version except the active one. Replaces the deprecated
# symlink-into-mep-docs flow — do not re-add links under ~/.claude/skills, they
# resurface every skill a second time without the cacau: prefix.
#
# Port of the zsh function in shell/zsh/.zshrc. `[[ ]]` and `${dir:t}` are
# zsh-only, so this is a rewrite rather than a copy — keep both in sync.
function cacau-update --description 'Update the Cacau Claude Code plugin and prune stale caches'
    if not command -q claude
        echo "cacau-update: claude CLI not found in PATH"
        return 1
    end

    claude plugin marketplace update mep-docs; or return 1
    claude plugin update cacau@mep-docs; or return 1

    set -l cache_dir "$HOME/.claude/plugins/cache/mep-docs/cacau"
    set -l installed_json "$HOME/.claude/plugins/installed_plugins.json"
    set -l active ""

    if command -q jq
        set active (jq -r '.plugins["cacau@mep-docs"][0].version // ""' "$installed_json" 2>/dev/null)
    end

    # No reliable read of the active version means no prune: deleting the wrong
    # directory here would uninstall the plugin.
    if test -n "$active" -a -d "$cache_dir"
        for dir in "$cache_dir"/*/
            test -d "$dir"; or continue
            set -l ver (basename "$dir")
            test "$ver" = "$active"; and continue
            rm -rf "$dir"; and echo "pruned stale cache: $ver"
        end
        echo "active version kept: $active"
    else
        echo "could not determine active version; skipped prune"
    end

    echo
    echo "Restart Claude Code, or run /reload-plugins then /reload-skills — a running"
    echo "session keeps the old skill list in memory until then."
end
