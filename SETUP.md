# Install Homebrew
```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# Setup 1Password
Install App/GUI

```sh
brew install --cask 1password/tap/1password-cli
```

# Setup Chezmoi
```sh
brew install chezmoi

chezmoi init git@github.com:mholtzscher/dotfiles.git
```

# Install Homebrew Apps
```sh
cd ~ && brew bundle   
```

# Setup Fonts

Set font in Warp

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

# Install OpenCommit
```sh
npm install -g opencommit
```
