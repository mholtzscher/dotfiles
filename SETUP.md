# Install Rust
```sh
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

# Install Homebrew
```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# Install Homebrew Apps
```sh
brew install --cask nightfall

brew install go node pyenv lazygit helix lsd bat awscli buf dive helm httpie hurl jq kubectx ripgrep ko slides
    
brew install delve gopls yaml-language-server rust-analyzer terraform-ls marksman taplo bash-language-server python-lsp-server vscode-langservers-extracted typescript-language-server
```

# Install Node Tools
```sh
npm install -g dockerfile-language-server-nodejs
```

# Install Python Tools
```sh
  pyenv install 3.11.3
  pyenv global 3.11.3
  pip install --upgrade pip
```

# Aliases and Shell
`.zprofile`

```
eval "$(/opt/homebrew/bin/brew shellenv)"


# Added by Toolbox App
export PATH="$PATH:/Users/michael/Library/Application Support/JetBrains/Toolbox/scripts"

# Go setup
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
#export PATH="$PATH:${GOPATH}/bin"

# k8s setup
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
source ~/.kube/source.sh

alias tf='terraform' 
alias lg='lazygit'
alias ls='lsd'
alias ll='lsd -al'
alias tree='lsd --tree -a --ignore-glob .git'
alias treed='lsd --tree -a -d --ignore-glob .git'
```

# Lazygit Config
`~/Library/Application\ Support/lazygit/config.yml`

```yaml
notARepository: "skip" # one of: 'prompt' | 'create' | 'skip'
gui:
  scrollHeight: 2
  sidePanelWidth: 0.3333
  expandFocusedSidePanel: false
  mainPanelSplitMode: flexible
  theme:
    lightTheme: false
    activeBorderColor:
      - "#89ddff"
      - bold
    inactiveBorderColor:
      - "#565f89"
    optionsTextColor:
      - "#3d59a1"
    selectedLineBgColor:
      - "#292e42"
      - bold
    selectedRangeBgColor:
      - "#89ddff"
```

# Helix Config
`~/.config/helix/config.toml`

```toml
theme = "tokyonight"

[editor]
line-number = "relative"
cursorline = true
color-modes = true
bufferline = "multiple"
mouse = false


[editor.statusline]
left = ["mode", "spinner", "version-control"]
center = ["file-name", "file-encoding", "diagnostics"]
right = ["selections", "position"]
separator = "|"

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.lsp]
display-signature-help-docs = true
display-inlay-hints = true

[keys.normal]
C-k = ["extend_to_line_bounds", "delete_selection", "move_line_up", "paste_before"]
C-j = ["extend_to_line_bounds", "delete_selection", "paste_after"]
```