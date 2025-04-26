{ pkgs, config, ... }:
{

  imports = [
    ./programs
  ];

  home.stateVersion = "24.11";
  # xdg.enable = true;
  home.packages = [ ] ++ (import ./packages.nix { inherit pkgs; });

  home.file = {
    "${config.xdg.configHome}/zellij/config.kdl".source = ./files/zellij.kdl;
    # ".asdfrc".source = ./files/asdfrc;
    "${config.xdg.configHome}/kafkactl/config.yml".source = ./files/kafkactl.yaml;
    "${config.xdg.configHome}/1Password/ssh/agent.toml".source = ./files/1password-agent.toml;
    "${config.xdg.configHome}/fish/functions/update.fish".source = ./files/fish/functions/update.fish;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    COMPOSE_PROFILES = "default"; # TODO: set only for paytient mac
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
