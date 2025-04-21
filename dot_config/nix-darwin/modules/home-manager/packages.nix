{ pkgs }:

with pkgs;
[
  nodejs_23
  lua
  python3
  # python313Packages.python-lsp-server
  # python313Packages.python-lsp-ruff
  # python313Packages.python-lsp-ruff
  # terraform
]
++ [
  # asdf-vm
  #awscli2
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
  lazydocker
  lsd
  mkalias
  nixfmt-rfc-style
  neovim
  nufmt
  nushellPlugins.polars
  oras # TODO: set only for paytient mac
  pokemon-colorscripts-mac
  procs
  rm-improved
  slides
  # sops
  tldr
  vim
  # vscode
  yq
]
