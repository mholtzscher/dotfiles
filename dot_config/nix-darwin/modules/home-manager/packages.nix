{ pkgs }:

with pkgs;
[
  nodejs
  lua
  python3
  # python313Packages.python-lsp-server
  # python313Packages.python-lsp-ruff
  # python313Packages.python-lsp-ruff
  # terraform
]
++ [
  # asdf-vm # really out of date
  #awscli2
  buf
  chezmoi
  cowsay
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
  just
  kdlfmt
  ko
  kubernetes-helm
  # lolcat
  mkalias
  nixfmt-rfc-style
  neovim
  nufmt
  nushellPlugins.polars
  oras # TODO: set only for paytient mac
  pokemon-colorscripts-mac
  procs
  rm-improved
  sl
  slides
  # sops
  tldr
  vim
  vscode
  wget
  yq
]
