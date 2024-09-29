function update --description "Update all the things"
    gum log --time kitchen --level info "Updating Homebrew Bundle"
    brew bundle --no-lock --file=~/Brewfile

    gum log --time kitchen --level info "Updating neovim plugins"
    nvim --headless "+Lazy! sync" +qa
end
