{ pkgs }:

with pkgs;
[
  nodejs_22
  lua
  python3
  terraform
]
++ [
  # asdf-vm
  awscli2
  buf
  chezmoi
  discord
  dive
  dust
  gnused
  grpcurl
  gum
  hey
  httpie
  hugo
  jc
  jq
  ko
  kubernetes-helm
  lsd
  mkalias
  nixfmt-rfc-style
  neovim
  obsidian
  oras # TODO: set only for paytient mac
  rm-improved
  slack
  slides
  sops
  tldr
  vim
  vscode
  yq
]
