fish_add_path "$ASDF_DIR/bin"
fish_add_path "$HOME/.asdf/shims"

if status --is-interactive && type -q asdf
    source (brew --prefix asdf)/libexec/asdf.fish
    atuin init fish | source
end

abbr -a -- sso aws_change_profile

zoxide init fish | source
starship init fish | source
