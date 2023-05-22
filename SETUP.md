# Install Homebrew
```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# Setup Fonts
```sh
brew install font-jetbrains-mono-nerd-font
```

Set font in Warp

# Setup Chezmoi
```sh
brew install chezmoi

chezmoi init git@github.com:mholtzscher/dotfiles.git
```

# Install Homebrew Apps
```sh
brew install --cask nightfall

brew install go node pyenv zoxide lazygit lsd bat awscli buf dive helm httpie hurl jq kubectx ripgrep ko slides fd fzf bottom
    
```

# Install Rust
```sh
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

# Install Python Tools
```sh
  pyenv install 3.11.3
  pyenv global 3.11.3
  pip install --upgrade pip
```

