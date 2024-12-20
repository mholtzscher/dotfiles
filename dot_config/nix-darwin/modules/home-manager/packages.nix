{ pkgs }:

with pkgs;
[
  nodejs_23
  lua
  python3
  # terraform
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
  kdlfmt
  ko
  kubernetes-helm
  lsd
  mkalias
  nixfmt-rfc-style
  neovim
  nufmt
  nushellPlugins.polars
  obsidian
  pokemon-colorscripts-mac
  oras # TODO: set only for paytient mac
  rm-improved
  slack
  slides
  # sops
  tldr
  vim
  vscode
  yq
]
