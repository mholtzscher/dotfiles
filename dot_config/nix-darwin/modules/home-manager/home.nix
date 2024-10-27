{ pkgs, ... }:
{

  imports = [
    ./programs
  ];

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [ ] ++ (import ./packages.nix { inherit pkgs; });

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
}
