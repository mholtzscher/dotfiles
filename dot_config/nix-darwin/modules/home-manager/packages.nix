{ pkgs }:

with pkgs;
[
  go
  nodejs_22
  lua
  terraform
]
++ [
  # asdf-vm
  atuin
  awscli2
  bat
  bottom
  buf
  chezmoi
  discord
  dive
  dust
  fd
  fish
  fzf
  gh
  gnused
  grpcurl
  gum
  hey
  httpie
  hugo
  jc
  jq
  k9s
  ko
  kubernetes-helm
  lazygit
  lsd
  mkalias
  nixfmt-rfc-style
  neovim
  obsidian
  oras # TODO: set only for paytient mac
  ripgrep
  rm-improved
  slack
  slides
  sops
  starship
  thefuck
  tldr
  vim
  vscode
  wezterm
  yq
  zellij
  zoxide
]
