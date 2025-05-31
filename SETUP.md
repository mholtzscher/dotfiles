# Setup

<!--toc:start-->

- [Setup](#setup)
  - [Install Homebrew](#install-homebrew)
  - [Setup 1Password](#setup-1password)
  - [Setup Chezmoi](#setup-chezmoi)
  - [Install Additional Tools](#install-additional-tools)
  - [Theming](#theming)
      <!--toc:end-->
    :

## Install Nix

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
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
