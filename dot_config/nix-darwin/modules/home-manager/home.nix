{ pkgs, config, ... }:
{

  imports = [
    ./programs
  ];

  home.stateVersion = "24.11";
  # xdg.enable = true;
  home.packages = [ ] ++ (import ./packages.nix { inherit pkgs; });

  home.file = {
    # ".ssh/config".source = ./files/ssh-config;
    "${config.xdg.configHome}/zellij/config.kdl".source = ./files/zellij.kdl;
    ".asdfrc".source = ./files/asdfrc;
    "${config.xdg.configHome}/kafkactl/config.yml".source = ./files/kafkactl.yaml;
    "${config.xdg.configHome}/1Password/ssh/agent.toml".source = ./files/1password-agent.toml;
    "${config.xdg.configHome}/fish/themes/catppuccin-mocha.theme".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
        sha256 = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
      }
      + "/themes/Catppuccin Mocha.theme";
    "${config.xdg.configHome}/fish/functions/update.fish".source = ./files/fish/functions/update.fish;
    # ".local/bin/terraform".source = "${pkgs.terraform}/bin/terraform";
    # "${config.xdg.configHome}/nvim" = {
    #   source = ./files/nvim;
    #   recursive = true;
    # };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    COMPOSE_PROFILES = "default"; # TODO: set only for paytient mac
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
