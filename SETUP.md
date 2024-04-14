# Setup

<!--toc:start-->

- [Setup](#setup)
  - [Install Homebrew](#install-homebrew)
  - [Setup 1Password](#setup-1password)
  - [Setup Chezmoi](#setup-chezmoi)
  - [Install Additional Tools](#install-additional-tools)
  - [Theming](#theming)
  <!--toc:end-->

## Install Homebrew

```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Note: need to run the following lines and restart shell to get homebrew into path

```sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Setup 1Password

1. Install App/GUI
1. Enable using 1Password for SSH keys
1. Install 1Password CLI

```sh
brew install 1password-cli
```

## Setup Chezmoi

```sh
brew install chezmoi
```

```sh
chezmoi init git@github.com:mholtzscher/dotfiles.git
```

```sh
chezmoi apply
```

## Install Additional Tools

```sh
galactus
```

## Theming

1. Set font in Warp
1. Set theme in Warp
