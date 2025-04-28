{ pkgs, config, ... }:
let
  tokyonight = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
    sha256 = "sha256-1xZhQR1BhH2eqax0swlNtnPWIEUTxSOab6sQ3Fv9WQA=";
  };
  starship = pkgs.fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "ed87dc5750338d37bfc2c17568ae3a9b589a8e8e";
    sha256 = "sha256-kPvyCKf62x+hXAxL5+sdWHLVoUx/n96EFEBOTpXnQhw=";
  };
in
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
    "Library/Application Support/eza/theme.yml".source = "${tokyonight}/extras/eza/tokyonight.yml";
    # "${config.xdg.configHome}/starship.toml".source =
    #   "${starship}/docs/public/presets/toml/pure-preset.toml";
    # "${config.xdg.configHome}/starship.toml".source =
    #   "${starship}/docs/public/presets/toml/jetpack.toml";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    COMPOSE_PROFILES = "default"; # TODO: set only for paytient mac
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
