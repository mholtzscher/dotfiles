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
  lazyIdeaVim = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/mikeslattery/d2f2562e5bbaa7ef036cf9f5a13deff5/raw/31278677c945d5f7be6f9c1e37a9779542ff1376/.idea-lazy.vim";
    # Replace with the actual SHA256 hash of the file
    sha256 = "sha256-WC8jzKir2LRMVOgyNJwDYH26mpIf9UCVTi6wOHdfDXo=";
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
    ".asdfrc".source = ./files/asdfrc;
    "${config.xdg.configHome}/kafkactl/config.yml".source = ./files/kafkactl.yaml;
    "${config.xdg.configHome}/1Password/ssh/agent.toml".source = ./files/1password-agent.toml;
    "${config.xdg.configHome}/fish/functions/update.fish".source = ./files/fish/functions/update.fish;
    "Library/Application Support/eza/theme.yml".source = "${tokyonight}/extras/eza/tokyonight.yml";
    ".ideavimrc".source = ./files/ideavimrc;
    ".idea-lazy.vim".source = lazyIdeaVim;
    "${config.xdg.configHome}/aerospace/aerospace.toml".source = ./files/aerospace.toml;
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
