{ pkgs, ... }:
{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    atuin
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
    hey
    httpie
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
    ripgrep
    rm-improved
    slack
    sops
    starship
    tldr
    vim
    vscode
    wezterm
    yq
    zellij
    zoxide
  ];

  home.file = {
    ".ssh/config".source = ./files/ssh-config;
    ".config/zellij/config.kdl".source = ./files/zellij.kdl;
    ".asdfrc".source = ./files/asdfrc;
    ".config/kafkactl/config.yml".source = ./files/kafkactl.yaml;
    ".config/1Password/ssh/agent.toml".source = ./files/1password-agent.toml;
    ".config/fish/themes/catppuccin-mocha.theme".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
        sha256 = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
      }
      + "/themes/Catppuccin Mocha.theme";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./programs/atuin.nix
    ./programs/bat.nix
    ./programs/bottom.nix
    ./programs/fd.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/k9s.nix
    ./programs/lazygit.nix
    ./programs/fish.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./programs/zsh.nix
    ./programs/zoxide.nix
  ];
}
