if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end

fish_add_path "$ASDF_DIR/bin"
fish_add_path "$ASDF_DIR/shims"
source /opt/homebrew/opt/asdf/libexec/asdf.fish

zoxide init fish | source
starship init fish | source
