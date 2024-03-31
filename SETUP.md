# Setup

<!--toc:start-->

- [Setup](#setup)
  - [Install Homebrew](#install-homebrew)
  - [Setup 1Password](#setup-1password)
  - [Setup Chezmoi](#setup-chezmoi)
  - [Install Additional Tools](#install-additional-tools)
  - [Setup Fonts](#setup-fonts)
  <!--toc:end-->

## Install Homebrew

```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Setup 1Password

1. Install App/GUI
1. Enable using 1Password for SSH keys

## Setup Chezmoi

```sh
brew install chezmoi

chezmoi init git@github.com:mholtzscher/dotfiles.git
```

## Install Additional Tools

```sh
galactus
```

## Setup Fonts

1. Set font in Warp
